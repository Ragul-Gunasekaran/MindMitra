from pydantic import BaseModel
from typing import List, Optional, Dict
from datetime import datetime

class UserBase(BaseModel):
    name: str
    age: int
    role: str = 'ELDERLY'

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

class CaregiverConnectionCreate(BaseModel):
    elderly_id: str
    caregiver_id: str
    relationship: str
    
class CaregiverConnectionResponse(CaregiverConnectionCreate):
    id: int
    status: str
    permissions: str
    created_at: datetime
    class Config:
        from_attributes = True

class CaregiverNoteCreate(BaseModel):
    caregiver_id: str
    elderly_id: str
    content: str
    
class CaregiverNoteResponse(CaregiverNoteCreate):
    id: int
    created_at: datetime
    class Config:
        from_attributes = True

class AnalyticsSummary(BaseModel):
    period: str
    activity_count: int
    average_accuracy: float
    routine_completion: float
    active_days: int
    domains: Dict[str, float]
    mood_trend: str

