# Bootstrapping a New Project

In this lab, you will create a new GenAI application repository based on the GPT-RAG orchestrator template and provision your development infrastructure with a single command. You’ll learn how to:

- Use **azd init** to instantiate a fresh repo from a template  
- Run **azd provision** to deploy all infrastructure via Bicep  
- Understand where the template’s IaC components live and how to customize them  



## Success Criteria

- A new repository exists in your GitHub (or Azure DevOps) account, created from the GPT-RAG template  
- Your development environment resources (App Service, AI Foundry Project, Search index, etc.) are deployed in Azure  
- You know where to find and modify the Bicep files for custom environments  


## Prerequisites

<details markdown="block">
<summary>Expand to view prerequisites</summary>

To deploy this template, you need:

* An Azure subscription.
* An Azure user with **Contributor** and **User Access Admin** permissions on the target resource group.

In addition, the machine or environment used for deployment should have:

- Azure Developer CLI: [Install azd](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
- PowerShell 7+ (Windows only): [Install PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#installing-the-msi-package)
- Git: [Download Git](https://git-scm.com/downloads)
- Python 3.12: [Download Python](https://www.python.org/downloads/release/python-3120/)
- An Azure AI Services resource created or agreement to Responsible AI terms in the portal

Note: To run the deployment automation lab, you need a Service Principal with Contributor or Owner permissions on your subscription.

</details>

## Task 1: Initialize from the GPT‑RAG Template

1. **Open your terminal** and navigate to the folder where you keep your repositories. If you don’t have one yet, create it as shown below:

   ```bash
   mkdir workspace
   cd workspace
   ```

2. **Create a directory** for your GPT‑RAG template and enter it:

   ```bash
   mkdir gpt-rag
   cd gpt-rag
   ```

3. **Initialize the project** using the Azure Developer CLI with the GPT‑RAG template:

   ```bash
   azd init -t azure/gpt-rag -b feature/vnext-architecture
   ```

4. **Follow the interactive prompts** to:

   * Sign in to your Azure account
   * Select your subscription
   * Choose or create a resource group

5. **Review the project structure.** You’ll find an `infra/` folder that contains Bicep files. These define all the Azure resources needed by the template.

**Tip:** To customize, click **Use this repository as a template** on GitHub (creating a new repo with no upstream link) or fork the original. Then edit any files under `infra/` to match your organization’s standards.

## Task 2: Provision Your Development Environment

1. From the project folder, run:  

```
   azd provision  
```

2. Wait for the deployment to complete. Review the CLI output for resource names and endpoints.  

3. In the Azure Portal, verify creation of:  
   - Azure Container Apps  
   - Azure AI Foundry Project  
   - Azure AI Search index  
   - Other resources defined in `main.bicep`

## Task 3: Verify and Explore

1. Inspect the `infra/` directory:  
   - `main.bicep` defines your core resources.  
   - `modules/` contains reusable components (App Service, Storage, AI Foundry, etc.).  

2. Review CI/CD pipeline definitions:  
   - `.github/workflows/` for GitHub Actions  
   - `.azdo/` for Azure DevOps pipelines  

3. Browse to your orchestrator endpoint URL (displayed by `azd provision`) and confirm it returns a "404 Not Found"—indicating the app is deployed and ready to accept requests.

Congratulations—you've successfully bootstrapped a new GenAI project using the GPT-RAG orchestrator template! You’re now ready to move on to Lab 2: From Idea to Prototype.