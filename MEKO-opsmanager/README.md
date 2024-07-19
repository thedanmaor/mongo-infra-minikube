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
# Setup Ops Manager
bash quick-start.sh
# Setup Org, config map and secret for a deployment
bash extras.sh
# deploy a Replica Set?
kubectl apply -f https://github.com/mongodb/mongodb-enterprise-kubernetes/raw/master/samples/mongodb/agent-startup-options/replica-set-agent-startup-options.yaml
```

### What next
- It should take a few minutes for your Ops Manger project to be created 
- The pods should come up one at a time and start to appear on the servers tab
- Each pod will download the mongod binary and mongosh
- Each pod will start mongod
- Ops Manager automation will configure the replica set
- A primary will be elected

### Clean Up

This has some pauses built in to ensure proper cleanup, it can take a couple of minutes. **You manually need to** remove the 'kubernetes' project from cloud manager afterwards (if you intend to use this tool again, otherwise old settings can affect the new deployment)
```
bash clean-up.sh
```

# Changelog
2024-07-19 Bring up any version of operator with Ops Manager 6.0.24
2024-06-14 Added zsh script, both bash|zsh prompt for missing values