# Lab: Automating Deployment with CI/CD

In this lab, you will configure GitHub Actions for your repo, inspect the two pipeline definitions, and run through the full feature-to-deploy workflow. You’ll learn how to:

- Set up a Service Principal and store its credentials in GitHub Secrets  
- Create GitHub Environment variables for `dev`, `qa`, and `prod`  
- Review the Pull Request and CI/CD pipeline YAML files  
- Trigger the pipelines by opening a PR and merging into `develop`  

## Success Criteria

- A Service Principal exists and its credentials are saved as a GitHub Secret  
- Each GitHub Environment (`dev`, `qa`, `prod`) has the required variables  
- You understand each step in `.github/pr_pipeline.yaml` and `.github/cicd_pipeline.yaml`  
- A PR into `develop` triggers the “Pull Request Pipeline”  
- A merge into `develop` triggers the “CI/CD Dev Pipeline” and deploys to your dev environment  

## Prerequisites

<details markdown="block">
<summary>Click to expand prerequisites</summary>

- Azure CLI (`az`) logged into your subscription  
- GitHub CLI (`gh`) installed and authenticated  
- Your feature repo created from the GPT-RAG template and initial code already pushed  
- Your lab environment variables from previous labs (`APP_CONFIG_ENDPOINT`)  
- A Service Principal with Contributor or Owner rights on your subscription  
</details>

Perfect — here’s your **Task 1** rewritten cleanly, in English, with both the **CLI one-liner** (works in Bash and PowerShell) and the **Portal alternative** (with a callout note about copying the secret).

---

## Task 1: Create a Service Principal

You need a Service Principal so GitHub Actions can authenticate with Azure during deployments. You can create it either with the **Azure CLI** (recommended) or via the **Azure Portal** (alternative, useful for documentation).

---

### Option A: Using Azure CLI (Recommended)

1. Open a terminal (PowerShell, Bash, or Azure Cloud Shell) and run this one-liner:

```bash
az ad sp create-for-rbac --name "<your-sp-name>" --role Owner --scopes /subscriptions/<your-subscription-id> --sdk-auth
```

2. The command returns a JSON block containing:

* `clientId`
* `clientSecret`
* `subscriptionId`
* `tenantId`

Save this JSON securely — you will use it in the next task when creating GitHub Secrets.

### Option B: Using the Azure Portal (Alternative)

1. Navigate to **Azure Portal → Microsoft Entra ID → App registrations → New registration**.

   * Enter a name (e.g., `sp-gpt-rag`).
   * Select **Accounts in this organizational directory only (Single tenant)**.
   * Click **Register**.

2. After registration, go to **Certificates & secrets → Client secrets → New client secret**.

   * Enter a description (e.g., `sp-gpt-rag-secret`).
   * Choose an expiration period.
   * Click **Add**.
   * Copy the **Value** immediately — this is your `clientSecret`.

3. Collect the following values for later use:

   * **Application (client) ID** → `clientId`
   * **Directory (tenant) ID** → `tenantId`
   * **Secret Value** (copied from step 2) → `clientSecret`
   * **Subscription ID** → `subscriptionId` (from your Azure subscription)

⚠️ **Important:** The client secret **Value** is only visible once, right after you create it. Be sure to copy and store it securely.

👉 Whether you use the CLI or the Portal, the end result is the same: you have the four required values (`clientId`, `clientSecret`, `subscriptionId`, `tenantId`) to use as credentials in GitHub.

## Task 2: Configure GitHub Environments

1. In your GitHub repository, navigate to Settings → Environments.  

2. Create three environments named `dev`, `qa`, and `prod`.  

3. For each environment, add this **Environment variables**:  

```
   - APP_CONFIG_ENDPOINT 
```

4. In the same environment, create one **Secret** named `AZURE_CREDENTIALS` with the JSON from your Service Principal:  

```
   {  
     "clientId": "…",  
     "clientSecret": "…",  
     "subscriptionId": "…",  
     "tenantId": "…"  
   }  
```

5. Confirm your Environments page shows the variables and secret for `dev` (repeat for `qa` and `prod`).  


## Task 3: Review the GitHub Actions Workflows

1. Open `.github/pr_pipeline.yaml` (Pull Request Pipeline):  
   - Triggers on pull requests to `develop`.  
   - Checks out code, logs into Azure, installs Python, and runs `evaluation/evaluate.sh`.  
   - Uploads evaluation-results as an artifact.  

2. Open `.github/cicd_pipeline.yaml` (CI/CD Dev Pipeline):  
   - Triggers on pushes to `develop`.  
   - Installs and verifies `azd`, logs into Azure CLI and `azd`, then runs azd deploy.

## Task 4: Execute the Feature-to-Deploy Workflow

1. **Create a feature branch** off of `develop`:  

```
      git checkout develop  
      git pull origin develop  
      git checkout -b feature/your_feature  
```

2. Make a small change (e.g., update documentation or a prompt template).  

3. **Open a pull request** against `develop`:  

```
      git add .  
      git commit -m "Add feature X"  
      git push origin feature/your_feature  
      gh pr create --base develop --head feature/your_feature --title "Feature X" --body "Adds feature X."
```

   - Observe in GitHub Actions that the Pull Request Pipeline runs, executes evaluations, and uploads results.  

4. **Merge the PR** into `develop` once checks pass.  
   - The CI/CD Dev Pipeline will trigger, run `azd init` and `azd deploy`, and update your dev Container App.  

Congratulations—you’ve configured end-to-end CI/CD for your GenAI project. Your tests and evaluations run automatically on PRs, and successful merges to `develop` deploy your orchestrator into the dev environment!  
