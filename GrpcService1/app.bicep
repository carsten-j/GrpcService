param location string = resourceGroup().location // Location for all resources
param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param repositoryUrl string = 'https://github.com/carsten-j/GrpcService'
param branch string = 'master'
param sku string = 'B1'
var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  kind: 'linux'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webSiteName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    enabled: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      alwaysOn: false
      http20Enabled: true
      appSettings: [
        {
          name: 'HTTP20_ONLY_PORT'
          value: '8585'
        }
      ]
      http20ProxyFlag: 1
    }
    httpsOnly: true
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: '${appService.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
