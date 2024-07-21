# Usage

### Example 1, Deploy OM and Replica Set
```
# Setup Ops Manager
bash quick-start.sh
```
This can take some time, maybe 6 or 7 minute (longer if your connection is slow). Wait for the output to show Ops Manager is running. Then hit ctrl+c to get your prompt back.

On Linux:
1. run the command `minikube ip`
2. Using a browser visit http://<ip.address.from.command>:30100 to view Ops Manager

On Mac:
1. nohup kubectl port-forward pod/mongo-infra-minikube-0 8080:8080 &
2. Then visit http://localhost:8080

---

Username: admin
Password: Passw0rd1!

---


```
# Setup Org, config map and secret for a deployment and sample deployment (you can deploy or edit and apply yourself)
bash extras.sh
```

### Clean Up

This will remove the kubernetes cluster and with it Ops Manager and your database
```
bash clean-up.sh
```

# Changelog
2024-07-21 Support for machines with only 16GB of RAM
2024-07-19 Bring up any version of operator with Ops Manager 6.0.24
2024-06-14 Added zsh script, both bash|zsh prompt for missing values
