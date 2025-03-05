from prophet import Prophet
from joblib import load
from datetime import datetime, timedelta

def predict_next_cycle(user_id):
    # Load user-specific model
    model = load(f'ml/model_{user_id}.joblib')
    
    # Generate future dates
    future = model.make_future_dataframe(periods=1, freq='D')
    
    # Predict
    forecast = model.predict(future)
    last_prediction = forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].iloc[-1]
    
    return {
        'date': last_prediction['ds'].strftime('%Y-%m-%d'),
        'cycle_length': round(last_prediction['yhat']),
        'confidence_interval': [
            last_prediction['yhat_lower'],
            last_prediction['yhat_upper']
        ]
    }