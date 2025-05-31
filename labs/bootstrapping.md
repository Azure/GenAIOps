# Bootstrapping a New Project

In this lab, you will create a new GenAI application repository based on the GPT-RAG orchestrator template (v2.0.0) and provision your development infrastructure with a single command. You’ll learn how to:

- Use **azd init** to instantiate a fresh repo from a template  
- Run **azd provision** to deploy all infrastructure via Bicep  
- Understand where the template’s IaC components live and how to customize them  

---

## Success Criteria

- A new repository exists in your GitHub (or Azure DevOps) account, created from the GPT-RAG template  
- Your development environment resources (App Service, AI Hub project, Search index, etc.) are deployed in Azure  
- You know where to find and modify the Bicep files for custom environments  

---

## Prerequisites

<details markdown="block">
<summary>Expand to view prerequisites</summary>

### Required Tools  
- Azure CLI (`az`) – https://aka.ms/install-az  
- Azure Developer CLI (`azd`) – https://aka.ms/install-azd  
- GitHub CLI (`gh`) – https://cli.github.com/  
- Git – https://git-scm.com/downloads  

### You Will Also Need  
- An **Azure subscription** with permissions to create resource groups and assign roles  
- Access to **Azure OpenAI** (request via the Microsoft form if needed)  
- Ability to create or use an existing **Service Principal** with at least **Contributor** role on your subscription  
  - _In production, you can scope down to least-privilege roles; Contributor is used here for simplicity._  
</details>

---

## Task 1: Initialize from GPT-RAG Template

1. Open your terminal and navigate to the folder where you want your project.  

2. Run the following command:  

```
   azd init -t azure/gpt-rag -b v2.0.0  
```

3. Follow the prompts to sign in, select your Azure account, and choose or create a resource group.  

4. Observe that this template includes an `infra/` directory containing Bicep files that define all necessary resources.

**Tip:** To customize, click **Use this repository as a template** on GitHub (creating a new repo with no upstream link) or fork the original. Then edit any files under `infra/` to match your organization’s standards.

---

## Task 2: Provision Your Development Environment

1. From the project folder, run:  

```
   azd provision  
```

2. Wait for the deployment to complete. Review the CLI output for resource names and endpoints.  

3. In the Azure Portal, verify creation of:  
   - App Service instance  
   - Azure AI Hub project  
   - Azure Cognitive Search index  
   - Other resources defined in `main.bicep`

---

## Task 3: Verify and Explore

1. Inspect the `infra/` directory:  
   - `main.bicep` defines your core resources.  
   - `modules/` contains reusable components (App Service, Storage, AI Hub, etc.).  
2. Review CI/CD pipeline definitions:  
   - `.github/workflows/` for GitHub Actions  
   - `.azdo/` for Azure DevOps pipelines  
3. Browse to your orchestrator endpoint URL (displayed by `azd provision`) and confirm it returns a “404 Not Found”—indicating the app is deployed and ready to accept requests.

---

Congratulations—you’ve successfully bootstrapped a new GenAI project using the GPT-RAG orchestrator template! You’re now ready to move on to Lab 2: From Idea to Prototype.
