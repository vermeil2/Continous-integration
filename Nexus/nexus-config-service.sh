#!/bin/bash
set -e

# 공통 설정 불러오기
source "$(dirname "$0")/nexus-env.sh"

# ==========================================
# 4. 실행 사용자 설정 (nexus.rc)
# ==========================================
echo "[Step 4] 실행 사용자 설정(run_as_user) 적용 중..."
sudo sed -i 's/#run_as_user=""/run_as_user="'$NEXUS_USER'"/' "$NEXUS_HOME/bin/nexus.rc"

# ==========================================
# 5. Systemd 서비스 등록
# ==========================================
echo "[Step 5] Systemd 서비스 파일 생성 중..."
sudo bash -c "cat > /etc/systemd/system/nexus.service" <<EOF
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=$NEXUS_USER
Group=$NEXUS_USER
ExecStart=$NEXUS_HOME/bin/nexus start
ExecStop=$NEXUS_HOME/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

echo "=== 서비스 설정 단계 완료 ==="

