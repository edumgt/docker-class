# 흐름-2: 새 Docker 이미지 생성 → 실행 → Docker Hub에 푸시

> 이 문서의 모든 명령은 `Nginx-DockerFiles` 폴더의 실제 파일(`Dockerfile`, `index.html`, `app.js`)을 기준으로 작성되었으며, 아래 순서 그대로 실행해 Docker Hub push까지 검증되었습니다.

## 사전 준비
- Docker Hub 계정 생성: https://hub.docker.com/
- 아래 명령에서 **`<your-docker-hub-id>`**는 본인의 Docker Hub 계정 아이디로 바꿔 사용합니다. (이 문서의 실제 검증 예시는 `edumgt` 계정을 사용했습니다.)
- `docker login` 으로 미리 로그인되어 있어야 push가 가능합니다.

```bash
docker login
# Username: <your-docker-hub-id>
# Password: <Docker Hub 비밀번호 또는 Access Token>
```

```text
Login Succeeded
```

## 1. Dockerfile 준비
`Nginx-DockerFiles` 폴더에는 다음 3개 파일이 있습니다.

**Nginx-DockerFiles/Dockerfile**
```Dockerfile
FROM nginx:latest

COPY ./index.html /usr/share/nginx/html
COPY ./app.js /usr/share/nginx/html
```

**Nginx-DockerFiles/index.html**
```html
Welcome to Stack Simplify - NGINX-V1 - Custom Image
```

**Nginx-DockerFiles/app.js**
```js
// test
```

## 2. Dockerfile로 이미지 빌드
![alt text](image.png)
![alt text](image-1.png)

저장소 루트에서 `Nginx-DockerFiles` 폴더를 컨텍스트로 지정해 빌드합니다. `<your-docker-hub-id>`는 본인의 Docker Hub 계정 아이디로 바꿉니다.

```bash
cd docker-basics/04-Build-new-Docker-Image-and-Run-and-Push-to-DockerHub/Nginx-DockerFiles
docker build -t <your-docker-hub-id>/mynginx_image1:v1 .
```

### 실제 검증된 빌드 출력 (계정: edumgt)
```text
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 131B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:latest
#2 DONE 2.3s

#5 [1/3] FROM docker.io/library/nginx:latest@sha256:8541484afbc9c8a5a8a99b379568ebbc957f658583ec9448fc43104229c03cf8
#5 DONE 5.2s

#7 [2/3] COPY ./index.html /usr/share/nginx/html
#7 DONE 0.1s

#8 [3/3] COPY ./app.js /usr/share/nginx/html
#8 DONE 0.1s

#9 exporting to image
#9 exporting layers done
#9 exporting manifest sha256:e13f7601f8a8ac912c2cb16cd929dc697e03f3c404976c1639c333f8f6b86246 0.0s done
#9 naming to docker.io/edumgt/mynginx_image1:v1 done
```

## 3. 컨테이너 실행 및 동작 확인
2번에서 빌드한 이미지를 실행하고, `index.html`과 `app.js`가 정상적으로 서빙되는지 확인합니다.

```bash
docker run --name mynginx1 -p 8080:80 -d <your-docker-hub-id>/mynginx_image1:v1
curl http://localhost:8080/
curl http://localhost:8080/app.js
```

### 실제 검증된 출력 (계정: edumgt)
```text
$ docker run --name mynginx1 -p 18081:80 -d edumgt/mynginx_image1:v1
mynginx1
91dd22192390c14099f10594d7f4bdd8333108fc94641a33ed63b56cd6b97f21

$ curl -s http://localhost:18081/
Welcome to Stack Simplify - NGINX-V1 - Custom Image

$ curl -s http://localhost:18081/app.js
// test
```

### 포트/이름 충돌 시
- 80번 포트가 이미 다른 컨테이너(예: SpringBoot 앱)에서 사용 중이면 다음과 같은 에러가 발생합니다.
```text
docker: Error response from daemon: Bind for 0.0.0.0:80 failed: port is already allocated
```
  → `-p 8080:80` 처럼 호스트 포트를 바꿔서 재시도합니다.
