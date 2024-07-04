# Atlas Kubernetes Operator and Minikube

Get a kubernetes cluster, the MongoDB Atlas Kubernetes Operator and and Atlas Project/Database setup in minimal time/effort

## Requirements
- minikube if you want this script to setup a cluster for you
- An Atlas account (where you will deploy your cluster)
- An Atlas API Key (how the operator talks to Atlas)

## Usage
Simply run this command (from this folder) and follow the prompts:
```
bash quick-start.sh
```

You can then take a look at the generated `deploy-a-cluster.yaml` file, or run:
```
kubectl apply -f deploy-a-cluster.yaml
```

This will create your secret (for your api key), your project, and an m10 deployment. It will also set up a tag with the projectname you provided and a keep.until variable (which we use to automatically remove test clusters) set to tomorrow.

## Clean up
To remove the minikube cluster and any tools that where downloaded to this directory simply run
```
bash clean-up.sh
```
