# Lab 4: Evaluating Your App Responses

In this lab, you’ll use the built-in evaluation harness in your orchestrator template to measure how well your agent answers real questions from the Contoso Electronics Employee Handbook. The template includes an `evaluations` folder with a Python script (`evaluate.py`) and a test dataset (`chat_eval_data.jsonl`). You will run that script from PowerShell, inspect the JSON output locally, then review the same results in the Azure AI Studio portal under your AI Foundry project’s **Evaluations** tab.

---

## Success Criteria

- You can locate and inspect the evaluation code and data in your cloned repo  
- All Python dependencies are installed and environment variables are loaded correctly  
- The evaluation script runs without errors and writes its results to `evaluation/evaluation-results.json`  
- You understand the key metrics produced (e.g., similarity scores)  
- You can open the AI Foundry project in Azure Portal and view the evaluation entry  

---

## Prerequisites

<details markdown="block">
<summary>Click to expand prerequisites</summary>

- **Local environment**  
  - PowerShell (or Windows Terminal) with Python 3.11  
  - Your cloned orchestrator repo at the v2.0.0 tag  
  - A Python virtual environment activated, if you use one  

- **Azure resources**  
  - Active Azure subscription with the AI Hub project you provisioned in Labs 1–3  
  - AI Agent Service and Cognitive Services index loaded with the Employee Handbook  
  - App Configuration endpoint and AI Foundry connection string set as environment variables  

- **Files in place**  
  - `evaluations/evaluate.py`  
  - `evaluations/dataset/chat_eval_data.jsonl`  
</details>

---

## Task 1: Review the Evaluation Folder

1. In your code editor, open the `evaluations/` directory.  

2. Confirm you see two items:  
   - `evaluate.py` (the orchestration evaluation script)  
   - `dataset/chat_eval_data.jsonl` (JSON Lines file with sample queries and ground truth)  

3. Skim through `evaluate.py` to note:  
   - It uses FastAPI’s TestClient to invoke your `/orchestrator` endpoint  
   - It wraps each query in a call to a `SimilarityEvaluator`  
   - Results are written to `evaluation/evaluation-results.json` and printed  

---

## Task 2: Install and Verify Dependencies

1. In PowerShell, change directory to your project root.  

2. If you haven’t already, install the required packages:  
      
       pip install -r requirements.txt  

3. Confirm that `azure-ai-projects`, `azure-ai-evaluation`, `azure-identity`, `pandas`, and `fastapi` are all installed.  

4. Ensure your environment variables are set:  
   - `APP_CONFIG_ENDPOINT`  
   - `AI_FOUNDRY_PROJECT_CONNECTION_STRING`  
   - `OPENAI_DEPLOYMENT_NAME`, etc.  

   You can verify by running:  

```      
       echo $Env:APP_CONFIG_ENDPOINT  
```

---

## Task 3: Execute the Evaluation Script

1. Change directory into the `evaluations` folder.  

2. Run the evaluation script:  

```      
   python .\evaluate.py  
```

3. Observe the console:  
   - The script will print “-----Summarized Metrics-----” followed by overall similarity scores  
   - It will show “-----Tabular Result-----” with a preview of each query’s response vs. ground truth  
   - Finally, it will display the link to view results in AI Studio  

4. Look for the output file at `evaluations/evaluation-results.json`. Open it in your editor to see the raw JSON, which includes:  
   - `rows`: an array of individual query results  
   - `metrics`: aggregate scores (e.g., average, min, max similarity)  
   - `studio_url`: direct link to the evaluation entry in Azure Portal  

---

## Task 4: Inspect Local Results

1. Open `evaluations/evaluation-results.json`.  
2. Identify one example row and check:  
   - `query` matches your input from `chat_eval_data.jsonl`  
   - `response` is the text returned by your orchestrator  
   - `ground_truth` matches the expected answer  
   - `similarity` shows how closely the response aligns with the truth  

3. Reflect on any low-scoring items—these indicate where your agent might need prompt tuning or more context data.

---

## Task 5: Review in Azure AI Studio

1. In the Azure Portal, navigate to your AI Hub → your AI Foundry project.  
2. Select the **Evaluations** tab in AI Agent Service.  
3. Find the entry named “evaluate_contoso_similarity” (or the name you see in your script).  
4. Click the entry to explore:  
   - Overall evaluation metrics dashboard  
   - Individual query cards showing query, response, ground truth, and similarity score  
   - Option to re-run the evaluation or compare with past runs  

---

Congratulations! You have successfully run a similarity-based evaluation of your Contoso orchestrator and examined the results both locally and in AI Studio. Next up: Lab 5 – Automating Deployment with CI/CD.  
