# Windows WSL 개발 환경 구축 가이드

> 대상: Windows 10 22H2 또는 Windows 11을 사용하는 실습자
>
> 목표: Windows → WSL 2 Ubuntu → Docker Desktop → VS Code 순서로, Docker와 AI 실습을 안정적으로 실행할 수 있는 개발 환경을 준비합니다.

## 1. 설치 전 확인

| 항목 | 권장 기준 | 확인 방법 |
|---|---|---|
| Windows | Windows 11 또는 Windows 10 22H2 이상 | `winver` |
| 가상화 | BIOS/UEFI에서 Intel VT-x 또는 AMD-V 활성화 | 작업 관리자 → 성능 → CPU → **가상화: 사용** |
| 메모리 | Docker 기초 8 GB 이상, AI 실습 16 GB 이상 | 작업 관리자 → 성능 → 메모리 |
| 디스크 | Docker 기초 50 GB, AI 실습 100 GB 이상 여유 | 설정 → 시스템 → 저장소 |

회사 관리 PC에서는 BIOS 설정, Microsoft Store, Hyper-V/WSL 기능이 정책으로 제한될 수 있습니다. 이 경우 관리자 또는 IT 부서에 WSL 2와 Docker Desktop 사용 허용을 요청해야 합니다.

## 2. WSL 2와 Ubuntu 설치

**관리자 권한 PowerShell**을 열어 아래를 실행합니다.

```powershell
wsl --install
wsl --update
wsl --set-default-version 2
wsl --install -d Ubuntu-24.04
```

설치 뒤 재부팅하라는 메시지가 나오면 재부팅합니다. Ubuntu 창이 열리면 Linux용 사용자 이름과 암호를 만듭니다. 이 암호는 Windows 암호와 별개이며 `sudo` 실행에 사용합니다.

```powershell
# 설치 상태 확인 (VERSION이 2여야 함)
wsl --list --verbose

# 기본 배포판을 Ubuntu로 지정 (여러 배포판이 있을 때)
wsl --set-default Ubuntu-24.04
```

`wsl --install`이 실패하면 Windows 기능을 수동으로 켠 뒤 재부팅하고 다시 시도합니다.

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

## 3. Ubuntu 최초 설정

Ubuntu 터미널에서 실행합니다.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential ca-certificates curl git jq unzip zip

# Git 작성자 정보 (본인 정보로 변경)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 실습 저장소는 Linux 파일 시스템에 둡니다.
mkdir -p ~/workspace
cd ~/workspace
git clone <repository-url> docker-class
cd docker-class
```

`/mnt/c/Users/...`는 Windows 드라이브를 WSL에서 보여 주는 경로입니다. 문서 편집에는 편리하지만, 대량 파일과 bind mount가 있는 Docker/Python 개발에서는 Linux 홈(`~/workspace`)보다 느리거나 권한·파일 감시 문제가 생길 수 있습니다. 이 과정의 저장소는 `~/workspace/docker-class`에 두는 것을 기본으로 합니다.

## 4. VS Code 연동

1. Windows에 [Visual Studio Code](https://code.visualstudio.com/)를 설치합니다.
2. 확장 프로그램에서 **WSL**(Microsoft)과 **Docker**(Microsoft)를 설치합니다.
3. Ubuntu 터미널에서 프로젝트를 연 뒤 실행합니다.

```bash
cd ~/workspace/docker-class
code .
```

처음 실행하면 VS Code Server가 WSL 안에 설치됩니다. 좌측 하단에 `WSL: Ubuntu-24.04`가 표시되면 정상입니다. 이후에는 VS Code의 내장 터미널도 Ubuntu 환경을 사용하므로 Docker 명령과 Git 명령을 같은 위치에서 실행할 수 있습니다.

## 5. WSL 리소스 설정 (AI 실습 권장)

Windows 사용자 홈의 `C:\Users\<Windows사용자명>\.wslconfig` 파일을 생성합니다. 아래 값은 RAM 32 GB PC의 예시입니다. PC RAM을 모두 할당하지 말고 Windows가 사용할 여유를 남깁니다.

```ini
[wsl2]
memory=20GB
processors=12
swap=8GB
localhostForwarding=true
```

PowerShell에서 WSL을 종료한 다음 Docker Desktop을 다시 실행해야 적용됩니다.

```powershell
wsl --shutdown
```

Linux에서 systemd가 필요한 도구를 쓸 경우에는 Ubuntu의 `/etc/wsl.conf`에 다음을 추가하고 같은 방식으로 재시작합니다.

```ini
[boot]
systemd=true
```

## 6. Docker Desktop 연결

1. Windows에 [Docker Desktop](https://www.docker.com/products/docker-desktop/)을 설치하고 실행합니다.
2. Settings → General에서 **Use the WSL 2 based engine**을 켭니다.
3. Settings → Resources → WSL Integration에서 `Ubuntu-24.04`를 켭니다.
4. Ubuntu 터미널에서 검증합니다.

```bash
docker version
docker compose version
docker run --rm hello-world
docker context ls
```

`docker version`에서 Client와 Server가 모두 출력되고 `hello-world`가 완료되면 연결된 것입니다. WSL 안에 `docker-ce`를 별도로 설치할 필요가 없습니다. Docker Desktop을 사용하는 경우 두 Docker Engine을 함께 설치하면 소켓과 포트가 충돌할 수 있습니다.

공유 네트워크는 모든 실습에서 한 번만 만듭니다.

```bash
docker network create shared-net 2>/dev/null || true
```

## 7. NVIDIA GPU 사용 (선택)

1. **Windows 호스트**에 최신 NVIDIA Game Ready 또는 Studio 드라이버를 설치합니다.
2. WSL Ubuntu에서 다음을 확인합니다.

```bash
nvidia-smi
docker run --rm --gpus all nvidia/cuda:12.9.0-base-ubuntu22.04 nvidia-smi
```

WSL + Docker Desktop 환경에서는 Linux 배포판에 NVIDIA Linux 드라이버를 별도로 설치하지 않습니다. Windows 드라이버가 GPU를 WSL에 노출합니다. GPU가 없는 PC도 CPU Compose 파일로 모든 기초 실습과 소형 모델 실습을 진행할 수 있습니다.

## 8. 일상 점검과 복구

```bash
# WSL 안에서
df -h
docker system df
docker ps
docker info | grep -E 'CPUs|Total Memory'
```

| 증상 | 조치 |
|---|---|
| `docker: command not found` | Docker Desktop 실행 및 WSL Integration의 Ubuntu 활성화 여부 확인 후 터미널을 다시 엽니다. |
| daemon에 연결할 수 없음 | PowerShell에서 `wsl --shutdown`을 실행하고 Docker Desktop을 재시작합니다. |
| WSL 버전이 1 | `wsl --set-version Ubuntu-24.04 2`를 PowerShell에서 실행합니다. |
| 디스크가 부족함 | `docker system df`로 확인 후 미사용 리소스만 `docker system prune`으로 정리합니다. 모델 볼륨을 지우기 전에 필요한 모델인지 확인합니다. |
| 포트가 이미 사용 중 | `ss -ltnp | grep -E '3000|6333|8000|8888|11435'`로 프로세스를 확인합니다. |

다음 단계는 [Docker 설치 가이드](./README.md)의 Docker Desktop 설정과 AI 실습을 진행하는 것입니다.
