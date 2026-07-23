FROM node:22.13.1-bookworm-slim

WORKDIR /runner
COPY worker.js ./worker.js

USER node
EXPOSE 3000

# Node permissions are defence in depth. Compose adds the actual isolation
# boundary: no external network, read-only rootfs, no capabilities or mounts.
CMD ["node", "--permission", "--allow-fs-read=/runner/worker.js", "--disallow-code-generation-from-strings", "worker.js"]

