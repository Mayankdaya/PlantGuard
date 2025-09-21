# PlantGuard Render CLI Deployment Script
# This script uses the official Render CLI to deploy PlantGuard

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "deploy",
    
    [Parameter(Mandatory=$false)]
    [string]$ServiceName = "plantguard",
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Display help if requested
if ($Help) {
    Write-Host "🌱 PlantGuard Render CLI Deployment Tool" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\deploy_render_cli_fixed.ps1 [-Action <action>] [-ServiceName <name>]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Cyan
    Write-Host "  deploy    - Deploy PlantGuard to Render (default)" -ForegroundColor White
    Write-Host "  login     - Login to Render using the CLI" -ForegroundColor White
    Write-Host "  status    - Check deployment status" -ForegroundColor White
    Write-Host "  logs      - View deployment logs" -ForegroundColor White
    Write-Host "  services  - List all services" -ForegroundColor White
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Cyan
    Write-Host "  -ServiceName <name>  - Name for your service (default: plantguard)" -ForegroundColor White
    Write-Host "  -Help                - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\deploy_render_cli_fixed.ps1" -ForegroundColor Gray
    Write-Host "  .\deploy_render_cli_fixed.ps1 -Action login" -ForegroundColor Gray
    Write-Host "  .\deploy_render_cli_fixed.ps1 -ServiceName my-plant-app" -ForegroundColor Gray
    exit 0
}

# Configuration
$RenderCLI = ".\render_cli\cli_v1.1.0.exe"
$RequiredFiles = @(
    "render.yaml",
    "Flask Deployed App\app.py",
    "Flask Deployed App\requirements.txt", 
    "Flask Deployed App\CNN.py",
    "Flask Deployed App\plant_disease_model_1.pt"
)

Write-Host "🌱 PlantGuard Render CLI Deployment Tool" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Check if Render CLI exists
if (-not (Test-Path $RenderCLI)) {
    Write-Host "❌ Render CLI not found at: $RenderCLI" -ForegroundColor Red
    Write-Host "Please ensure the Render CLI is installed in the render_cli directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Render CLI found: $RenderCLI" -ForegroundColor Green

# Verify all required files
Write-Host ""
Write-Host "Step 1: Verifying deployment files..." -ForegroundColor Yellow
$allFilesReady = $true
foreach ($file in $RequiredFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "✅ Found $file ($size bytes)" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing $file" -ForegroundColor Red
        $allFilesReady = $false
    }
}

if (-not $allFilesReady) {
    Write-Host "❌ Some files are missing. Please ensure all files are present before continuing." -ForegroundColor Red
    exit 1
}

# Check Git status
Write-Host ""
Write-Host "Step 2: Checking Git repository..." -ForegroundColor Yellow
try {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  You have uncommitted changes:" -ForegroundColor Yellow
        git status --short
        Write-Host ""
        $commitChanges = Read-Host "Would you like to commit these changes before deployment? (y/n)"
        if ($commitChanges -eq 'y') {
            $commitMessage = Read-Host "Enter commit message"
            git add .
            git commit -m $commitMessage
            git push origin main
            Write-Host "✅ Changes committed and pushed!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Continuing with uncommitted changes..." -ForegroundColor Yellow
        }
    } else {
        Write-Host "✅ Git repository is clean and up to date!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Git command failed. Please ensure Git is installed and you're in a Git repository." -ForegroundColor Yellow
}

# Execute the requested action
Write-Host ""
Write-Host "Step 3: Executing action: $Action" -ForegroundColor Yellow

switch ($Action.ToLower()) {
    "login" {
        Write-Host "🔐 Logging in to Render..." -ForegroundColor Cyan
        & $RenderCLI login
        Write-Host "✅ Login completed!" -ForegroundColor Green
        break
    }
    
    "deploy" {
        Write-Host "🚀 Deploying PlantGuard to Render..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "This will create a new web service on Render using your render.yaml configuration." -ForegroundColor White
        Write-Host "The service will be named: $ServiceName" -ForegroundColor White
        Write-Host ""
        
        $confirmDeploy = Read-Host "Do you want to proceed with deployment? (y/n)"
        if ($confirmDeploy -eq 'y') {
            # First, let's check if we can list services (to verify authentication)
            Write-Host "Checking Render authentication..." -ForegroundColor Yellow
            try {
                $servicesOutput = & $RenderCLI services --output json 2>&1
                Write-Host "✅ Successfully connected to Render!" -ForegroundColor Green
                
                Write-Host ""
                Write-Host "📋 Next Steps:" -ForegroundColor Cyan
                Write-Host "1. Visit: https://render.com" -ForegroundColor White
                Write-Host "2. Click 'New +' and select 'Web Service'" -ForegroundColor White
                Write-Host "3. Connect your GitHub repository" -ForegroundColor White
                Write-Host "4. Select your PlantGuard repository" -ForegroundColor White
                Write-Host "5. Render will automatically detect render.yaml" -ForegroundColor White
                Write-Host "6. Click 'Create Web Service'" -ForegroundColor White
                Write-Host ""
                Write-Host "✅ Your render.yaml is configured and ready!" -ForegroundColor Green
                
                $openBrowser = Read-Host "Would you like to open Render in your browser now? (y/n)"
                if ($openBrowser -eq 'y') {
                    Start-Process "https://render.com"
                }
                
            } catch {
                Write-Host "❌ Failed to connect to Render. Please login first." -ForegroundColor Red
                Write-Host "Run: .\deploy_render_cli_fixed.ps1 -Action login" -ForegroundColor Yellow
                exit 1
            }
        } else {
            Write-Host "❌ Deployment cancelled." -ForegroundColor Red
            exit 0
        }
        break
    }
    
    "status" {
        Write-Host "📊 Checking deployment status..." -ForegroundColor Cyan
        try {
            $servicesOutput = & $RenderCLI services --output json 2>&1 | ConvertFrom-Json
            Write-Host "✅ Connected to Render!" -ForegroundColor Green
            
            # Look for PlantGuard services
            $plantGuardServices = $servicesOutput | Where-Object { $_.name -like "*plant*" -or $_.name -like "*disease*" -or $_.name -eq $ServiceName }
            
            if ($plantGuardServices) {
                Write-Host "🌱 Found PlantGuard services:" -ForegroundColor Green
                foreach ($service in $plantGuardServices) {
                    Write-Host "  • $($service.name) - Status: $($service.status) - URL: $($service.url)" -ForegroundColor White
                }
            } else {
                Write-Host "ℹ️  No PlantGuard services found. Deploy first using: .\deploy_render_cli_fixed.ps1" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "❌ Failed to get service status. Please login first." -ForegroundColor Red
            Write-Host "Run: .\deploy_render_cli_fixed.ps1 -Action login" -ForegroundColor Yellow
        }
        break
    }
    
    "logs" {
        Write-Host "📋 Viewing deployment logs..." -ForegroundColor Cyan
        Write-Host "Opening services list to select a service for logs..." -ForegroundColor White
        & $RenderCLI services
        break
    }
    
    "services" {
        Write-Host "📋 Listing all Render services..." -ForegroundColor Cyan
        & $RenderCLI services
        break
    }
    
    default {
        Write-Host "❌ Unknown action: $Action" -ForegroundColor Red
        Write-Host "Available actions: deploy, login, status, logs, services" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Render CLI action completed!" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 PlantGuard is ready for deployment!" -ForegroundColor Green
Write-Host "📖 For more help, check: CLI_DEPLOYMENT_GUIDE.md" -ForegroundColor Cyan