#!/bin/sh
set -e

echo "Patching Grafana UI..."

find /usr/share/grafana/public/build/ -type f -name '*.js' -exec sed -i 's/Welcome to Grafana/Welcome to API2 Analytics/g' {} + || true
find /usr/share/grafana/public/build/ -type f -name '*.js' -exec sed -i 's/Grafana/API2/g' {} + || true

echo "Patch complete."
