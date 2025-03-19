# backend/app.py
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import joblib
import numpy as np
from datetime import datetime, timedelta

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS

# Configure Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://period_user:strongpassword@localhost/period_tracker'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Load ML model
model = joblib.load('cycle_predictor.joblib')

# Database Models
class Cycle(db.Model):
    __tablename__ = 'cycles'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    symptoms = db.Column(db.Text)

    def __repr__(self):
        return f'<Cycle {self.id}>'

# Routes
@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json

        # Validate input
        if not data or 'last_cycle_length' not in data or 'last_end_date' not in data:
            return jsonify({'error': 'Invalid input format'}), 400
            
        last_cycle = float(data['last_cycle_length'])
        last_end_date = datetime.strptime(data['last_end_date'], '%Y-%m-%d')
        
        # Make prediction
        prediction = model.predict([[last_cycle]])[0]
        next_date = last_end_date + timedelta(days=prediction)
        
        return jsonify({
            'next_period': next_date.strftime('%Y-%m-%d'),
            'predicted_cycle_length': round(prediction, 1)
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cycles', methods=['POST'])
def create_cycle():
    try:
        data = request.json
        
        # Validate required fields
        required_fields = ['user_id', 'start_date', 'end_date']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        new_cycle = Cycle(
            user_id=data['user_id'],
            start_date=datetime.strptime(data['start_date'], '%Y-%m-%d').date(),
            end_date=datetime.strptime(data['end_date'], '%Y-%m-%d').date(),
            symptoms=data.get('symptoms', '')
        )

        db.session.add(new_cycle)
        db.session.commit()

        return jsonify({
            'id': new_cycle.id,
            'message': 'Cycle created successfully'
        }), 201

    except ValueError as e:
        return jsonify({'error': 'Invalid date format. Use YYYY-MM-DD'}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)