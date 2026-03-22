RG=aks-rg
LOC=centralindia
ACR_NAME=myacr121
AKS_NAME=myaks121

az group create -n $RG -l $LOC

az acr create -n $ACR_NAME -g $RG --sku Basic

az aks create -n $AKS_NAME -g $RG --node-count 1 --enable-managed-identity

az aks get-credentials -n $AKS_NAME -g $RG

az aks update -n $AKS_NAME -g $RG --attach-acr $ACR_NAME
