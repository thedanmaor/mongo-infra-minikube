# This is an experiment
$MEKO_namespace="mongodb"

# Prompt for memory and default to 8GB
Write-Output "How much memory have you given to docker (ignore on linux)"

$minikube_memory="7935mb"
$om_om_memory="4.0Gi"
$om_appdb_memory="500Mi"
$deploy_mem="500Mi"

# Prompt for operator version and default to 1.26.0
$MEKO_version="1.26.0"

# Prompt for Ops Manager version
$OM_VERSION="7.0.8"

# Check if minikube is available and run it
minikube start --cpus=4 --memory="$minikube_memory" --disk-size=60000mb -p opsmanager --namespace "$MEKO_namespace"

# Check if kubectl is availabe us it to install the operator
Write-Output "Installing the operator into the mongodb namespace"
kubectl create namespace mongodb
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/mongodb-enterprise.yaml
kubectl describe deployments mongodb-enterprise-operator -n "$MEKO_namespace"

# Generate deployment
Get-Content -Path templates\deploy-om.template | %{ $_ -replace 'om_version_goes_here', "$OM_VERSION"} | %{ $_ -replace 'om_om_memory', "$om_om_memory"} | %{ $_ -replace 'om_appdb_memory', "$om_appdb_memory"} > deploy-om.yaml
kubectl apply -f deploy-om.yaml
Write-Output ""
kubectl get om -w