# 01. Setup and Preparation
Write-Host "`n01. Setup and Preparation." -ForegroundColor Magenta

# Define the temporary directory within the current directory
$currentDir = Get-Location
$tempDir = Join-Path $currentDir "temp"

# Create the temporary directory
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $tempDir

# Change to the temporary directory
Set-Location $tempDir

# Read the variables from the bootstrap.properties file
$bootstrapFile = "..\bootstrap.properties"
if (Test-Path $bootstrapFile) {
    Get-Content $bootstrapFile | ForEach-Object {
        # Ignore comments and empty lines
        if ($_ -notmatch '^\s*#' -and $_.Trim() -ne '') {
            # Split the line into name and value
            $parts = $_ -split '=', 2
            $name = $parts[0].Trim()
            $value = $parts[1].Trim().Trim('"')
            # Create a PowerShell variable with the name and value
            Set-Variable -Name $name -Value $value
            # Print the variable name in Cyan 
            Write-Host "$name = " -NoNewline -ForegroundColor Blue
            Write-Host $value 
        }
    }
} else {
    Write-Host "bootstrap.properties does not exist." -ForegroundColor Red
    exit 1
}

# Setup additional variables
if ($github_use_ssh -eq "true") {
    $github_template_repo_uri = "git@github.com:${github_template_repo}.git"
} else {
    $github_template_repo_uri = "https://github.com/${github_template_repo}.git"
}
if ($github_use_ssh -eq "true") {
    $github_new_repo_uri = "git@github.com:${github_new_repo}.git"
} else {
    $github_new_repo_uri = "https://github.com/${github_new_repo}.git"
}
$github_new_repo_name = $github_new_repo -split '/' | Select-Object -Last 1
$github_template_repo_name = $github_template_repo -split '/' | Select-Object -Last 1
# Print the new additional 
Write-Host "github_template_repo_name = " -NoNewline -ForegroundColor Blue
Write-Host $github_template_repo_name  
Write-Host "github_template_repo_uri = " -NoNewline -ForegroundColor Blue
Write-Host $github_template_repo_uri 
Write-Host "github_new_repo_name = " -NoNewline -ForegroundColor Blue
Write-Host $github_new_repo_name 
Write-Host "github_new_repo_uri = " -NoNewline -ForegroundColor Blue
Write-Host $github_new_repo_uri 

Write-Host "`nFinished Setup and Preparation." -ForegroundColor Green

# 02. Repository Creation and Initialization
Write-Host "`n02. New GitHub Repository Creation and Initialization.`n" -ForegroundColor Magenta

# Check if the GitHub repository exists
$repoExists = $false
$repoCheck = gh repo view "$github_new_repo_uri" 2>&1
if ($LASTEXITCODE -eq 0) {
    $repoExists = $true
    Write-Host "GitHub repository $github_new_repo_uri already exists." -ForegroundColor Cyan
} else {
    if ($repoCheck -like "*gh auth login*") {
        Write-Host "Error: User is not logged in. Please log in using gh auth login." -ForegroundColor Red
    } elseif ($repoCheck -like "*Could not resolve to a Repository with the name*") {
        Write-Host "GitHub repository $github_new_repo_uri does not exist." -ForegroundColor Yellow
    } else {
        Write-Host "Error checking the repository: $repoCheck" -ForegroundColor Red
    }
}

if (-not $repoExists) {
    # Create a new GitHub repository
    Write-Host "Creating a new GitHub repository."
    gh repo create "$github_new_repo" --$github_new_repo_visibility
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create new GitHub repository."
        exit 1
    }
}

# Copying template repo in the new repository
Write-Host "Cloning template repository." -ForegroundColor Cyan
git clone --bare "$github_template_repo_uri"
Set-Location "$github_template_repo_name.git"
Write-Host "Mirroring template repository in the new GitHub repository." -ForegroundColor Cyan

# Mirror-push to the new repository
git push --mirror "$github_new_repo_uri"
if ($LASTEXITCODE -ne 0) {
    if ($github_use_ssh -eq $true) {
        Write-Host "ERROR: Permission denied to GitHub repo. github_use_ssh is true. Please look at this reference:"
        Write-Host "https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls"
    } else {
        Write-Host "ERROR: Permission denied to GitHub repo. github_use_ssh is false, you are using HTTPS. Please look at this reference:"
        Write-Host "https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-ssh-urls"
    }
    cd ..
    cd ..    
    exit 1
}

Write-Host "Setting default branch in the new repository." -ForegroundColor Cyan
gh repo edit $github_new_repo --default-branch develop
Set-Location ..
Remove-Item -Recurse -Force "$github_template_repo_name.git"

