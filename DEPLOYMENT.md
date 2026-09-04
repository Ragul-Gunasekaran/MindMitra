# MindMitra Deployment Guide

## 1. Database Configuration (Neon PostgreSQL)

1. Create a free PostgreSQL database on [Neon](https://neon.tech/).
2. Copy the database connection string. It should look like `postgresql://user:password@host/dbname`.
3. If it starts with `postgres://`, the backend will automatically handle replacing it with `postgresql://`.

## 2. Backend Deployment (Render)

1. Sign in to [Render](https://render.com/).
2. Create a new **Web Service**.
3. Connect your GitHub repository (`Ragul-Gunasekaran/MindMintra`).
4. Render will automatically detect the `render.yaml` configuration and apply the following:
   * **Build Command:** `pip install -r backend/requirements.txt`
   * **Start Command:** `cd backend && uvicorn app.main:app --host 0.0.0.0 --port $PORT`
5. Go to the "Environment" tab on your Render dashboard and set these exact variables:
   * `DATABASE_URL`: Add your Neon PostgreSQL URL here.
   * `CORS_ORIGINS`: Add `https://ragul-gunasekaran.github.io,http://localhost:8000`
   * `PYTHON_VERSION`: `3.10.0`

## 3. API Configuration

Once your Render service is deployed, copy the provided URL (e.g., `https://mindmitra-api.onrender.com`).

To deploy the frontend to point to this new API:
1. Go to your GitHub repository > **Settings** > **Variables** > **Actions** > **Repository variables**.
2. Create a new variable named `API_BASE_URL`.
3. Set the value to your Render URL (no trailing slash).
4. Any new commit to the `main` branch will automatically trigger the GitHub Actions workflow, injecting your URL directly into the Flutter Web build.

## 4. Frontend Deployment (GitHub Pages)

The Flutter web frontend is automatically deployed via GitHub Actions (`.github/workflows/flutter_web.yml`) every time you push to the `main` branch. 
The final URL is:
`https://ragul-gunasekaran.github.io/MindMintra/`

## 5. Health Check

You can verify the backend is running by visiting:
`<your-render-url>/health`
It will return `{"status": "healthy"}`.
