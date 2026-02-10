#!/bin/bash
set -e

# ==========================================
# Jenkins 서비스 시작
# ==========================================

echo "[Step 1] Jenkins 서비스 시작..."
sudo systemctl enable jenkins

sudo systemctl start jenkins

