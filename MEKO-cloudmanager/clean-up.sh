#!/bin/bash

echo "Attempting to remove my-replica-set"
kubectl delete mdb my-replica-set -n mongodb
sleep 60

echo "Attempting to remove operator"
kubectl delete deployment mongodb-enterprise-operator -n mongodb
sleep 30

echo "Attempting to remove the minikube cluster"
minikube delete -p cloudmanager
sleep 15

echo "You should delete the project from Cloud Manager also, so new deploys go smoothly and are not affected"
echo "by settings from the old project."
echo
echo "Done"