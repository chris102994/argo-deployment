# minikube
Enable Ingress on minikube: `minikube addons enable ingress`
Or Start with it: `minikube start --driver=docker --addons=ingress`

nginx proper: `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`
remove: `-publish-status-address=localhost` from nginx below
check nodeSelector for stuff that this cluster doesn't have labeled: `kubectl -n ingress-nginx edit deployment ingress-nginx-controller`

NOTE: Minikube Default Ones:
```
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=minikube
                    kubernetes.io/os=linux
                    minikube.k8s.io/commit=1fd1f67f338cbab4b3e5a6e4c71c551f522ca138-dirty
                    minikube.k8s.io/name=minikube
                    minikube.k8s.io/updated_at=2022_09_13T20_30_47_0700
                    minikube.k8s.io/version=v1.13.1
                    node-role.kubernetes.io/master=

```

View argo-server spec info:
```shell
kubectl -n argo get deployments argo-server -o 'jsonpath={.spec.template.spec.containers[0].args}' | jq
```

Manual argocd-repo-server patch:
```shell
kubectl patch deployment argocd-repo-server --namespace argocd --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/securityContext/seccompProfile/type", "value": "Unconfined"}]'
kubectl -n argocd get deployments argocd-repo-server -o 'jsonpath={.spec.template.spec.containers[0].securityContext.seccompProfile.type}'
```

```shell
cd base/
kubectl kustomize . -o deployment.yaml
kubectl apply -f deployment.yaml

minikube tunnel ?
```