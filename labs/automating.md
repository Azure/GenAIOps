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
- Your project repo created from the project template and initial code already pushed  
- Your lab environment variables from previous labs (`APP_CONFIG_ENDPOINT`)  
- A Service Principal with Contributor or Owner rights on your subscription  
</details>

## Task 1: Create a Service Principal

You need a Service Principal so GitHub Actions can authenticate with Azure during deployments.

1. Navigate to **Azure Portal → Microsoft Entra ID → App registrations → New registration**.

   * Enter a name (e.g., `sp-genaiops`).
   * Select **Accounts in this organizational directory only (Single tenant)**.
   * Click **Register**.

2. After registration, go to **Certificates & secrets → Client secrets → New client secret**.

   * Enter a description (e.g., `sp-genaiops-secret`).
   * Choose an expiration period.
   * Click **Add**.
   * Copy the **Value** immediately — this is your `clientSecret`.

3. Collect the following values for later use:

   * **Application (client) ID** → `clientId`
   * **Directory (tenant) ID** → `tenantId`
   * **Secret Value** (copied from step 2) → `clientSecret`
   * **Subscription ID** → `subscriptionId` (from your Azure subscription)

⚠️ **Important:** The client secret **Value** is only visible once, right after you create it. Be sure to copy and store it securely.

## Task 2: Assign Permissions to the Service Principal

For the newly created Service Principal to successfully deploy the application to your subscription, it must have the necessary permissions.

| Role | Resource Type | Purpose |
|------|---------------|---------|
| **Owner** | Resource Group | Manage all Azure resources for deployment |
| **App Configuration Data Reader** | App Configuration | Read application configuration settings |
| **Azure AI User** | AI Foundry Resource | Access AI services and models |
| **Azure AI Project Manager** | AI Foundry Resource | Manage AI projects and deployments |
| **Key Vault Secrets User** | Key Vault | Access secrets and credentials |
| **Search Index Data Reader** | AI Search | Read search indexes and data |
| **Cosmos DB Built-in Data Contributor** | Cosmos DB | Read and write data to Cosmos DB |

These role assignments must be configured on the respective resources after they are provisioned during the bootstrapping process.

> **Note:** If your organization requires more restrictive permissions, you can assign **Contributor** role instead. However, ensure the Service Principal has sufficient permissions to create and manage all required Azure resources for deployment.

## Task 3: Configure GitHub Environments

In this lab, we will configure only the **dev** environment. In a real-world scenario, you would repeat these steps for additional environments such as `qa` and `prod`.

1. In your GitHub repository, navigate to **Settings → Environments**.  

2. Click **New environment** and create an environment named `dev`.  

3. In the `dev` environment, add the following **Environment variable**:  

   - **Name:** `APP_CONFIG_ENDPOINT`
   - **Value:** (the endpoint from your Azure App Configuration resource)

4. In the same `dev` environment, create a **Secret** named `AZURE_CREDENTIALS` with the JSON from your Service Principal:  

   ```json
   {  
     "clientId": "your-client-id",  
     "clientSecret": "your-client-secret",  
     "subscriptionId": "your-subscription-id",  
     "tenantId": "your-tenant-id"  
   }  
   ```

5. Confirm your dev environment shows the variable `APP_CONFIG_ENDPOINT` and the secret `AZURE_CREDENTIALS`.

> Note: In a real world setup, you would create additional environments (qa, prod) and configure the same variables and secrets for each, potentially with different values for each environment (e.g., different App Configuration endpoints, different subscriptions, or different Service Principals with environment-specific permissions).


## Task 4: Review the GitHub Actions Workflows

efore reviewing the workflows, ensure you are in your local project directory that was created from the project template during the bootstrapping lab.

1. Open `.github/pr_pipeline.yaml` (Pull Request Pipeline):  
   - Triggers on pull requests to `genaiops-workshop`.  
   - Checks out code, logs into Azure, installs Python, and runs `evaluation/evaluate.sh`.  
   - Uploads evaluation-results as an artifact.  

2. Open `.github/cicd_pipeline.yaml` (CI/CD Dev Pipeline):  
   - Triggers on pushes to `genaiops-workshop`.  
   - Installs and verifies `azd`, logs into Azure CLI and `azd`, then runs azd deploy.

> **Note:** In this workshop, we're using the `genaiops-workshop` branch for simplicity. In a typical real world scenario, you would use the `develop` branch for development work and configure pipelines to trigger on pull requests and merges to `develop`.

## Task 5: Execute the Feature-to-Deploy Workflow

Now you will execute the complete workflow by creating a feature branch, making changes, and deploying through the CI/CD pipeline. Make sure you are in your local repository directory (the one created from the project template).

1. **Create a feature branch** off of `genaiops-workshop`:  

```
      git checkout genaiops-workshop  
      git pull origin genaiops-workshop  
      git checkout -b feature/feature_x  
```

2. Make a small change (e.g., update documentation or a prompt template).  

3. **Open a pull request** against `genaiops-workshop`:  

```
      git add .  
      git commit -m "Feature X"  
      git push origin feature/feature_x  
      gh pr create --base genaiops-workshop --head feature/feature_x --title "Feature X" --body "Adds feature X."
```

   - Observe in GitHub Actions that the Pull Request Pipeline runs, executes evaluations, and uploads results.  

4. **Merge the PR** into `genaiops-workshop` once checks pass.  
   - The CI/CD Dev Pipeline will trigger, run `azd init` and `azd deploy`, and update your dev Container App.  

> **Note:** For this workshop, we're merging into the `genaiops-workshop` branch. In a real-world development workflow, you would typically use a branching strategy where feature branches are merged into `develop`, which then gets promoted to `main` branch through additional environments and approval gates.

Congratulations, you've configured end-to-end CI/CD for your GenAI project. Your tests and evaluations run automatically on PRs, and successful merges to `genaiops-workshop` deploy your orchestrator into the dev environment!
