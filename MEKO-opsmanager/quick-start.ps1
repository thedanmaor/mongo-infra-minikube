# This is an experiment
$MEKO_namespace="mongodb"

# Prompt for memory and default to 8GB
Write-Host "How much memory have you given to docker"
Write-Host "1. 8GB"
Write-Host "2. 16GB"
Write-Host "3. 32GB"
Write-Host "4. 64GB"

$memory_option = Read-Host -Prompt "Enter a number 1-4: "

Switch ($memory_option)
{
    1 {
        $minikube_memory="7900mb"
        # 7900MB = 7534Mi
        $om_om_memory="4500Mi"
        $om_appdb_memory="700Mi"
        $deploy_mem="700Mi"
    }
    2 {
        $minikube_memory="15800mb"
        $om_om_memory="5500Mi"
        $om_appdb_memory="900Mi"
        $deploy_mem="9000Mi"
    }
    3 {
        $minikube_memory="31900mb"
        $om_om_memory="6000Mi"
        $om_appdb_memory="1200Mi"
        $deploy_mem="1200Mi"
    }
    4 {
        $minikube_memory="63800mb"
        $om_om_memory="8000Mi"
        $om_appdb_memory="2000Mi"
        $deploy_mem="1200Mi"
    }
}

# Prompt for operator version and default to 1.26.0
Write-Host "Which version of the operator would you like to install?"
Write-Host "1. 1.26.0"
Write-Host "2. 1.25.0"
Write-Host "3. 1.24.0"
Write-Host "4. custom"

$meko_version_option = Read-Host -Prompt "Enter a number 1-4: "

Switch ($meko_version_option)
{
    1 {
        $MEKO_version="1.26.0"
    }
    2 {
        $MEKO_version="1.25.0"
    }
    3 {
        $MEKO_version="1.24.0"
    }
    4 {
        $MEKO_version= Read-Host -Prompt "Enter an operator version: "
    }
}



# Prompt for Ops Manager version
Write-Host "Which version of Ops Manager would you like to install?"
Write-Host "1. 7.0.8"
Write-Host "2. 6.0.24"
Write-Host "3. custom"

$meko_version_option = Read-Host -Prompt "Enter a number 1-4: "

Switch ($meko_version_option)
{
    1 {
        $OM_VERSION="7.0.8"
    }
    2 {
        $OM_VERSION="6.0.24"
    }
    3 {
        $OM_VERSION= Read-Host -Prompt "Enter an Ops Manager version: "
    }
}

# Check if minikube is available and run it
Write-Host "Creating a Kubernetes cluster via minikube"
minikube start --cpus=4 --memory="$minikube_memory" --disk-size=60000mb -p opsmanager --namespace "$MEKO_namespace"

# Check if kubectl is availabe us it to install the operator
Write-Host "Installing the operator into the mongodb namespace"
kubectl create namespace mongodb
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/$MEKO_version/mongodb-enterprise.yaml
kubectl describe deployments mongodb-enterprise-operator -n "$MEKO_namespace"

# Generate Ops Manager
Get-Content -Path templates\deploy-om.template | %{ $_ -replace 'om_version_goes_here', "$OM_VERSION"} | %{ $_ -replace 'om_om_memory', "$om_om_memory"} | %{ $_ -replace 'om_appdb_memory', "$om_appdb_memory"} | Out-File -FilePath deploy-om.yaml

# Generate Deployment
Get-Content -Path templates\deploy-mdb.template | %{ $_ -replace 'deploy_mem_goes_here', "$deploy_mem"} | Out-File -FilePath deploy-mdb.yaml

# Deploy and Display
kubectl apply -f deploy-om.yaml
Write-Host ""
kubectl get om -w
