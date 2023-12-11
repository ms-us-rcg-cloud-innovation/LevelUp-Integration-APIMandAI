# Workshop - Using Azure API Management to manage an OpenAI API
In this workshop, you play the role of an architect who is responding to a request from the business to build an advanced chatbot experience to drive engagement and awareness about the company's products and capabilities.  The business has already selected OpenAI as the AI engine to power the chatbot.  Your job is to build the infrastructure to support the chatbot and ensure it can scale to meet the expected demand.

## Getting started
First things first, you need to clone this repo to your local machine and deploy the infrastructure.  Infrastructure templates have been provided for your convinience and can be found in the ```infra``` folder.  After cloning the repo, open a terminal window and navigate to the ```infra``` folder.  From there, run the following commands:

```az deployment sub create --location eastus --template-file main.bicep```

The deployment process should take about 5 minutes to 10 minutes to complete.  This will deploy the following resources:
- Azure Function App
- Azure Function App Plan
- Azure Application Insights
- Azure API Management
- Azure OpenAI
- Azure Key Vault
- Azure Log Analytics Workspace

## Scenario 1
The business is intending to promote their capabilities by creating a magic mirror chat bot experience.  The idea is to let customers as questions about anything that may come to mind and respond as if it were the magic mirror from the classic movie Snow White and the 7 dwarfs.  While you are focused on the API, it needs to be kept in mind that the UI for the experience will be built for multiple different platforms and clients.  The API needs to be flexible enough to support the different UIs.

