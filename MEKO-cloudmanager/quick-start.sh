#!/bin/bash
export CM_version=master
export CM_namespace=mongodb
export CM_URL=https://cloud.mongodb.com

if [[ ! -v $CM_ORGID ]]; then
  read -r -p "Please provide your Cloud Manager Organization ID: " CM_ORGID
fi

if [[ ! -v $CM_PUBKEY ]]; then
  read -r -p "Please provide your API Public Key: " CM_PUBKEY
fi

if [[ ! -v $CM_PRIKEY ]]; then
  read -r -p "Please provide your API Private Key: " CM_PRIKEY
fi


# check if the minikube command is available and setup our cluser/profile
if ! minikube &> /dev/null
then 
  echo "Minikube could not be found, please install."
  exit 1
else
  minikube start --cpus=3 --memory=3G --disk-size=6000mb -p cloudmanager --namespace $CM_namespace
  minikube profile list
fi

# check for kubectl
if ! kubectl &> /dev/null
then
  echo "kubectl not found, please install it, or alias kubectl='minikube kubectl' to use the one bundled with minikube"
  exit 1
else
  echo "Installing the operator into the mongodb namespace"
  kubectl create namespace mongodb
  kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$CM_version/crds.yaml
  kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$CM_version/mongodb-enterprise.yaml
  kubectl describe deployments mongodb-enterprise-operator -n mongodb
fi

# https://www.mongodb.com/docs/kubernetes-operator/master/tutorial/create-operator-credentials/#std-label-create-k8s-credentials
echo "Creating credentials for the Kubernetes Operator to access MongoDB Cloud Manager"

kubectl -n $CM_namespace \
create secret generic my-credentials \
--from-literal="publicKey=$CM_PUBKEY" \
--from-literal="privateKey=$CM_PRIKEY"

# https://www.mongodb.com/docs/kubernetes-operator/master/tutorial/create-project-using-configmap/#std-label-create-k8s-project
echo "Creating One Project using a ConfigMap"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-project
  namespace: mongodb
data:
  projectName: kubernetes         # this is an optional parameter; when omitted, the Operator creates a project with the resource name
  orgId: $CM_ORGID # this is a required parameter
  baseUrl: https://cloud.mongodb.com
EOF

# Deploy a sample replica set
echo "Deploying Sample Replica Set"
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/samples/mongodb/persistent-volumes/replica-set-persistent-volumes.yaml

echo "It can take a few minutes for pods to get going, please check Servers in Cloud Manager and kubectl get mdb"