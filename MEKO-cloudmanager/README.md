# Usage

1. You need a Cloud Manager Organisation
1. An apikey (public and private parts) 
1. You must add an IP from which the key can access cloud manage

Once you have these you should export them, and then run `zsh quick-start.zsh` (on mac) or `bash quick-start.sh` (on linux) which will use these values.

If you don't provide them, we will prompt you to enter them when you run the script.

### Example 1, providing values on linux
```
bash quick-start.sh 
powershell quick-start.ps1
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
