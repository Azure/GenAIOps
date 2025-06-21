# From Idea to Prototype

> 🎥 **Watch the step-by-step demo**: [Prototyping with Azure AI Foundry](https://www.youtube.com/embed/ohgpsAIZ1w4?autoplay=1)

In this lab, you will select and compare AI models in Azure AI Foundry, then prototype an agent connected to your RAG index. The sample project is **Contoso Electronics**.

- Browse the **Model Catalog** in AI Agent Service  
- Run a **model comparison** using the 4.1 baseline model  
- Index your documents in an AI Search Index
- Launch the **Agent Playground**, hook up your RAG index, and test an agent  

## Success Criteria

- You can locate and explore models in the AI Agent Service catalog  
- You’ve run comparison between models  
- You’ve created an agent in the playground, connected it to the Contoso Electronics Employee Handbook index, and tested it with sample queries  


## Prerequisites

<details markdown="block">
<summary>Expand to view prerequisites</summary>

### Required Tools & Access  

- **Bootstraping**: Ensure you have completed the bootstraping process and have a running environment.  
- **Docker Desktop**: [Download and install Docker Desktop](https://docs.docker.com/get-started/introduction/get-docker-desktop/).  

</details>

## Task 1: Browse the Model Catalog

1. In the Azure Portal, navigate to your **AI Foundry** project from bootstraping.
2. Select **Model Catalog**.
3. Review the list of available models (e.g., `gpt-4o`, `gpt-4o-mini`, `gpt-4.1`, etc.).
4. Click on **gpt-4.1** to view its details:

   * Training data cut-off
   * Token limits
   * Pricing and SLA

> **Highlight:** Understanding model details helps balance capability, cost, and latency.

---

## Task 2: Run a Model Comparison

1. In the **Model Catalog**, select **gpt-4.1**.
2. Analyze the following characteristics:

   * Token window
   * Cost and pricing
   * Regional availability
   * Retirement date
3. Click on the **Benchmarking** tab to compare **gpt-4.1** with other models across multiple dimensions.
4. Return to the Model Catalog home page and click on the **Vrowse leaderboards** button.
5. In the **Trade-off Charts** section:

   * A. Under *Quality vs Cost*, select only the models you want to compare (e.g., `gpt-4.1` and `gpt-4.1-mini`).
   * B. Under *Quality vs Throughput*, select the same models again to compare performance.
6. Observe how `gpt-4.1-mini` offers a good balance between quality, cost, and latency—often making it a solid option for early prototyping.
7. Based on the insights from the model details and comparison charts, you now have enough information to confidently select a model to start building your prototype. For this use case, we will proceed with `gpt-4.1-mini`.
8. In the *Trade-off Charts*, click directly on the `gpt-4.1-mini` bubble. A popup will appear.
9. In the popup, click **Go to model details**.
10. On the model detail page, click the **Use this model** button.
11. In the "Deploy gpt-4.1-mini" dialog, click **Deploy** (you can use default options).
12. After deployment is complete, you will be redirected to the deployment page.
13. Click the blue **Open in playground** button.
14. In the playground, ask:

    ```text
    What is Contoso Electronics?
    ```
15. Note: The response will be generic based on public data. In the next task, you'll use Azure AI Search to ground responses using your Employee Handbook.

---

## Task 3: Index Your **Employee Handbook** in Azure AI Search

To index the content, deploy the data ingestion service that chunks and indexes documents. Follow these steps:

### A. Prepare Your Environment

1. Open a terminal and navigate to your desired working directory:

   ```bash
   cd workspace
   ```
2. Create and enter a new folder for the ingestion service:

   ```bash
   mkdir gpt-rag-ingestion
   cd gpt-rag-ingestion
   ```
3. Initialize the project from the GPT-RAG ingestion template:

   ```bash
   azd init -t azure/gpt-rag-ingestion -b feature/vnext-architecture
   ```

   > **Important:** Select the same environment name used during bootstrapping.
4. Log in to Azure:

   ```bash
   az login
   ```
5. Refresh environment variables:

   ```bash
   azd env refresh
   ```
   > **Important:** Select the same environment name, resource group and location used during bootstrapping.

### B. Deploy the Ingestion Service

> [!IMPORTANT]
> Docker engine must be running to execute containerized applications in the next steps.

6. Deploy the project:

   ```bash
   azd deploy
   ```

### C. Upload the Employee Handbook

7. Upload the [`employee_handbook.pdf`](https://github.com/Azure/gpt-rag-ingestion/blob/feature/vnext-architecture/samples/documents/contoso-eletronics/employee_handbook.pdf) to the **documents** container in your **Storage Account** (the one **without 'foundry' in its name**).

### D. Trigger the Indexer

8. In the [Azure Portal](https://portal.azure.com), go to your **AI Search** service (again, the one without 'foundry' in its name).
9. Find the indexer that starts with `ragindexer`, and click **Run** to trigger the indexing process.

---

## Task 4: Prototype in the Agent Playground

### A. Test Without the Index

1. In **AI Agent Service**, open **Agent Playground**.
2. Create a new agent using a model (e.g., `gpt-4.1`).
3. In the chat window, ask:

   ```text
   What is Contoso Electronics?
   ```
4. Notice that the answer is generic and not grounded in your handbook.

### B. Attach the Contoso Electronics Index

1. In the left-hand **Setup** panel, go to the **Knowledge** section.
2. Click **Add AI Search Index**.
3. Choose **Index not part of this Project**.
4. Select the **AI Search connection** that corresponds to the service without 'foundry' in the name.
5. Choose the index that starts with `ragindex`.
6. Provide a display name (e.g., *Contoso Handbook*) and set the search mode to **Simple**.
7. Click **Connect**.

### C. Add Agent Instructions

1. In the **Setup** panel, under **Instructions**, paste the following:

   ```
   You are a Virtual Assistant to help Contoso Electronics Employees. Use your Knowledge Base in AI Search to ground your answers.
   ```

### D. Test With the Index

1. In the chat, ask:

   ```text
   What is Contoso Electronics' corporate policy?
   ```
2. You should now see responses grounded in the indexed handbook with citations.
3. Try another question:

   ```text
   What are Contoso Electronics Company Values?
   ```

> **Insight:** Grounded responses cite specific passages from your indexed handbook, improving accuracy and trust.

---

**✅ Congratulations!**
You’ve completed **From Idea to Prototype Lab**: explored models, performed benchmarking, and built a prototype agent using real documentation from Contoso Electronics.

Up next: **Building Lab**, where you’ll implement GenAI app features in code.