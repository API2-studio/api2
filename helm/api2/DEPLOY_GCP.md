# Deploy API2 to GCP (GKE)

This guide deploys the existing Helm chart to Google Kubernetes Engine using a public HTTPS endpoint.

## 1) Prerequisites

- `gcloud`, `kubectl`, `helm` installed
- A GCP project with billing enabled
- Artifact Registry enabled in your project (if you push private images)
- A DNS domain you can point to a GCP static IP

## 2) Set variables

```bash
export PROJECT_ID="your-gcp-project-id"
export REGION="europe-west2"
export CLUSTER_NAME="cluster-api2"
export NAMESPACE="api2"
export HOSTNAME="example.com" # Your API hostname (e.g. api.example.com)
```

## 3) Create and connect to a GKE cluster

```bash
gcloud config set project "${PROJECT_ID}"
gcloud container clusters create-auto "${CLUSTER_NAME}" --region "${REGION}"
gcloud container clusters get-credentials "${CLUSTER_NAME}" --region "${REGION}" --project "${PROJECT_ID}"
```

## 4) Reserve static IP + managed certificate

```bash
gcloud compute addresses create api2-ip --global
gcloud compute addresses describe api2-ip --global --format="value(address)"
```

Create `managed-cert.yaml`:

```yaml
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: api2-cert
  namespace: api2
spec:
  domains:
    - api2.dev
```

Apply it (replace `api.example.com` with your hostname first):

```bash
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f managed-cert.yaml
```

Point your DNS `A` record for `${HOSTNAME}` to the static IP from step 4.

## 5) Create runtime secrets

Do not keep real secrets in `values.yaml`. Create them at deploy time.

```bash
kubectl -n "${NAMESPACE}" create secret docker-registry gitlab-registry \
  --docker-server=registry.gitlab.com \
  --docker-username='<username>' \
  --docker-password='<token>' \
  --docker-email='<email>' \
  --dry-run=client -o yaml | kubectl apply -f -
```

## 6) Deploy Helm chart

Set your hostname in `helm/api2/values-gcp.yaml` (`ingress.host` and GCP-related URLs), then deploy:

```bash
helm upgrade --install api2 ./helm/api2 \
  -n "${NAMESPACE}" \
  --create-namespace \
  -f ./helm/api2/values.yaml \
  -f ./helm/api2/values-gcp.yaml
```

## 7) Validate

```bash
kubectl get pods -n "${NAMESPACE}"
kubectl get ingress -n "${NAMESPACE}"
kubectl describe managedcertificate api2-cert -n "${NAMESPACE}"
```

Wait for the managed certificate to become `Active`, then open:

`https://api.example.com`

## 8) Optional: Autopilot-safe Loki labels via Pub/Sub forwarder

If you want labels in Grafana Explore for Loki on GKE Autopilot, use:

`Cloud Logging -> Pub/Sub -> lokiForwarder -> Loki`

1. Create Pub/Sub topic + subscription:

```bash
export LOG_TOPIC="api2-logs"
export LOG_SUBSCRIPTION="api2-logs-sub"

gcloud pubsub topics create "${LOG_TOPIC}"
gcloud pubsub subscriptions create "${LOG_SUBSCRIPTION}" --topic "${LOG_TOPIC}"
```

2. Create a Cloud Logging sink into that topic:

```bash
export LOG_SINK="api2-loki-sink"

gcloud logging sinks create "${LOG_SINK}" \
  "pubsub.googleapis.com/projects/${PROJECT_ID}/topics/${LOG_TOPIC}" \
  --log-filter='resource.type=("k8s_container" OR "k8s_pod")'
```

3. Grant sink writer permission to publish to Pub/Sub:

```bash
SINK_WRITER_IDENTITY="$(gcloud logging sinks describe "${LOG_SINK}" --format='value(writerIdentity)')"
gcloud pubsub topics add-iam-policy-binding "${LOG_TOPIC}" \
  --member="${SINK_WRITER_IDENTITY}" \
  --role="roles/pubsub.publisher"
```

4. Create a GSA for the forwarder and grant subscriber access:

```bash
export FORWARDER_GSA="loki-forwarder"

gcloud iam service-accounts create "${FORWARDER_GSA}" \
  --display-name="Loki Forwarder"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${FORWARDER_GSA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/pubsub.subscriber"
```

5. Bind KSA <-> GSA using Workload Identity:

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "${FORWARDER_GSA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="serviceAccount:${PROJECT_ID}.svc.id.goog[${NAMESPACE}/loki-forwarder]"
```

6. Enable forwarder values in `helm/api2/values-gcp.yaml`:

```yaml
lokiForwarder:
  enabled: true
  projectId: api2-mvp
  subscription: api2-logs-sub
  workloadIdentityGsa: loki-forwarder@api2-mvp.iam.gserviceaccount.com
  cluster: api2-gke
```

7. Redeploy:

```bash
helm upgrade --install api2 ./helm/api2 \
  -n "${NAMESPACE}" \
  --create-namespace \
  -f ./helm/api2/values.yaml \
  -f ./helm/api2/values-gcp.yaml
```

## Notes

- The checked-in secrets and API keys should be rotated before production use.
- If you use Google Cloud Storage credentials via JSON key, prefer Workload Identity for production.
