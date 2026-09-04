# MindMitra

**AI-Powered Cognitive Gaming & Memory Assistance Platform for Elderly Care**

## Project Overview
MindMitra is a comprehensive Smart India Hackathon (SIH) prototype designed for elderly users, specifically those facing cognitive decline or early-stage dementia. The platform combines interactive cognitive training with memory assistance and caregiver monitoring, completely wrapped in a highly accessible, elderly-first user interface.

## SIH Problem/Solution
**Problem:** Elderly patients with cognitive decline struggle with memory, daily routines, and mental engagement.
**Solution:** MindMitra provides 7 focused cognitive games, adaptive difficulty, and a memory assistant to keep patients engaged while giving caregivers actionable insights.

## Features
- **7 Cognitive Games:** Memory, Attention, Jigsaw, Reaction, Memory Recall, Language, Math.
- **AI Adaptive Difficulty:** Rule-based engine that automatically scales difficulty based on recent performance.
- **Recommendation Engine:** Analyzes subscores to recommend targeted training.
- **Memory Assistant:** Daily reminders with simple "Done" interactions.
- **Caregiver Dashboard:** Provides insights into training time, accuracy, and overall cognitive score progression.
- **Elderly-First UI:** Large touch targets, high contrast colors, and simple navigation.
- **Offline Fallback:** Gracefully degrades to local memory if the API is unavailable.

## Technology Stack
- **Frontend:** Flutter Web
- **Backend:** Python, FastAPI, SQLAlchemy
- **Database:** PostgreSQL (Supabase / Neon)
- **Deployment:** GitHub Pages (Frontend), Render (Backend)

## Architecture
```text
                 USER
                  |
                  v
        +-------------------+
        |     FRONTEND      |
        |   Flutter Web     |
        |    GitHub Pages   |
        +---------+---------+
                  | HTTPS REST API
                  v
        +-------------------+
        |      BACKEND      |
        | Python + FastAPI  |
        |      Render       |
        +---------+---------+
                  |
                  v
        +-------------------+
        |      DATABASE     |
        |    PostgreSQL     |
        |   Supabase/Neon   |
        +-------------------+
```

## AI Logic
Our **AI-powered adaptive cognitive training** system ensures the patient is always appropriately challenged:
- Accuracy >= 80% -> Increase difficulty
- Accuracy 50-79% -> Maintain difficulty
- Accuracy < 50% -> Decrease difficulty
*(Note: This is an adaptive training system, not a medical diagnostic tool.)*

## Deployment & Live URLs

? **Frontend (Live):** https://ragul-gunasekaran.github.io/MindMitra/

*(Note: The backend requires manual account configuration to deploy on Render. See setup below.)*

---

## Local Development & Setup

### Frontend Setup
1. Install Flutter SDK.
2. Run `flutter pub get`.
3. Set `API_BASE_URL` in `lib/constants/base_url.dart`.
4. Run `flutter run -d chrome`.

### Backend Setup
1. `cd backend`
2. `pip install -r requirements.txt`
3. Copy `.env.example` to `.env` and set `DATABASE_URL`.
4. `uvicorn app.main:app --reload`

### Database Setup
1. Create a free PostgreSQL database on Supabase or Neon.
2. Get the connection string.
3. Replace the `DATABASE_URL` in `.env` (backend) or `render.yaml` (production).

## Production Deployment (Render)
To deploy the FastAPI backend:
1. Connect this GitHub repository to Render (https://render.com/).
2. Create a new **Web Service**.
3. Render will automatically detect the `render.yaml` file and configure the build and start commands (`pip install` and `uvicorn`).
4. In the Render Dashboard, add your `DATABASE_URL` as an Environment Variable.
5. Once deployed, take the Render URL and update `API_BASE_URL` in `lib/constants/base_url.dart`, then push to GitHub to trigger the frontend re-build.

## API Endpoints
- `GET /health`
- `GET /api/users/{id}`
- `POST /api/users`
- `GET /api/users/{id}/results`
- `POST /api/results`
- `GET /api/users/{id}/cognitive-score`
- `PUT /api/users/{id}/cognitive-score`
- `GET /api/users/{id}/reminders`
- `POST /api/reminders`
- `PUT /api/reminders/{id}`
- `DELETE /api/reminders/{id}`
