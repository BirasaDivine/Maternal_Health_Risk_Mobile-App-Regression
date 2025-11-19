# create_model.py
"""
Sample script to create a regression model for the API.
Replace this with your actual trained model from Task 1.

Your Task 1 model should be saved like this:

pipeline = {
    'model': decision_tree,  # or any trained model
    'scaler': scaler,
    'feature_columns': X.columns.tolist()
}

with open('model.pkl', 'wb') as file:
    pickle.dump(pipeline, file)
"""

import pickle
import numpy as np
import pandas as pd
from sklearn.tree import DecisionTreeRegressor
from sklearn.preprocessing import StandardScaler

# Sample data (replace with your actual training data from Task 1)
# This is just for demonstration purposes
np.random.seed(42)
X_train = np.random.rand(100, 4) * 50  # 100 samples, 4 features
y_train = 2 * X_train[:, 0] + 3 * X_train[:, 1] - 1.5 * X_train[:, 2] + 0.5 * X_train[:, 3] + np.random.randn(100) * 5

# Convert to DataFrame (similar to your Task 1 data)
X = pd.DataFrame(X_train, columns=['feature1', 'feature2', 'feature3', 'feature4'])

# Create and train the scaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Create and train the model (using DecisionTree as example)
decision_tree = DecisionTreeRegressor(random_state=42, max_depth=5)
decision_tree.fit(X_scaled, y_train)

# Create pipeline dictionary (matching your Task 1 structure)
pipeline = {
    'model': decision_tree,
    'scaler': scaler,
    'feature_columns': X.columns.tolist()
}

# Save the pipeline
with open('model.pkl', 'wb') as file:
    pickle.dump(pipeline, file)

print("Model created and saved successfully!")
print(f"Model type: {type(decision_tree).__name__}")
print(f"Feature columns: {pipeline['feature_columns']}")
print("\n*** IMPORTANT: Replace this with your actual trained model from Task 1! ***")
