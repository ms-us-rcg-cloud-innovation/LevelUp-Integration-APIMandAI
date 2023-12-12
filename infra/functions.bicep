param location string = resourceGroup().location
param storageAccountName string
param functionAppName string
param applicationInsightsKey string
param openAiServiceName string

resource site 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  kind: 'functionapp,linux'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      alwaysOn:true
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsKey
        }
        {
          name: 'AZURE_OPENAI_SERVICENAME'
          value: openAiServiceName
        }
        {
          name: 'AZURE_OPENAI_APIVERSION'
          value: '2023-05-15'
        }
      ]
    }
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${functionAppName}Plan'
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
