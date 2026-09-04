import os
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from datetime import datetime, timedelta

from . import models, schemas
from .database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="MindMitra API")

cors_origins = os.getenv("CORS_ORIGINS", "http://localhost:3000,http://localhost:8000,*").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/api/users", response_model=schemas.UserResponse)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user.id).first()
    if db_user:
        return db_user
    db_user = models.User(id=user.id, name=user.name, age=user.age)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    db_score = models.CognitiveScore(user_id=user.id, memory=55, attention=82, language=70, math=65, reaction=76, problem_solving=74)
    db.add(db_score)
    db.commit()
    return db_user

@app.get("/api/users/{user_id}", response_model=schemas.UserResponse)
def get_user(user_id: str, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.post("/api/results", response_model=schemas.GameResultResponse)
def add_game_result(result: schemas.GameResultCreate, db: Session = Depends(get_db)):
    db_result = models.GameResult(**result.model_dump())
    db.add(db_result)
    db.commit()
    db.refresh(db_result)
    return db_result

@app.get("/api/users/{user_id}/results", response_model=list[schemas.GameResultResponse])
def get_results(user_id: str, db: Session = Depends(get_db)):
    return db.query(models.GameResult).filter(models.GameResult.user_id == user_id).order_by(models.GameResult.created_at.desc()).all()

@app.get("/api/users/{user_id}/cognitive-score", response_model=schemas.CognitiveScoreResponse)
def get_cognitive_score(user_id: str, db: Session = Depends(get_db)):
    score = db.query(models.CognitiveScore).filter(models.CognitiveScore.user_id == user_id).first()
    if not score:
        score = models.CognitiveScore(user_id=user_id, memory=55, attention=82, language=70, math=65, reaction=76, problem_solving=74)
        db.add(score)
        db.commit()
        db.refresh(score)
    return score

@app.put("/api/users/{user_id}/cognitive-score", response_model=schemas.CognitiveScoreResponse)
def update_cognitive_score(user_id: str, score_update: schemas.CognitiveScoreBase, db: Session = Depends(get_db)):
    score = db.query(models.CognitiveScore).filter(models.CognitiveScore.user_id == user_id).first()
    if not score:
        raise HTTPException(status_code=404, detail="Score not found")
    
    for var, value in vars(score_update).items():
        setattr(score, var, value) if value else None
        
    db.commit()
    db.refresh(score)
    return score

@app.post("/api/reminders", response_model=schemas.ReminderResponse)
def add_reminder(reminder: schemas.ReminderCreate, db: Session = Depends(get_db)):
    db_rem = models.Reminder(**reminder.model_dump())
    db.add(db_rem)
    db.commit()
    db.refresh(db_rem)
    return db_rem

@app.get("/api/users/{user_id}/reminders", response_model=list[schemas.ReminderResponse])
def get_reminders(user_id: str, db: Session = Depends(get_db)):
    return db.query(models.Reminder).filter(models.Reminder.user_id == user_id).order_by(models.Reminder.time.asc()).all()

@app.put("/api/reminders/{reminder_id}", response_model=schemas.ReminderResponse)
def update_reminder(reminder_id: str, reminder_update: schemas.ReminderBase, db: Session = Depends(get_db)):
    db_rem = db.query(models.Reminder).filter(models.Reminder.id == reminder_id).first()
    if not db_rem:
        raise HTTPException(status_code=404, detail="Reminder not found")
    
    db_rem.title = reminder_update.title
    db_rem.time = reminder_update.time
    db_rem.category = reminder_update.category
    db_rem.completed = reminder_update.completed
    
    db.commit()
    db.refresh(db_rem)
    return db_rem

@app.delete("/api/reminders/{reminder_id}")
def delete_reminder(reminder_id: str, db: Session = Depends(get_db)):
    db_rem = db.query(models.Reminder).filter(models.Reminder.id == reminder_id).first()
    if db_rem:
        db.delete(db_rem)
        db.commit()
    return {"status": "deleted"}
