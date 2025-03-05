from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object('backend.config.Config')
    
    db.init_app(app)
    
    with app.app_context():
        from .routes import cycle_bp
        app.register_blueprint(cycle_bp, url_prefix='/api')
        db.create_all()
    
    return app