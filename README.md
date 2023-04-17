# Argo Home Server Stack

`kubectl apply -f  https://raw.githubusercontent.com/chris102994/argo-deployment/master/argocd_deployment.yaml`

Note: expects a clear range from `192.168.1.190-192.168.1.199` to be available for ingress/metallb or else the ingress service will be stuck <Pending>