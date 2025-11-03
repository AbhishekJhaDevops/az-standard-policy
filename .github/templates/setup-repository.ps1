# GitHub Repository Setup Script
# This PowerShell script helps configure your GitHub repository for Azure Policy deployments

# Prerequisites:
# - GitHub CLI installed (gh cli)
# - Azure CLI installed
# - Repository owner/admin permissions

param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryName,
    
    [Parameter(Mandatory = $true)]
    [string]$RootManagementGroupId,
    
    [Parameter(Mandatory = $false)]
    [string]$ServicePrincipalName = "github-actions-azure-policy"
)

Write-Host "🚀 Setting up GitHub repository for Azure Policy deployments..." -ForegroundColor Green

# Step 1: Create Service Principal
Write-Host "📋 Step 1: Creating Azure Service Principal..." -ForegroundColor Yellow

$scope = "/providers/Microsoft.Management/managementGroups/$RootManagementGroupId"

try {
    $spCredentials = az ad sp create-for-rbac --name $ServicePrincipalName --role "Management Group Contributor" --scopes $scope --sdk-auth | ConvertFrom-Json
    Write-Host "✅ Service Principal created successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create Service Principal: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Set GitHub Secrets
Write-Host "📋 Step 2: Setting GitHub repository secrets..." -ForegroundColor Yellow

try {
    $credentialsJson = $spCredentials | ConvertTo-Json -Depth 10
    gh secret set AZURE_CREDENTIALS --body $credentialsJson --repo $RepositoryName
    Write-Host "✅ AZURE_CREDENTIALS secret set" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set GitHub secrets: $_" -ForegroundColor Red
    Write-Host "Please manually add the following as AZURE_CREDENTIALS secret:" -ForegroundColor Yellow
    Write-Host ($spCredentials | ConvertTo-Json -Depth 10) -ForegroundColor Cyan
}

# Step 3: Create Environments and Variables
Write-Host "📋 Step 3: Creating GitHub environments..." -ForegroundColor Yellow

$environments = @("dev", "test", "prod")

foreach ($env in $environments) {
    try {
        # Create environment
        gh api --method PUT "/repos/$RepositoryName/environments/$env" --field wait_timer=0
        
        # Set environment variable
        $envMgId = switch ($env) {
            "dev" { "$RootManagementGroupId-dev" }
            "test" { "$RootManagementGroupId-test" }
            "prod" { $RootManagementGroupId }
        }
        
        gh api --method POST "/repos/$RepositoryName/environments/$env/variables" --field name="DEFAULT_MANAGEMENT_GROUP_ID" --field value=$envMgId
        Write-Host "✅ Environment '$env' created with DEFAULT_MANAGEMENT_GROUP_ID = $envMgId" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Could not create environment '$env' automatically. Please create manually." -ForegroundColor Yellow
    }
}

# Step 4: Display Summary
Write-Host "`n📋 Setup Summary:" -ForegroundColor Yellow
Write-Host "Repository: $RepositoryName" -ForegroundColor Cyan
Write-Host "Service Principal: $ServicePrincipalName" -ForegroundColor Cyan
Write-Host "Management Group: $RootManagementGroupId" -ForegroundColor Cyan

Write-Host "`n🔧 Manual Setup Required:" -ForegroundColor Yellow
Write-Host "1. Go to $RepositoryName → Settings → Environments" -ForegroundColor White
Write-Host "2. Verify the following environments exist with variables:" -ForegroundColor White
Write-Host "   - dev: DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId-dev" -ForegroundColor Gray
Write-Host "   - test: DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId-test" -ForegroundColor Gray
Write-Host "   - prod: DEFAULT_MANAGEMENT_GROUP_ID = $RootManagementGroupId" -ForegroundColor Gray

Write-Host "`n✨ Setup completed! You can now use the GitHub Actions workflows." -ForegroundColor Green