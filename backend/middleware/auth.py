from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from backend.models import User, db
import jwt
from datetime import datetime, timedelta

auth_bp = Blueprint('auth', __name__)
SECRET_KEY = "your-secure-key-here"

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    
    if User.query.filter_by(email=data['email']).first():
        return jsonify({'error': 'Email already exists'}), 409

    user = User(
        email=data['email'],
    )
    user.set_password(data['password'])
    
    db.session.add(user)
    db.session.commit()
    
    return jsonify({'message': 'User created successfully'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = User.query.filter_by(email=data['email']).first()

    if not user or not user.check_password(data['password']):
        return jsonify({'error': 'Invalid credentials'}), 401

    token = jwt.encode({
        'sub': user.id,
        'exp': datetime.utcnow() + timedelta(hours=24)
    }, SECRET_KEY)

    return jsonify({'token': token, 'user_id': user.id}), 200