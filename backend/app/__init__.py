from flask import Flask, Blueprint
from flask_sqlalchemy import SQLAlchemy

# Initialize extensions outside app context
db = SQLAlchemy()
cycle_bp = Blueprint('cycle', __name__)

def create_app():
    app = Flask(__name__)
    app.config.from_object('backend.config.Config')
    
    # Initialize extensions with app
    db.init_app(app)
    
    with app.app_context():
        from . import routes
        db.create_all()
    
    app.register_blueprint(cycle_bp, url_prefix='/api')
    return app