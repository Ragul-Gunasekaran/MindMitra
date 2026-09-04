from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, ForeignKey, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(String, primary_key=True, index=True)
    name = Column(String)
    age = Column(Integer)
    role = Column(String, default="ELDERLY")  # ELDERLY, CAREGIVER, ADMIN

class CaregiverConnection(Base):
    __tablename__ = "caregiver_connections"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    elderly_id = Column(String, ForeignKey("users.id"))
    caregiver_id = Column(String, ForeignKey("users.id"))
    relationship = Column(String)
    status = Column(String, default="PENDING") # PENDING, ACTIVE, REJECTED
    permissions = Column(String, default="ALL")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class CaregiverNote(Base):
    __tablename__ = "caregiver_notes"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    caregiver_id = Column(String, ForeignKey("users.id"))
    elderly_id = Column(String, ForeignKey("users.id"))
    content = Column(Text)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class GameResult(Base):
    __tablename__ = "game_results"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String, ForeignKey("users.id"))
    game_type = Column(String)
    score = Column(Integer)
    accuracy = Column(Float)
    response_time = Column(Float)
    difficulty = Column(String, default="Medium")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class CognitiveScore(Base):
    __tablename__ = "cognitive_scores"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String, ForeignKey("users.id"), unique=True)
    memory = Column(Integer, default=50)
    attention = Column(Integer, default=50)
    language = Column(Integer, default=50)
    math = Column(Integer, default=50)
    reaction = Column(Integer, default=50)
    problem_solving = Column(Integer, default=50)

class Reminder(Base):
    __tablename__ = "reminders"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    title = Column(String)
    time = Column(DateTime)
    category = Column(String)
    completed = Column(Boolean, default=False)