- 동일한 이름의 컨테이너가 이미 있으면 다음과 같은 에러가 발생합니다.
```text
docker: Error response from daemon: Conflict. The container name "/mynginx1" is already in use ...
```
  → 기존 컨테이너를 정리(`docker rm -f mynginx1`)하거나 다른 이름을 사용합니다.

### 컨테이너 정리
```bash
docker ps
docker stop mynginx1
docker rm mynginx1
```

## 4. 태그(Tag) 지정
Docker Hub에 push하려면 `<계정>/<이미지>:<태그>` 형식으로 태그가 지정되어 있어야 합니다. 2번에서 이미 `<your-docker-hub-id>/mynginx_image1:v1`로 빌드했으므로, 배포용 태그를 하나 더 추가합니다.

```bash
docker images
docker tag <your-docker-hub-id>/mynginx_image1:v1 <your-docker-hub-id>/mynginx_image1:v1-release
```

## 5. Docker Hub에 Push
```bash
docker push <your-docker-hub-id>/mynginx_image1:v1-release
```

### 실제 검증된 push 출력 (계정: edumgt)
```text
$ docker push edumgt/mynginx_image1:v1-release
The push refers to repository [docker.io/edumgt/mynginx_image1]
c0df8d325117: Pushed
b8b80b9bc028: Pushed
13739289aa77: Pushed
d84ae7b21412: Pushed
f5de6e85ac74: Pushed
38552efe2229: Pushed
b2b44851aebb: Pushed
5a4222b844e8: Pushed
26c307b5e35a: Pushed
3c55dc422a81: Pushed
v1-release: digest: sha256:31d3965fdc39ef8191837928f31936ecb53effeb81ab226723f195c19a66cc4c size: 856
```

## 6. Docker Hub에서 확인
- 로그인 후 업로드된 이미지를 확인합니다.
- https://hub.docker.com/repositories

로컬 이미지를 지우고 다시 pull 해서 실제로 push가 반영됐는지 검증할 수 있습니다.

```bash
docker rmi <your-docker-hub-id>/mynginx_image1:v1-release
docker pull <your-docker-hub-id>/mynginx_image1:v1-release
```

### 실제 검증된 pull 출력 (계정: edumgt)
```text
$ docker pull edumgt/mynginx_image1:v1-release
v1-release: Pulling from edumgt/mynginx_image1
Digest: sha256:31d3965fdc39ef8191837928f31936ecb53effeb81ab226723f195c19a66cc4c
Status: Downloaded newer image for edumgt/mynginx_image1:v1-release
docker.io/edumgt/mynginx_image1:v1-release
```

## 참고: Docker Hub에서 유명 이미지 가져오기 (예: GitLab)
- https://hub.docker.com/r/gitlab/gitlab-ce

![alt text](image-7.png)
![alt text](image-8.png)

```bash
docker pull gitlab/gitlab-ce
```

- 기존 컨테이너/데몬의 포트 충돌 여부를 확인하세요.

![alt text](image-9.png)

```bash
docker run --detach \
  --publish 80:80 --publish 443:443 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume $PWD/gitlab/config:/etc/gitlab \
  --volume $PWD/gitlab/logs:/var/log/gitlab f63df4c43029
```

- 컨테이너 실행에는 5분 이상 걸릴 수 있습니다.

![alt text](image-10.png)
![alt text](image-11.png)

### 초기 비밀번호 확인
```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```



```text
PS C:\edumgt-java-education\docker-fundamentals> docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
Password: r5qhhvf2x0fmfrj8QdQ7d5srae9zUSvbrZ+A/m6W0+g=
```

- root 계정으로 위 비밀번호로 로그인합니다.
- 아래 화면이 보이면 `home`을 클릭합니다.

![alt text](image-12.png)
![alt text](image-13.png)

## 참고: AWS ECR로 푸시
- Docker Hub와 절차는 유사하며, AWS 환경에 맞춰 진행합니다.

![alt text](image-14.png)

- https://gallery.ecr.aws/

### ECR 생성
![alt text](image-15.png)
![alt text](image-16.png)
![alt text](image-17.png)

