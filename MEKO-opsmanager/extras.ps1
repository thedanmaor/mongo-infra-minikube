# This is an experiment
$MEKO_namespace="mongodb"
$MONGO_INFRA_MINIKUBE_IP="http://localhost:8080"

# Prompt for memory and default to 8GB
Write-Host "Please Make sure you have setup a port forward:"
Write-Host "- Ops Manager should be availabe on http://localhost:8080"
Write-Host "- Using the UI, create an Organization Owner API Key"
Write-Host "- The IP can be 0.0.0.0/1 and 128.0.0.0/1"
Write-Host "- Provide the details below so that we can create cm/secret/mdb objects"

$MONGO_INFRA_MINIKUBE_ORG                = Read-Host -Prompt "Enter Organization ID: "
$MONGO_INFRA_MINIKUBE_GLOBAL_API_PUBLIC  = Read-Host -Prompt "Enter Public API Key: "
$MONGO_INFRA_MINIKUBE_GLOBAL_API_PRIVATE = Read-Host -Prompt "Enter Private API Key: "

# Do a curl to create an org? nah user did it above
# Do a curl to get the keys, nah user provided above

kubectl -n "$MEKO_namespace" create secret generic my-credentials --from-literal="publicKey=$MONGO_INFRA_MINIKUBE_GLOBAL_API_PUBLIC" --from-literal="privateKey=$MONGO_INFRA_MINIKUBE_GLOBAL_API_PRIVATE"

# Create config-map
echo "
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-project
  namespace: mongodb
data:
  projectName: mongo-infra-minikube
  orgId: '$MONGO_INFRA_MINIKUBE_ORG'
  baseUrl: http://mongo-infra-minikube-svc.mongodb.svc.cluster.local:8080
" | kubectl apply -f -

Write-Host "Would you like to Deploy the sample Replica Set?"
Write-Host "1. Yes"
Write-Host "2. No"

$deploy_option = Read-Host -Prompt "Enter a number 1 or 2: "

Switch ($deploy_option)
{
    1 {
        kubectl apply -f deploy-mdb.yaml
    }
    2 {
        echo "Please edit deploy-mdb.yaml, then deploy with:"
        echo "\> kubectl apply -f deploy-mdb.yaml"
    }
}