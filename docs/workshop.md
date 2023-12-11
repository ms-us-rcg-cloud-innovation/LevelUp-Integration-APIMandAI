# Workshop - Using Azure API Management to manage an OpenAI API
In this workshop, you play the role of an architect who is responding to a request from the business to build an advanced chatbot experience to drive engagement and awareness about the company's products and capabilities.  The business has already selected OpenAI as the AI engine to power the chatbot.  Your job is to build the infrastructure to support the chatbot and ensure it can scale to meet the expected demand.

## Getting started
### Deploying the infrastructure
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

### Deploying the function
Once the infrastructure has been deployed, you need to deploy the function.  The function is responsible for proxying requests to OpenAI so that we can simulate 429 responses.  To deploy the function, run the following command from the ```src\ProxyOpenAIEndpoint``` folder:

```func azure functionapp publish <function app name>```

After the function is deployed, you need to fetch the Open AI Service Keys and Endpoint information to configure the function.

## Scenario 1
The business is intending to promote their capabilities by creating a magic mirror chat bot experience.  The idea is to let customers ask questions about anything that may come to mind and respond as if it were the magic mirror from the classic movie Snow White and the 7 Dwarfs.  While you are focused on the API, it needs to be kept in mind that the UI for the experience will be built for multiple different platforms and clients.  The API needs to be flexible enough to support the different UIs.

### Task 1 - Deploy the Open AI Model
First we need to deploy a model to our Open AI service.

### Task 2 - Create the Backend
We now need to configure the backend for the API.

### Task 3 - Create the API

### Task 4 - Create the Product
We want to create a product to manage access to the Magic Mirror API.  This will allow us to control access to the API and provide multiple authentication mechanisms to support different clients.

### Task 5 - Create the Policy and Supporting Policy 
We need an easy way to control the system message that is sent to OpenAI.  We want to be able to adjust the message as we refine how the system responds to users.  To do this, we will create a Policy Fragment that will pull the System Message from a variable and insert it into the call to the backend system.

### Task 6 - Test the API
Using your favorite tool, call the APIM endpoint and ask the Magic Mirror a question.

## Scenario 2
The Magic Mirror experience has been a wild success, now the business would like to create a Zoltar chat bot experience.  The idea is to let customers ask questions about anything that may come to mind and respond as if it were the Zoltar machine from the classic movie Big.  While you are focused on the API, it needs to be kept in mind that the UI for the experience will be built for multiple different platforms and clients.  The API needs to be flexible enough to support the different UIs.

### Task 1 - Create the product
Since the model has already been deployed, we can leverage the same model for the Zoltar experience.  First up, we will create a product for the Zoltar experience.

### Task 2 - Refactor the Policy to support both Products
Next, we need to setup a new variable to hold the system message for Zoltar and then update the policy to use either the Zoltar or Magic Mirror system message based on the product being used.

### Task 3 - Test the APIs
Again, using your favorite tool, call the APIM endpoint with the Zoltar subscription key and verify the response is coming from Zoltar.  Then call the APIM endpoint with the Magic Mirror subscription key and verify the response is coming from the Magic Mirror.

## Scenario 3
Well... that didn't last long.  The campaign has been wildly successful and the business is now seeing a huge spike in traffic.  This is causing the OpenAI service to be throttled and return 429 respsponses.  The business is not happy and is demanding that you fix the problem immediately as they are getting negative feedback from customers.

### Task 1 - Deploy a new OpenAI Model

### Task 2 - Create a new Backend in APIM

