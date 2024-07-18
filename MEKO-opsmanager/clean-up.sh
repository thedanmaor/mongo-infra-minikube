#!/bin/bash
echo "Attempting to remove the minikube cluster"
minikube delete -p opsmanager
sleep 15
