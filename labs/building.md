# Building Your GenAI App

In this lab you’ll review your GenAI landing-zone architecture, explore the dev environment you provisioned in Lab 1, then deploy the orchestrator code from the GPT-RAG template into that same environment.

![Architecture Overview](../media/ai_landing_zone.png)

_Above: the GenAI landing zone and AI Foundry Agent standard setup you provisioned with **azd provision**._



## Success Criteria

- Identify all deployed resources in the Azure Portal “dev” environment  
- Clone the GPT-RAG Orchestrator template and configure it against your existing azd environment  
- Deploy the orchestrator Container App and successfully POST to `/orchestrator` endpoint  



## Task 1: Review Your Architecture in the Portal

1. Open the Azure Portal and navigate to the **Resource Group** you created in Lab 1.  
2. Verify these key resources exist:  
   - Azure AI Foundry Project & AI Agent Service  
   - Azure Cognitive Services index (Employee Handbook)  
   - Container Apps environment (Infra and Orchestrator apps)  
3. Explore networking settings, App Configuration, and any private endpoints.



## Task 2: Clone the Orchestrator Template

1. In your browser, go to https://github.com/Azure/gpt-rag-orchestrator.git  
2. Click **Use this repository as a template**, name it (e.g. contoso-orchestrator), and create.  
3. Clone your new repo locally and change directory:  
```   
   git clone https://github.com/<your-org>/contoso-orchestrator.git  
   cd contoso-orchestrator   
```

4. Fetch tags and check out v2.0.0:  
```
   git fetch --all --tags  
   git checkout tags/v2.0.0  
```



## Task 3: Hook into Your Existing AZD Environment

1. Refresh azd environment settings:  
```   
       azd env refresh  
```

2. When prompted, select the **existing** environment, subscription, location and resource group from Lab 1.  

   _Do not create a new resource group – reuse your dev environment._



## Task 4: Explore the Orchestrator Code

1. Open the `orchestration/` folder in your code editor.  

2. Locate the FastAPI app and `Orchestrator` class (in orchestrator.py).  

3. Review how the agent is created, how thread/agent IDs are stored, and how `stream_response()` is called.



## Task 5: Deploy the Orchestrator

1. Deploy to Azure Container Apps:  
```
       azd deploy  
```
       
2. Wait for the CLI to finish and note your orchestrator URL, for example:  
   
       https://capp-vgo24eyyo4gf2-orchestrator.kindmushroom-0bbe9868.swedencentral.azurecontainerapps.io/orchestrator  



## Task 6: Test Your Endpoint

1. In any REST client like [HTTPie](https://httpie.io/), send a POST to your orchestrator URL with JSON body:  
```
       {
         "conversation_id": "",
         "ask": "Describe the Contoso Electronics employee benefits program.",
         "client_principal_id": "abc12345-6789-4def-0123-456789abcdef",
         "client_principal_name": "johndoe@example.com",
         "client_group_names": ["genai-users","hr-team"],
         "access_token": "dummy"
       }  
```

2. Confirm you receive a streamed, handbook-grounded response.  

3. Try another HR question, such as:  
   - “What is the process for requesting vacation?”  
   - “How do I enroll in the healthcare plan?”  

-

Congratulations—you’ve deployed your GenAI orchestrator into your dev environment and verified end-to-end functionality!  
