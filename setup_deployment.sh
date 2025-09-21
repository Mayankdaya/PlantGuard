#!/bin/bash
# PlantGuard Deployment Setup Script
# This script sets up the environment for deployment

set -e

echo "🌱 PlantGuard Deployment Setup"
echo "================================"

# Check Python version
echo "Checking Python version..."
python_version=$(python --version 2>&1 | awk '{print $2}')
echo "Python version: $python_version"

# Create virtual environment
echo "Creating virtual environment..."
python -m venv venv
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
cd "Flask Deployed App"
pip install -r requirements.txt

# Verify model file
echo "Checking model file..."
if [ -f "plant_disease_model_1.pt" ]; then
    echo "✅ Model file found: plant_disease_model_1.pt"
    model_size=$(ls -lh plant_disease_model_1.pt | awk '{print $5}')
    echo "Model size: $model_size"
else
    echo "⚠️  Model file not found. Please ensure plant_disease_model_1.pt is present"
    echo "   or set MODEL_URL environment variable for automatic download."
fi

# Test application startup
echo "Testing application startup..."
timeout 10s python app.py &
APP_PID=$!
sleep 3

# Check if app is running
if ps -p $APP_PID > /dev/null; then
    echo "✅ Application started successfully"
    kill $APP_PID
else
    echo "❌ Application failed to start"
    exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Choose your deployment platform (Render, Fly.io, or Hugging Face)"
echo "2. Follow the deployment guide in deployment_guide.md"
echo "3. Set up environment variables as needed"
echo ""
echo "To run locally:"
echo "cd 'Flask Deployed App' && python app.py"