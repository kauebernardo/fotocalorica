# Deploy & Production Guide - FotoCalórica

## Backend: containerized deployment
- Build Docker image:
  docker build -t fotocalorica-backend ./backend
- Run locally with docker-compose:
  docker-compose up --build

## Recommended hosting
- **Render.com** (easy deploy from GitHub, supports Docker)
- **Railway.app** (quick deploy)
- **Google Cloud Run** (scalable serverless containers)

## CI for Flutter
- Use GitHub Actions workflow `.github/workflows/flutter-build.yml` to generate APK artifacts automatically on push.
- For building iOS (IPA) use macOS runner with proper signing secrets (not included).

## Subscriptions
- Configure subscription products:
  - Google Play Console -> Subscriptions -> Add subscription with id `fotocalorica_monthly`
  - App Store Connect -> In-App Purchases -> Subscription group -> add subscription
- Implement server-side receipt validation (see `backend/receipt_validation.py`).
