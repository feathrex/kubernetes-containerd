IP=$(kubectl get svc httpenv -o go-template --template '{{ .spec.clusterIP }}')
