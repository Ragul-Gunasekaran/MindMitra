import os
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from . import database, models

SECRET_KEY = os.getenv("JWT_SECRET", "super-secret-key-for-dev") # DO NOT COMMIT PROD SECRETS
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7 # 7 days

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/login")

def verify_password(plain_password, hashed_password):
    if not hashed_password:
        return False
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(database.get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        raise credentials_exception
    return user

def require_role(allowed_roles: list[str]):
    def role_dependency(current_user: models.User = Depends(get_current_user)):
        if current_user.role not in allowed_roles:
            raise HTTPException(status_code=403, detail="Not enough permissions")
        return current_user
    return role_dependency


def authorize_access(target_user_id: str, current_user: models.User = Depends(get_current_user), db: Session = Depends(database.get_db)):
    if current_user.role == 'ADMIN':
        return current_user
    if current_user.id == target_user_id:
        return current_user
    if current_user.role == 'CAREGIVER':
        # Check active connection
        conn = db.query(models.CaregiverConnection).filter(
            models.CaregiverConnection.caregiver_id == current_user.id,
            models.CaregiverConnection.elderly_id == target_user_id,
            models.CaregiverConnection.status == 'ACTIVE'
        ).first()
        if conn:
            return current_user
    raise HTTPException(status_code=403, detail='Not authorized to access this user''s data')

