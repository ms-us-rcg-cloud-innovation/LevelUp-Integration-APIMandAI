# Scenario
- Leverage GPT-4 model when possible, but be prepared to use GPT-3 if necessary due to rate limiting
- Setup products for Zoltar and Magic Mirror
- Depending on product being used, hard code the system message so the response acts like either Zoltar or Magic Mirror
- Leverage App Insights to trace/debug the system

## Pre-Requisites
- Azure Subscription with contributor permissions
- Azure CLI
- Azure Functions Core Tools

## Infrastructure Overview
The infrastructure is fairly simple.  We are going to use a function as a proxy between APIM and OpenAI GPT-4 API so we can generate 429 responses when needed without actually becoming rate limited.

![Alt text](docs/img/scenariooverview.drawio.svg)

## Workshop
The workshop will show you how to leverage APIM to manage connectivity to OpenAI in situations where a high volume of requests are expected.

In this workshop you will learn about the following API Management capabilities;
- API Management Policies
- API Management Products
- Configuring APIM Backends
- Leveraging APIM variables in policies
- Azure Open AI System Message
- API Management Instrumentation

You can find the workshop here: [Workshop](docs/workshop.md)