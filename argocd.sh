# Prepare
set -eo pipefail

# kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd login --core
kubectl config set-context --current --namespace=argocd

argocd app create fullconfig --repo https://github.com/SilasPeters/kuberyeetes.git --path overlays/development/ --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync fullconfig
