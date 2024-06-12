# Usage

You need a Cloud Manager Organisation, and an apikey (pub and private parts) which is allowed to access cloud manager from your current IP address (check this in the Cloud Manager UI). Once you have these you should export them, and then run `bash quick-start.sh` which will use these values.

If you don't provide them, we will prompt you to enter them

### Example 1, providing values
```
export CM_ORGID=5addaf80d383ad7df4cbd310
export CM_PUBKEY=uglagfda
export CM_PRIKEY=5a3f6634-1245-48c1-a683-373992baaa14
bash quick-start.sh
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
bash clean-up.sh
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