### ECR에 Push 절차
ECR(Amazon Elastic Container Registry)에 생성한 private repository에 로컬 Docker 이미지를 push하는 전체 절차는 다음과 같습니다.

#### 전제 조건
1. AWS CLI 설치 및 `aws configure` 완료
2. ECR에 private repository 생성 완료 (예: `my-ecr-repo`)
3. 로컬에 Docker 이미지 존재 (예: `my-app:latest`)

```bash
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.ap-northeast-2.amazonaws.com
```

- 권한 문제가 발생하면 에러 로그를 확인하고 IAM 권한을 부여해야 합니다.

```text
PS C:\edumgt-java-education\docker-fundamentals> aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 086015456585.dkr.ecr.ap-northeast-2.amazonaws.com
Login Succeeded
```

#### 이미지 태깅
- 아직 push는 아닙니다.

```bash
docker tag 9b02795cc82cbf635af6325c51c65b1bbc9eefe2926398fd27b19d482557b14b 086015456585.dkr.ecr.ap-northeast-2.amazonaws.com/edumgt/nginx
```

- 위 명령을 위해 AWS repo 주소를 복사합니다.

![alt text](image-18.png)

![alt text](image-19.png)

#### ECR로 Push
```bash
docker push 086015456585.dkr.ecr.ap-northeast-2.amazonaws.com/edumgt/nginx
```

```text
PS C:\edumgt-java-education\docker-fundamentals> docker push 086015456585.dkr.ecr.ap-northeast-2.amazonaws.com/edumgt/nginx
Using default tag: latest
The push refers to repository [086015456585.dkr.ecr.ap-northeast-2.amazonaws.com/edumgt/nginx]
71a22e73ef26: Waiting
021db26e13de: Waiting
dad67da3f26b: Waiting
397cc88dcd41: Waiting
ee11c21378de: Waiting
4eb3a9835b30: Waiting
66467f827546: Waiting
f05e87039331: Waiting
error from registry: User: arn:aws:iam::086015456585:user/DevUser0002 is not authorized to perform: ecr:InitiateLayerUpload on resource: arn:aws:ecr:ap-northeast-2:086015456585:repository/edumgt/nginx because no identity-based policy allows the ecr:InitiateLayerUpload action
```

#### 권한 오류 예시 및 해결
```text
error from registry: User: arn:aws:iam::086015456585:user/DevUser0002 is not authorized to perform: ecr:InitiateLayerUpload on resource: arn:aws:ecr:ap-northeast-2:086015456585:repository/edumgt/nginx because no identity-based policy allows the ecr:InitiateLayerUpload action
```

- 권한 부여 예시:

```bash
aws iam attach-user-policy \
  --user-name DevUser0002 \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser
```

```text
PS C:\edumgt-java-education\docker-fundamentals> aws iam attach-user-policy \
>>   --user-name DevUser0002 \
>>   --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser

An error occurred (AccessDenied) when calling the AttachUserPolicy operation: User: arn:aws:iam::086015456585:user/DevUser0002 is not authorized to perform: iam:AttachUserPolicy on resource: user DevUser0002 because no identity-based policy allows the iam:AttachUserPolicy action
```

- IAM 콘솔에서 권한을 부여합니다.

![alt text](image-20.png)
![alt text](image-21.png)

- 권한 문제가 해결되면 다시 push합니다.

```bash
docker push 086015456585.dkr.ecr.ap-northeast-2.amazonaws.com/edumgt/nginx
```

![alt text](image-22.png)

---

## Harbor에 Push

Harbor는 오픈소스 프라이빗 컨테이너 레지스트리로, 온프레미스 환경에서 이미지를 관리하고 취약점 스캔·접근 정책을 적용할 수 있습니다.

### 전제 조건
- Harbor 서버가 실행 중 (예: `11-Integrated-DevSecOps-Lab`의 `harbor` 프로필 또는 별도 설치)
- Harbor URL 및 프로젝트 이름 확인 (예: `harbor.example.com` / 프로젝트: `myproject`)
- Harbor 계정(admin 또는 프로젝트 Developer 이상)

