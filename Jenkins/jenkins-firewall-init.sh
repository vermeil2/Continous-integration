#!/bin/bash
set -e

# ==========================================
# 방화벽 설정 및 초기 관리자 비밀번호 확인
# ==========================================

YOURPORT=8080
PERM="--permanent"
SERV="$PERM --service=jenkins"

echo "[Step 1] firewalld 에 Jenkins 서비스 등록 및 포트 오픈..."
firewall-cmd $PERM --new-service=jenkins || true
firewall-cmd $SERV --set-short="Jenkins ports"
firewall-cmd $SERV --set-description="Jenkins port exceptions"
firewall-cmd $SERV --add-port=$YOURPORT/tcp
firewall-cmd $PERM --add-service=jenkins
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload

echo "[Step 2] Jenkins 초기 관리자 비밀번호 출력..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || {
  echo "초기 비밀번호 파일을 찾을 수 없습니다. Jenkins 서비스 상태를 확인하세요."
}

echo "=== 방화벽 설정 및 초기 비밀번호 확인 단계 완료 ==="

