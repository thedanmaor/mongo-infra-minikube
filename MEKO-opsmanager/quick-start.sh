#!/bin/bash

export MEKO_namespace=mongodb

### Prompt for version

version_options=("1.26.0" "1.23.0" "1.21.0" "custom" "Quit")
select opt in "${version_options[@]}"
do
  case $opt in
      1.26.0)
      export MEKO_version=1.22.6
      break
      ;;
      1.23.0)
      export MEKO_version=1.23.0
      break
      ;;
      1.21.0)
      export MEKO_version=1.21.0
      break
      ;;
      custom)
      read -r MEKO_version
      break
      ;;
      Quit)
      echo "Bye."
      break
      ;;
      *)
      echo "Invalid option"
      ;;
  esac
done

# check if the minikube command is available and setup our cluser/profile
if ! minikube &> /dev/null
then 
  echo "Minikube could not be found, please install."
  exit 1
else
  minikube start --cpus=4 --memory=15991mb --disk-size=60000mb -p opsmanager --namespace $MEKO_namespace
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
  kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/crds.yaml
  kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/mongodb-enterprise.yaml
  kubectl describe deployments mongodb-enterprise-operator -n $MEKO_namespace
fi

cat deploy-om.template > deploy-om.yaml

export MONGO_INFRA_MINIKUBE_IP=`minikube ip -p opsmanager`

#kubectl apply -f deploy-om.yaml
echo
echo -------------------------------------------------------------------------------
echo "On Linux visit http://$MONGO_INFRA_MINIKUBE_IP:30100 in about 5 minutes, to view Ops Manager"
echo "On Mac you need 2 steps:"
echo "1. nohup kubectl port-forward pod/mongo-infra-minikube-0 8080:8080 &"
echo "2. Then visit http://localhost:8080 in about 5 minutes"
echo "------------------------------------------------------------------------------"
echo "Username: admin"
echo "Password: Passw0rd1!"
echo "------------------------------------------------------------------------------"
echo
echo "You can check Ops Manager startup progress with:"
echo "\> kubectl get pods -w | grep mongo-infra-minikube-0"
echo "\> kubectl logs -f pod/mongo-infra-minikube-0"
echo
echo "Now run:"
echo "\> bash extras.sh"
echo
echo "To Deploy a cluster you can use any of the samples:"
echo "\> kubectl apply -f https://github.com/mongodb/mongodb-enterprise-kubernetes/raw/master/samples/mongodb/agent-startup-options/replica-set-agent-startup-options.yaml"