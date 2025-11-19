# inspect_model.py
"""
This script will inspect your model.pkl file and show you:
1. The feature column names
2. The number of features
3. The model type
4. Sample data ranges (if available)
"""

import pickle
import numpy as np

# Load the model
with open('model.pkl', 'rb') as file:
    pipeline = pickle.load(file)

print("=" * 60)
print("MODEL INSPECTION REPORT")
print("=" * 60)

# Get the components
model = pipeline['model']
scaler = pipeline['scaler']
feature_columns = pipeline['feature_columns']

print(f"\n📊 Number of features: {len(feature_columns)}")
print(f"\n📝 Feature column names:")
for i, col in enumerate(feature_columns, 1):
    print(f"   {i}. {col}")

print(f"\n🤖 Model type: {type(model).__name__}")

print(f"\n📏 Scaler information:")
print(f"   Type: {type(scaler).__name__}")

if hasattr(scaler, 'mean_'):
    print(f"\n📈 Feature statistics from training data:")
    print(f"\n   {'Feature':<20} {'Mean':<15} {'Std Dev':<15}")
    print(f"   {'-'*20} {'-'*15} {'-'*15}")
    for i, col in enumerate(feature_columns):
        mean = scaler.mean_[i] if hasattr(scaler, 'mean_') else 'N/A'
        std = scaler.scale_[i] if hasattr(scaler, 'scale_') else 'N/A'
        print(f"   {col:<20} {mean:<15.2f} {std:<15.2f}")

print("\n" + "=" * 60)
print("COPY THESE FEATURE NAMES TO UPDATE main.py")
print("=" * 60)
print("\nFeature columns list:")
print(feature_columns)
print("\n")
