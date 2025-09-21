# Plant Disease Detection

A deep learning-based web application for detecting plant diseases from leaf images. This application uses a custom CNN model trained to identify 38 different plant diseases.

## Features
- Upload an image of a plant leaf
- Get instant disease prediction
- View detailed information about the detected disease
- Get treatment recommendations

## How to Use
1. Click on the "Upload" button to select an image of a plant leaf
2. The app will process the image and predict the disease
3. View the results including disease name, description, and treatment options

## Model Details
- **Model Architecture**: Custom CNN
- **Number of Classes**: 38 different plant diseases
- **Input Size**: 224x224 pixels
- **Framework**: PyTorch

## Local Setup
1. Clone the repository:
```bash
git clone https://huggingface.co/spaces/Mayankdl233/plantguard
cd plantguard
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
uvicorn app:app --reload
```

4. Open your browser and go to `http://localhost:7860`

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- Dataset: [PlantVillage Dataset](https://plantvillage.psu.edu/)
- Framework: PyTorch, FastAPI
