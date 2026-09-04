from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from .database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(String, primary_key=True, index=True)
    name = Column(String)
    age = Column(Integer)
    results = relationship("GameResult", back_populates="user")
    reminders = relationship("Reminder", back_populates="user")
    cognitive_score = relationship("CognitiveScore", back_populates="user", uselist=False)

class GameResult(Base):
    __tablename__ = "game_results"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String, ForeignKey("users.id"))
    game_type = Column(String)
    score = Column(Integer)
    accuracy = Column(Float)
    response_time = Column(Float)
    difficulty = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    user = relationship("User", back_populates="results")

class CognitiveScore(Base):
    __tablename__ = "cognitive_scores"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String, ForeignKey("users.id"), unique=True)
    memory = Column(Integer, default=0)
    attention = Column(Integer, default=0)
    language = Column(Integer, default=0)
    math = Column(Integer, default=0)
    reaction = Column(Integer, default=0)
    problem_solving = Column(Integer, default=0)
    user = relationship("User", back_populates="cognitive_score")

class Reminder(Base):
    __tablename__ = "reminders"
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    title = Column(String)
    time = Column(DateTime)
    category = Column(String)
    completed = Column(Boolean, default=False)
    user = relationship("User", back_populates="reminders")
