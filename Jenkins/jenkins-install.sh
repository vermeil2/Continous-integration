#!/bin/bash
set -e

# ==========================================
# Jenkins 저장소 추가 및 패키지 설치
# ==========================================

echo "[Step 1] Jenkins 저장소 추가..."
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo

echo "[Step 2] 시스템 업그레이드..."
sudo yum upgrade -y

echo "[Step 3] Jenkins 및 의존성(java-21-openjdk 등) 설치..."
sudo yum install -y fontconfig java-21-openjdk
sudo yum install -y jenkins

echo "[Step 4] systemd 데몬 리로드..."
sudo systemctl daemon-reload

echo "=== Jenkins 패키지 설치 단계 완료 ==="

