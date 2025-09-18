import os
from flask import Flask, redirect, render_template, request
from PIL import Image
import torchvision.transforms.functional as TF
import CNN
import numpy as np
import torch
import pandas as pd
import requests
import re
from typing import Optional

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_DIR = os.path.join(BASE_DIR, 'static', 'uploads')
os.makedirs(UPLOAD_DIR, exist_ok=True)

disease_csv_path = os.path.join(BASE_DIR, 'disease_info.csv')
supplement_csv_path = os.path.join(BASE_DIR, 'supplement_info.csv')

disease_info = pd.read_csv(disease_csv_path, encoding='cp1252')
supplement_info = pd.read_csv(supplement_csv_path, encoding='cp1252')

model = CNN.CNN(39)

# Resolve model path and optionally download from MODEL_URL if missing
default_model_path = os.path.join(BASE_DIR, 'plant_disease_model_1.pt')
model_path = os.getenv('MODEL_PATH', default_model_path)

if not os.path.isfile(model_path):
    model_url = os.getenv('MODEL_URL')
    if model_url:
        try:
            def _download_with_requests(url: str, out_path: str):
                resp = requests.get(url, stream=True, timeout=300)
                resp.raise_for_status()
                os.makedirs(os.path.dirname(out_path), exist_ok=True)
                with open(out_path, 'wb') as f:
                    for chunk in resp.iter_content(chunk_size=8192):
                        if chunk:
                            f.write(chunk)

            def _maybe_use_gdown(url: str, out_path: str) -> bool:
                # Returns True if gdown handled the download
                if 'drive.google.com' not in url:
                    return False
                # Normalize to uc?id= format
                file_id: Optional[str] = None
                m = re.search(r"/file/d/([^/]+)/", url)
                if m:
                    file_id = m.group(1)
                m2 = re.search(r"[?&]id=([^&]+)", url)
                if not file_id and m2:
                    file_id = m2.group(1)
                if not file_id:
                    return False
                dl_url = f"https://drive.google.com/uc?id={file_id}"
                try:
                    import gdown  # type: ignore
                    os.makedirs(os.path.dirname(out_path), exist_ok=True)
                    gdown.download(dl_url, out_path, quiet=False, fuzzy=True)
                    return os.path.isfile(out_path)
                except Exception as _:
                    return False

            handled = _maybe_use_gdown(model_url, model_path)
            if not handled:
                _download_with_requests(model_url, model_path)
        except Exception as e:
            # If download fails, continue and let torch.load raise a clearer error
            print(f"Warning: Failed to download model from MODEL_URL: {e}")

state_dict = torch.load(model_path, map_location='cpu')
model.load_state_dict(state_dict)
model.eval()

def prediction(image_path):
    image = Image.open(image_path).convert('RGB')
    image = image.resize((224, 224))
    input_data = TF.to_tensor(image)
    input_data = input_data.view((-1, 3, 224, 224))
    with torch.no_grad():
        output = model(input_data)
        output = output.detach().numpy()
    index = np.argmax(output)
    return index


app = Flask(__name__)

@app.route('/')
def home_page():
    return render_template('home_pg.html')

@app.route('/healthz')
def healthz():
    # Basic health endpoint for Render/uptime checks
    return {'status': 'ok'}, 200

@app.route('/contact')
def contact():
    # Redirect to the premium homepage contact section
    return redirect('/#contact')

@app.route('/index')
def ai_engine_page():
    return render_template('index_pg.html')

@app.route('/mobile-device')
def mobile_device_detected_page():
    # Legacy page removed; send users to the premium homepage
    return redirect('/')

@app.route('/submit', methods=['GET', 'POST'])
def submit():
    if request.method == 'POST':
        image = request.files['image']
        filename = image.filename
        file_path = os.path.join(UPLOAD_DIR, filename)
        image.save(file_path)
        print(file_path)
        pred = prediction(file_path)
        title = disease_info['disease_name'][pred]
        description = disease_info['description'][pred]
        prevent = disease_info['Possible Steps'][pred]
        image_url = disease_info['image_url'][pred]
        supplement_name = supplement_info['supplement name'][pred]
        supplement_image_url = supplement_info['supplement image'][pred]
        supplement_buy_link = supplement_info['buy link'][pred]
        return render_template('submit_pg.html' , title = title , desc = description , prevent = prevent , 
                               image_url = image_url , pred = pred ,sname = supplement_name , simage = supplement_image_url , buy_link = supplement_buy_link)

@app.route('/market', methods=['GET', 'POST'])
def market():
    # Legacy market view removed; direct users to tips section on AI page
    return redirect('/index#tips')

if __name__ == '__main__':
    # Respect PORT for container/local parity
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', '0') == '1'
    app.run(host='0.0.0.0', port=port, debug=debug)
