# PlantGuard Direct Deployment Script
# This script provides step-by-step deployment instructions

param(
    [Parameter(Mandatory=$false)]
    [string]$Platform = "render"
)

Write-Host "🌱 PlantGuard Direct Deployment Tool" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Check if all files are ready
Write-Host "Step 1: Verifying deployment files..." -ForegroundColor Yellow
$requiredFiles = @(
    "render.yaml",
    "Flask Deployed App\app.py",
    "Flask Deployed App\requirements.txt", 
    "Flask Deployed App\CNN.py",
    "Flask Deployed App\plant_disease_model_1.pt"
)

$allFilesReady = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        $size = if (Test-Path $file) { (Get-Item $file).Length } else { 0 }
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

Write-Host ""
Write-Host "Step 2: Checking Git repository..." -ForegroundColor Yellow

# Check git status
try {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  You have uncommitted changes:" -ForegroundColor Yellow
        git status --short
        Write-Host ""
        $commitChanges = Read-Host "Would you like to commit these changes? (y/n)"
        if ($commitChanges -eq 'y') {
            $commitMessage = Read-Host "Enter commit message"
            git add .
            git commit -m $commitMessage
            git push origin main
            Write-Host "✅ Changes committed and pushed!" -ForegroundColor Green
        }
    } else {
        Write-Host "✅ Git repository is clean and up to date!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Git command failed. Please ensure Git is installed and you're in a Git repository." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 3: Deployment Instructions" -ForegroundColor Yellow

switch ($Platform.ToLower()) {
    "render" {
        Write-Host "🚀 Deploying to Render (Recommended)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Option A: Automatic Deployment (Recommended)" -ForegroundColor Green
        Write-Host "1. Visit: https://render.com" -ForegroundColor White
        Write-Host "2. Click 'Sign Up' or 'Log In'" -ForegroundColor White
        Write-Host "3. Click 'New +' and select 'Web Service'" -ForegroundColor White
        Write-Host "4. Connect your GitHub repository" -ForegroundColor White
        Write-Host "5. Select your PlantGuard repository" -ForegroundColor White
        Write-Host "6. Render will automatically detect render.yaml" -ForegroundColor White
        Write-Host "7. Click 'Create Web Service'" -ForegroundColor White
        Write-Host "8. Wait for deployment to complete (2-5 minutes)" -ForegroundColor White
        Write-Host ""
        Write-Host "Option B: Manual Configuration" -ForegroundColor Yellow
        Write-Host "If render.yaml is not detected, use these settings:" -ForegroundColor White
        Write-Host "- Name: plantguard" -ForegroundColor Gray
        Write-Host "- Environment: Python 3" -ForegroundColor Gray
        Write-Host "- Build Command: cd 'Flask Deployed App' && pip install -r requirements.txt" -ForegroundColor Gray
        Write-Host "- Start Command: cd 'Flask Deployed App' && gunicorn app:app" -ForegroundColor Gray
        Write-Host "- Root Directory: Flask Deployed App" -ForegroundColor Gray
        
        # Open Render in browser
        Write-Host ""
        $openBrowser = Read-Host "Would you like to open Render in your browser? (y/n)"
        if ($openBrowser -eq 'y') {
            Start-Process "https://render.com"
        }
    }
    
    "fly" {
        Write-Host "✈️ Deploying to Fly.io" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Prerequisites:" -ForegroundColor Yellow
        Write-Host "1. Install Fly CLI: curl -L https://fly.io/install.sh | sh" -ForegroundColor White
        Write-Host "2. Login: fly auth login" -ForegroundColor White
        Write-Host ""
        Write-Host "Deployment Steps:" -ForegroundColor Green
        Write-Host "1. Run: fly launch" -ForegroundColor White
        Write-Host "2. Follow the prompts" -ForegroundColor White
        Write-Host "3. Use existing fly.toml configuration" -ForegroundColor White
        Write-Host "4. Run: fly deploy" -ForegroundColor White
        
        # Open Fly.io in browser
        Write-Host ""
        $openBrowser = Read-Host "Would you like to open Fly.io in your browser? (y/n)"
        if ($openBrowser -eq 'y') {
            Start-Process "https://fly.io"
        }
    }
    
    "heroku" {
        Write-Host "🟣 Deploying to Heroku" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Prerequisites:" -ForegroundColor Yellow
        Write-Host "1. Install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor White
        Write-Host "2. Login: heroku login" -ForegroundColor White
        Write-Host ""
        Write-Host "Deployment Steps:" -ForegroundColor Green
        Write-Host "1. Run: heroku create your-app-name" -ForegroundColor White
        Write-Host "2. Run: heroku buildpacks:add heroku/python" -ForegroundColor White
        Write-Host "3. Run: git push heroku main" -ForegroundColor White
        
        # Open Heroku in browser
        Write-Host ""
        $openBrowser = Read-Host "Would you like to open Heroku in your browser? (y/n)"
        if ($openBrowser -eq 'y') {
            Start-Process "https://heroku.com"
        }
    }
    
    default {
        Write-Host "❌ Unknown platform: $Platform" -ForegroundColor Red
        Write-Host "Available platforms: render, fly, heroku" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "Step 4: After Deployment" -ForegroundColor Yellow
Write-Host "Once deployed, test your application:" -ForegroundColor White
Write-Host "- Health check: https://your-app-url.com/health" -ForegroundColor Gray
Write-Host "- Test prediction: Upload a plant image to your app" -ForegroundColor Gray
Write-Host "- Monitor logs through your platform dashboard" -ForegroundColor Gray

Write-Host ""
Write-Host "Step 5: Troubleshooting" -ForegroundColor Yellow
Write-Host "If deployment fails:" -ForegroundColor White
Write-Host "1. Check platform logs" -ForegroundColor Gray
Write-Host "2. Verify all files are present" -ForegroundColor Gray
Write-Host "3. Test locally: cd 'Flask Deployed App' && python app.py" -ForegroundColor Gray
Write-Host "4. Check requirements.txt for compatibility" -ForegroundColor Gray

Write-Host ""
Write-Host "✅ PlantGuard is ready for deployment!" -ForegroundColor Green
Write-Host "🚀 Choose your platform and follow the steps above." -ForegroundColor Green
Write-Host ""
Write-Host "Need help? Check CLI_DEPLOYMENT_GUIDE.md for detailed instructions." -ForegroundColor Cyan