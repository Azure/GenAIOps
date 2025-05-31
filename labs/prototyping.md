# From Idea to Prototype

In this lab, you will select and compare AI models in Azure AI Foundry, then prototype an agent connected to your RAG index. The sample project is **Contoso Electronics**, which already has the **Employee Handbook** indexed in Azure Cognitive Services. You’ll learn how to:

- Browse the **Model Catalog** in AI Agent Service  
- Run a **model comparison** using the 4.1 baseline model  
- Launch the **Agent Playground**, hook up your RAG index, and test an agent  

---

## Success Criteria

- You can locate and explore models in the AI Agent Service catalog  
- You’ve run a side-by-side comparison of the 4.1 model against another candidate  
- You’ve created an agent in the playground, connected it to the Contoso Electronics Employee Handbook index, and tested it with sample queries  

---

## Prerequisites

<details markdown="block">
<summary>Expand to view prerequisites</summary>

### Required Tools & Access  
- **Azure Portal** access with contributor rights on your AI Hub  
- **Azure AI Foundry** enabled in your subscription  
- The Contoso Electronics **Employee Handbook** indexed in Azure Cognitive Services (from Lab 1)  
- Familiarity with the Azure Portal UI  

</details>

---

## Task 1: Browse the Model Catalog

1. In the Azure Portal, navigate to your **AI Hub** from Lab 1.  
2. Select **AI Agent Service** → **Model Catalog**.  
3. Observe the list of available models (e.g., “gpt-4o”, “gpt-4o-mini”, “gpt-4.1”, etc.).  
4. Click **gpt-4.1** to view details:  
   - Training data cut-off  
   - Token limits  
   - Pricing and SLA  

> **Highlight:** Model details help you choose the right balance of capability, cost, and latency.

---

## Task 2: Run a Model Comparison

1. In **Model Catalog**, click **Compare models**.  
2. Choose **gpt-4.1** as Model A and another candidate (e.g., gpt-4o-mini) as Model B.  
3. Use this prompt for both:
   > “Summarize the key policies in the Contoso Electronics Employee Handbook.”  
4. Submit and wait for side-by-side responses.  
5. Evaluate:
   - **Quality** (completeness, clarity)  
   - **Latency** and **token usage**  

> **Tip:** Note which model gives the most accurate handbook summary with acceptable performance.

---

## Task 3: Prototype in the Agent Playground

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

---

Congratulations—you’ve completed Lab 2! You’ve explored model options, compared a baseline, and built a prototype agent grounded in your Contoso Electronics Employee Handbook. Next up: Lab 3, where you’ll implement core GenAI app features in code.  
