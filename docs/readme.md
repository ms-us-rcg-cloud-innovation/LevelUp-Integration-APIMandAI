# Scenario
- Leverage GPT-4 model when possible, but be prepared to use GPT-3 if necessary due to rate limiting
- Setup products for Zoltar and Magic Mirror
- Depending on product being used, hard code the system message so the response acts like either Zoltar or Magic Mirror
- Leverage App Insights to trace/debug the system

## Infrastructure Overview
The infrastructure is fairly simple.  We are going to use a function as a proxy between APIM and OpenAI GPT-4 API so we can generate 429 responses when needed without actually becoming rate limited.

![Alt text](img/scenariooverview.drawio.svg)