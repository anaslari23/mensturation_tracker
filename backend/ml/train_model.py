import pandas as pd
from prophet import Prophet
from joblib import dump

def train_prophet_model(user_id):
    # Fetch user's historical data (example)
    data = [
        {'ds': '2024-01-01', 'y': 28},  # ds=start_date, y=cycle_length
        {'ds': '2024-02-01', 'y': 30},
        {'ds': '2024-03-01', 'y': 29}
    ]
    df = pd.DataFrame(data)
    df['ds'] = pd.to_datetime(df['ds'])

    # Train model
    model = Prophet(interval_width=0.95)  # 95% confidence interval
    model.fit(df)
    
    # Save model
    dump(model, f'ml/model_{user_id}.joblib')

if __name__ == '__main__':
    train_prophet_model('user1')  # Replace with dynamic user ID