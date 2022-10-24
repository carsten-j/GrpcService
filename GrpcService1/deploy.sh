az group create --name $1 --location "northeurope"
az deployment group create --resource-group $1 --template-file app.bicep




az group create --name myResourceGroup10 --location "northeurope"
az deployment group create --resource-group myResourceGroup9 --template-file ./GrpcService1/app.bicep