### 1) Harbor 로그인
```bash
docker login harbor.example.com
# Username: admin (또는 본인 계정)
# Password: 설정한 비밀번호 입력
```

```text
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Login Succeeded
```

> [!TIP]
> HTTPS 인증서가 자체 서명(self-signed)인 경우 `/etc/docker/daemon.json`에 `insecure-registries` 를 추가하거나, 사설 CA 인증서를 시스템에 등록하세요.
>
> ```json
> {
>   "insecure-registries": ["harbor.example.com"]
> }
> ```
> 변경 후 Docker 재시작: `sudo systemctl restart docker`

### 2) 이미지 태깅
```bash
# 형식: <harbor-host>/<project>/<image-name>:<tag>
docker tag <your-docker-hub-id>/mynginx_image1:v1 harbor.example.com/myproject/mynginx_image1:v1
```

### 3) Harbor로 Push
```bash
docker push harbor.example.com/myproject/mynginx_image1:v1
```

```text
The push refers to repository [harbor.example.com/myproject/mynginx_image1]
v1: digest: sha256:... size: 1234
```

### 4) Harbor UI에서 확인
1. 브라우저에서 `https://harbor.example.com` 접속
2. 로그인 후 **Projects** → `myproject` 선택
3. **Repositories** 탭에서 업로드된 이미지와 태그를 확인합니다.
4. **Vulnerabilities** 탭에서 자동 스캔 결과도 확인할 수 있습니다.

### 5) Harbor에서 Pull
```bash
docker pull harbor.example.com/myproject/mynginx_image1:v1
```

---

## GitHub Packages(ghcr.io)에 Push

GitHub Container Registry(GHCR)를 이용하면 GitHub 저장소와 연동된 패키지(컨테이너 이미지)를 관리하고, 저장소 **Packages** 탭에서 목록을 확인할 수 있습니다.

### 전제 조건
- GitHub 계정 및 저장소 준비
- GitHub Personal Access Token (PAT) 발급
  - `Settings` → `Developer settings` → `Personal access tokens` → `Tokens (classic)`
  - 권한 선택: `write:packages`, `read:packages`, `delete:packages`, `repo`

### 1) PAT 환경 변수 설정 및 로그인

```bash
# PAT를 환경 변수에 저장 (터미널 세션 종료 시 사라짐)
export CR_PAT=<your_github_pat>

# ghcr.io 로그인
echo $CR_PAT | docker login ghcr.io -u <your-github-username> --password-stdin
```

```text
Login Succeeded
```

### 2) 이미지 태깅
```bash
# 형식: ghcr.io/<github-username-or-org>/<image-name>:<tag>
docker tag <your-docker-hub-id>/mynginx_image1:v1 ghcr.io/<your-github-username>/mynginx_image1:v1
```

예시:
```bash
docker tag stacksimplify/mynginx_image1:v1 ghcr.io/stacksimplify/mynginx_image1:v1
```

### 3) ghcr.io로 Push
```bash
docker push ghcr.io/<your-github-username>/mynginx_image1:v1
```

```text
The push refers to repository [ghcr.io/your-github-username/mynginx_image1]
v1: digest: sha256:... size: 1234
```

### 4) GitHub Packages 목록 확인

#### 방법 A: GitHub 웹 UI
1. `https://github.com/<your-github-username>` 접속
2. 프로필 페이지의 **Packages** 탭 클릭
   - 또는 특정 저장소 → **Packages** 섹션(우측 사이드바) 확인
3. Push한 이미지(`mynginx_image1`)가 목록에 표시됩니다.
4. 패키지 클릭 시 태그 목록, 다운로드 수, 메타데이터를 확인할 수 있습니다.

#### 방법 B: GitHub CLI (`gh`)
```bash
# 로그인
gh auth login

# 패키지 목록 확인 (사용자)
gh api user/packages?package_type=container --jq '.[].name'

# 패키지 목록 확인 (조직)
gh api orgs/<org-name>/packages?package_type=container --jq '.[].name'
```

#### 방법 C: Docker CLI로 확인
```bash
# 이미지 목록에서 ghcr.io 이미지 확인
docker images | grep ghcr.io
```

