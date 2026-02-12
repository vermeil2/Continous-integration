#!/bin/bash
set -e

# ==========================================
# Harbor 온라인 설치 스크립트
#  - 사전 조건: docker, docker-compose(or 내장 docker compose) 설치
#  - 인증서: harbor-cert.sh 로 미리 생성 완료 가정
#  - harbor.yml 은 미리 수정 완료 가정 (hostname, https cert 경로 등)
# ==========================================

HARBOR_DIR="${HARBOR_DIR:-$HOME/harbor}"
HARBOR_VERSION="${HARBOR_VERSION:-latest}"

echo "==== 1. Harbor 온라인 설치 파일 다운로드 ===="
mkdir -p "$HARBOR_DIR"
cd "$HARBOR_DIR"

if [ ! -f "harbor-online-installer.tgz" ]; then
  echo "Harbor 온라인 설치 패키지 다운로드 (버전: $HARBOR_VERSION)..."
  wget -O harbor-online-installer.tgz "https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer.tgz"
else
  echo "기존 harbor-online-installer.tgz 파일이 있어 재다운로드를 건너뜁니다."
fi

echo "==== 2. 압축 해제 ===="
tar xzf harbor-online-installer.tgz --strip-components=1

echo "==== 3. harbor.yml 존재 여부 확인 ===="
if [ ! -f "harbor.yml" ]; then
  echo "harbor.yml 파일이 없습니다. 샘플 파일을 복사합니다."
  cp harbor.yml.tmpl harbor.yml
  echo "harbor.yml 을 도메인/인증서 경로에 맞게 수정 후 다시 실행하세요."
  exit 1
fi

echo "==== 4. Harbor 설치 스크립트 실행 (install.sh) ===="
sudo ./install.sh --with-trivy

echo "===================================================="
echo "Harbor 온라인 설치 스크립트가 완료되었습니다."
echo "docker ps 로 Harbor 컨테이너가 정상 동작하는지 확인하세요."
echo "===================================================="

