# Usage

1. You need a Cloud Manager Organisation
1. An apikey (public and private parts) 
1. You must add an IP from which the key can access cloud manage

Once you have these you should export them, and then run `zsh quick-start.zsh` (on mac) or `bash quick-start.sh` (on linux) which will use these values.

If you don't provide them, we will prompt you to enter them when you run the script.

### Example 1, providing values on linux
```
export CM_ORGID=5addaf80d383ad7df4cbd310
export CM_PUBKEY=uglagfda
export CM_PRIKEY=5a3f6634-1245-48c1-a683-373992baaa14
bash quick-start.sh
```

### Example 2, prompting for values on mac
```
zsh quick-start.zsh 
Please provide your Cloud Manager Organization ID: 5addaf80d383ad7df4cbd310
Please provide your API Public Key: uglagfda
Please provide your API Private Key: 5a3f6634-1245-48c1-a683-373992baaa14
😄  [cloudmanager] minikube v1.33.1 on Nixos 24.05
    ▪ MINIKUBE_WANTUPDATENOTIFICATION=false
✨  Using the docker driver based on existing profile
👍  Starting "cloudmanager" primary control-plane node in "cloudmanager" cluster
🚜  Pulling base image v0.0.44 ...
🏃  Updating the running docker "cloudmanager" container ...
🐳  Preparing Kubernetes v1.30.0 on Docker 26.1.1 ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "cloudmanager" cluster and "mongodb" namespace by default
|--------------|-----------|---------|--------------|------|---------|---------|-------|----------------|--------------------|
|   Profile    | VM Driver | Runtime |      IP      | Port | Version | Status  | Nodes | Active Profile | Active Kubecontext |
|--------------|-----------|---------|--------------|------|---------|---------|-------|----------------|--------------------|
| cloudmanager | docker    | docker  | 192.168.49.2 | 8443 | v1.30.0 | Running |     1 |                | *                  |
|--------------|-----------|---------|--------------|------|---------|---------|-------|----------------|--------------------|
Installing the operator into the mongodb namespace

...Extra output removed...

Creating credentials for the Kubernetes Operator to access MongoDB Cloud Manager
secret/my-credentials created
Creating One Project using a ConfigMap
configmap/my-project created
Deploying Sample Replica Set
mongodb.mongodb.com/my-replica-set created
It can take a few minutes for pods to get going, please check Servers in Cloud Manager and kubectl get mdb
```

### What next
- It should take a few minutes for your Cloud Manger project to be created (using your org api key)
- The pods should come up one at a time and start to appear on the servers tab
- Each pod will download the mongod binary and mongosh
- Each pod will start mongod
- Cloud Manager automation will configure the replica set
- A primary will be elected

### Clean Up

This has some pauses built in to ensure proper cleanup, it can take a couple of minutes. **You manually need to** remove the 'kubernetes' project from cloud manager afterwards (if you intend to use this tool again, otherwise old settings can affect the new deployment)
```
zsh clean-up.sh # or bash clean-up.sh
Attempting to remove my-replica-set
mongodb.mongodb.com "my-replica-set" deleted
Attempting to remove operator
deployment.apps "mongodb-enterprise-operator" deleted
Attempting to remove the minikube cluster
🔥  Deleting "cloudmanager" in docker ...
🔥  Deleting container "cloudmanager" ...
🔥  Removing /home/karl/.minikube/machines/cloudmanager ...
💀  Removed all traces of the "cloudmanager" cluster.
You should delete the project from Cloud Manager also, so new deploys go smoothly and are not affected
by settings from the old project.

Done
```

# Changelog
2021-06-14 Added zsh script, both bash|zsh prompt for missing values