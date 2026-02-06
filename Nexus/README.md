# Nexus 3 초기 설치 스크립트 (AlmaLinux)

이 디렉터리는 AlmaLinux 계열에서 Nexus 3를 설치하기 위한 쉘 스크립트 모음입니다.  
각 스크립트는 **환경 설정 / 설치 / 서비스 설정 / 기동** 단계를 나누어 실행합니다.

> 기본적으로 `sudo` 권한이 필요하며, AlmaLinux 9.x 기준으로 작성되었습니다.

---

## 스크립트 개요

- **`nexus-env.sh`**
  - 모든 스크립트에서 공통으로 사용하는 환경 변수 정의
  - 예: `NEXUS_USER`, `INSTALL_DIR`, `NEXUS_HOME`, `WORK_DIR`, `JAVA_PKG`, `NEXUS_PORT`, `DOWNLOAD_URL` 등
  - 다른 스크립트에서 `source "$(dirname "$0")/nexus-env.sh"` 형태로 불러옵니다.

- **`nexus-install-base.sh`**
  - 시스템 업데이트 및 필수 패키지 설치 (`dnf update`, `wget`, `tar`, `java-17-openjdk-devel` 등)
  - Nexus 전용 계정 생성 (`nexus` 사용자)
  - Nexus 바이너리 다운로드 및 `/opt` 하위에 설치
  - `NEXUS_HOME` / `WORK_DIR` 디렉터리 권한 설정

- **`nexus-config-service.sh`**
  - `nexus.rc` 파일의 `run_as_user` 값을 `nexus` 사용자로 설정
  - `systemd` 유닛 파일(`/etc/systemd/system/nexus.service`) 생성
  - Nexus를 서비스 형태로 관리할 수 있도록 준비하는 단계

- **`nexus-start.sh`**
  - `firewalld` 가 활성화되어 있는 경우, Nexus 포트(`8081`) 방화벽 오픈
  - `systemctl daemon-reload` 및 `systemctl enable --now nexus` 로 서비스 등록 및 즉시 기동
  - 초기 관리자 비밀번호 파일 위치 출력 (`$WORK_DIR/nexus3/admin.password`)

> 참고: 기존의 `nexus.sh` 는 전체 과정을 한 번에 실행하는 올인원 스크립트이며,  
> 분리된 스크립트를 사용하려면 굳이 실행할 필요는 없습니다.

---

## 실행 순서

1. **스크립트에 실행 권한 부여**

   ```bash
   cd Nexus
   chmod +x nexus-*.sh
   ```

2. **기본 설치 (필수 패키지 설치 + Nexus 설치)**

   ```bash
   ./nexus-install-base.sh
   ```

3. **서비스 설정 (실행 사용자 + systemd 유닛 등록)**

   ```bash
   ./nexus-config-service.sh
   ```

4. **방화벽 설정 및 Nexus 서비스 기동**

   ```bash
   ./nexus-start.sh
   ```

---

## 비고

- 설치/설정 도중 에러가 발생하면, 해당 단계 스크립트만 다시 실행해도 되도록 설계되어 있습니다.
- `DOWNLOAD_URL`, `NEXUS_PORT` 등을 변경하고 싶다면 `nexus-env.sh` 만 수정하면 됩니다.

