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

## Task 1: Create a Service Principal

1. In a terminal, run:  

```bash
az ad sp create-for-rbac --name "<your-sp-name>" \
  --role Owner \
  --scopes /subscriptions/<your-subscription-id> \
  --sdk-auth
```

2. Copy the JSON output (contains `clientId`, `clientSecret`, `subscriptionId`, `tenantId`) and save it for the next step.  

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
