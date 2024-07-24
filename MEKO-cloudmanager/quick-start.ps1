$CM_version='1.25.0'
$CM_namespace="mongodb"
$CM_URL='https://cloud.mongodb.com'

$CM_ORGID  = Read-Host -Prompt "Please provide your Cloud Manager Organization ID" 
$CM_PUBKEY = Read-Host -Prompt "Please provide your Cloud Manager API Public Key"
$CM_PRIKEY = Read-Host -Prompt "Please provide your Cloud Manager API Private Key"

minikube start --cpus=3 --memory=3G --disk-size=6000mb -p cloudmanager --namespace $CM_namespace
minikube profile list

kubectl create namespace mongodb
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$CM_version/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$CM_version/mongodb-enterprise.yaml
kubectl describe deployments mongodb-enterprise-operator -n mongodb

kubectl -n $CM_namespace create secret generic my-credentials --from-literal="publicKey=$CM_PUBKEY" --from-literal="privateKey=$CM_PRIKEY"

echo "
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-project
  namespace: mongodb
data:
  projectName: mongo-infra-minikube
  orgId: '$CM_ORGID'
  baseUrl: https://cloud.mongodb.com
" | kubectl apply -f -

echo "Deploying Sample Replica Set"
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/samples/mongodb/persistent-volumes/replica-set-persistent-volumes.yaml

echo "It can take a few minutes for pods to get going, please check Servers in Cloud Manager and kubectl get mdb"