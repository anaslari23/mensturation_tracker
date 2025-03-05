from datetime import datetime
from backend import db  # Update this import

class Cycle(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(50), nullable=False, default='user1')
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    symptoms = db.Column(db.String(200))

    def to_dict(self):
        return {
            'id': self.id,
            'start_date': self.start_date.isoformat(),
            'end_date': self.end_date.isoformat(),
            'symptoms': self.symptoms
        }