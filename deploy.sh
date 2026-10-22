# Prepare
set -eo pipefail
env=development

# Start "provisioned" cluster
minikube start

# Apply configuration
kubectl kustomize overlays/development/ | kubectl apply -f -

# Install argocd
kubectl create namespace argocd || true # Make idempotent
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Await deployment
echo "Awaiting deployment to finish..."
kubectl rollout status deployment/development-ratshapes-deployment

# Await tunnel
# TODO run tunnel in other window now (seems to resolve weird edge case)
echo -e "\nYou should now run ./tunnel.sh..."
kubectl wait --for=jsonpath='{.status.loadBalancer.ingress[0].ip}' svc/${env}-ratshapes-service --timeout=30s
export external_ip=$(kubectl get svc ${env}-ratshapes-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Website is available on http://${external_ip}"

