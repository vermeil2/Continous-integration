## Harbor 설치/운영 스크립트

- **`harbor-cert.sh`**  
  - 자체 서명 CA 및 서버 인증서 생성
  - `/data/cert` 에 CA/서버 인증서 및 키 저장
  - OS 및 Docker 신뢰 저장소에 CA 등록
  - `/etc/hosts` 에 Harbor 도메인과 IP 추가
  - 마지막에 `harbor.yml` 에서 `certificate`, `private_key` 로 어떤 경로를 써야 하는지 안내

- **`harbor-install-online.sh`**  
  - GitHub 릴리즈에서 Harbor 온라인 설치 패키지(`harbor-online-installer.tgz`) 다운로드
  - `$HOME/harbor` (또는 `HARBOR_DIR` 환경 변수) 하위에 압축 해제
  - `harbor.yml` 이 없으면 `harbor.yml.tmpl` 을 복사해 주고, 수정 후 다시 실행하도록 종료
  - `install.sh` 를 실행하여 Harbor 컨테이너 설치

- **`harbor-start.sh`**  
  - `$HOME/harbor` 디렉터리에서 `docker-compose.yml` 기준으로 Harbor 컨테이너 기동/중지/상태 확인
  - 사용 예:

    ```bash
    ./harbor-start.sh start     # 시작
    ./harbor-start.sh stop      # 중지
    ./harbor-start.sh restart   # 재시작
    ./harbor-start.sh status    # 상태 확인
    ```

### 기본 설치 순서 예시

1. 인증서 생성:

   ```bash
   chmod +x harbor-cert.sh
   ./harbor-cert.sh
   ```

2. Harbor 온라인 설치:

   ```bash
   chmod +x harbor-install-online.sh
   ./harbor-install-online.sh
   ```

   > `harbor.yml` 을 도메인/인증서 경로/포트 등에 맞게 꼭 수정한 뒤 설치하세요.

