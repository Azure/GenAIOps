# Repository Structure

This accelerator utilizes project templates as its foundation. Therefore, the repository system is structured to include a primary repository, which contains comprehensive documentation and bootstrapping scripts for initiating projects using these templates. To maintain simplicity and promote cohesion within each repository, a separate repository is allocated for each project template. Additionally, dependencies between the primary repository and the template repositories are minimized. The diagram below illustrates the proposed structure.

![Header](../media/git_workflow_repository_structure.png)

## Repositories and their Directories

This section describes the directory structure used in the GenAIOps accelerator. By following this directory structure, teams can ensure a consistent and organized approach to developing and managing their LLM projects.

### GenAIOps

The `GenAIOps` repository is the central hub, offering detailed documentation and scripts for initializing projects with these templates. It allows direct use or customization through copying/forking. It includes the following:

- **documentation**: Holds setup guides and concept explanations for the GenAIOps accelerator.
- **bootstrapping script**: Initializes and configures new projects using GenAIOps templates.

### LLM Project-template

The `LLM Project-template` represents repositories serving as templates for LLM projects, which can be utilized to initiate new projects. While the structure of project templates may differ based on specific needs, a typical template includes the following subdirectories:

- **.github**: GitHub-specific workflows, and actions used for continuous integration and deployment.
- **data**: This directory is used to store datasets required for training and evaluation.
- **evaluations**: Contains scripts and resources for evaluating the performance of the trained models.
- **infra**: Holds infrastructure-related code and configurations, such as Bicep or Terraform scripts.
- **src**: Source code for the project, including orchestration flows, model definitions, training scripts, and utilities.
- **tests**: Contains test cases and scripts to ensure the quality and correctness of the codebase.

For an example of a project template, you can refer to this [RAG with Azure AI Studio and Promptflow](https://github.com/azure/GenAIOps-project-template) template.

### Project A (Bootstrapped Project)

`Project A` represents a project that has been bootstrapped from the template. We're calling it Project A for illustration purposes, but it can be named appropriately for your use case. It will have the same initial directory structure as the template.