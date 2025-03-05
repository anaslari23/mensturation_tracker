import joblib
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from .data_preprocessor import preprocess_data  # Relative import

def build_lstm_model(n_steps=3, n_features=1):
    """Build LSTM model architecture"""
    model = Sequential()
    model.add(LSTM(50, activation='relu', input_shape=(n_steps, n_features)))
    model.add(Dense(1))
    model.compile(optimizer='adam', loss='mse')
    return model

def train_lstm(user_id, cycle_lengths):
    """Train and save LSTM model"""
    if len(cycle_lengths) < 4:
        raise ValueError("Need at least 4 cycles for training")
    
    # Preprocess data
    X, y, scaler = preprocess_data(cycle_lengths)
    
    # Build model
    model = build_lstm_model()
    
    # Train model
    model.fit(X, y, epochs=200, verbose=0)
    
    # Save artifacts
    model.save(f'ml/models/lstm_{user_id}.h5')
    joblib.dump(scaler, f'ml/scalers/scaler_{user_id}.pkl')