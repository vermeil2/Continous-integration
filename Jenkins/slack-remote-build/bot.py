import os
import requests
from dotenv import load_dotenv
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
from requests.auth import HTTPBasicAuth

# 1. .env 파일로부터 환경변수 로드
load_dotenv()

# 2. 환경변수 할당 (없을 경우 에러 발생시켜 실행 방지)
SLACK_BOT_TOKEN = os.environ.get("SLACK_BOT_TOKEN")
SLACK_APP_TOKEN = os.environ.get("SLACK_APP_TOKEN")
JENKINS_URL = os.environ.get("JENKINS_URL")
JENKINS_USER = os.environ.get("JENKINS_USER")
JENKINS_TOKEN = os.environ.get("JENKINS_TOKEN")

if not all([SLACK_BOT_TOKEN, SLACK_APP_TOKEN]):
    raise ValueError("필수 슬랙 토큰이 설정되지 않았습니다. .env 파일을 확인하세요.")

app = App(token=SLACK_BOT_TOKEN)

@app.action("approve_build")
def handle_approval(ack, body, client):
    ack()

    # 버튼 value에 담긴 "job_name/build_number" 추출
    metadata = body['actions'][0]['value']
    job_name, build_number = metadata.split("/")
    user_id = body['user']['id']

    print(f"[*] 승인 요청 감지: {job_name} #{build_number} by <@{user_id}>")

    # 젠킨스 Input 승인 API 호출
    # Input ID인 'AskApproval'은 Jenkinsfile 설정과 일치해야 함
    api_url = f"{JENKINS_URL}/job/{job_name}/{build_number}/input/AskApproval/proceedEmpty"

    try:
        response = requests.post(
            api_url,
            auth=HTTPBasicAuth(JENKINS_USER, JENKINS_TOKEN),
            timeout=10
        )

        if response.status_code in [200, 302]:
            # 기존 메세지 업데이트하여 버튼 제거 및 승인자 표시
            client.chat_update(
                channel=body['channel']['id'],
                ts=body['message']['ts'],
                text=f":white_check_mark: <@{user_id}> 님이 {job_name} #{build_number} 빌드를 승인했습니다.",
                blocks=[]
            )
        else:
            print(f"[!] 젠킨스 응답 에러: {response.status_code}")

    except Exception as e:
        print(f"[!] 통신 에러: {e}")

if __name__ == "__main__":
    print("⚡️ Slack Bot is booting up with Socket Mode...")
    handler = SocketModeHandler(app, SLACK_APP_TOKEN)
