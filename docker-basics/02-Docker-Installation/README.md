# Docker 설치 가이드

> 이 가이드는 **Windows 11 + WSL2 + Docker Desktop + NVIDIA GPU** 환경을 기준으로 작성되었습니다.
> 실습 환경: Docker Desktop 4.73.1 / Engine 29.4.3 / RTX 3080 (8GB) / CUDA 12.9

> [!TIP]
> Windows PC를 처음 설정하는 학습자는 먼저 [Windows WSL 개발 환경 구축 가이드](./WSL-Setup.md)를 완료하세요. BIOS 가상화, WSL 배포판 설치, 사용자 설정, 저장 위치와 VS Code 연동까지 다룹니다.

---

## 1. 환경별 설치 경로

| 환경 | 방법 | 권장 여부 |
|---|---|---|
| **Windows 11 + WSL2** | Docker Desktop (WSL2 Backend) | ✅ 이 가이드 기준 |
| **macOS (Apple Silicon)** | Docker Desktop ARM 빌드 | ✅ |
| **Ubuntu 22.04/24.04 LTS** | Docker Engine + Compose Plugin | ✅ 서버 환경 |
| **Windows 10** | Docker Desktop (Hyper-V) | ⚠️ WSL2 강력 권장 |

---

## 2. Windows 11 + WSL2 설치

아래는 빠른 설치 경로입니다. 회사 PC 정책, 프록시, WSL 설치 오류 또는 개발 환경 초기 설정이 필요한 경우에는 위의 상세 WSL 가이드를 사용합니다.

### Step 1 — WSL2 활성화

```powershell
# PowerShell (관리자 권한)
wsl --install
wsl --set-default-version 2

# Ubuntu 22.04 설치
wsl --install -d Ubuntu-22.04

# 설치 확인
wsl --list --verbose
```

### Step 2 — NVIDIA 드라이버 설치 (GPU 사용 시)

> Windows 호스트에 드라이버를 설치하면 WSL2 내부에도 GPU가 자동으로 노출됩니다.
> WSL2 안에 별도 NVIDIA 드라이버를 설치하면 충돌합니다.

