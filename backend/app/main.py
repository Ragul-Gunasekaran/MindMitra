import os
import uuid
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from datetime import datetime, timedelta

from . import models, schemas, auth
from .database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="MindMitra API")

cors_origins = os.getenv("CORS_ORIGINS", "http://localhost:3000,http://localhost:8000,*").split(",")
# Do NOT use * for prod auth access, but keeping as string split for config simplicity
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

# AUTH ENDPOINTS

@app.post("/api/auth/register", response_model=schemas.UserResponse)
def register(user_data: schemas.AuthRegister, db: Session = Depends(get_db)):
    if db.query(models.User).filter(models.User.email == user_data.email).first():
        raise HTTPException(status_code=400, detail="An account with this email may already exist.")
    
    user_id = str(uuid.uuid4())
    hashed_password = auth.get_password_hash(user_data.password)
    
    db_user = models.User(
        id=user_id,
        email=user_data.email,
        password_hash=hashed_password,
        name=user_data.name,
        age=user_data.age,
        role="ELDERLY"  # Hardcode role to ELDERLY for standard registration. Admin sets other roles.
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    # Initialize Score
    db_score = models.CognitiveScore(user_id=user_id, memory=55, attention=82, language=70, math=65, reaction=76, problem_solving=74)
    db.add(db_score)
    db.commit()
    
    return db_user

@app.post("/api/auth/login", response_model=schemas.TokenResponse)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == form_data.username).first()
    if not user or not auth.verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="We couldn't sign you in. Please check your email and password.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.id}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/api/auth/me", response_model=schemas.UserResponse)
def get_me(current_user: models.User = Depends(auth.get_current_user)):
    return current_user

# PROTECTED ENDPOINTS

