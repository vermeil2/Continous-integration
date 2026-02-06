# Jenkins 초기 설치 및 실행 스크립트

이 디렉터리는 AlmaLinux/RHEL 계열에서 Jenkins를 설치하고 초기 설정을 돕기 위한 스크립트 모음입니다.

---

## 스크립트 개요

- **`jenkins-install.sh`**
  - Jenkins 공식 저장소(repo) 추가
  - `yum upgrade -y` 실행
  - `fontconfig`, `java-21-openjdk`, `jenkins` 패키지 설치
  - `systemctl daemon-reload` 수행

- **`jenkins-firewall-init.sh`**
  - `firewalld`에 `jenkins` 서비스 정의
  - Jenkins 기본 포트 `8080/tcp` 오픈
  - `public` 존에 `http` 서비스 영구 추가
  - 방화벽 설정 적용(`firewall-cmd --reload`)
  - Jenkins 초기 관리자 비밀번호 파일 출력  
    (`/var/lib/jenkins/secrets/initialAdminPassword`)

- **`start-jenkins.sh`**
  - Jenkins 서비스를 `enable` (부팅 시 자동 시작)
  - Jenkins 서비스를 `start` (즉시 시작)

---

## 실행 순서 예시

1. **실행 권한 부여**

   ```bash
   cd Jenkins
   chmod +x jenkins-*.sh start-jenkins.sh
   ```

2. **Jenkins 패키지 설치**

   ```bash
   ./jenkins-install.sh
   ```

3. **방화벽 설정 및 초기 비밀번호 확인**

   ```bash
   ./jenkins-firewall-init.sh
   ```

4. **Jenkins 서비스 활성화 및 시작**

   ```bash
   ./start-jenkins.sh
   ```

---

## 접속 정보

- 웹 접근 URL: `http://<서버 IP>:8080`
- 초기 관리자 비밀번호:
  - `./jenkins-firewall-init.sh` 실행 시 자동 출력
  - 또는 다음 명령으로 직접 확인:

    ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

