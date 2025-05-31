# Project Templates

This guide—and the example templates it references—help you discover and explore starter repositories you can use as blueprints. Browse available templates (including the GPT-RAG Orchestrator example below) to see best practices in action, then apply those patterns to create your own project templates within your organization. Your custom templates will serve as the foundation for all future projects, providing consistent structure and CI/CD workflows from day one.

Project templates are starter repositories you can use as a launchpad for your own projects. By using a template repository, you get a fully structured codebase and CI/CD pipelines tailored to a specific type of solution—allowing you to focus on building features rather than setting up boilerplate.

## How to Use a Project Template

1. **Select a template**  
   Browse available project-template repositories (this guide, the GPT-RAG Orchestrator example, and others in your organization or the public GitHub org) and choose one that matches your requirements.

2. **Create your repository**  
   - On **GitHub**, click the **Use this repository as a template** button to create a fresh repo without any upstream origin.  
   - In **Azure DevOps**, fork or import the template into your own project collection.  
   - Give the new repository a meaningful name (e.g., `my-genai-app`).

3. **Customize and extend**  
   - Update infrastructure scripts, CI/CD workflows, and source code to suit your needs.  
   - Remove or add directories and tools as your project evolves.

4. **Iterate and maintain**  
   - Commit changes to your own repository.  
   - Periodically compare with the original template (and other example templates) to pick up useful updates or patterns.

## Typical Template Structure

A well-organized project template often includes these key directories:

- **.github/** or **.azdo/**  
  CI/CD workflows and pipeline definitions for GitHub Actions or Azure DevOps.  
- **data/**  
  Sample or placeholder datasets for training and evaluation.  
- **evaluations/**  
  Scripts and resources to measure model performance.  
- **infra/**  
  Infrastructure-as-Code: Bicep, Terraform, ARM templates, etc.  
- **src/**  
  Application source code (orchestration flows, model definitions, training scripts).  
- **tests/**  
  Unit and integration tests to validate code quality and correctness.  

## Example Template: GPT-RAG Orchestrator 

**Link:** https://github.com/Azure/gpt-rag-orchestrator/tree/v2.0.0

This template provides a fully configured FastAPI-based orchestrator for Retrieval-Augmented Generation using Azure AI Foundry. It includes:

- **FastAPI application** with Server-Sent Events streaming endpoint  
- **Azure App Configuration** integration for feature flags and settings  
- **Orchestrator class** that manages agent creation, thread management, and message streaming  
- **Single-agent RAG strategy** integrating tools like Code Interpreter, Bing Grounding, and Azure AI Search  
- **Event handler** to process partial responses, citations, and run steps  

Use this example (and others) to inform the design of your own templates, then tailor infrastructure, tools, and code to your organization’s standards and requirements.  
