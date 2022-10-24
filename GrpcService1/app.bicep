param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param location string = resourceGroup().location // Location for all resources
var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')
param repositoryUrl string = 'https://github.com/carsten-j/GrpcService'
param branch string = 'master'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  kind: 'linux'
  location: location
  properties: {
    workerSize: 'Default'
    workerSizeId: 0
    currentWorkerSize: 'Default'
    currentWorkerSizeId: 0
    currentNumberOfWorkers: 1
    webSpace: 'asdfawer-WestEuropewebspace-Linux'
    planName: 'VirtualDedicatedPlan'
    computeMode: 'Dedicated'
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    kind: 'linux'
    reserved: true
    isXenon: false
    hyperV: false
    mdmId: 'waws-prod-am2-603_9267'
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
  sku: {
    name: 'B1'
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webSiteName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    enabled: true
    adminEnabled: true
    siteProperties: {
      metadata: null
      properties: [
        {
          name: 'LinuxFxVersion'
          value: 'DOTNETCORE|6.0'
        }
        {
          name: 'WindowsFxVersion'
          value: null
        }
      ]
      appSettings: null
    }
    reserved: true
    isXenon: false
    hyperV: false
    storageRecoveryDefaultState: 'Running'
    contentAvailabilityState: 'Normal'
    runtimeAvailabilityState: 'Normal'
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|6.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    sku: 'B1'
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    kind: 'app,linux'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    siteDisabledReason: 0
    httpsOnly: true
    http20ProxyFlag: 1
    redundancyMode: 'None'
    privateEndpointConnections: []
    eligibleLogCategories: 'AppServiceAppLogs,AppServiceAuditLogs,AppServiceConsoleLogs,AppServiceHTTPLogs,AppServiceIPSecAuditLogs,AppServicePlatformLogs,ScanLogs'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
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
