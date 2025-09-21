# PlantGuard CLI Deployment Guide 🌱

This guide provides step-by-step instructions for deploying PlantGuard using command-line tools across multiple platforms.

## Quick Start

### Prerequisites
- Git repository with PlantGuard code
- Python 3.8+ installed
- Command-line access (Terminal/PowerShell)
- Account on your chosen deployment platform

### One-Command Deployment

**For Unix/Linux/macOS:**
```bash
# Make the script executable
chmod +x deploy_cli.sh

# Deploy to your chosen platform
./deploy_cli.sh render    # Deploy to Render (recommended)
./deploy_cli.sh fly       # Deploy to Fly.io
./deploy_cli.sh heroku    # Deploy to Heroku
```

**For Windows:**
```cmd
# Deploy to your chosen platform
deploy_cli.bat render     # Deploy to Render (recommended)
deploy_cli.bat fly        # Deploy to Fly.io
deploy_cli.bat heroku     # Deploy to Heroku
```

## Platform-Specific Setup

### 1. Render (Recommended) 🚀

**Advantages:**
- Free tier with generous limits
- Automatic deployments from Git
- Built-in SSL and custom domains
- PostgreSQL database support

**Setup Steps:**
1. **Install Render CLI:**
   ```bash
   # macOS/Linux
   curl -fsSL https://render.com/install-render-cli.sh | bash
   
   # Windows (manual)
   # Download from: https://render.com/docs/cli
   ```

2. **Login to Render:**
   ```bash
   render login
   ```

3. **Deploy:**
   ```bash
   ./deploy_cli.sh render
   ```

**Manual Alternative:**
1. Visit [render.com](https://render.com)
2. Connect your GitHub repository
3. Create a new Web Service
4. Select your repository
5. Render will automatically use your `render.yaml` configuration

### 2. Fly.io ✈️

**Advantages:**
- Global edge deployment
- Automatic scaling
- Built-in monitoring
- Competitive pricing

**Setup Steps:**
1. **Install Fly CLI:**
   ```bash
   # macOS/Linux
   curl -L https://fly.io/install.sh | sh
   
   # Windows (manual)
   # Download from: https://fly.io/docs/hands-on/install-flyctl/
   ```

2. **Login to Fly.io:**
   ```bash
   fly auth login
   ```

3. **Create fly.toml (if not exists):**
   ```toml
   app = "plantguard-app"
   primary_region = "iad"
   
   [build]
     dockerfile = "Dockerfile"
   
   [env]
     PORT = "8080"
     FLASK_ENV = "production"
   
   [[services]]
     internal_port = 8080
     protocol = "tcp"
     
     [[services.ports]]
       port = 80
       handlers = ["http"]
       
     [[services.ports]]
       port = 443
       handlers = ["tls", "http"]
   ```

4. **Deploy:**
   ```bash
   ./deploy_cli.sh fly
   ```

### 3. Heroku 🟣

**Advantages:**
- Well-established platform
- Extensive add-on ecosystem
- Easy scaling options
- Good documentation

**Setup Steps:**
1. **Install Heroku CLI:**
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku
   
   # Linux
   curl https://cli-assets.heroku.com/install.sh | sh
   
   # Windows
   # Download from: https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Login to Heroku:**
   ```bash
   heroku login
   ```

3. **Deploy:**
   ```bash
   ./deploy_cli.sh heroku
   ```

**Manual Alternative:**
```bash
# Create Heroku app
heroku create your-app-name

# Set buildpack
heroku buildpacks:add heroku/python

# Deploy
git push heroku main
```

## Environment Variables

Set these environment variables on your chosen platform:

### Required Variables:
```bash
FLASK_ENV=production
FLASK_DEBUG=False
PORT=8080
```

### Optional Variables:
```bash
MODEL_URL=https://your-domain.com/model.pth  # For model download
SECRET_KEY=your-secret-key-here
MAX_CONTENT_LENGTH=16777216  # 16MB file upload limit
```

## Verification Steps

After deployment, verify your application:

1. **Health Check:**
   ```bash
   curl https://your-app-url.com/health
   ```

2. **Test Prediction:**
   ```bash
   # Upload a test image
   curl -X POST -F "file=@test_plant.jpg" https://your-app-url.com/predict
   ```

3. **Check Logs:**
   ```bash
   # Render
   render logs
   
   # Fly.io
   fly logs
   
   # Heroku
   heroku logs --tail
   ```

## Troubleshooting

### Common Issues

1. **Model File Missing**
   ```bash
   # Check if model exists
   ls -la Flask\ Deployed\ App/plant_disease_model_1.pt
   
   # If missing, download it
   cd "Flask Deployed App"
   python -c "import gdown; gdown.download('https://drive.google.com/uc?id=1-YourModelID', 'plant_disease_model_1.pt')"
   ```

2. **Build Failures**
   ```bash
   # Check requirements.txt
   pip install -r "Flask Deployed App/requirements.txt"
   
   # Test locally first
   cd "Flask Deployed App"
   python app.py
   ```

3. **Memory Issues**
   - Reduce model size if possible
   - Use lighter dependencies
   - Consider using a smaller base image

### Platform-Specific Issues

**Render:**
- Check build logs in Render dashboard
- Ensure `render.yaml` is valid
- Verify Python version compatibility

**Fly.io:**
- Check region availability
- Verify `fly.toml` configuration
- Monitor resource usage

**Heroku:**
- Check dyno hours (free tier limits)
- Verify buildpack configuration
- Monitor slug size

## Performance Optimization

1. **Model Optimization:**
   - Use model quantization
   - Consider using ONNX format
   - Implement model caching

2. **Application Optimization:**
   - Enable GZIP compression
   - Use CDN for static files
   - Implement request caching

3. **Resource Management:**
   - Monitor memory usage
   - Set appropriate timeouts
   - Use connection pooling

## Security Best Practices

1. **Environment Variables:**
   - Never hardcode secrets
   - Use platform secret management
   - Rotate keys regularly

2. **File Uploads:**
   - Validate file types
   - Limit file sizes
   - Scan for malware

3. **HTTPS:**
   - Always use HTTPS in production
   - Implement proper SSL certificates
   - Use secure headers

## Monitoring and Maintenance

### Health Checks
Set up regular health checks:
```bash
# Cron job for health monitoring
*/5 * * * * curl -f https://your-app-url.com/health || echo "Health check failed"
```

### Log Monitoring
Monitor application logs for:
- Error rates
- Response times
- Resource usage
- Security events

### Updates
Regular maintenance:
```bash
# Update dependencies
pip install --upgrade -r requirements.txt

# Test updates locally
python app.py

# Deploy updates
git add .
git commit -m "Update dependencies"
git push origin main
```

## Support

If you encounter issues:

1. **Check Platform Documentation:**
   - [Render Docs](https://render.com/docs)
   - [Fly.io Docs](https://fly.io/docs/)
   - [Heroku Dev Center](https://devcenter.heroku.com/)

2. **Community Support:**
   - Check existing GitHub issues
   - Join platform-specific communities
   - Consult deployment guides

3. **Troubleshooting Commands:**
   ```bash
   # Check deployment status
   ./deploy_cli.sh help
   
   # Verify configuration
   python verify_render_config.py
   
   # Check local setup
   ./setup_deployment.sh
   ```

## Next Steps

After successful deployment:

1. **Set up custom domain** (if needed)
2. **Configure monitoring alerts**
3. **Set up CI/CD pipeline**
4. **Implement backup strategy**
5. **Plan for scaling**

Happy deploying! 🚀