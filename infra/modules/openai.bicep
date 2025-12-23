// Microsoft Foundry (Azure AI Services) Module
@description('Name of the Azure OpenAI resource')
param openAiName string

@description('Location for the Azure OpenAI resource')
param location string = resourceGroup().location

@description('SKU for the Azure OpenAI resource')
param sku string = 'S0'

@description('Tags for the resource')
param tags object = {}

@description('Deployments to create')
param deployments array = []

resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openAiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: sku
  }
  tags: tags
  properties: {
    customSubDomainName: openAiName
    publicNetworkAccess: 'Enabled'
  }
}

resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for item in deployments: {
  parent: openAi
  name: item.name
  sku: {
    name: 'Standard'
    capacity: item.capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: item.model
      version: item.version
    }
  }
}]

@description('The endpoint of the Azure OpenAI resource')
output endpoint string = openAi.properties.endpoint

@description('The resource ID of the Azure OpenAI resource')
output openAiId string = openAi.id

@description('The name of the Azure OpenAI resource')
output openAiName string = openAi.name
