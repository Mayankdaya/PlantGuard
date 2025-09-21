#!/usr/bin/env python3
"""
PlantGuard Deployment Verification Script
This script verifies that the deployment is ready and working correctly.
"""

import requests
import sys
import time

def verify_deployment(url):
    """Verify PlantGuard deployment is working correctly."""
    
    print(f"🔍 Verifying deployment at: {url}")
    
    try:
        # Test health endpoint
        health_url = f"{url.rstrip('/')}/healthz"
        print(f"Testing health endpoint: {health_url}")
        
        response = requests.get(health_url, timeout=30)
        
        if response.status_code == 200:
            health_data = response.json()
            if health_data.get('status') == 'ok':
                print("✅ Health check passed")
            else:
                print(f"⚠️  Health check returned unexpected status: {health_data}")
        else:
            print(f"❌ Health check failed with status code: {response.status_code}")
            return False
            
        # Test main page
        print(f"Testing main page: {url}")
        response = requests.get(url, timeout=30)
        
        if response.status_code == 200:
            print("✅ Main page loads successfully")
            
            # Check for key content
            content = response.text
            if 'PlantGuard' in content:
                print("✅ PlantGuard branding found")
            else:
                print("⚠️  PlantGuard branding not found")
                
            if 'upload' in content.lower():
                print("✅ Upload functionality detected")
            else:
                print("⚠️  Upload functionality not detected")
                
        else:
            print(f"❌ Main page failed with status code: {response.status_code}")
            return False
            
        print("\n🎉 Deployment verification completed successfully!")
        print(f"🌱 Your PlantGuard app is live at: {url}")
        print(f"📸 Test it by uploading a plant leaf image!")
        
        return True
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Deployment verification failed: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False

def main():
    """Main function to run deployment verification."""
    
    if len(sys.argv) > 1:
        url = sys.argv[1]
    else:
        print("Usage: python verify_deployment.py <deployment_url>")
        print("Example: python verify_deployment.py https://plantguard-xyz.onrender.com")
        return
    
    print("🚀 Starting PlantGuard deployment verification...")
    print("=" * 50)
    
    success = verify_deployment(url)
    
    if success:
        print("\n✅ Deployment verified and ready for use!")
    else:
        print("\n❌ Deployment verification failed. Please check the logs above.")
        sys.exit(1)

if __name__ == "__main__":
    main()