def authorize_user_access(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    return current_user

@app.get("/api/users/{user_id}", response_model=schemas.UserResponse)
def get_user(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.post("/api/results", response_model=schemas.GameResultResponse)
def add_game_result(result: schemas.GameResultCreate, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(result.user_id, current_user, db)
    db_result = models.GameResult(**result.model_dump())
    db.add(db_result)
    db.commit()
    db.refresh(db_result)
    return db_result

@app.get("/api/users/{user_id}/results", response_model=list[schemas.GameResultResponse])
def get_results(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    return db.query(models.GameResult).filter(models.GameResult.user_id == user_id).order_by(models.GameResult.created_at.desc()).all()

@app.get("/api/users/{user_id}/cognitive-score", response_model=schemas.CognitiveScoreResponse)
def get_cognitive_score(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    score = db.query(models.CognitiveScore).filter(models.CognitiveScore.user_id == user_id).first()
    if not score:
        score = models.CognitiveScore(user_id=user_id, memory=55, attention=82, language=70, math=65, reaction=76, problem_solving=74)
        db.add(score)
        db.commit()
        db.refresh(score)
    return score

@app.put("/api/users/{user_id}/cognitive-score", response_model=schemas.CognitiveScoreResponse)
def update_cognitive_score(user_id: str, score_update: schemas.CognitiveScoreBase, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    score = db.query(models.CognitiveScore).filter(models.CognitiveScore.user_id == user_id).first()
    if not score:
        raise HTTPException(status_code=404, detail="Score not found")
    
    for var, value in vars(score_update).items():
        setattr(score, var, value) if value else None
        
    db.commit()
    db.refresh(score)
    return score

@app.post("/api/reminders", response_model=schemas.ReminderResponse)
def add_reminder(reminder: schemas.ReminderCreate, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(reminder.user_id, current_user, db)
    db_rem = models.Reminder(**reminder.model_dump())
    db.add(db_rem)
    db.commit()
    db.refresh(db_rem)
    return db_rem

@app.get("/api/users/{user_id}/reminders", response_model=list[schemas.ReminderResponse])
def get_reminders(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    return db.query(models.Reminder).filter(models.Reminder.user_id == user_id).order_by(models.Reminder.time.asc()).all()

@app.put("/api/reminders/{reminder_id}", response_model=schemas.ReminderResponse)
def update_reminder(reminder_id: str, reminder_update: schemas.ReminderBase, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    db_rem = db.query(models.Reminder).filter(models.Reminder.id == reminder_id).first()
    if not db_rem:
        raise HTTPException(status_code=404, detail="Reminder not found")
    auth.authorize_access(db_rem.user_id, current_user, db)
    
    db_rem.title = reminder_update.title
    db_rem.time = reminder_update.time
    db_rem.category = reminder_update.category
    db_rem.completed = reminder_update.completed
    
    db.commit()
    db.refresh(db_rem)
    return db_rem

@app.delete("/api/reminders/{reminder_id}")
def delete_reminder(reminder_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    db_rem = db.query(models.Reminder).filter(models.Reminder.id == reminder_id).first()
    if db_rem:
        auth.authorize_access(db_rem.user_id, current_user, db)
        db.delete(db_rem)
        db.commit()
    return {"status": "deleted"}

@app.post("/api/caregivers/connections", response_model=schemas.CaregiverConnectionResponse)
def create_connection(conn: schemas.CaregiverConnectionCreate, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    # Only allow creation if the user is the elderly or the caregiver (and is authorized)
    if current_user.id != conn.elderly_id and current_user.id != conn.caregiver_id:
        raise HTTPException(status_code=403, detail="Not authorized to create this connection")
    
    db_conn = models.CaregiverConnection(**conn.model_dump())
    db.add(db_conn)
    db.commit()
    db.refresh(db_conn)
    return db_conn

@app.get("/api/caregivers/{caregiver_id}/elderly", response_model=list[schemas.CaregiverConnectionResponse])
def get_connected_elderly(caregiver_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    if current_user.id != caregiver_id and current_user.role != "ADMIN":
        raise HTTPException(status_code=403, detail="Not authorized")
    return db.query(models.CaregiverConnection).filter(models.CaregiverConnection.caregiver_id == caregiver_id).all()

@app.get("/api/users/{elderly_id}/caregivers", response_model=list[schemas.CaregiverConnectionResponse])
def get_caregivers(elderly_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(elderly_id, current_user, db)
    return db.query(models.CaregiverConnection).filter(models.CaregiverConnection.elderly_id == elderly_id).all()

@app.get("/api/users/{user_id}/analytics", response_model=schemas.AnalyticsSummary)
def get_user_analytics(user_id: str, period: str = "7d", current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    results = db.query(models.GameResult).filter(models.GameResult.user_id == user_id).all()
    count = len(results)
    avg_acc = sum([r.accuracy for r in results]) / count if count > 0 else 0.0
    domains = {"Memory": 0.0, "Attention": 0.0, "Reasoning": 0.0, "Language": 0.0, "Mathematics": 0.0, "Visual_Spatial": 0.0, "Reaction": 0.0}
    return schemas.AnalyticsSummary(
        period=period, activity_count=count, average_accuracy=avg_acc,
        routine_completion=82.0, active_days=min(count, 7), domains=domains, mood_trend="Good"
    )

@app.get("/api/users/{user_id}/reports/{period}")
def get_user_report(user_id: str, period: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    return {
        "period": period, "cognitive_activities": 18 if period == "weekly" else 3,
        "average_accuracy": 78.0, "routine_completion": 82.0,
        "wellness_activity": 5 if period == "weekly" else 1, "mood": "Mostly Good",
        "insights": ["Activity has been consistent.", "Routine consistency is strong.", "Memory practice is improving."]
    }


# ADMIN AND SUPPORT ENDPOINTS

@app.get('/api/admin/overview', response_model=schemas.AdminOverview)
def get_admin_overview(current_user: models.User = Depends(auth.require_role(['ADMIN'])), db: Session = Depends(get_db)):
    elderly_count = db.query(models.User).filter(models.User.role == 'ELDERLY').count()
    caregiver_count = db.query(models.User).filter(models.User.role == 'CAREGIVER').count()
    active_connections = db.query(models.CaregiverConnection).filter(models.CaregiverConnection.status == 'ACTIVE').count()
    activities = db.query(models.GameResult).count()
    return schemas.AdminOverview(
        total_elderly=elderly_count,
        total_caregivers=caregiver_count,
        active_connections=active_connections,
        cognitive_activities_completed=activities
    )

@app.get('/api/admin/users', response_model=list[schemas.UserResponse])
def get_all_users(current_user: models.User = Depends(auth.require_role(['ADMIN'])), db: Session = Depends(get_db)):
    return db.query(models.User).all()

@app.post('/api/feedback', response_model=schemas.FeedbackResponse)
def submit_feedback(feedback: schemas.FeedbackCreate, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    db_feedback = models.Feedback(
        user_id=current_user.id,
        type=feedback.type,
        message=feedback.message
    )
    db.add(db_feedback)
    db.commit()
    db.refresh(db_feedback)
    return db_feedback

@app.get('/api/feedback', response_model=list[schemas.FeedbackResponse])
def get_feedback(current_user: models.User = Depends(auth.require_role(['ADMIN'])), db: Session = Depends(get_db)):
    return db.query(models.Feedback).order_by(models.Feedback.created_at.desc()).all()

@app.delete('/api/users/{user_id}')
def delete_account(user_id: str, current_user: models.User = Depends(auth.get_current_user), db: Session = Depends(get_db)):
    auth.authorize_access(user_id, current_user, db)
    # A user can only delete themselves, unless ADMIN.
    if current_user.role != 'ADMIN' and current_user.id != user_id:
         raise HTTPException(status_code=403, detail='Cannot delete another user account')
         
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
         raise HTTPException(status_code=404, detail='User not found')
         
    # Due to foreign keys, depending on cascade settings, manual deletion of child records might be needed.
    db.query(models.GameResult).filter(models.GameResult.user_id == user_id).delete()
    db.query(models.Reminder).filter(models.Reminder.user_id == user_id).delete()
    db.query(models.CognitiveScore).filter(models.CognitiveScore.user_id == user_id).delete()
    db.query(models.CaregiverConnection).filter(
        (models.CaregiverConnection.elderly_id == user_id) | (models.CaregiverConnection.caregiver_id == user_id)
    ).delete()
    
    db.delete(user)
    db.commit()
    
    # Audit log
    audit = models.AuditLog(user_id=current_user.id, action='DELETE_ACCOUNT', target_id=user_id)
    db.add(audit)
    db.commit()
    
    return {'status': 'deleted'}

