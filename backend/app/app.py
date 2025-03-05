from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv
from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True, port=5000)

load_dotenv()

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests for React frontend

# Configure SQLite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cycles.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Database model for cycles
class Cycle(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(50), nullable=False)  # For simplicity, hardcode to "user1"
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    symptoms = db.Column(db.String(200))

    def __repr__(self):
        return f"Cycle(start_date={self.start_date}, symptoms={self.symptoms})"

# Create database tables
with app.app_context():
    db.create_all()

# Prediction algorithm (basic average)
def predict_next_period(start_dates):
    if len(start_dates) < 2:
        return None
    cycle_lengths = [(start_dates[i] - start_dates[i-1]).days for i in range(1, len(start_dates))]
    avg_cycle = sum(cycle_lengths) / len(cycle_lengths)
    next_start = start_dates[-1] + timedelta(days=avg_cycle)
    return next_start.strftime("%Y-%m-%d")

# API Endpoints
@app.route('/api/cycles', methods=['POST'])
def add_cycle():
    data = request.json
    new_cycle = Cycle(
        user_id="user1",  # Hardcoded for simplicity
        start_date=datetime.strptime(data['start_date'], '%Y-%m-%d').date(),
        end_date=datetime.strptime(data['end_date'], '%Y-%m-%d').date(),
        symptoms=data.get('symptoms', '')
    )
    db.session.add(new_cycle)
    db.session.commit()
    return jsonify({"message": "Cycle added!"}), 201

@app.route('/api/predict-next', methods=['GET'])
def predict_next():
    cycles = Cycle.query.filter_by(user_id="user1").order_by(Cycle.start_date).all()
    start_dates = [cycle.start_date for cycle in cycles]
    if len(start_dates) < 2:
        return jsonify({"error": "Insufficient data"}), 400
    prediction = predict_next_period(start_dates)
    return jsonify({"prediction": prediction})

if __name__ == '__main__':
    app.run(debug=True, port=5000)