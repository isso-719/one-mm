#!/bin/bash

# Cloud Run にデプロイ
gcloud run deploy one-mm \
  --no-cpu-throttling \
  --region=asia-northeast1 \
  --source=.