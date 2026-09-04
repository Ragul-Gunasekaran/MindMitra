from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class UserBase(BaseModel):
    name: str
    age: int

class UserCreate(UserBase):
    id: str

class UserResponse(UserBase):
    id: str
    class Config:
        from_attributes = True

class GameResultCreate(BaseModel):
    user_id: str
    game_type: str
    score: int
    accuracy: float
    response_time: float
    difficulty: str

class GameResultResponse(GameResultCreate):
    id: int
    created_at: datetime
    class Config:
        from_attributes = True

class CognitiveScoreBase(BaseModel):
    memory: int
    attention: int
    language: int
    math: int
    reaction: int
    problem_solving: int

class CognitiveScoreCreate(CognitiveScoreBase):
    user_id: str

class CognitiveScoreResponse(CognitiveScoreBase):
    id: int
    user_id: str
    class Config:
        from_attributes = True

class ReminderBase(BaseModel):
    title: str
    time: datetime
    category: str
    completed: bool = False

class ReminderCreate(ReminderBase):
    id: str
    user_id: str

class ReminderResponse(ReminderCreate):
    class Config:
        from_attributes = True
