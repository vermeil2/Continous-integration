#!/bin/bash
set -e

# 공통 설정 불러오기
source "$(dirname "$0")/nexus-env.sh"

# ==========================================
# 1. 시스템 업데이트 및 필수 패키지 설치
# ==========================================
echo "[Step 1] 시스템 업데이트 및 Java 설치 중..."
sudo dnf update -y
sudo dnf install wget tar $JAVA_PKG -y

# ==========================================
# 2. Nexus 전용 사용자 생성
# ==========================================
echo "[Step 2] Nexus 사용자($NEXUS_USER) 생성 중..."
if id "$NEXUS_USER" &>/dev/null; then
    echo "사용자가 이미 존재합니다. 생략합니다."
else
    sudo useradd -m -d "${INSTALL_DIR}/nexus" -s /bin/bash $NEXUS_USER
fi

# ==========================================
# 3. Nexus 다운로드 및 설치
# ==========================================
echo "[Step 3] Nexus 다운로드 및 압축 해제 중..."
cd $INSTALL_DIR

if [ -d "$NEXUS_HOME" ]; then
    echo "기존 설치 폴더가 존재합니다. 백업 후 진행하세요."
else
    sudo wget -O nexus.tar.gz $DOWNLOAD_URL
    sudo tar -xvf nexus.tar.gz
    sudo rm -f nexus.tar.gz

    # 압축 해제된 폴더(nexus-3.x.x)를 nexus-app으로 이름 변경
    # 주의: /opt 안에 nexus-3* 로 시작하는 다른 폴더가 없어야 함
    sudo mv nexus-3* "$NEXUS_HOME"
fi

# 권한 및 작업 디렉토리 설정
echo "[Step 3-1] 파일 권한 및 작업 디렉토리 설정 중..."
sudo mkdir -p "$WORK_DIR"
sudo chown -R $NEXUS_USER:$NEXUS_USER "$NEXUS_HOME"
sudo chown -R $NEXUS_USER:$NEXUS_USER "$WORK_DIR"

echo "=== Base 설치 단계 완료 ==="

