from . import cycle_bp, db
from backend.ml.trainer import train_lstm
from .models import Cycle
from datetime import datetime
from flask import jsonify, request
from . import cycle_bp, db
from .models import Cycle  # Relative import
from backend.ml.trainer import train_lstm
from datetime import datetime


@cycle_bp.route('/cycles', methods=['POST'])
def add_cycle():
    try:
        data = request.json
        new_cycle = Cycle(
            start_date=datetime.strptime(data['start_date'], '%Y-%m-%d').date(),
            end_date=datetime.strptime(data['end_date'], '%Y-%m-%d').date(),
            symptoms=data.get('symptoms', '')
        )
        db.session.add(new_cycle)
        db.session.commit()
        return jsonify(new_cycle.to_dict()), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@cycle_bp.route('/cycles', methods=['GET'])
def get_cycles():
    cycles = Cycle.query.order_by(Cycle.start_date).all()
    return jsonify([cycle.to_dict() for cycle in cycles])

@cycle_bp.route('/predict-next-lstm', methods=['GET'])
def predict_next_lstm():
    try:
        cycles = Cycle.query.order_by(Cycle.start_date).all()
        cycle_lengths = [(c.end_date - c.start_date).days for c in cycles]
        
        if len(cycle_lengths) < 4:
            return jsonify({'error': 'Need at least 4 cycles'}), 400
            
        train_lstm('user1', cycle_lengths)
        last_sequence = cycle_lengths[-3:]
        # Add prediction logic here
        return jsonify({'prediction': '28 days'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500