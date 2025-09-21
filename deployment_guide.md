# PlantGuard Deployment Guide

## Project Overview
PlantGuard is a Flask-based web application for plant disease detection using a CNN model. The project supports multiple deployment platforms including Render, Fly.io, and Hugging Face Spaces.

## 🚀 Quick Start

### Local Development
1. **Setup Virtual Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install Dependencies**
   ```bash
   cd "Flask Deployed App"
   pip install -r requirements.txt
   ```

3. **Run Application**
   ```bash
   python app.py
   ```
   Access at: http://localhost:5000

### Production Deployment Options

## 🌐 Platform-Specific Deployment

### 1. Render Deployment
**Recommended for beginners** - Free tier available with automatic deployments.

**Steps:**
1. Fork this repository
2. Create account at [render.com](https://render.com)
3. Click "New Web Service"
4. Connect your GitHub repository
5. Configure:
   - **Name**: plantguard
   - **Environment**: Python
   - **Root Directory**: Flask Deployed App
   - **Build Command**: 
     ```bash
     pip install -r requirements.txt
     ```
   - **Start Command**: `gunicorn -w 2 -k gthread -b 0.0.0.0:$PORT app:app`

**Environment Variables (Optional):**
- `MODEL_URL`: URL to download model file if not in repository
- `MODEL_PATH`: Custom model file path
- `PORT`: Port number (automatically set by Render)

**Configuration File**: `render.yaml` (already provided)

### 2. Fly.io Deployment
**Best for global deployment** - Edge locations worldwide.

**Steps:**
1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Login: `fly auth login`
3. Deploy: `fly launch` (follow prompts)
4. Configure using `fly.toml` (already provided)

**Key Features:**
- Auto-scaling
- Global edge deployment
- Built-in SSL/TLS
- Health checks configured

### 3. Hugging Face Spaces
**Great for ML demos** - Free GPU/CPU resources.

**Steps:**
1. Create account at [huggingface.co](https://huggingface.co)
2. Create new Space
3. Upload files from `hf_space/` directory
4. Configure Space settings
5. Deploy automatically

## 📋 Deployment Checklist

### Pre-deployment
- [ ] Model file (`plant_disease_model_1.pt`) present or `MODEL_URL` configured
- [ ] Dependencies installed successfully
- [ ] Local testing completed
- [ ] Health check endpoint responds (`/healthz`)

### Environment Variables
- [ ] `PORT` (automatically set by platforms)
- [ ] `MODEL_URL` (optional - for external model hosting)
- [ ] `MODEL_PATH` (optional - custom model path)
- [ ] `FLASK_DEBUG` (set to `0` for production)

### Security & Performance
- [ ] Debug mode disabled in production
- [ ] Gunicorn worker processes configured
- [ ] Health checks enabled
- [ ] SSL/TLS enabled (automatic on most platforms)

## 🔧 Technical Specifications

### Model Information
- **Architecture**: CNN with 4 convolutional layers
- **Input**: 224x224 RGB images
- **Output**: 39 plant disease classes
- **File Size**: ~210MB

### Dependencies
- Flask 2.2.5
- PyTorch (CPU version)
- Pillow, Pandas, NumPy
- Gunicorn (production server)

### Resource Requirements
- **Memory**: 512MB+ recommended
- **Storage**: 300MB+ for model and dependencies
- **CPU**: Single core sufficient for inference

## 🐛 Troubleshooting

### Common Issues
1. **Model Loading Errors**
   - Ensure model file exists in correct location
   - Check `MODEL_URL` if downloading externally
   - Verify file permissions

2. **Memory Issues**
   - Use CPU-only PyTorch for lower memory usage
   - Consider model quantization for edge deployment

3. **Port Binding**
   - Ensure `PORT` environment variable is set
   - Check firewall settings

### Health Check
Test application health:
```bash
curl http://localhost:5000/healthz
# Expected: {"status":"ok"}
```

## 📊 Performance Optimization

### Production Settings
- Use Gunicorn with multiple workers
- Enable model caching
- Implement request queuing for high traffic
- Consider CDN for static assets

### Scaling Recommendations
- **Low traffic**: 1-2 workers
- **Medium traffic**: 2-4 workers
- **High traffic**: Consider load balancing

## 🔗 Additional Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [PyTorch Deployment Guide](https://pytorch.org/tutorials/recipes/deployment.html)
- [Gunicorn Configuration](https://docs.gunicorn.org/en/stable/configure.html)

## 📞 Support

For deployment issues:
1. Check application logs
2. Verify environment variables
3. Test locally first
4. Review platform-specific documentation

---

**Ready to deploy? Choose your platform and follow the steps above! 🌱**