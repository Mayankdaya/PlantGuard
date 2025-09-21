#!/usr/bin/env python3
"""
Verify Render deployment configuration for PlantGuard
"""

import os
import yaml

def verify_render_config():
    """Verify render.yaml configuration and required files."""
    
    print("🔍 Verifying render.yaml configuration...")
    
    try:
        # Load render.yaml
        with open('render.yaml', 'r') as f:
            config = yaml.safe_load(f)
        
        service = config['services'][0]
        print(f"✅ Service name: {service['name']}")
        print(f"✅ Environment: {service['env']}")
        print(f"✅ Root directory: {service['rootDir']}")
        print(f"✅ Build command length: {len(service['buildCommand'])} chars")
        print(f"✅ Start command: {service['startCommand']}")
        print(f"✅ Environment variables: {len(service['envVars'])}")
        
        # Check Flask Deployed App directory
        flask_dir = service['rootDir']
        if os.path.exists(flask_dir):
            print(f"✅ {flask_dir} directory exists")
            
            # Check key files
            required_files = ['app.py', 'requirements.txt', 'CNN.py', 'plant_disease_model_1.pt']
            all_present = True
            
            for file in required_files:
                filepath = os.path.join(flask_dir, file)
                if os.path.exists(filepath):
                    size = os.path.getsize(filepath)
                    print(f"  ✅ {file} ({size:,} bytes)")
                else:
                    print(f"  ❌ {file} missing")
                    all_present = False
            
            if all_present:
                print("\n🎉 All required files present!")
            else:
                print("\n⚠️  Some files missing")
                return False
        else:
            print(f"❌ {flask_dir} directory not found")
            return False
        
        print("\n🎉 Render configuration verified!")
        print("🚀 Ready for deployment to Render!")
        return True
        
    except Exception as e:
        print(f"❌ Configuration error: {e}")
        return False

if __name__ == "__main__":
    success = verify_render_config()
    if success:
        print("\n✅ PlantGuard is ready for Render deployment!")
        print("\n🌱 Next steps:")
        print("1. Go to https://render.com")
        print("2. Create new Web Service")
        print("3. Connect your GitHub repository")
        print("4. Render will automatically detect render.yaml")
        print("5. Deploy!")
    else:
        print("\n❌ Please fix the issues above before deployment.")