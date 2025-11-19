# example_create_model.py
"""
EXAMPLE: Create a sample model for testing the API
This shows you the exact structure your Task 1 model should have.

REPLACE THIS with your actual Task 1 code that creates your trained model!
"""

import pickle
import numpy as np
import pandas as pd
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# ============================================
# EXAMPLE DATA - REPLACE WITH YOUR TASK 1 DATA
# ============================================

# Create sample dataset (replace with your actual data)
np.random.seed(42)
n_samples = 200

# Example: Predicting house prices based on features
data = {
    'square_footage': np.random.randint(500, 3000, n_samples),
    'num_bedrooms': np.random.randint(1, 6, n_samples),
    'num_bathrooms': np.random.randint(1, 4, n_samples),
    'age_years': np.random.randint(0, 50, n_samples),
}

# Create target variable (price)
df = pd.DataFrame(data)
df['price'] = (
    df['square_footage'] * 100 + 
    df['num_bedrooms'] * 10000 + 
    df['num_bathrooms'] * 15000 - 
    df['age_years'] * 500 + 
    np.random.randn(n_samples) * 10000
)

# Separate features and target
X = df.drop('price', axis=1)
y = df['price']

print("Dataset Info:")
print(f"Number of samples: {len(X)}")
print(f"Features: {X.columns.tolist()}")
print(f"\nFeature ranges:")
print(X.describe())

# ============================================
# TRAIN THE MODEL (YOUR TASK 1 CODE SHOULD BE HERE)
# ============================================

# Split the data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Create and fit the scaler
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train the model (you might use a different model type)
decision_tree = DecisionTreeRegressor(
    max_depth=10,
    min_samples_split=5,
    random_state=42
)
decision_tree.fit(X_train_scaled, y_train)

# Evaluate
train_score = decision_tree.score(X_train_scaled, y_train)
test_score = decision_tree.score(X_test_scaled, y_test)

print(f"\n✅ Model trained successfully!")
print(f"Training R² score: {train_score:.4f}")
print(f"Testing R² score: {test_score:.4f}")

# ============================================
# SAVE THE MODEL (THIS STRUCTURE IS REQUIRED)
# ============================================

# This is the EXACT structure your Task 1 should use
pipeline = {
    'model': decision_tree,
    'scaler': scaler,
    'feature_columns': X.columns.tolist()
}

# Save to file
with open('model.pkl', 'wb') as file:
    pickle.dump(pipeline, file)

print(f"\n💾 Model saved to model.pkl")
print(f"\n📋 Feature columns in your model:")
for i, col in enumerate(X.columns.tolist(), 1):
    print(f"   {i}. {col}")

print("\n" + "="*60)
print("NEXT STEPS:")
print("="*60)
print("1. Run: python inspect_model.py")
print("2. Copy the feature names shown")
print("3. Update app/main.py with those feature names")
print("="*60)
