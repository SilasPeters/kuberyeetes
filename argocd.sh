# Prepare
set -eo pipefail

argocd login --core
kubectl config set-context --current --namespace=argocd

argocd app create fullconfig --repo https://github.com/SilasPeters/kuberyeetes.git --path overlays/development/ --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync fullconfig