### 5) 패키지 공개/비공개 설정
기본적으로 Push된 패키지는 **private**입니다. 공개하려면:
1. `https://github.com/users/<your-github-username>/packages/container/<image-name>/settings` 접속
2. **Danger Zone** → **Change visibility** → `Public` 선택

### 6) 저장소와 패키지 연결
```bash
# 이미지에 저장소 라벨을 추가하면 GitHub이 자동으로 연결합니다.
docker build \
  --label "org.opencontainers.image.source=https://github.com/<your-github-username>/<repo-name>" \
  -t ghcr.io/<your-github-username>/mynginx_image1:v1 .

docker push ghcr.io/<your-github-username>/mynginx_image1:v1
```

> [!TIP]
> `org.opencontainers.image.source` 라벨을 추가하면 GitHub Packages 상세 페이지에서 연결된 저장소 링크가 표시됩니다.

### 7) GitHub Actions에서 자동 Push (CI/CD 예시)
```yaml
name: Build and Push to GHCR

on:
  push:
    branches: [main]

jobs:
  build-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: ./04-Build-new-Docker-Image-and-Run-and-Push-to-DockerHub/Nginx-DockerFiles
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/mynginx_image1:latest
          labels: |
            org.opencontainers.image.source=${{ github.server_url }}/${{ github.repository }}
```

> [!NOTE]
> GitHub Actions에서는 별도 PAT 없이 `secrets.GITHUB_TOKEN`으로 ghcr.io에 Push할 수 있습니다.

---

## 레지스트리별 비교 요약

| 레지스트리 | 주소 형식 | 주요 특징 | 인증 방식 |
|---|---|---|---|
| Docker Hub | `<id>/<image>:<tag>` | 공개 레지스트리, 무료 플랜 제한 있음 | `docker login` |
| AWS ECR | `<account>.dkr.ecr.<region>.amazonaws.com/<repo>` | AWS IAM 연동, 프라이빗 | AWS CLI + `docker login` |
| Harbor | `<harbor-host>/<project>/<image>:<tag>` | 온프레미스, 취약점 스캔, 정책 관리 | `docker login <harbor-host>` |
| GitHub GHCR | `ghcr.io/<owner>/<image>:<tag>` | GitHub 저장소 연동, CI/CD 통합 | PAT 또는 `GITHUB_TOKEN` |

---

## 수업 보강 가이드
<!-- course-boost-foundation-v1 -->

### 학습 목표(보강)
- Docker CLI를 단순 암기하지 않고, "이미지/컨테이너/볼륨/네트워크"의 관계로 설명할 수 있다.
- 동일 실습을 `run` 단건 명령과 `compose` 방식으로 모두 재현할 수 있다.
- 장애가 났을 때 `logs`, `inspect`, `exec`로 원인을 1차 분석할 수 있다.

### 실습 전 체크리스트
- `docker version` / `docker info`가 정상 출력되는지 확인
- 로컬에 사용 가능한 디스크 여유 10GB 이상 확보
- 포트 충돌 확인: `80`, `443`, `8080`, `3306`, `5432`

### 수업 운영(권장)
1. 개념 설명 20분: 컨테이너와 VM의 차이, 레이어/캐시 개념
2. 데모 20분: 강사가 명령 실행 후 결과 해석 시연
3. 실습 60분: 학습자 직접 실행 + 체크포인트 제출
4. 회고 20분: 실패 사례 공유, 재현 가능한 명령 정리

### 제출물(권장)
- 실행 명령 히스토리(중요 명령 10개 이상)
- `docker ps -a`, `docker images` 결과 캡처
- 장애 1건 이상 재현 + 해결 과정(runbook 10줄 이상)

### 평가 포인트
- 명령 실행 자체보다 "왜 이 명령을 썼는지" 설명 가능한지
- 동일 결과를 다른 방법(run/compose)으로 재현 가능한지
- 정리 문서에 복구 절차가 포함되어 있는지

---

## 📺 관련 YouTube 영상

[🎬 YouTube에서 관련 영상 검색하기](https://www.youtube.com/results?search_query=Docker+이미지+빌드+DockerHub+푸시)
