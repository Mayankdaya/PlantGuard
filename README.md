# PlantGuard — Premium Plant Disease Detection (Flask + PyTorch)

PlantGuard is a modern, premium web app to detect plant leaf diseases using a Convolutional Neural Network (CNN) built with PyTorch. The app ships with a beautiful, professional UI and predicts across 39 classes (PlantVillage). A Flask backend serves the model and provides actionable results with descriptions and prevention steps.

PlantGuard is designed for clarity and speed: upload a leaf image (or capture via camera), get an instant prediction, then act on precise prevention guidelines.

![PlantGuard banner](assets/banner.svg)

![Version](https://img.shields.io/badge/Version-1.0.0-4b5563?style=flat)
![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=flat&logo=python&logoColor=white) 
![Framework](https://img.shields.io/badge/Flask-Backend-000?style=flat&logo=flask&logoColor=white) 
![DL](https://img.shields.io/badge/PyTorch-Model-EE4C2C?style=flat&logo=pytorch&logoColor=white) 
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat)



---

## Table of Contents

- [Highlights](#highlights)
- [Screenshots](#screenshots)
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Dataset](#dataset)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [UI Tour](#ui-tour)
- [Command Cheatsheet](#command-cheatsheet)
- [Using Test Images](#using-test-images)
- [Troubleshooting](#troubleshooting)
- [Model Notes](#model-notes)
- [FAQ](#faq)
- [Roadmap / Ideas](#roadmap--ideas)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Links](#links)

---

## Highlights

<table>
<tr>
<td>

- Premium UI/UX with modern glassmorphism
- Local & private by default
- Camera capture + drag‑and‑drop upload

</td>
<td>

- 39 classes (PlantVillage)
- Fast inference with lightweight CNN
- Actionable description + prevention steps

</td>
</tr>
</table>

---

## Screenshots

Latest UI

- Homepage (premium)
  
  ![Homepage](https://github.com/user-attachments/assets/851873b4-a1cc-493f-af14-32e545263df8)

- Image Upload page (AI Engine)
  
  ![Image Upload](https://github.com/user-attachments/assets/f7a585a4-dc94-484f-ac14-fec4809a0f16)

---

## See it in action

> Short walkthrough from Home → Upload → Results. Replace the placeholder with your GIF when ready.

<p align="center">
  <img alt="Demo walkthrough" src="https://github.com/user-attachments/assets/placeholder-demo-gif" width="820" />
</p>

---

## Overview

PlantGuard helps you: (1) quickly scan a plant leaf for disease, (2) learn what the disease means, and (3) take action with prevention steps and suggested supplements. It’s optimized for local, private use by agronomists, farmers, researchers, and hobbyists.

## Tech Stack

- **Backend**: `Flask`
- **DL Framework**: `PyTorch`, `torchvision`
- **Image**: `Pillow`
- **Data**: `pandas`, CSV metadata for descriptions & steps
- **Frontend**: `Bootstrap 5`, custom CSS/JS

---

## Quick Start

> Recommended: Python 3.10

1) Clone the repo

```bash
git clone https://github.com/Mayankdaya/PlantGuard.git
cd "PlantGuard/Flask Deployed App"
```

2) Create and activate a virtual environment (Windows PowerShell)

```powershell
py -3.10 -m venv .venv
.\.venv\Scripts\Activate.ps1
```

3) Install dependencies

```bash
pip install -r requirements.txt
```

4) Download model weights

- Download `plant_disease_model_1.pt` and place it in the folder:
  
  `Flask Deployed App/`

5) Run the app

```bash
python app.py
```

6) Open in browser

- Home: `http://127.0.0.1:5000/`
- AI Engine: `http://127.0.0.1:5000/index`

---

## Architecture

```
Browser (Upload/Capture)
        |
        v  POST /submit
Flask app (app.py)
        |
        v
Preprocess image (Pillow, torchvision.transforms)
        |
        v
CNN model (PyTorch, defined in CNN.py)
        |
        v
Prediction index (0..38)
        |
        v
Lookup details (disease_info.csv, supplement_info.csv)
        |
        v
Render results (submit_pg.html)
```

- UI pages: `home_pg.html`, `index_pg.html`, `submit_pg.html`
- Model: `CNN.py` (224×224 RGB input, 39 classes)
- Metadata: advice and supplement tables via CSV

---

## Dataset

- Source: PlantVillage dataset (39 classes)
- Input format: 224×224 RGB images
- Note: Inference uses a trained `.pt` file: `plant_disease_model_1.pt`

If you wish to retrain or fine‑tune, start from the notebook in `Model/` and export a new state_dict.

## Project Structure

```
PlantGuard/
├─ Flask Deployed App/
│  ├─ app.py                 # Flask server
│  ├─ CNN.py                 # CNN architecture
│  ├─ requirements.txt       # Python dependencies
│  ├─ disease_info.csv       # Descriptions & prevention
│  ├─ supplement_info.csv    # Supplement metadata
│  ├─ templates/
│  │  ├─ home_pg.html        # Premium home
│  │  ├─ index_pg.html       # Premium AI Engine (upload/camera)
│  │  └─ submit_pg.html      # Premium results page
│  └─ static/
│     └─ uploads/            # Uploaded images (gitkept)
├─ Model/                    # Notebooks, docs, assets
├─ demo_images/              # UI screenshots
└─ test_images/              # Sample test images
```

---

## Configuration

- `Flask Deployed App/app.py` expects the model file name:
  
  ```python
  model.load_state_dict(torch.load("plant_disease_model_1.pt"))
  ```

- Uploads are stored under `Flask Deployed App/static/uploads/`.

---

## UI Tour

- **Homepage (`/`)**: Premium landing with navigation to the AI engine.
- **AI Engine (`/index`)**: Drag‑and‑drop upload, camera capture, file validation (type & size), and helpful guidance.
- **Results (`/submit`)**: Prediction title, disease description or healthy tips, prevention steps, and supplement card (if applicable).

The UI uses glassmorphism, subtle animations, and strong accessibility defaults (ARIA live regions, keyboard support).

---

## Command Cheatsheet

```bash
# Create and activate venv (Windows PowerShell)
py -3.10 -m venv .venv
.\.venv\Scripts\Activate.ps1

# Install deps
pip install -r "Flask Deployed App/requirements.txt"

# Run the server
cd "Flask Deployed App"
python app.py

# Optional: change port
# app.run(debug=True, port=5050)
```

## Using Test Images

If you don’t have your own leaf photos, try the samples in `test_images/`. Many are labeled so you can validate predictions.

---

<details>
<summary><b>Troubleshooting</b></summary>

### Common issues

- **Model file not found**
  - Ensure `plant_disease_model_1.pt` is placed in `Flask Deployed App/`.

- **Port already in use**
  - Edit the bottom of `app.py` to change the port:
  
    ```python
    if __name__ == '__main__':
        app.run(debug=True, port=5050)
    ```

- **Image errors**
  - Use clear, well‑lit images; avoid glare/shadows.
  - Ensure RGB images (JPEG/PNG).

- **Dependency issues**
  - Use Python 3.10 and install via `pip install -r requirements.txt`.

</details>

---

## Model Notes

- Architecture: Custom CNN defined in `Flask Deployed App/CNN.py`.
- Input size: 224 × 224 RGB.
- Output: 39 classes, softmax argmax used for predicted index.

---

<details>
<summary><b>FAQ</b></summary>

- **Where do I put the model file?**
  - Place `plant_disease_model_1.pt` in `Flask Deployed App/` next to `app.py`.

- **Can I change the port?**
  - Yes, edit `app.py` bottom: `app.run(debug=True, port=5050)`.

- **How do I use the camera upload?**
  - Open `http://127.0.0.1:5000/index`, click “Open Camera”, then “Capture”, and submit.

- **How can I add confidence score?**
  - Expose softmax probabilities from the model and pass to the template. A progress bar can visualize the top‑1 score.

- **Can I deploy this?**
  - Yes. Add a production WSGI server (e.g., gunicorn/uvicorn) and host on Render/Railway/VM. For Docker, create a simple Dockerfile.

</details>

---

## Roadmap / Ideas

- Confidence score display and progress bar on results
- Unified `base_pg.html` layout for premium pages
- Dockerfile and one‑click deploy (Render/Railway)
- Optional GPU build (CUDA) for faster inference

---

## Highlights

<div class="row">
  <div class="column">
    <h3>Key Features</h3>
    <ul>
      <li>Drag-and-drop upload and camera capture</li>
      <li>File validation (type and size)</li>
      <li>Prediction title, disease description, and prevention steps</li>
    </ul>
  </div>
  <div class="column">
    <h3>Technical Details</h3>
    <ul>
      <li>Custom CNN architecture defined in CNN.py</li>
      <li>Input size: 224 × 224 RGB</li>
      <li>Output: 39 classes, softmax argmax used for predicted index</li>
    </ul>
  </div>
</div>

---

## Releases

- Model weights: `plant_disease_model_1.pt`
  - Location: `Flask Deployed App/`
  - SHA256: `1a60ecd77e31d64dc726e1cca0ea43d0cbec0cf2088bb403f44f0e2720c23bb1`

---

<details>
<summary><b>Deployment</b></summary>

Render (Docker)

```bash
# From repo root
docker build -t plantguard:latest .
docker run -p 5000:5000 plantguard:latest
# App on http://localhost:5000
```

Railway (Docker)

- Create a new project from repo.
- Use the Dockerfile; set port 5000.

Manual (VM)

```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .\.venv\Scripts\Activate.ps1
pip install -r "Flask Deployed App/requirements.txt"
cd "Flask Deployed App"
gunicorn -w 2 -b 0.0.0.0:5000 app:app
```

</details>

---

## Contributing

Issues and PRs are welcome. Please open an issue to discuss significant changes.

---

## License

This project is licensed under the **MIT License** — see the [`LICENSE`](./LICENSE) file for details.
Copyright (c) 2025 **Mayank Daya**

---

## Changelog

- 1.0.0
  - Premium UI for Home, AI Engine, Results (`home_pg.html`, `index_pg.html`, `submit_pg.html`)
  - README overhaul: overview, architecture, dataset, UI tour, FAQ
  - Dockerfile added for containerized deploy
  - Deployment guide (Render/Railway/Manual)
  - Releases section with model checksum
  - MIT License added

## Acknowledgements

- PlantVillage dataset creators and community
- Open‑source frameworks: Flask, PyTorch, torchvision

---

## Links

- Repo: https://github.com/Mayankdaya/PlantGuard
- Issues: https://github.com/Mayankdaya/PlantGuard/issues

Enjoy using PlantGuard! 🌱

---

## API Endpoints

- `GET /` → Serve premium homepage (`home_pg.html`).
- `GET /index` → Serve AI Engine page (`index_pg.html`).
- `POST /submit` → Accepts multipart form `image`.
  - Returns a rendered results page (`submit_pg.html`) with:
    - `title` (predicted class)
    - `desc` (disease description or healthy tips)
    - `prevent` (prevention steps or benefits)
    - `image_url` (reference image from CSV)
    - `sname`, `simage`, `buy_link` (supplement info if applicable)

---

## Security & Privacy

- Images are processed locally on your machine; no third‑party services.
- Uploaded files are saved to `Flask Deployed App/static/uploads/` for the current session.
- To avoid persisting uploads, you can modify `app.py` to not save the original file (process in memory, then delete).
- Keep your model weights private unless you intend to share them.

---

<details>
<summary><b>Class Labels (39)</b></summary>

```text
0: Apple___Apple_scab
1: Apple___Black_rot
2: Apple___Cedar_apple_rust
3: Apple___healthy
4: Background_without_leaves
5: Blueberry___healthy
6: Cherry___Powdery_mildew
7: Cherry___healthy
8: Corn___Cercospora_leaf_spot Gray_leaf_spot
9: Corn___Common_rust
10: Corn___Northern_Leaf_Blight
11: Corn___healthy
12: Grape___Black_rot
13: Grape___Esca_(Black_Measles)
14: Grape___Leaf_blight_(Isariopsis_Leaf_Spot)
15: Grape___healthy
16: Orange___Haunglongbing_(Citrus_greening)
17: Peach___Bacterial_spot
18: Peach___healthy
19: Pepper,_bell___Bacterial_spot
20: Pepper,_bell___healthy
21: Potato___Early_blight
22: Potato___Late_blight
23: Potato___healthy
24: Raspberry___healthy
25: Soybean___healthy
26: Squash___Powdery_mildew
27: Strawberry___Leaf_scorch
28: Strawberry___healthy
29: Tomato___Bacterial_spot
30: Tomato___Early_blight
31: Tomato___Late_blight
32: Tomato___Leaf_Mold
33: Tomato___Septoria_leaf_spot
34: Tomato___Spider_mites Two-spotted_spider_mite
35: Tomato___Target_Spot
36: Tomato___Tomato_Yellow_Leaf_Curl_Virus
37: Tomato___Tomato_mosaic_virus
38: Tomato___healthy
```

</details>

---

## Training & Fine‑Tuning (High Level)

1) Prepare dataset
- Organize images by class into train/val/test directories.
- Apply augmentations (flip, rotate, color jitter) to improve robustness.

2) Define/Reuse model
- Start from `CNN.py` or use a pretrained backbone (e.g., ResNet18) for transfer learning.

3) Train
- Use cross‑entropy loss; Adam or SGD optimizer.
- Track accuracy and loss on a validation split; early stop to prevent overfit.

4) Export
- Save state_dict: `torch.save(model.state_dict(), 'plant_disease_model_1.pt')`.
- Drop the file in `Flask Deployed App/` and verify with a few test images.

---

## Local Development Guide

- Environment
  - Python 3.10 recommended
  - Virtual env: `py -3.10 -m venv .venv && .\.venv\Scripts\Activate.ps1`

- Code style
  - Keep routes in `app.py`; UI in `templates/` and light JS in the page itself.
  - Use `static/uploads/` for temporary outputs.

- Testing ideas
  - Add a simple script to batch‑test images in `test_images/` and log predictions.
  - Consider adding a “confidence score” to the results page (softmax max value).

---

## Performance Notes

- CPU‑only PyTorch is used for broad compatibility; for speed, consider GPU builds if you have CUDA.
- Resize to 224×224 and normalize images consistently.
- Avoid very large uploads (>10 MB) for faster inference and better UX.

---

## Support / Contact

- Open an issue: `Issues` tab on GitHub
- For general queries: create a discussion or email listed on your profile
