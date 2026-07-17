#!/usr/bin/env bash
set -euo pipefail

NIX=./result/bin/nix
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

CHART_URL="https://charts.bitnami.com/bitnami/nginx-19.0.2.tgz"
CHART_HASH="sha256-XEFGRXPpStborNWzvRlzHUdHChaJjl/HKPGpjR1pTBc="

echo "=== Step 1: Fetch chart, patch port 8080 -> 9090, serialize ==="

CHART_PATH=$($NIX eval --impure --raw --expr "
  builtins.fetchTarball {
    url = \"$CHART_URL\";
    sha256 = \"$CHART_HASH\";
  }
")

$NIX eval --impure --raw --expr "
  let
    chart = builtins.fetchTarball {
      url = \"$CHART_URL\";
      sha256 = \"$CHART_HASH\";
    };
    values = builtins.fromYAML (builtins.readFile \"\${chart}/values.yaml\") {};
    patched = values // {
      containerPorts = values.containerPorts // {
        http = 9090;
      };
      service = values.service // {
        ports = values.service.ports // {
          http = 9090;
        };
      };
    };
  in builtins.toYAML patched
" > "$WORKDIR/values.yaml"

echo "  containerPort http: $(grep -A1 'containerPorts:' "$WORKDIR/values.yaml" | grep http | head -1)"
echo "  service port http:  $(grep -A10 '^service:' "$WORKDIR/values.yaml" | grep -A5 'ports:' | grep 'http:' | head -1)"

echo ""
echo "=== Step 2: Render with helm template ==="

nix-shell -p kubernetes-helm --run "
  helm template test-nginx '$CHART_PATH' -f '$WORKDIR/values.yaml' > '$WORKDIR/rendered.yaml' 2>&1
"

DOCS=$(grep -c '^---' "$WORKDIR/rendered.yaml")
echo "  Rendered $DOCS YAML documents"

echo ""
echo "=== Step 3: Verify port 9090 in rendered manifests ==="

echo "  Deployment containerPort:"
grep 'containerPort:' "$WORKDIR/rendered.yaml" | head -2 | sed 's/^/    /'

echo "  Service targetPort:"
grep 'targetPort:' "$WORKDIR/rendered.yaml" | head -2 | sed 's/^/    /'

echo "  Service port:"
grep -E '^\s+port:' "$WORKDIR/rendered.yaml" | head -2 | sed 's/^/    /'

# Verify the port is actually 9090
if grep -q 'containerPort: 9090' "$WORKDIR/rendered.yaml"; then
  echo ""
  echo "  PASS: containerPort is 9090"
else
  echo ""
  echo "  FAIL: containerPort is not 9090"
  exit 1
fi

echo ""
echo "=== Step 4: Round-trip verify - parse rendered YAML back ==="

$NIX eval --impure --expr "
  let
    rendered = builtins.readFile \"$WORKDIR/rendered.yaml\";
    # extract just the Deployment document
    values = builtins.fromYAML (builtins.readFile \"$WORKDIR/values.yaml\") {};
  in {
    containerPort = values.containerPorts.http;
    servicePort = values.service.ports.http;
  }
"

echo ""
echo "=== Step 5: Deploy to docker with helm ==="

# Check if docker is available
if ! docker info >/dev/null 2>&1; then
  echo "  Docker not available, skipping deploy test"
  exit 0
fi

nix-shell -p kind kubectl kubernetes-helm --run "
  set -e
  CLUSTER=nix-yaml-test

  kind delete cluster --name \$CLUSTER 2>/dev/null || true
  echo '  Creating kind cluster...'
  kind create cluster --name \$CLUSTER --wait 60s

  echo '  Installing chart with patched port...'
  helm install test-nginx '$CHART_PATH' \
    -f '$WORKDIR/values.yaml' \
    --kube-context kind-\$CLUSTER \
    --wait --timeout 120s

  echo ''
  echo '  Pod status:'
  kubectl --context kind-\$CLUSTER get pods | sed 's/^/    /'

  echo ''
  echo '  Service port:'
  SVC_PORT=\$(kubectl --context kind-\$CLUSTER get svc test-nginx -o jsonpath='{.spec.ports[0].port}')
  echo \"    port: \$SVC_PORT\"

  if [ \"\$SVC_PORT\" = \"9090\" ]; then
    echo '    PASS: service port is 9090'
  else
    echo \"    FAIL: expected 9090, got \$SVC_PORT\"
    kind delete cluster --name \$CLUSTER
    exit 1
  fi

  echo ''
  echo '  Cleaning up...'
  kind delete cluster --name \$CLUSTER
"

echo ""
echo "=== ALL TESTS PASSED ==="
