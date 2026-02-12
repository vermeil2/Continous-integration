#!/bin/bash

# 1. 변수 설정 (사용자 환경에 맞게 수정)
DOMAIN="pjjharbor.com"
IP="192.168.106.132"
CERT_DIR="/data/cert"
HARBOR_DIR="$HOME/harbor"

echo "==== 1. 기존 인증서 및 설정 초기화 ===="
sudo mkdir -p $CERT_DIR
sudo rm -rf $CERT_DIR/*
sudo rm -rf /etc/docker/certs.d/$DOMAIN

echo "==== 2. CA 인증서 생성 (CN: pjjharbor-CA) ===="
openssl genrsa -out $CERT_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=KR/ST=Incheon/L=Yeonsu/O=DevOps/OU=CA/CN=pjjharbor-CA" \
 -key $CERT_DIR/ca.key \
 -out $CERT_DIR/ca.crt

echo "==== 3. 서버 인증서 및 CSR 생성 (CN: $DOMAIN) ===="
openssl genrsa -out $CERT_DIR/$DOMAIN.key 4096
openssl req -sha512 -new \
 -subj "/C=KR/ST=Incheon/L=Yeonsu/O=DevOps/OU=Server/CN=$DOMAIN" \
 -key $CERT_DIR/$DOMAIN.key \
 -out $CERT_DIR/$DOMAIN.csr

echo "==== 4. SAN 설정 파일(v3.ext) 생성 ===="
cat > $CERT_DIR/v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:$DOMAIN,DNS:harbor.com,IP:$IP
EOF

echo "==== 5. 서버 인증서 최종 발급 ===="
openssl x509 -req -sha512 -days 3650 \
 -extfile $CERT_DIR/v3.ext \
 -CA $CERT_DIR/ca.crt -CAkey $CERT_DIR/ca.key -CAcreateserial \
 -in $CERT_DIR/$DOMAIN.csr \
 -out $CERT_DIR/$DOMAIN.crt

echo "==== 6. Docker 및 OS 시스템 신뢰 설정 ===="
# Docker certs.d 설정
sudo mkdir -p /etc/docker/certs.d/$DOMAIN
sudo cp $CERT_DIR/ca.crt /etc/docker/certs.d/$DOMAIN/ca.crt

# OS 전체 신뢰 목록 등록 (AlmaLinux/CentOS)
sudo cp $CERT_DIR/ca.crt /etc/pki/ca-trust/source/anchors/$DOMAIN-ca.crt
sudo update-ca-trust

# Docker 재시작
sudo systemctl restart docker

echo "==== 7. /etc/hosts 등록 확인 ===="
if ! grep -q "$DOMAIN" /etc/hosts; then
    echo "$IP $DOMAIN" | sudo tee -a /etc/hosts
fi

echo "===================================================="
echo "인증서 생성이 완료되었습니다!"
echo "경로: $CERT_DIR"
echo "이제 'harbor.yml'에서 아래 경로를 지정하고 설치를 진행하세요."
echo "certificate: $CERT_DIR/$DOMAIN.crt"
echo "private_key: $CERT_DIR/$DOMAIN.key"
echo "===================================================="