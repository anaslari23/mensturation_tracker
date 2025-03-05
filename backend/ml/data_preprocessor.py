import numpy as np
from sklearn.preprocessing import MinMaxScaler

def create_sequences(data, n_steps=3):
    X, y = [], []
    for i in range(len(data)-n_steps):
        X.append(data[i:i+n_steps])
        y.append(data[i+n_steps])
    return np.array(X), np.array(y)

def preprocess_data(cycle_lengths):
    scaler = MinMaxScaler(feature_range=(0, 1))
    scaled_data = scaler.fit_transform(np.array(cycle_lengths).reshape(-1, 1))
    X, y = create_sequences(scaled_data)
    X = X.reshape((X.shape[0], X.shape[1], 1))
    return X, y, scaler