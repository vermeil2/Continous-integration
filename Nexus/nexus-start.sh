#!/bin/bash
set -e

# 공통 설정 불러오기
source "$(dirname "$0")/nexus-env.sh"

# ==========================================
# 6. 방화벽 설정 및 서비스 시작
# ==========================================
echo "[Step 6] 방화벽 포트($NEXUS_PORT) 개방 및 서비스 시작..."

if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-port=${NEXUS_PORT}/tcp
    sudo firewall-cmd --reload
else
    echo "Firewalld가 실행 중이지 않아 포트 설정을 건너뜁니다."
fi

sudo systemctl daemon-reload
sudo systemctl enable --now nexus

# ==========================================
# 7. 완료 안내
# ==========================================
echo "================================================================"
echo " 설치가 완료되었습니다!"
echo " Nexus가 시작되는 데 약 1~2분이 소요될 수 있습니다."
echo " 초기 비밀번호 확인 명령어: "
echo "  cat $WORK_DIR/nexus3/admin.password"
echo "================================================================"

