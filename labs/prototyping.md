# From Idea to Prototype

In this lab, you will select and compare AI models in Azure AI Foundry, then prototype an agent connected to your RAG index. The sample project is **Contoso Electronics**, which already has an index that you will use to ground your answers. You’ll learn how to:

- Browse the **Model Catalog** in AI Agent Service  
- Run a **model comparison** using the 4.1 baseline model  
- Index your documents in an AI Search Index
- Launch the **Agent Playground**, hook up your RAG index, and test an agent  

## Success Criteria

- You can locate and explore models in the AI Agent Service catalog  
- You’ve run a side-by-side comparison of the 4.1 model against another candidate  
- You’ve created an agent in the playground, connected it to the Contoso Electronics Employee Handbook index, and tested it with sample queries  

## Prerequisites

<details markdown="block">
<summary>Expand to view prerequisites</summary>

### Required Tools & Access  
- **Azure Portal** access with contributor rights on your AI Foundry  
- **Azure AI Foundry** enabled in your subscription  
- The Contoso Electronics **Employee Handbook** indexed in Azure Cognitive Services (from Lab 1)  
- Familiarity with the Azure Portal UI  

</details>

## Task 1: Browse the Model Catalog

1. In the Azure Portal, navigate to your **AI Foundry** from Lab 1.  
2. Select **AI Agent Service** → **Model Catalog**.  
3. Observe the list of available models (e.g., “gpt-4o”, “gpt-4o-mini”, “gpt-4.1”, etc.).  
4. Click **gpt-4.1** to view details:  
   - Training data cut-off  
   - Token limits  
   - Pricing and SLA  

> **Highlight:** Model details help you choose the right balance of capability, cost, and latency.

## Task 2: Run a Model Comparison

1. In **Model Catalog**, click **Compare models**.  
2. Choose **gpt-4.1** as Model A and another candidate (e.g., gpt-4o-mini) as Model B.  
3. Use this prompt for both:
   > "Summarize the key policies in the Contoso Electronics Employee Handbook."  
4. Submit and wait for side-by-side responses.  
5. Evaluate:
   - **Quality** (completeness, clarity)  
   - **Latency** and **token usage**  

> **Tip:** Note which model gives the most accurate handbook summary with acceptable performance.

## Task 3: Index Your **Employee Handbook** in Azure AI Search

To index the content, you will need to deploy the data ingestion service that implements the chunking logic for documents into your index. Follow these steps:

### 1. Open a terminal and navigate to your desired working directory

```bash
cd workspace
```

### 2. Create and navigate to a folder for the data ingestion service

```bash
mkdir gpt-rag-ingestion
cd gpt-rag-ingestion
```

### 3. Initialize the project using the GPT-RAG ingestion template with Azure Developer CLI

```bash
azd init -t azure/gpt-rag-ingestion -b feature/vnext-architecture
```

Follow the interactive prompts to sign in, select your Azure subscription, and choose the same resource group and location used during the bootstrapping.

### 4. Deploy the project using Azure Developer CLI

```bash
azd deploy
```

### 5. Upload the employee handbook PDF

Upload the [`employee_handbook.pdf`](https://github.com/Azure/gpt-rag-ingestion/blob/feature/vnext-architecture/samples/documents/contoso-eletronics/employee_handbook.pdf) to the **documents** container in your **Storage Account** (make sure it is the one **without 'foundry' in its name**).

### 6. Trigger the indexer manually

Go to the **AI Search** service in the [Azure portal](https://portal.azure.com). Choose the service that does **not** include 'foundry' in the name. Locate the indexer whose name begins with `ragindexer`, and click **Run** to trigger document indexing.


## Task 4: Prototype in the Agent Playground

### A. Test Without the Index

1. In **AI Agent Service**, go to **Agent Playground**.  
2. Create a new agent using your chosen model (e.g., gpt-4.1).  
3. In the chat window, ask:
   - “What is Contoso Electronics’ return policy?”  
   - “How many paid holidays do employees receive?”  
4. Notice that answers are generic and not grounded to your handbook content.

### B. Attach the Contoso Electronics Handbook Index

1. Under **Data sources**, add Azure Cognitive Services.  
2. Select the **Employee Handbook** index you provisioned in Lab 1.  
3. Configure retrieval:
   - **Top K results**: 3  
   - **Filter**: leave blank  
4. Save the agent and restart the session.

### C. Test With the Index

1. Ask the same questions again:
   - “What is Contoso Electronics’ vacations policy?”  
   - “How many paid holidays do employees receive?”  
2. Observe that responses now cite specific handbook sections and are fully grounded.  
3. Experiment further:
   - “List any confidentiality requirements.”  
   - “Explain the process for requesting remote work.”  

> **Insight:** Grounded responses pull direct passages from the indexed handbook, ensuring accuracy.

Congratulations—you’ve completed Lab 2! You’ve explored model options, compared a baseline, and built a prototype agent grounded in your Contoso Electronics Employee Handbook. Next up: Lab 3, where you’ll implement core GenAI app features in code. 