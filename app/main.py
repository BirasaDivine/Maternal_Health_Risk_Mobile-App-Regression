# app/main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
from typing import Optional
import pickle
import numpy as np
import os

# Initialize FastAPI with metadata
app = FastAPI(
    title="Regression Model Prediction API",
    description="API for making predictions using a trained regression model (Decision Tree/Linear Regression)",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Enable CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify allowed origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the saved model pipeline
model = None
scaler = None
feature_columns = None

try:
    model_path = os.path.join(os.path.dirname(__file__), '..', 'model.pkl')
    if os.path.exists(model_path):
        with open(model_path, 'rb') as file:
            pipeline = pickle.load(file)
        model = pipeline['model']
        scaler = pipeline['scaler']
        feature_columns = pipeline['feature_columns']
    else:
        print(f"Warning: Model file not found at {model_path}")
except Exception as e:
    print(f"Error loading model: {e}")


# Define input schema with data types and range constraints
class PredictionInput(BaseModel):
    """
    Input schema for prediction requests.
    All fields have enforced data types and realistic range constraints based on medical data.
    """
    Age: float = Field(
        ..., 
        ge=0.0, 
        le=120.0,
        description="Patient age in years (float between 0 and 120)"
    )
    DiastolicBP: float = Field(
        ..., 
        ge=40.0, 
        le=150.0,
        description="Diastolic blood pressure in mmHg (float between 40 and 150)"
    )
    BS: float = Field(
        ..., 
        ge=0.0, 
        le=30.0,
        description="Blood sugar level (float between 0 and 30)"
    )
    BodyTemp: float = Field(
        ...,
        ge=95.0,
        le=106.0,
        description="Body temperature in Fahrenheit (float between 95 and 106)"
    )
    HeartRate: float = Field(
        ...,
        ge=30.0,
        le=200.0,
        description="Heart rate in beats per minute (float between 30 and 200)"
    )
    
    class Config:
        schema_extra = {
            "example": {
                "Age": 29.5,
                "DiastolicBP": 76.0,
                "BS": 8.5,
                "BodyTemp": 98.6,
                "HeartRate": 74.0
            }
        }


# Define output schema
class PredictionOutput(BaseModel):
    """
    Output schema for prediction responses.
    """
    prediction: float = Field(..., description="The predicted value from the regression model")
    status: str = Field(default="success", description="Status of the prediction")
    
    class Config:
        schema_extra = {
            "example": {
                "prediction": 78.45,
                "status": "success"
            }
        }


# Root endpoint
@app.get("/", tags=["Root"])
def read_root():
    """
    Root endpoint providing API information.
    """
    return {
        "message": "Welcome to the Regression Model Prediction API",
        "docs": "/docs",
        "redoc": "/redoc",
        "version": "1.0.0"
    }


# Health check endpoint
@app.get("/health", tags=["Health"])
def health_check():
    """
    Health check endpoint to verify API status.
    """
    model_loaded = model is not None
    return {
        "status": "healthy" if model_loaded else "degraded",
        "model_loaded": model_loaded
    }


# Prediction function
def predict(features_dict):
    """
    Make prediction using the loaded regression model.
    
    Args:
        features_dict: Dictionary containing feature values
        
    Returns:
        Predicted value as float
    """
    if model is None or scaler is None or feature_columns is None:
        raise HTTPException(
            status_code=503, 
            detail="Model not loaded. Please ensure model.pkl exists in the project root."
        )
    
    # Extract features in the correct order
    features = np.array([[features_dict.get(col, 0.0) for col in feature_columns]])
    
    # Scale features
    features_scaled = scaler.transform(features)
    
    # Make prediction
    prediction = model.predict(features_scaled)[0]
    
    return float(prediction)


# API endpoint for predictions (POST request)
@app.post("/predict", response_model=PredictionOutput, tags=["Prediction"])
def predict_endpoint(input_data: PredictionInput):
    """
    Make a prediction using the trained regression model.
    
    Parameters:
    - **Age**: Patient age in years (0-120)
    - **DiastolicBP**: Diastolic blood pressure in mmHg (40-150)
    - **BS**: Blood sugar level (0-30)
    - **BodyTemp**: Body temperature in Fahrenheit (95-106)
    - **HeartRate**: Heart rate in beats per minute (30-200)
    
    Returns:
    - **prediction**: The predicted value
    - **status**: Status of the prediction
    """
    try:
        # Convert input to dictionary
        input_dict = input_data.dict()
        
        # Make prediction
        prediction_value = predict(input_dict)
        
        return PredictionOutput(
            prediction=prediction_value,
            status="success"
        )
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")


# Run the application (for local development)
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
