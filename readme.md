<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

# <i class="fa-brands fa-docker"></i> Docker Class Master
 
## 선수 repo - https://github.com/edumgt/edumgt-lab-init

## 목차
- [0. 폴더 구조](#0-폴더-구조)
- [1. 시작 전 준비사항](#1-시작-전-준비사항)
- [2. 학습 로드맵](#2-학습-로드맵)
- [3. Docker Desktop 빠른 제어](#3-docker-desktop-빠른-제어)
- [4. 아키텍처 개요](#4-아키텍처-개요)
- [5. 온프렘 최소 자원 산정](#5-온프렘-최소-자원-산정)
- [6. 운영 고도화 확장 스택](#6-운영-고도화-확장-스택)
- [7. 통합 의존관계 다이어그램](#7-통합-의존관계-다이어그램)
- [8. WSL 포트 80 트러블슈팅](#8-wsl-포트-80-트러블슈팅)
- [9. Docker 이미지 목록](#9-docker-이미지-목록)
- [10. 대상 독자와 도입 로드맵](#10-대상-독자와-도입-로드맵)
- [11. 확장 커리큘럼 맵](#11-확장-커리큘럼-맵)
- [12. 공용 리소스 폴더](#12-공용-리소스-폴더)
- [13. Vector DB 원리와 Docker 실습](#13-vector-db-원리와-docker-실습)
- [14. 멀티 모델 & sLLM Docker 서빙](#14-멀티-모델--sllm-docker-서빙)
- [15. Windows WSL·Docker·AI 개발 환경](#15-windows-wsldockerai-개발-환경)

---

## 0. 폴더 구조

```
docker-class/
├── docker-basics/                         # Docker 기초 (01~05장)
│   ├── 01-Docker-Introduction/            # Docker 개념 소개
│   ├── 02-Docker-Installation/            # 설치 가이드 (Windows/macOS/Linux)
│   ├── 03-Pull-from-DockerHub-and-Run-Docker-Images/  # Hub에서 Pull & Run
│   ├── 04-Build-new-Docker-Image-and-Run-and-Push-to-DockerHub/  # 이미지 빌드·Push
│   └── 05-Essential-Docker-Commands/      # 핵심 CLI 명령어 모음
│
├── devsecops-on-prem/                     # DevSecOps On-Prem 도구 (06~11장)
│   ├── 06-Jenkins-Server-On-Prem/         # Jenkins LTS 온프레미스 구축
│   ├── 07-GitLab-CE-On-Prem/              # GitLab CE 온프레미스 구축
│   ├── 08-SonarQube-On-Prem/              # SonarQube 코드 품질 분석
│   ├── 09-Nexus-Repository-On-Prem/       # Nexus 아티팩트 저장소
│   ├── 10-Drone-CI-On-Prem/               # Drone CI 경량 파이프라인
│   └── 11-Integrated-DevSecOps-Lab/       # 전체 스택 통합 실습 (Traefik·Keycloak·Vault·Trivy·Prometheus·Grafana·Loki)
│
├── ai-tools/                              # AI 환경 구축 (설치 순서대로 넘버링)
│   ├── README.md                          # 단계별 마스터 가이드
│   ├── 01-llm-server/                     # Step 1: Ollama LLM 서버 (RTX 3080 GPU)
│   ├── 02-vector-db/                      # Step 2: Vector DB (Qdrant·pgvector·Chroma·Weaviate)
│   ├── 03-webui/                          # Step 3: Open WebUI 브라우저 채팅 UI
│   ├── 04-rag-stack/                      # Step 4: 통합 RAG 스택 (Ollama+Qdrant+WebUI)
│   └── 05-ai-dev-container/               # Step 5: AI 응용 개발 컨테이너 (Python·Jupyter·FastAPI)
│
├── _shared-advanced-core/                 # Advanced 과정 공용 리소스 (12~20장 내용 포함)
│   ├── labs/
│   │   ├── day01/  → Docker 개요 & 첫 걸음
│   │   ├── day02/  → 컨테이너 심화 (프로세스/자원/IO)
│   │   ├── day03/  → Dockerfile & 이미지 빌드
│   │   ├── day04/  → 이미지 최적화 (멀티스테이지)
│   │   ├── day05/  → 네트워킹 (브리지/DNS/통신)
│   │   ├── day06/  → 스토리지 & 백업/복구
│   │   ├── day07/  → Compose 실전
│   │   ├── day08/  → 디버깅 & 운영
│   │   └── day09/  → Jenkins CI 파이프라인
│   ├── capstone/                          # 캡스톤 프로젝트
│   ├── docs/                              # 강의 문서
│   └── templates/                         # 공용 템플릿
│
├── _shared-onprem-core/                   # OnPrem 솔루션 공용 리소스 (21~25장 내용 포함)
│   ├── solutions/
│   │   ├── odoo/     → Odoo ERP
│   │   ├── erpnext/  → ERPNext
│   │   ├── tryton/   → Tryton
│   │   ├── taiga/    → Taiga (프로젝트 관리)
│   │   └── zulip/    → Zulip (팀 메시지)
│   ├── captures/                          # 실습 캡처 이미지
│   ├── docker/                            # 공용 DB 초기화·인증 스크립트
│   └── scripts/                           # 오케스트레이션 스크립트
│
```

---

## 1. 시작 전 준비사항

> [!IMPORTANT]
> 실습을 시작하기 전에 아래 항목을 모두 확인하세요. 기술 스택 이해도와 PC 사양에 따라 진행 가능한 단계가 달라집니다.

---

### 0-1. 개인별 습득해야 할 기술 스택

#### <i class="fa-solid fa-circle" style="color:#22c55e;"></i> 기초 — `docker-basics/` (01~05장 필수)

| 영역 | 필요 역량 | 참고 자료 |
|---|---|---|
| CLI / 터미널 | 명령줄 기본 사용법 (pwd, ls, cd, cat, grep 등) | [Linux 기초 명령어](https://ubuntu.com/tutorials/command-line-for-beginners) |
| Git | clone, add, commit, push, pull 기본 흐름 | [Git 공식 문서](https://git-scm.com/doc) |
| Linux 기초 | 파일 권한, 환경변수, 프로세스, 패키지 관리(apt/yum) | — |
| 네트워크 기초 | IP, 포트, DNS, TCP/UDP 개념 이해 | — |
| Docker 기초 | 이미지/컨테이너/볼륨/네트워크 개념, Dockerfile 문법 | [Docker 공식 튜토리얼](https://docs.docker.com/get-started/) |

#### <i class="fa-solid fa-circle" style="color:#eab308;"></i> 중급 — `devsecops-on-prem/` (06~11장) + `_shared-advanced-core/labs/` (Advanced day01~09)

| 영역 | 필요 역량 |
|---|---|
| Docker Compose | `docker-compose.yml` 작성, 멀티 컨테이너 의존 관계 제어 |
| CI/CD 개념 | 파이프라인 단계(빌드→테스트→배포), Webhook 트리거 이해 |
| Jenkins | Declarative Pipeline(Jenkinsfile) 작성 기초 |
| GitLab | 브랜치 전략, Merge Request, CI/CD 연동 개념 |
| SonarQube | 품질 게이트, 코드 커버리지 개념 |
| Nexus / Harbor | 아티팩트·이미지 저장소 구조 이해 |
| 역방향 프록시 | Traefik / Nginx 라우팅, TLS 종료 개념 |
| 보안 기초 | 시크릿 관리(Vault), SSO(Keycloak), 이미지 취약점 스캔(Trivy) |
| 모니터링 | Prometheus 메트릭 수집, Grafana 대시보드, Loki 로그 집계 |

#### <i class="fa-solid fa-circle" style="color:#ef4444;"></i> 심화 — `_shared-onprem-core/solutions/` (21~25장) + `ai-tools/` (27~28장, 선택)

| 영역 | 필요 역량 |
|---|---|
| ERP 솔루션 운영 | Odoo, ERPNext, Tryton 기본 아키텍처 이해 |
| Python 기초 | 스크립트 작성, 패키지 관리(pip), 가상환경(venv) |
| AI / LLM 기초 | 임베딩, 벡터 유사도, RAG(Retrieval-Augmented Generation) 개념 |
| Vector DB | Qdrant, Chroma, Weaviate, pgvector 기본 사용법 |
| sLLM 서빙 | Ollama 모델 Pull·서빙, REST API 호출, GPU 드라이버 설정 |

---

### 0-2. 권장 PC 사양

> [!NOTE]
> 단계별 실습 범위에 따라 필요한 사양이 크게 다릅니다. 아래 표를 기준으로 자신의 진행 범위를 확인하세요.

#### 단계별 최소 / 권장 사양

| 실습 단계 | 최소 CPU | 최소 RAM | 최소 디스크 | 권장 RAM | 권장 디스크 | 비고 |
|---|---:|---:|---:|---:|---:|---|
| **01~05장** (Docker 기초) | 4코어 | 8 GB | 50 GB | 16 GB | 100 GB | Docker Desktop 구동 기준 |
| **06~10장** (핵심 On-Prem 스택) | 8코어 | 16 GB | 400 GB | 32 GB | 600 GB | GitLab 단독 최소 8 GB RAM |
| **11장** (통합 DevSecOps Lab) | 8코어 | 32 GB | 300 GB | 64 GB | 500 GB | 전체 프로파일 동시 기동 기준 |
| **Advanced day01~09** (`_shared-advanced-core/labs/`) | 8코어 | 16 GB | 200 GB | 32 GB | 400 GB | Compose 멀티 컨테이너 구동 |
| **OnPrem 솔루션** (`_shared-onprem-core/solutions/`) | 8코어 | 16 GB | 200 GB | 32 GB | 400 GB | Odoo/ERPNext DB 포함 |
| **27장** (Vector DB) | 4코어 | 8 GB | 50 GB | 16 GB | 100 GB | 경량 Vector DB 실습 |
| **28장** (sLLM 서빙, CPU) | 8코어 | 16 GB | 100 GB | 32 GB | 200 GB | gemma3:2b 기준 |
| **28장** (sLLM 서빙, GPU) | 8코어 | 32 GB | 200 GB | 64 GB | 500 GB | NVIDIA GPU 8 GB VRAM 이상 |

#### OS별 설치 환경

| 운영체제 | 권장 설정 |
|---|---|
| **Windows 10/11** | WSL 2 + Docker Desktop 최신 버전, RAM 16 GB 이상 권장 |
| **macOS (Intel)** | Docker Desktop for Mac, Rosetta 비활성화 권장 |
| **macOS (Apple Silicon / M1~M4)** | Docker Desktop ARM 빌드, `platform: linux/amd64` 에뮬레이션 주의 |
| **Ubuntu 22.04 LTS** | Docker Engine + Docker Compose Plugin 직접 설치, WSL 불필요 |

> [!TIP]
> **전체 커리큘럼(01~28장)을 모두 진행하려면** CPU 12코어 이상, RAM 32 GB 이상, NVMe SSD 1 TB 이상을 권장합니다.
> 클라우드 VM(AWS EC2, GCP Compute, Azure VM)을 활용하면 로컬 사양 제약을 해결할 수 있습니다.

---

### 0-3. 가입해야 할 플랫폼

| 플랫폼 | 용도 | 무료 플랜 여부 | 가입 URL |
|---|---|---|---|
| **Docker Hub** | 이미지 Pull/Push, 공개 레지스트리 | <i class="fa-solid fa-circle-check"></i> 무료 (Pull 제한 있음) | [hub.docker.com](https://hub.docker.com) |
| **GitHub** | 선수 repo(`edumgt-lab-init`) 및 소스 관리 | <i class="fa-solid fa-circle-check"></i> 무료 | [github.com](https://github.com) |
| **GitLab.com** (선택) | 클라우드 GitLab 연습용 (로컬 CE와 병행 가능) | <i class="fa-solid fa-circle-check"></i> 무료 (Free tier) | [gitlab.com](https://gitlab.com) |
| **SonarCloud** (선택) | 공개 저장소 코드 품질 분석 클라우드판 | <i class="fa-solid fa-circle-check"></i> 오픈소스 무료 | [sonarcloud.io](https://sonarcloud.io) |
| **Hugging Face** (선택) | sLLM 모델 다운로드 (28장) | <i class="fa-solid fa-circle-check"></i> 무료 | [huggingface.co](https://huggingface.co) |
| **AWS / GCP / Azure** (선택) | 클라우드 VM에서 온프레미스 실습 환경 구성 | <i class="fa-solid fa-circle-xmark"></i> 유료 (프리 티어 한정 무료) | 각 클라우드 콘솔 참고 |

> [!NOTE]
> **로컬 PC에서만 실습**하는 경우 Docker Hub와 GitHub 계정만으로도 01~28장 전 과정을 진행할 수 있습니다.

---

### 0-4. 예상 비용 (카드 청구 예상금액)

#### 로컬 PC 실습 (클라우드 미사용)

| 항목 | 예상 비용 | 비고 |
|---|---|---|
| Docker Hub (Personal) | **무료** | Pull 횟수 제한 있음 (6시간당 100회) |
| Docker Hub (Pro) | **$9/월** ≈ 13,000원/월 | 무제한 Pull, 개인 레지스트리 무제한 | 
| GitHub | **무료** | 공개/비공개 저장소 모두 무료 |
| GitLab.com (Free) | **무료** | CI 월 400분 무료 제공 |
| 전기 요금 | **약 5,000~20,000원/월** | 24시간 상시 운영 기준, PC 소비전력·전기요금에 따라 상이 |
| **소계 (기본)** | **월 0~22,000원** | Docker Hub 무료 티어 사용 시 실질 비용 최소화 가능 |

#### 클라우드 VM 활용 (선택)

> [!WARNING]
> 아래 비용은 2025년 기준 대략적인 추정치이며, 사용 시간·리전·옵션에 따라 달라집니다. 반드시 각 클라우드 콘솔의 요금 계산기를 사용해 정확한 금액을 확인하세요.

| 시나리오 | AWS EC2 예시 | GCP Compute 예시 | Azure VM 예시 | 월 예상 비용 |
|---|---|---|---|---|
| **기초 실습 전용** (01~05장) | t3.medium (2vCPU/4GB) | e2-medium (2vCPU/4GB) | B2s (2vCPU/4GB) | 약 **25,000~40,000원/월** |
| **핵심 On-Prem 스택** (06~11장) | m6i.2xlarge (8vCPU/32GB) | n2-standard-8 (8vCPU/32GB) | D8s v5 (8vCPU/32GB) | 약 **200,000~350,000원/월** |
| **전체 통합 실습** (01~28장) | m6i.4xlarge (16vCPU/64GB) + SSD 1TB | n2-standard-16 (16vCPU/64GB) | D16s v5 (16vCPU/64GB) | 약 **500,000~900,000원/월** |
| **sLLM GPU 서빙** (28장) | g4dn.xlarge (4vCPU/16GB, T4 GPU) | n1-standard-4 + T4 GPU | NC4as T4 v3 | 약 **150,000~350,000원/월** |

#### 비용 절감 팁

- **스팟/프리엠티블 인스턴스** 활용: AWS Spot, GCP Preemptible은 On-Demand 대비 60~80% 저렴합니다.
- **실습 후 즉시 중지**: VM을 사용하지 않을 때 중지(Stop)하면 컴퓨팅 비용이 발생하지 않습니다(스토리지 비용은 유지).
- **프리 티어 활용**: AWS 신규 계정은 12개월간 t2.micro(1vCPU/1GB) 무료 제공. 기초 실습(01~05장) 진행 가능.
- **Docker Hub 풀 제한 우회**: 로컬 Nexus Repository(09장)를 구축하면 Pull 횟수 제한 없이 이미지를 캐싱할 수 있습니다.
- **GitLab CE 자체 호스팅**: GitLab.com CI 무료 400분 한계를 우회하려면 07장에서 로컬 GitLab CE를 구축하세요.

#### 전체 커리큘럼 완주 시 예상 총비용

| 환경 | 기간 | 예상 총비용 |
|---|---|---|
| 로컬 PC (스펙 충족 시) | 1~3개월 | **5,000~60,000원** (전기 요금만) |
| 클라우드 (핵심 스택 위주) | 1~3개월 | **300,000~1,000,000원** |
| 클라우드 (전체 + GPU) | 1~3개월 | **1,000,000~3,000,000원** |

> [!TIP]
> 비용 부담을 최소화하려면 **로컬 PC(RAM 32 GB 이상)**를 우선 활용하고, GPU가 필요한 28장만 클라우드 GPU 인스턴스를 단기 사용하는 방식을 권장합니다.

---

## 2. 학습 로드맵

### Docker 기초 — `docker-basics/`

| 단계 | 주제 | 이동 |
|---|---|---|
| 01 | Docker 소개 | [01-Docker-Introduction](./docker-basics/01-Docker-Introduction/README.md) |
| 02 | Docker 설치 | [02-Docker-Installation](./docker-basics/02-Docker-Installation/README.md) |
| 03 | Docker Hub 이미지 Pull/Run | [03-Pull-from-DockerHub-and-Run-Docker-Images](./docker-basics/03-Pull-from-DockerHub-and-Run-Docker-Images/README.md) |
| 04 | 이미지 Build/Run/Push | [04-Build-new-Docker-Image-and-Run-and-Push-to-DockerHub](./docker-basics/04-Build-new-Docker-Image-and-Run-and-Push-to-DockerHub/README.md) |
| 05 | 핵심 Docker 명령어 | [05-Essential-Docker-Commands](./docker-basics/05-Essential-Docker-Commands/README.md) |

### DevSecOps On-Prem 도구 — `devsecops-on-prem/`

| 단계 | 주제 | 이동 |
|---|---|---|
| 06 | Jenkins 온프레미스 구축 | [06-Jenkins-Server-On-Prem](./devsecops-on-prem/06-Jenkins-Server-On-Prem/README.md) |
| 07 | GitLab CE 온프레미스 구축 | [07-GitLab-CE-On-Prem](./devsecops-on-prem/07-GitLab-CE-On-Prem/README.md) |
| 08 | SonarQube 온프레미스 구축 | [08-SonarQube-On-Prem](./devsecops-on-prem/08-SonarQube-On-Prem/README.md) |
| 09 | Nexus Repository 온프레미스 구축 | [09-Nexus-Repository-On-Prem](./devsecops-on-prem/09-Nexus-Repository-On-Prem/README.md) |
| 10 | Drone CI 온프레미스 구축 | [10-Drone-CI-On-Prem](./devsecops-on-prem/10-Drone-CI-On-Prem/README.md) |
| 11 | 통합 DevSecOps Lab | [11-Integrated-DevSecOps-Lab](./devsecops-on-prem/11-Integrated-DevSecOps-Lab/README.md) |

### Advanced 심화 과정 — `_shared-advanced-core/labs/`

| 단계 | 주제 | 이동 |
|---|---|---|
| Advanced Day01 | Docker 개요 & 첫 걸음 | [day01](./\_shared-advanced-core/labs/day01/README.md) |
| Advanced Day02 | 컨테이너 심화 (프로세스/자원/IO) | [day02](./\_shared-advanced-core/labs/day02/README.md) |
| Advanced Day03 | 이미지 빌드 기초 (Dockerfile) | [day03](./\_shared-advanced-core/labs/day03/README.md) |
| Advanced Day04 | 이미지 최적화 (멀티스테이지) | [day04](./\_shared-advanced-core/labs/day04/README.md) |
| Advanced Day05 | 네트워킹 (브리지/DNS/통신) | [day05](./\_shared-advanced-core/labs/day05/README.md) |
| Advanced Day06 | 스토리지 & 백업/복구 | [day06](./\_shared-advanced-core/labs/day06/README.md) |
| Advanced Day07 | Compose 실전 | [day07](./\_shared-advanced-core/labs/day07/README.md) |
| Advanced Day08 | 디버깅 & 운영 | [day08](./\_shared-advanced-core/labs/day08/README.md) |
| Advanced Day09 | Jenkins CI 파이프라인 | [day09](./\_shared-advanced-core/labs/day09/README.md) |

### OnPrem ERP/협업 솔루션 — `_shared-onprem-core/solutions/`

| 단계 | 솔루션 | 이동 |
|---|---|---|
| 21 | Odoo ERP | [odoo](./\_shared-onprem-core/solutions/odoo/README.md) |
| 22 | ERPNext | [erpnext](./\_shared-onprem-core/solutions/erpnext/README.md) |
| 23 | Tryton | [tryton](./\_shared-onprem-core/solutions/tryton/README.md) |
| 24 | Taiga (프로젝트 관리) | [taiga](./\_shared-onprem-core/solutions/taiga/README.md) |
| 25 | Zulip (팀 메시지) | [zulip](./\_shared-onprem-core/solutions/zulip/README.md) |

### AI 환경 구축 — `ai-tools/` (설치 순서)

| 단계 | 주제 | 이동 |
|---|---|---|
| Step 1 | Ollama LLM 서버 (RTX 3080 GPU) | [01-llm-server](./ai-tools/01-llm-server/README.md) |
| Step 2 | Vector DB (Qdrant·pgvector·Chroma·Weaviate) | [02-vector-db](./ai-tools/02-vector-db/README.md) |
| Step 3 | Open WebUI 브라우저 채팅 UI | [03-webui](./ai-tools/03-webui/README.md) |
| Step 4 | 통합 RAG 스택 (Ollama+Qdrant+WebUI) | [04-rag-stack](./ai-tools/04-rag-stack/README.md) |
| Step 5 | AI 응용 개발 컨테이너 (Python·Jupyter·FastAPI) | [05-ai-dev-container](./ai-tools/05-ai-dev-container/README.md) |

---

## 3. Docker Desktop 빠른 제어

### CLI
```bash
# 상태 확인 (4.37+)
docker desktop status

# 시작 / 재시작 / 중지
docker desktop start
docker desktop restart
docker desktop stop

# 로그 확인
docker desktop logs
```

### PowerShell
```powershell
# Docker Desktop 관련 프로세스 종료
Get-Process "*docker*" -ErrorAction SilentlyContinue | Stop-Process -Force

# Docker Desktop UI 재실행
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

---

## 4. 아키텍처 개요

### 핵심 플랫폼 레이어
| 레이어 | 구성 요소 |
|---|---|
| Container Runtime | Docker Engine |
| SCM | GitLab CE |
| CI | Jenkins, Drone CI |
| Quality Gate | SonarQube |
| Artifact Registry | Nexus Repository OSS (또는 Docker Hub/Harbor) |
| Runtime Workload | Nginx, Spring Boot 등 |

### 표준 흐름 (Reference Flow)
1. 개발자가 GitLab CE에 코드 Push
2. Jenkins 또는 Drone CI 파이프라인 실행
3. SonarQube 품질 검사 수행
4. Docker 이미지 빌드 후 Nexus(또는 Docker Hub)로 Push
5. 운영 노드가 이미지 Pull 후 배포

> [!TIP]
> 기본 체인은 `GitLab -> Jenkins/Drone -> SonarQube -> Nexus -> Docker Runtime` 으로 이해하면 됩니다.

### 권장 네트워크 존
- `Zone 1 (Dev)`: 개발자 PC, 로컬 Docker
- `Zone 2 (CI)`: GitLab, Jenkins/Drone, SonarQube
- `Zone 3 (Artifact)`: Nexus/Harbor
- `Zone 4 (Runtime)`: 서비스 컨테이너 실행 노드
- `Zone 5 (Ops)`: 모니터링, 로깅, 백업, 보안

권장 정책:
- CI Zone -> Artifact Zone: Push 허용
- Runtime Zone -> Artifact Zone: Pull 허용
- Dev Zone -> Runtime Zone: 직접 접근 제한

---

## 5. 온프렘 최소 자원 산정

> [!IMPORTANT]
> 아래 수치는 단일 노드 실습/PoC 최소 기준입니다. 운영 환경은 최소 1.5~2배 여유 자원을 권장합니다.

### 기준 범위
- 06~10장: Jenkins, GitLab CE, SonarQube, Nexus, Drone
- 11장: Integrated DevSecOps Lab (`docker-compose.yml`) 기본/선택 프로파일
- 기준 파일:
  - `devsecops-on-prem/06-Jenkins-Server-On-Prem/Dockerfile`
  - `devsecops-on-prem/07-GitLab-CE-On-Prem/Dockerfile`
  - `devsecops-on-prem/08-SonarQube-On-Prem/Dockerfile`
  - `devsecops-on-prem/09-Nexus-Repository-On-Prem/Dockerfile`
  - `devsecops-on-prem/10-Drone-CI-On-Prem/Dockerfile`
  - `devsecops-on-prem/11-Integrated-DevSecOps-Lab/docker-compose.yml`

### 이미지별 최소 컴퓨팅 자원
| 구분 | Docker 이미지 | 최소 vCPU | 최소 RAM | 최소 디스크(볼륨) | 비고 |
|---|---|---:|---:|---:|---|
| CI | `jenkins/jenkins:lts-jdk17` | 2 | 4 GB | 50 GB | 플러그인/워크스페이스 증가 고려 |
| SCM | `gitlab/gitlab-ce:17.5.2-ce.0` | 4 | 8 GB | 100 GB | 실무 최소 여유 반영 |
| Code Quality | `sonarqube:community` | 2 | 4 GB | 50 GB | 운영은 외부 PostgreSQL 연동 권장 |
| Artifact | `sonatype/nexus3:3.70.1` | 2 | 4 GB | 100 GB | Blob 저장 증가 유의 |
| CI (경량) | `drone/drone:2` | 1 | 1 GB | 20 GB | Runner 별도 산정 필요 |
| Reverse Proxy | `traefik:v3.1` | 1 | 1 GB | 10 GB | 인증서/액세스 로그 포함 |
| DB | `postgres:16` | 1 | 2 GB | 20 GB | Keycloak 백엔드 DB |
| IAM | `quay.io/keycloak/keycloak:25.0.5` | 1 | 2 GB | 10 GB | 사용자 증가 시 확장 필요 |
| Secrets | `hashicorp/vault:1.17` | 1 | 1 GB | 10 GB | 레포는 Dev 모드 |
| Scanner | `aquasec/trivy:0.56.2` | 1 | 1 GB | 10 GB | 스캔 시 순간 부하 증가 |
| Metrics | `prom/prometheus:v2.54.1` | 2 | 2 GB | 30 GB | 보관 기간에 비례해 디스크 증가 |
| Alert | `prom/alertmanager:v0.27.0` | 1 | 1 GB | 5 GB | 알림 라우팅 |
| Dashboard | `grafana/grafana:11.2.2` | 1 | 1 GB | 10 GB | 대시보드/플러그인 저장 |
| Logs | `grafana/loki:3.1.1` | 2 | 2 GB | 30 GB | 로그 보관 정책 핵심 |
| Log Agent | `grafana/promtail:3.1.1` | 1 | 1 GB | 5 GB | 호스트 로그 수집 |
| Private CA (옵션) | `smallstep/step-ca:0.27.4` | 1 | 1 GB | 5 GB | `private-ca` profile |
| Harbor DB (옵션) | `goharbor/harbor-db:v2.11.1` | 1 | 2 GB | 20 GB | `harbor` profile |
| Harbor Redis (옵션) | `goharbor/redis-photon:v2.11.1` | 1 | 1 GB | 10 GB | `harbor` profile |
| Harbor Registry (옵션) | `goharbor/registry-photon:v2.11.1` | 2 | 2 GB | 80 GB | `harbor` profile |

### 합산 최소 사양 (단일 노드)
| 시나리오 | 최소 vCPU 합계 | 최소 RAM 합계 | 최소 디스크 합계 |
|---|---:|---:|---:|
| 06~10장 핵심 스택 (Jenkins+GitLab+Sonar+Nexus+Drone) | 11 | 21 GB | 320 GB |
| 11장 기본 프로파일 (Traefik~Promtail) | 12 | 14 GB | 140 GB |
| 11장 + `private-ca` + `harbor` 프로파일 | 17 | 20 GB | 255 GB |

추가 권장 오버헤드: `2 vCPU`, `4 GB RAM`, `30 GB` (호스트 OS + Docker)

---

## 6. 운영 고도화 확장 스택

### 보안/접근제어
- Keycloak: SSO 및 중앙 인증
- HashiCorp Vault: 비밀정보 중앙관리
- Trivy: 이미지 취약점 스캔 자동화

### 관측성
- Prometheus + Grafana: 메트릭/대시보드
- Loki + Promtail (또는 EFK/ELK): 로그 수집/분석
- Alertmanager: 알림 자동화

### 네트워크/트래픽
- Traefik / Nginx Proxy Manager: 리버스 프록시, TLS 종료
- 사설 CA 기반 인증서 운영 전략 수립

### 이미지 거버넌스
- Harbor: 내부 레지스트리 + 취약점 스캔 + 정책
- Nexus와 병행 또는 대체 가능

### 백업/DR
- GitLab, SonarQube, Nexus 볼륨/DB 정기 백업
- MinIO 등 오브젝트 스토리지 기반 보관

---

## 7. 통합 의존관계 다이어그램

```mermaid
flowchart LR
  subgraph Core["06~10 Core On-Prem Stack"]
    DEV[Developer]
    GITLAB["gitlab/gitlab-ce"]
    JENKINS["jenkins/jenkins"]
    DRONE["drone/drone"]
    SONAR["sonarqube:community"]
    NEXUS["sonatype/nexus3"]
    RUNTIME[Docker Runtime Host]

    DEV -->|Push| GITLAB
    GITLAB -->|Webhook Trigger| JENKINS
    GITLAB -->|Webhook Trigger| DRONE
    JENKINS -->|Quality Scan| SONAR
    DRONE -->|Quality Scan| SONAR
    JENKINS -->|Build Push Image| NEXUS
    DRONE -->|Build Push Image| NEXUS
    RUNTIME -->|Pull Image| NEXUS
  end

  subgraph Lab["11 Integrated DevSecOps Lab"]
    TRAEFIK["traefik:v3.1"]
    POSTGRES["postgres:16"]
    KEYCLOAK["keycloak:25.0.5"]
    VAULT["vault:1.17"]
    TRIVY["trivy:0.56.2"]
    PROM["prometheus:v2.54.1"]
    ALERT["alertmanager:v0.27.0"]
    GRAFANA["grafana:11.2.2"]
    LOKI["loki:3.1.1"]
    PROMTAIL["promtail:3.1.1"]
    STEPCA["step-ca:0.27.4 profile"]
    HDB["harbor-db:v2.11.1 profile"]
    HREDIS["harbor-redis:v2.11.1 profile"]
    HREG["harbor-registry:v2.11.1 profile"]

    KEYCLOAK -->|DB| POSTGRES
    GRAFANA -->|Query Metrics| PROM
    GRAFANA -->|Query Logs| LOKI
    PROMTAIL -->|Ship Logs| LOKI
    PROM -->|Alert Route| ALERT

    TRAEFIK -->|Route| KEYCLOAK
    TRAEFIK -->|Route| VAULT
    TRAEFIK -->|Route| PROM
    TRAEFIK -->|Route| GRAFANA
    TRAEFIK -->|Route| HREG

    HREG -->|Metadata State| HDB
    HREG -->|Cache Queue| HREDIS
    STEPCA -->|Internal TLS optional| TRAEFIK
    TRIVY -->|Image Scan Target| HREG
  end
```

산정 가정:
- 단일 Docker Host 최소 실습 기준
- HA/장기보관/대규모 부하는 미반영
- 디스크는 GitLab/SonarQube/Nexus부터 우선 확장 고려

---

## 8. WSL 포트 80 트러블슈팅

### 1) 점유 프로세스 확인
```bash
# LISTEN 중인 80 포트 프로세스
sudo ss -ltnp 'sport = :80'

# 프로세스/사용자/FD 상세 확인
sudo lsof -iTCP:80 -sTCP:LISTEN -n -P
```

### 2) 점유 프로세스 종료
```bash
# 방법 A: 서비스 종료 (예: nginx)
sudo systemctl stop nginx 2>/dev/null || sudo service nginx stop

# 방법 B: PID 강제 종료 (예시)
sudo kill -9 197
```

### 3) 해제 확인
```bash
sudo ss -ltnp 'sport = :80'
```

> [!WARNING]
> `kill -9`는 마지막 수단으로만 사용하고, 가능하면 서비스 정상 종료를 우선 사용하세요.

---

## 9. Docker 이미지 목록

| 애플리케이션 | Docker 이미지 |
|---|---|
| Nginx | `nginx` |
| 커스텀 Nginx | `stacksimplify/mynginx_image1` |
| Spring Boot HelloWorld | `stacksimplify/dockerintro-springboot-helloworld-rest-api` |
| Jenkins LTS | `jenkins/jenkins:lts-jdk17` |
| GitLab CE | `gitlab/gitlab-ce:17.5.2-ce.0` |
| SonarQube Community | `sonarqube:community` |
| Nexus Repository OSS | `sonatype/nexus3:3.70.1` |
| Drone CI | `drone/drone:2` |
| Ollama | `ollama/ollama:latest` |
| Open WebUI | `ghcr.io/open-webui/open-webui:main` |

---

## 10. 대상 독자와 도입 로드맵

### 활용 대상
- Docker를 처음 학습하는 엔지니어
- 온프레미스 DevOps/Platform 구축을 시작하는 팀
- 도구 간 연결 구조를 빠르게 파악하려는 Solution Architect

### 단계별 도입
1. **Phase 1 (기본기/PoC)**
   - 1~10 단계 실습 완료
   - Jenkins/Drone 중 표준 CI 1개 선정
2. **Phase 2 (표준화)**
   - 브랜치 전략, 파이프라인 템플릿, Sonar 품질 게이트 표준화
   - Nexus 저장소 구조(팀/환경별) 정리
3. **Phase 3 (운영 안정화)**
   - 모니터링/로그/알림 연계
   - 백업/복구 리허설 및 장애 대응 Runbook 작성
4. **Phase 4 (보안 고도화)**
   - SSO, 비밀정보 중앙관리, 이미지 스캔/서명 정책 도입

---

## 11. 확장 커리큘럼 맵

난이도 순 확장 실습 구조:
- `_shared-advanced-core/labs/day01~09`: Advanced 심화 과정 (구 12~20장)
- `_shared-onprem-core/solutions/`: OnPrem ERP/협업 솔루션 (구 21~25장)
- `ai-tools/01-llm-server`: Ollama LLM 서버 (RTX 3080 GPU 서빙)
- `ai-tools/02-vector-db`: Qdrant·pgvector·Chroma·Weaviate Vector DB
- `ai-tools/03-webui`: Open WebUI 브라우저 채팅 UI
- `ai-tools/04-rag-stack`: 통합 RAG 스택 (Ollama+Qdrant+WebUI)
- `ai-tools/05-ai-dev-container`: AI 응용 개발 컨테이너 (Python·Jupyter·FastAPI)

### Advanced 심화 파트 — `_shared-advanced-core/labs/`
| 폴더 | 핵심 주제 |
|---|---|
| `day01` | Docker 기초/첫 실행 |
| `day02` | 프로세스/자원/IO |
| `day03` | Dockerfile/이미지 빌드 |
| `day04` | 멀티스테이지/최적화 |
| `day05` | 브리지/DNS/통신 |
| `day06` | 볼륨/백업/복구 |
| `day07` | Compose 실전 |
| `day08` | 장애 분석/Runbook |
| `day09` | CI 파이프라인 |

### OnPrem 솔루션 파트 — `_shared-onprem-core/solutions/`
| 폴더 | 솔루션 |
|---|---|
| `odoo` | Odoo ERP |
| `erpnext` | ERPNext |
| `tryton` | Tryton |
| `taiga` | Taiga (프로젝트 관리) |
| `zulip` | Zulip (팀 메시지) |

### AI 환경 구축 파트 — `ai-tools/`
| 폴더 | 핵심 주제 |
|---|---|
| `01-llm-server` | Ollama GPU 서빙 (RTX 3080, 포트 11435) |
| `02-vector-db` | Qdrant·pgvector·Chroma·Weaviate Vector DB |
| `03-webui` | Open WebUI 브라우저 채팅 UI (포트 3000) |
| `04-rag-stack` | 통합 RAG 스택 — Ollama+Qdrant+WebUI 한 번에 기동 |
| `05-ai-dev-container` | AI 응용 개발 — Python·JupyterLab·FastAPI·RAG 라이브러리 |

---

## 12. 공용 리소스 폴더

Advanced 과정과 OnPrem 솔루션의 정식 파일은 아래 공용 폴더에 통합 관리합니다.

- `_shared-advanced-core/`
  - `labs/day01~09`: Advanced 심화 과정 실습 파일 (구 12~20장과 동일 내용)
  - `capstone/`: 캡스톤 프로젝트
  - `docs/`: 강의 문서
  - `templates/`: 공용 Dockerfile·Compose 템플릿
- `_shared-onprem-core/`
  - `solutions/odoo|erpnext|tryton|taiga|zulip`: OnPrem 솔루션별 실습 파일 (구 21~25장과 동일 내용)
  - `docker/`: 공용 DB 초기화·인증 스크립트
  - `scripts/`: 오케스트레이션 스크립트 (start/stop/sync)
  - `captures/`: 실습 캡처 이미지

---

## 13. Vector DB 원리와 Docker 실습

### Vector DB 핵심 원리
- **임베딩(Vectorization)**: 텍스트/이미지 등을 고정 길이 벡터로 변환해 의미 유사성을 수치화합니다.
- **인덱싱(ANN)**: HNSW/IVF 같은 근사 최근접 탐색 인덱스로 대규모 벡터에서 빠르게 Top-K를 찾습니다.
- **유사도 계산**: Cosine, Dot Product, Euclidean 거리로 질의 벡터와 저장 벡터의 유사도를 평가합니다.
- **메타데이터 필터**: 태그/시간/권한 같은 조건을 함께 걸어 검색 범위를 줄입니다.
- **RAG 연결**: 검색된 문서를 LLM 프롬프트 컨텍스트로 주입해 환각을 줄이고 근거 기반 답변을 만듭니다.

### 왜 Docker로 실습하나?
- 설치 복잡도를 줄이고, 서비스별 버전을 고정하여 재현 가능한 실습 환경을 만듭니다.
- 로컬 노트북/서버 어디서든 동일 명령으로 기동/중지/정리할 수 있습니다.

### 경량 오픈소스 Vector DB Docker 예제
- Qdrant
- Chroma
- Weaviate
- pgvector (PostgreSQL 확장)

실습 경로: [`02-vector-db`](./ai-tools/02-vector-db/README.md)

---

## 14. 멀티 모델 & sLLM Docker 서빙

### 개요
Ollama Docker 이미지 하나로 Gemma3, Llama 3, DeepSeek-R1 등 최신 오픈소스 sLLM을 CPU/GPU 환경에서 바로 서빙할 수 있습니다. Open WebUI를 함께 기동하면 브라우저에서 멀티 모델 채팅 환경을 구성할 수 있습니다.

### 핵심 구성 요소
- **Ollama**: 모델 Pull/서빙/REST API 제공 (`/api/generate`, `/api/chat`)
- **Open WebUI**: 브라우저 기반 멀티 모델 채팅 UI (Ollama와 자동 연동)

### 지원 모델 (도메인별 추천)

| 도메인 | 추천 모델 | 특징 |
|---|---|---|
| 범용/교육 | `gemma3:2b`, `gemma3:12b` | Google, 경량~중형 |
| 범용/대화 | `llama3:8b`, `llama3:70b` | Meta, 생태계 최대 |
| 추론/코딩 | `deepseek-r1:7b`, `deepseek-r1:14b` | 추론 특화 |
| 다국어(한국어) | `qwen2.5:7b` | 한국어 강점 |
| 경량/엣지 | `phi4` | Microsoft, 14B |

### 빠른 시작 (RTX 3080 GPU / 포트 11435)

```bash
# Step 1: LLM 서버 (GPU)
cd ai-tools/01-llm-server
docker compose -f docker-compose.gpu.yml up -d

# 모델 Pull (qwen3.5 권장 — VRAM 6.6GB, RTX 3080 완전 처리)
docker exec ollama ollama pull qwen3.5:latest
docker exec ollama ollama pull nomic-embed-text   # 임베딩용

# REST API 테스트 (포트 11435)
curl -s http://localhost:11435/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3.5:latest","prompt":"Docker란 무엇인가?","stream":false}' \
  | python3 -m json.tool

# Step 3: Open WebUI (UI: http://localhost:3000)
cd ../03-webui && docker compose up -d

# 또는 Step 4: 전체 RAG 스택 한 번에
cd ../04-rag-stack && docker compose up -d
```

실습 경로: [`ai-tools/`](./ai-tools/README.md)

---

## 15. Windows WSL·Docker·AI 개발 환경

Windows 학습자는 먼저 [WSL 개발 환경 구축 가이드](./docker-basics/02-Docker-Installation/WSL-Setup.md)로 WSL 2, Ubuntu, VS Code Remote WSL, Docker Desktop 연동을 완료합니다. 저장소는 `/mnt/c/...`보다 WSL 홈의 `~/workspace`에 두는 것을 권장합니다.

AI 응용을 개발할 때는 [AI 응용 개발 컨테이너](./ai-tools/05-ai-dev-container/README.md)를 사용합니다. FastAPI, JupyterLab, LangChain/LangGraph/LlamaIndex, Ollama, Qdrant/Chroma/pgvector 클라이언트, 테스트·정적 분석 도구가 포함되어 있으며, 기존 Ollama·Qdrant RAG 스택과 `shared-net`에서 연결됩니다.

---

## <i class="fa-solid fa-tv"></i> 관련 YouTube 영상

[<i class="fa-solid fa-clapperboard"></i> YouTube에서 관련 영상 검색하기](https://www.youtube.com/results?search_query=Docker+DevSecOps+강의)
