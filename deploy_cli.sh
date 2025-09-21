#!/bin/bash

# PlantGuard CLI Deployment Script
# Deploy to multiple platforms using command line interface

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "🌱 PlantGuard CLI Deployment Tool"
    echo "=================================="
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

check_dependencies() {
    echo "Checking dependencies..."
    
    # Check if git is available
    if command -v git &> /dev/null; then
        print_success "Git is available"
    else
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    # Check if curl is available
    if command -v curl &> /dev/null; then
        print_success "Curl is available"
    else
        print_warning "Curl is not available. Some features may not work."
    fi
}

verify_deployment_files() {
    echo "Verifying deployment files..."
    
    # Check if we're in the right directory
    if [ ! -f "render.yaml" ]; then
        print_error "render.yaml not found. Please run this script from the PlantGuard root directory."
        exit 1
    fi
    
    # Check Flask Deployed App directory
    if [ ! -d "Flask Deployed App" ]; then
        print_error "Flask Deployed App directory not found."
        exit 1
    fi
    
    # Check key files
    required_files=("Flask Deployed App/app.py" "Flask Deployed App/requirements.txt" "Flask Deployed App/CNN.py" "Flask Deployed App/plant_disease_model_1.pt")
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            size=$(ls -lh "$file" 2>/dev/null | awk '{print $5}' || echo "unknown")
            print_success "Found $file ($size)"
        else
            print_error "Missing $file"
            exit 1
        fi
    done
}

deploy_to_render() {
    echo "Deploying to Render..."
    
    # Check if render CLI is available
    if ! command -v render &> /dev/null; then
        print_info "Render CLI not found. Installing..."
        
        # Install Render CLI
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            curl -fsSL https://render.com/install-render-cli.sh | bash
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            curl -fsSL https://render.com/install-render-cli.sh | bash
        else
            print_error "Automatic Render CLI installation not supported on this OS."
            print_info "Please install manually from: https://render.com/docs/cli"
            exit 1
        fi
        
        # Add to PATH if needed
        export PATH="$PATH:$HOME/.render/bin"
    fi
    
    # Check if user is logged in to Render
    if render whoami &> /dev/null; then
        print_success "Logged in to Render"
    else
        print_info "Please login to Render first:"
        echo "render login"
        exit 1
    fi
    
    # Create service using render.yaml
    print_info "Creating Render service from render.yaml..."
    
    # Use render blueprint
    if render blueprint apply --file render.yaml; then
        print_success "Render service created successfully!"
        print_info "Check your Render dashboard for the deployment status."
    else
        print_error "Failed to create Render service"
        print_info "You can also deploy manually at: https://render.com"
        exit 1
    fi
}

deploy_to_fly() {
    echo "Deploying to Fly.io..."
    
    # Check if fly CLI is available
    if ! command -v fly &> /dev/null; then
        print_info "Fly CLI not found. Installing..."
        
        # Install Fly CLI
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            curl -L https://fly.io/install.sh | sh
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            curl -L https://fly.io/install.sh | sh
        else
            print_error "Automatic Fly CLI installation not supported on this OS."
            print_info "Please install manually from: https://fly.io/docs/hands-on/install-flyctl/"
            exit 1
        fi
        
        # Add to PATH
        export PATH="$PATH:$HOME/.fly/bin"
    fi
    
    # Check if user is logged in to Fly
    if fly auth whoami &> /dev/null; then
        print_success "Logged in to Fly.io"
    else
        print_info "Please login to Fly.io first:"
        echo "fly auth login"
        exit 1
    fi
    
    # Launch app
    print_info "Launching Fly.io app..."
    
    # Use existing fly.toml
    if [ -f "fly.toml" ]; then
        print_info "Using existing fly.toml configuration"
        if fly launch --now --copy-config; then
            print_success "Fly.io app launched successfully!"
        else
            print_error "Failed to launch Fly.io app"
            exit 1
        fi
    else
        print_error "fly.toml not found. Please create it first."
        exit 1
    fi
}

deploy_to_heroku() {
    echo "Deploying to Heroku..."
    
    # Check if Heroku CLI is available
    if ! command -v heroku &> /dev/null; then
        print_info "Heroku CLI not found. Installing..."
        
        # Install Heroku CLI
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            brew tap heroku/brew && brew install heroku
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            curl https://cli-assets.heroku.com/install.sh | sh
        else
            print_error "Automatic Heroku CLI installation not supported on this OS."
            print_info "Please install manually from: https://devcenter.heroku.com/articles/heroku-cli"
            exit 1
        fi
    fi
    
    # Check if user is logged in to Heroku
    if heroku auth:whoami &> /dev/null; then
        print_success "Logged in to Heroku"
    else
        print_info "Please login to Heroku first:"
        echo "heroku login"
        exit 1
    fi
    
    # Create Heroku app
    print_info "Creating Heroku app..."
    
    # Generate unique app name
    app_name="plantguard-$(date +%s)"
    
    if heroku create "$app_name"; then
        print_success "Heroku app created: $app_name"
        
        # Set buildpack
        heroku buildpacks:add heroku/python
        
        # Deploy
        print_info "Deploying to Heroku..."
        if git push heroku main; then
            print_success "Deployed to Heroku successfully!"
            echo "App URL: https://$app_name.herokuapp.com"
        else
            print_error "Failed to deploy to Heroku"
            exit 1
        fi
    else
        print_error "Failed to create Heroku app"
        exit 1
    fi
}

show_help() {
    echo "PlantGuard CLI Deployment Tool"
    echo ""
    echo "Usage: $0 [PLATFORM]"
    echo ""
    echo "Platforms:"
    echo "  render    Deploy to Render.com (recommended)"
    echo "  fly       Deploy to Fly.io"
    echo "  heroku    Deploy to Heroku"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 render"
    echo "  $0 fly"
    echo "  $0 help"
    echo ""
    echo "Prerequisites:"
    echo "- Git repository with committed changes"
    echo "- Account on chosen platform"
    echo "- Platform CLI installed (will attempt auto-install)"
}

# Main script
main() {
    print_header
    
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        echo "Please specify a deployment platform:"
        echo "render, fly, heroku, or help"
        exit 1
    fi
    
    case "$1" in
        "render")
            check_dependencies
            verify_deployment_files
            deploy_to_render
            ;;
        "fly")
            check_dependencies
            verify_deployment_files
            deploy_to_fly
            ;;
        "heroku")
            check_dependencies
            verify_deployment_files
            deploy_to_heroku
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown platform: $1"
            echo "Use 'help' to see available options"
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Deployment process completed!"
}

# Run main function with all arguments
main "$@"