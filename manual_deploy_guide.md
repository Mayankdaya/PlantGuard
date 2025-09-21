# 🌱 PlantGuard Manual Deployment Guide

Since the automatic render.yaml detection didn't work, let's manually create the service on Render.

## 📋 Step-by-Step Manual Deployment:

### Step 1: Access Render Dashboard
1. Go to https://dashboard.render.com
2. Log in with your account (mayankdl203@gmail.com)
3. Click "New" → "Web Service"

### Step 2: Connect GitHub Repository
1. Click "Connect GitHub" if not already connected
2. Search for "PlantGuard" or "Plant-Disease-Detection" repository
3. Select your repository: `Mayankdaya/PlantGuard`
4. Authorize Render to access your repository

### Step 3: Configure the Service
Fill in the following details:

**Basic Settings:**
- **Name**: `plantguard`
- **Branch**: `main`
- **Root Directory**: `Flask Deployed App`
- **Environment**: `Python`
- **Region**: Choose closest to you

**Build Settings:**
- **Build Command**: 
```bash
echo "🌱 Setting up PlantGuard deployment..."
pip install -r requirements.txt
echo "✅ Dependencies installed"

# Check for model file
if [ -f "plant_disease_model_1.pt" ]; then
  echo "✅ Model file found"
else
  echo "⚠️ Model file not found - using placeholder"
fi
echo "🚀 Build complete"
```

**Start Settings:**
- **Start Command**: `gunicorn -w 2 -k gthread -b 0.0.0.0:$PORT app:app`

**Environment Variables:**
- `PYTHON_VERSION`: `3.10.13`
- `FLASK_ENV`: `production`
- `FLASK_DEBUG`: `0`

### Step 4: Deploy
1. Click "Create Web Service"
2. Wait for the deployment to complete
3. Monitor the build logs for any issues

### Step 5: Verify Deployment
Once deployed, you should be able to:
- Access the application via the provided URL
- Test the plant disease prediction functionality
- Monitor logs and performance through the Render dashboard

## 🛠 Alternative: Direct Render CLI Deployment

If you prefer using the CLI, try this approach:

```bash
# First, ensure you're in the project directory
cd "E:\Gihub\Plant-Disease-Detection"

# Try to create service via CLI (may need manual intervention)
.\render_cli\cli_v1.1.0.exe services create --interactive

# Or use the web interface and then manage via CLI
```

## 📊 Post-Deployment Verification

Once the service is created, you can use these commands to monitor it:

```bash
# List services
.\render_cli\cli_v1.1.0.exe services list

# View logs
.\render_cli\cli_v1.1.0.exe logs --service plantguard

# Check deployment status
.\render_cli\cli_v1.1.0.exe deploys list --service plantguard
```

## ⚠️ Important Notes:

1. **Model File**: The application expects `plant_disease_model_1.pt` in the Flask Deployed App directory. If it's not there, you may need to:
   - Upload it to the repository
   - Use an environment variable with a download URL
   - Or modify the app to handle missing model gracefully

2. **Free Plan**: The service is configured for Render's free plan, which has:
   - Limited resources
   - Sleeps after 15 minutes of inactivity
   - Monthly usage limits

3. **GitHub Integration**: Make sure your GitHub account is properly connected to Render for automatic deployments.

## 🎯 Expected Outcome:

After successful deployment:
- PlantGuard will be accessible via a public URL
- Plant disease prediction functionality will be available
- The service will auto-deploy on future GitHub pushes
- You can monitor and manage the service through Render dashboard and CLI

---

**Need Help?** Check the Render documentation or run `check_status.bat` for current deployment status.