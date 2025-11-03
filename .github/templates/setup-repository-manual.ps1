# GitHub Repository Setup Script (Manual Mode)
# This PowerShell script helps configure your GitHub repository for Azure Policy deployments

param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryName,
    
    [Parameter(Mandatory = $true)]
    [string]$RootManagementGroupId,
    
    [Parameter(Mandatory = $false)]
    [string]$ServicePrincipalName = "github-actions-azure-policy"
)

Write-Host "Setting up GitHub repository for Azure Policy deployments..." -ForegroundColor Green
Write-Host "Repository: $RepositoryName" -ForegroundColor Cyan
Write-Host "Management Group: $RootManagementGroupId" -ForegroundColor Cyan

# Step 1: Create Service Principal
Write-Host ""
Write-Host "Step 1: Creating Azure Service Principal..." -ForegroundColor Yellow

$scope = "/providers/Microsoft.Management/managementGroups/$RootManagementGroupId"

try {
    Write-Host "Creating service principal with scope: $scope" -ForegroundColor Gray
    $spOutput = az ad sp create-for-rbac --name $ServicePrincipalName --role "Management Group Contributor" --scopes $scope --sdk-auth
    
    if ($LASTEXITCODE -eq 0) {
        $spCredentials = $spOutput | ConvertFrom-Json
        Write-Host "Service Principal created successfully!" -ForegroundColor Green
        Write-Host "Client ID: $($spCredentials.clientId)" -ForegroundColor Gray
    } else {
        Write-Host "Failed to create Service Principal. Exit code: $LASTEXITCODE" -ForegroundColor Red
        Write-Host "Output: $spOutput" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Failed to create Service Principal: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Display GitHub Secrets Setup
Write-Host ""
Write-Host "Step 2: GitHub Secrets Setup (Manual)" -ForegroundColor Yellow
Write-Host "Since GitHub CLI is not available, please manually add the following secret:" -ForegroundColor Yellow

$credentialsJson = $spCredentials | ConvertTo-Json -Depth 10 -Compress
Write-Host ""
Write-Host "SECRET NAME: AZURE_CREDENTIALS" -ForegroundColor Cyan
Write-Host "SECRET VALUE:" -ForegroundColor Cyan
Write-Host $credentialsJson -ForegroundColor White
Write-Host ""

# Step 3: Manual GitHub Setup Instructions
Write-Host "Step 3: Manual GitHub Repository Setup" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to your GitHub repository: https://github.com/$RepositoryName" -ForegroundColor White
Write-Host "2. Navigate to Settings > Secrets and variables > Actions" -ForegroundColor White
Write-Host "3. Click 'New repository secret'" -ForegroundColor White
Write-Host "4. Name: AZURE_CREDENTIALS" -ForegroundColor White
Write-Host "5. Value: Copy the JSON above" -ForegroundColor White
Write-Host ""

# Step 4: Environment Setup Instructions
Write-Host "Step 4: Environment Setup" -ForegroundColor Yellow
Write-Host ""
Write-Host "Create the following environments in your GitHub repository:" -ForegroundColor White
Write-Host "1. Go to Settings > Environments" -ForegroundColor White
Write-Host "2. Create environment 'dev' with variable:" -ForegroundColor White
Write-Host "   DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId-dev" -ForegroundColor Gray
Write-Host "3. Create environment 'test' with variable:" -ForegroundColor White
Write-Host "   DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId-test" -ForegroundColor Gray
Write-Host "4. Create environment 'prod' with variable:" -ForegroundColor White
Write-Host "   DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId" -ForegroundColor Gray
Write-Host ""

# Step 5: Summary
Write-Host "Setup Summary:" -ForegroundColor Green
Write-Host "- Service Principal created: $ServicePrincipalName" -ForegroundColor White
Write-Host "- Management Group scope: $scope" -ForegroundColor White
Write-Host "- Repository: $RepositoryName" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Green
Write-Host "1. Add the AZURE_CREDENTIALS secret to your GitHub repository" -ForegroundColor White
Write-Host "2. Create the three environments (dev, test, prod) with variables" -ForegroundColor White
Write-Host "3. Your GitHub Actions workflows will be ready to use!" -ForegroundColor White
Write-Host ""
Write-Host "Setup completed! Please follow the manual steps above." -ForegroundColor Green