# develop branch protection rule
gh api `
  -X PUT `
  -H "Accept: application/vnd.github+json" `
  -H "X-GitHub-Api-Version: 2022-11-28" `
  /repos/$github_new_repo/branches/develop/protection `
  -F "required_status_checks[strict]=true" `
  -F "required_status_checks[contexts][]=evaluate-flow" `
  -F "enforce_admins=true" `
  -F "required_pull_request_reviews[dismiss_stale_reviews]=false" `
  -F "required_pull_request_reviews[require_code_owner_reviews]=false" `
  -F "required_pull_request_reviews[required_approving_review_count]=0" `
  -F "required_pull_request_reviews[require_last_push_approval]=false" `
  -F "allow_force_pushes=true" `
  -F "allow_deletions=true" `
  -F "block_creations=true" `
  -F "required_conversation_resolution=true" `
  -F "lock_branch=false" `
  -F "allow_fork_syncing=true" `
  -F "restrictions=null"

# Create GitHub environment named dev with specified variables
gh api --method PUT -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/dev
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/dev/variables -f name=AZURE_ENV_NAME -f value="$azd_dev_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/dev/variables -f name=AZURE_SUBSCRIPTION_ID -f value="$azd_dev_env_subscription"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/dev/variables -f name=AZURE_LOCATION -f value="$azd_dev_env_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env dev --body "replace_with_dev_sp_credencials"

# Create placeholders for GitHub environment qa variables
gh api --method PUT -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/qa
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/qa/variables -f name=AZURE_ENV_NAME -f value="replace_with_qa_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/qa/variables -f name=AZURE_SUBSCRIPTION_ID -f value="replace_with_qa_subscription_id"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/qa/variables -f name=AZURE_LOCATION -f value="replace_with_qa_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env qa --body "replace_with_qa_sp_credencials"

# Create placeholders for GitHub environment prod variables
gh api --method PUT -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/prod
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/prod/variables -f name=AZURE_ENV_NAME -f value="replace_with_prod_env_name"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/prod/variables -f name=AZURE_SUBSCRIPTION_ID -f value="replace_with_prod_subscription_id"
gh api --method POST -H "Accept: application/vnd.github+json" /repos/$github_new_repo/environments/prod/variables -f name=AZURE_LOCATION -f value="replace_with_prod_location"
gh secret set AZURE_CREDENTIALS --repo $github_new_repo --env prod --body "replace_with_prod_sp_credencials"

Write-Host "`nNew repository set up successfully." -ForegroundColor Green

Write-Host "`nAccess your new repo in: `nhttps://github.com/$github_new_repo"  -ForegroundColor Green

if ($azd_dev_env_provision -eq "true") {

    # 03. Initializing AZD dev environment
    Write-Host "`n03. Initializing AZD dev environment.`n" -ForegroundColor Magenta

    # Clone the new repository
    Write-Host "Cloning the new GitHub repository." -ForegroundColor Cyan
    git clone "$github_new_repo_uri"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone GitHub Repo." -ForegroundColor Red
        cd ..
        exit 1
    }

    # Verify the repository directory exists before changing location
    if (Test-Path "$github_new_repo_name") {
        Set-Location "$github_new_repo_name"
        Write-Host "Changed directory to $github_new_repo_name." -ForegroundColor Green
    } else {
        Write-Host "Error when cloning GitHub. The path '$github_new_repo_name' does not exist." -ForegroundColor Red
        exit 1
    }

    # Initialize the azd environment
    Write-Host "Running azd init." -ForegroundColor Cyan
    azd init -e $azd_dev_env_name -s $azd_dev_env_subscription -l $azd_dev_env_location
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to initialize the Azure Developer environment." -ForegroundColor Red
        exit 1
    }

    # 04. Check if user logged in to Azure is Service Principal or not
    $azd_user_type = (az account show --query user.type -o tsv)
    
    if ($azd_user_type -eq "servicePrincipal") {
        Write-Host "User is a Service Principal. Setting AZURE_PRINCIPAL_TYPE to ServicePrincipal." -ForegroundColor Green
        azd env set AZURE_PRINCIPAL_TYPE ServicePrincipal
    } else {
        Write-Host "User is not a Service Principal. Setting AZURE_PRINCIPAL_TYPE to User." -ForegroundColor Green
        azd env set AZURE_PRINCIPAL_TYPE User
    }
    
    # 05. Disable App Service provisioning
    azd env set AZURE_DEPLOY_APP_SERVICE false

    # 06. Show azd environment variables
    Write-Host "`n05. Show azd environment variables.`n" -ForegroundColor Magenta
    azd env get-values
    
    # 07. Provision dev environment resources
    Write-Host "`n06. Provision dev environment.`n" -ForegroundColor Magenta
    Write-Host "Running azd provision." -ForegroundColor Cyan
    azd provision

    # Check if azd provision succeeded
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to provision the Azure environment." -ForegroundColor Red
        exit 1
    }

    Write-Host "`nDev environment provisioned successfully." -ForegroundColor Green

} else {
    Write-Host "`nDev environment provisioning was not selected." -ForegroundColor Yellow
}

# Change back to the original directory
Set-Location $currentDir

# Remove the temporary directory
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

Write-Host "`nTemporary directory removed successfully." -ForegroundColor Cyan