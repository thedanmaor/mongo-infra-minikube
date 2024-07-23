$AKO_namespace="mongodb-atlas-system"

$AKO_ORGID = Read-Host -Prompt "Enter Organization ID"
$AKO_PROJ = Read-Host -Prompt "Enter Project ID"
$AKO_PUBKEY = Read-Host -Prompt "Enter Organization ID"
$AKO_PRIKEY = Read-Host -Prompt "Enter Organization ID"
$AKO_PROJNAME = Read-Host -Prompt "Enter Organization ID"

### Prompt for version
Write-Host "What version of the operator would you like to install"
Write-Host "1. v2.3.1"
Write-Host "2. v2.2.2"
Write-Host "3. v2.0.1"
Write-Host "4. custom"
$version_prompt = Read-Host -Prompt "Enter version"
Switch ($version_prompt)
{
    1 {
        $AKO_version = "v2.3.1"        
    }
    2 {
        $AKO_version = "v2.2.2"
    }
    3 {
        $AKO_version = "v2.0.1"
    }
    4 {
        $AKO_version = Read-Host -Prompt "Enter version"
    }
}

### Setup Kubernetes Cluster
minikube start --cpus=2 --memory=2G --disk-size=5000mb -p atlas --namespace $AKO_namespace
echo "=== Kubernetes Setup ==="
echo "- profile = atlas"
echo "- CPUs = 2"
echo "- Memory = 2G"
echo "- Disk space= 5G" 

# Use Atlas CLI to deploy operator, or download it if the user doesn't have it
$atlas_cli_present = Read-Host -Prompt "Do you have Atlas CLI installed, Y/N"
Switch ($atlas_cli_present)
{
    Y {
        kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-atlas-kubernetes/$AKO_version/deploy/all-in-one.yaml
    }
    N {
        echo "Downloading it for you to file > atlas-cli-setup.msi < please install and run again"
        Invoke-WebRequest -Uri https://fastdl.mongodb.org/mongocli/mongodb-atlas-cli_1.25.0_windows_x86_64.msi -OutFile atlas-cli-setup.msi
        exit
    }
}

# get tommorrows date in YYYY-MM-DD format
$AKO_KEEPUNTIL=(Get-Date).adddays(1).ToString("yyy-MM-dd")

# get out ip address so that we can allow access from it
$AKO_IPACCESS=(Invoke-WebRequest -Uri https://ipinfo.io/ip).Content

# modify our template file
Get-Content -Path templates\deploy-om.template | %{ $_ -replace 'AKO_ORGID', "$AKO_ORGID"} | %{ $_ -replace 'AKO_PROJID', "$AKO_PROJID"} | %{ $_ -replace 'AKO_PUBKEY', "$AKO_PUBKEY"} | %{ $_ -replace 'AKO_PRIKEY', "$AKO_PRIKEY"} | %{ $_ -replace 'AKO_PROJNAME', "$AKO_PROJNAME"} | %{ $_ -replace 'AKO_IPACCESS', "$AKO_IPACCESS"} | %{ $_ -replace 'AKO_KEEPUNTIL', "$AKO_KEEPUNTIL"} | Out-File -FilePath deploy-a-cluster.yaml

# modify our clean up file
# TODO

# Output
echo "Cluster can been deployed using the command:"
echo "$ kubectl apply -f deploy-a-cluster.yaml"
echo
echo "Please modify the above file to your requirments before running"