1. [NVIDIA 드라이버](https://www.nvidia.com/drivers) → **Game Ready / Studio 576+** 설치
2. WSL2 내에서 확인:

```bash
nvidia-smi
# NVIDIA-SMI 575.xx  Driver Version: 576.xx  CUDA Version: 12.9
```

### Step 3 — Docker Desktop 설치

1. [Docker Desktop 다운로드](https://www.docker.com/products/docker-desktop/) → **4.73.1 이상**
2. Settings → General → **Use WSL 2 based engine** ✅
3. Settings → Resources → WSL Integration → **Ubuntu-22.04** ✅
4. Settings → Resources → **CPU: 12+ / Memory: 16GB+** 권장

> [!IMPORTANT]
> 소스 코드는 `/mnt/c/...` 대신 WSL Linux 파일 시스템(예: `~/workspace/docker-class`)에 clone하세요. 파일 감시와 bind mount 성능이 더 안정적입니다.

### Step 4 — 설치 검증

```bash
# 버전 확인
docker version
# Client + Server 모두 출력되면 정상

# 리소스 확인
docker info | grep -E "CPUs|Memory|Kernel"

# GPU 동작 테스트
docker run --rm --gpus all nvidia/cuda:12.9.0-base-ubuntu22.04 nvidia-smi
# GPU 정보가 출력되면 GPU 지원 완료
```

CPU 전용 PC에서는 마지막 GPU 테스트를 건너뛰어도 됩니다. 대신 다음 명령으로 컨테이너 실행을 확인합니다.

```bash
docker run --rm hello-world
docker run --rm -it alpine:3.21 sh -c 'uname -a; echo Docker is ready'
```

---

## 3. 플러그인 확인 (Docker Desktop 4.73.1 기본 포함)

```bash
docker compose version    # v5.1.x  — 멀티 컨테이너 오케스트레이션
docker buildx version     # v0.33.x — 멀티 플랫폼 빌드
docker model              # Docker Model Runner — sLLM 서빙
docker mcp                # MCP Plugin — AI 에이전트 툴 연동
docker scout version      # 이미지 취약점 스캔
docker ai version         # Docker AI Agent (Gordon)
```

---

## 4. 공유 네트워크 생성 (필수)

모든 실습 컨테이너가 공유하는 브리지 네트워크입니다. **처음 한 번만** 실행합니다:

```bash
docker network create shared-net
docker network ls | grep shared-net
```

---

## 5. daemon.json 권장 설정

Docker Desktop → Settings → Docker Engine (또는 `%USERPROFILE%\.docker\daemon.json`):

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

## 6. WSL2 메모리 제한 설정

`C:\Users\<username>\.wslconfig` 파일 생성 (없으면 새로 만들기):

```ini
[wsl2]
memory=20GB
processors=14
swap=8GB
```

적용: `wsl --shutdown` → Docker Desktop 재시작

---

## 7. 리소스 현황 확인

```bash
# 전체 디스크 사용량
docker system df

# 이미지 목록 (크기 내림차순)
docker images --format "{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -rh | head -20

# 불필요한 리소스 정리 (중지 컨테이너, dangling 이미지, 미사용 네트워크)
docker system prune

# Build Cache만 정리
docker builder prune --keep-storage 10GB
```

---

## 8. macOS 설치

```bash
# Homebrew
brew install --cask docker
# 설치 후 Docker Desktop 실행 → 상단 메뉴바 고래 아이콘 확인
docker version
```

---

## 9. Ubuntu 22.04 LTS (서버/VM)

```bash
# Docker 공식 저장소 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 현재 사용자를 docker 그룹에 추가 (재로그인 필요)
sudo usermod -aG docker $USER

# NVIDIA Container Toolkit (GPU 서버만)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 10. 트러블슈팅

### `docker: command not found` 또는 Docker daemon 연결 실패

1. Docker Desktop이 실행 중인지 확인합니다.
2. Docker Desktop → Settings → Resources → WSL Integration에서 사용하는 Ubuntu 배포판을 활성화합니다.
3. WSL 터미널을 완전히 닫고 새로 열어 `docker version`을 다시 실행합니다.

Windows PowerShell에서 다음을 실행한 뒤 Docker Desktop을 다시 실행하는 방법도 있습니다.

```powershell
wsl --shutdown
```

### WSL에서 파일 권한 또는 Git 실행 파일 문제

프로젝트를 `/mnt/c/Users/...`에서 실행했을 때 발생하기 쉽습니다. Linux 홈으로 옮긴 뒤 다시 clone합니다.

```bash
mkdir -p ~/workspace
cd ~/workspace
git clone <repository-url>
```

### 포트 80/443 충돌 (WSL2)
```bash
sudo ss -ltnp 'sport = :80'
sudo systemctl stop nginx 2>/dev/null || true
```

### GPU가 컨테이너에서 안 보일 때
```bash
# Docker Desktop 재시작
docker desktop restart
# 또는 Windows에서 Docker Desktop 완전 종료 후 재실행
```

### WSL2 디스크 용량 부족
```bash
# 현재 사용량 확인
docker system df
# Build cache 정리
docker builder prune -f
# 미사용 이미지 정리
docker image prune -a
```

---

## 수업 보강 가이드

### 실습 전 체크리스트
- `docker version` / `docker info` 정상 출력 확인
- `docker network ls | grep shared-net` — 공유 네트워크 존재 확인
- 여유 디스크 최소 20GB 확보 (AI 실습 시 50GB 이상 권장)
- 포트 충돌 사전 확인: `11435`, `6333`, `3000`, `8080`

### 수업 운영(권장)
1. 개념 설명 20분: 컨테이너 vs VM, 레이어/캐시 원리
2. 데모 20분: 강사 실행 + 결과 해석
3. 실습 60분: 학생 직접 실행 + 체크포인트 제출
4. 회고 20분: 실패 사례 공유 + 재현 가능한 명령 정리
