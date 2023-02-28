#!/bin/bash

# Cloud Run にデプロイ
gcloud run deploy one-mm \
  --no-cpu-throttling \
  --region=asia-northeast1 \
  --source=. \
  --update-env-vars GOOGLE_APP_SCRIPT_DEPLOY_URL=$1