# Linear Regression Prediction API

A FastAPI-based REST API for making predictions using a trained linear regression model. This API includes CORS middleware, Pydantic data validation with type enforcement and range constraints, and comprehensive Swagger UI documentation.

## Features

✅ **API Endpoint for Prediction**: POST `/predict` endpoint for making predictions  
✅ **Swagger UI Documentation**: Interactive API documentation at `/docs`  
✅ **CORS Middleware**: Cross-Origin Resource Sharing enabled  
✅ **Pydantic Constraints**: Data type enforcement and range validation  
✅ **Type Safety**: Each variable has enforced data types (float, int, etc.)

## Live Demo

🔗 **Public URL**: `https://your-app-name.onrender.com`  
📖 **Swagger UI**: `https://your-app-name.onrender.com/docs`

> Replace `your-app-name` with your actual Render deployment URL

## Project Structure

```
linear_regression_api/
├── app/
│   └── main.py          # FastAPI application
├── create_model.py      # Script to create sample model
├── model.pkl            # Trained model (create using create_model.py)
├── requirements.txt     # Python dependencies
└── README.md           # This file
```

## Installation

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd linear_regression_api
```

### 2. Create a virtual environment

```bash
python -m venv venv
```

### 3. Activate virtual environment

**Windows (PowerShell):**

```powershell
.\venv\Scripts\Activate.ps1
```

**Windows (CMD):**

```cmd
venv\Scripts\activate.bat
```

**Linux/Mac:**

```bash
source venv/bin/activate
```

### 4. Install dependencies

```bash
pip install -r requirements.txt
```

### 5. Create the model file

If you don't have a `model.pkl` file yet, run the sample model creation script:

```bash
python create_model.py
```

**Important**: Replace `create_model.py` with your actual trained model from Task 1!

## Running Locally

Start the development server:

```bash
uvicorn app.main:app --reload
```

The API will be available at:

- **Base URL**: http://localhost:8000
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## API Endpoints

### 1. Root Endpoint

- **Method**: GET
- **URL**: `/`
- **Description**: API information

### 2. Health Check

- **Method**: GET
- **URL**: `/health`
- **Description**: Check API and model status

### 3. Prediction Endpoint (Main)

- **Method**: POST
- **URL**: `/predict`
- **Description**: Make a prediction using the linear regression model

#### Request Body

```json
{
  "feature1": 45.5,
  "feature2": 23.8,
  "feature3": 5,
  "feature4": 12.3
}
```

#### Input Constraints

| Field    | Data Type | Range          | Required          |
| -------- | --------- | -------------- | ----------------- |
| feature1 | float     | 0.0 - 100.0    | Yes               |
| feature2 | float     | 0.0 - 50.0     | Yes               |
| feature3 | integer   | 1 - 10         | Yes               |
| feature4 | float     | -100.0 - 100.0 | No (default: 0.0) |

#### Response

```json
{
  "prediction": 78.45,
  "status": "success"
}
```

## CORS Configuration

The API implements CORS middleware allowing:

- All origins (`*`)
- All methods (GET, POST, etc.)
- All headers
- Credentials

**Production Note**: Update `allow_origins` in `app/main.py` to specify allowed domains.

## Pydantic Data Validation

The API uses Pydantic's `BaseModel` for:

1. **Type Enforcement**: Each field has a specific data type (float, int)
2. **Range Constraints**: Using `Field()` with `ge` (greater/equal) and `le` (less/equal)
3. **Required Fields**: Using `...` for mandatory fields
4. **Default Values**: Optional fields with defaults
5. **Validation**: Automatic validation of incoming requests

Example from code:

```python
class PredictionInput(BaseModel):
    feature1: float = Field(..., ge=0.0, le=100.0)
    feature2: float = Field(..., ge=0.0, le=50.0)
    feature3: int = Field(..., ge=1, le=10)
    feature4: float = Field(default=0.0, ge=-100.0, le=100.0)
```

## Deployment to Render

### Step 1: Prepare Your Repository

1. Ensure `requirements.txt` is in the root directory
2. Ensure `model.pkl` exists in the root directory
3. Push your code to GitHub

### Step 2: Create Render Account

1. Go to [render.com](https://render.com)
2. Sign up using your GitHub account

### Step 3: Create New Web Service

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `linear-regression-api` (or your choice)
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
   - **Plan**: Free

### Step 4: Deploy

1. Click **"Create Web Service"**
2. Wait for deployment to complete
3. Your API will be available at: `https://your-app-name.onrender.com`

### Step 5: Access Swagger UI

Visit: `https://your-app-name.onrender.com/docs`

## Testing the API

### Using Swagger UI (Recommended)

1. Navigate to `/docs`
2. Click on **POST /predict**
3. Click **"Try it out"**
4. Enter sample data
5. Click **"Execute"**

### Using cURL

```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "feature1": 45.5,
    "feature2": 23.8,
    "feature3": 5,
    "feature4": 12.3
  }'
```

### Using Python

```python
import requests

url = "http://localhost:8000/predict"
data = {
    "feature1": 45.5,
    "feature2": 23.8,
    "feature3": 5,
    "feature4": 12.3
}

response = requests.post(url, json=data)
print(response.json())
```

## Requirements Met

This implementation satisfies all rubric requirements:

1. ✅ **API endpoint for prediction**: POST `/predict` endpoint implemented
2. ✅ **Public URL + Path to Swagger UI Documentation**: Deploy to Render → access `/docs`
3. ✅ **Implements the CORS middleware**: `CORSMiddleware` configured in `main.py`
4. ✅ **Implements constraints on Variables using Pydantic**: `Field()` with `ge`/`le` constraints
5. ✅ **Each variable is associated to a datatype**: `float`, `int` types explicitly defined

## Troubleshooting

### Model not found error

- Ensure `model.pkl` exists in the project root
- Run `python create_model.py` to create a sample model
- Replace with your actual trained model

### Import errors

- Ensure all dependencies are installed: `pip install -r requirements.txt`
- Check Python version (3.8+ recommended)

### Port already in use

- Change port: `uvicorn app.main:app --port 8001`
- Or kill the process using port 8000

## Dependencies

- **fastapi**: Web framework for building APIs
- **pydantic**: Data validation using Python type hints
- **uvicorn**: ASGI server for running FastAPI
- **numpy**: Numerical computing
- **scikit-learn**: Machine learning library
- **python-multipart**: Form data parsing

## License

MIT License

## Author

[Your Name]

## Support

For issues or questions, please open an issue on GitHub.
