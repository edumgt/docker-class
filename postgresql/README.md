# PostgreSQL (pg-stock)

Docker로 띄우는 종목 OHLCV 저장용 PostgreSQL. `docker-class/scripts/`의 수집·적재 배치 스크립트가 이 컨테이너에 데이터를 저장합니다.

## 목차
- [1. 실행](#1-실행)
- [2. 접속 정보](#2-접속-정보)
- [3. 스키마](#3-스키마)
- [4. PostgreSQL 클라이언트 설치](#4-postgresql-클라이언트-설치)
- [5. 접속 테스트](#5-접속-테스트)
- [6. 트러블슈팅](#6-트러블슈팅)

---

## 1. 실행

```bash
cd postgresql
docker compose up -d
```

- 이미지: `postgres:latest`
- 컨테이너명: `pg-stock`
- 데이터 볼륨: `pg_stock_data` (컨테이너 재생성해도 데이터 유지)
- `.env`로 계정/포트를 바꿀 수 있습니다. 기본값은 `.env.example` 참고.

컨테이너가 뜬 뒤 스키마를 적용합니다 (최초 1회):

```bash
docker exec -i pg-stock psql -U admin -d admin < schema.sql
```

## 2. 접속 정보

| 항목 | 값 |
|---|---|
| Host | `localhost` / `127.0.0.1` |
| Port | `5433` (호스트) → 컨테이너 내부는 5432 |
| User | `admin` |
| Password | `admin1234` |
| Database | `admin` |

> **주의**: 호스트의 기본 PostgreSQL 포트 `5432`는 이미 네이티브로 설치된 다른 PostgreSQL이 쓰고 있을 수 있습니다. 그래서 이 컨테이너는 `5433`으로 노출됩니다. GUI 툴에서 접속할 때 포트를 반드시 `5433`으로 지정하세요.
> **주의**: "데이터베이스 이름"은 컨테이너명(`pg-stock`)이 아니라 `admin`입니다.

## 3. 스키마

`schema.sql` 참고. 종목마다 테이블을 만들지 않고, `tickers`(종목 마스터) + `ohlcv`(전 종목 공용 시세, PK `(ticker_code, trade_date)`) 구조로 수천 개 종목을 감당합니다.

## 4. PostgreSQL 클라이언트 설치

### CLI (`psql`)

```bash
# Ubuntu / Debian (WSL 포함)
sudo apt update
sudo apt install -y postgresql-client

# macOS (Homebrew)
brew install libpq
echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc

# Windows
# https://www.postgresql.org/download/windows/ 에서 설치 프로그램의
# "Command Line Tools"만 선택 설치하면 psql이 함께 설치됩니다.
```

설치 확인:

```bash
psql --version
```

### Python 드라이버 (`psycopg2`)

배치 스크립트(`scripts/load_data3_to_db.py`)가 사용하는 드라이버입니다.

```bash
python3 -m venv venv
source venv/bin/activate       # Windows: venv\Scripts\activate
pip install psycopg2-binary
```

### GUI 클라이언트 (택 1)

| 도구 | 비고 |
|---|---|
| Azure Data Studio + PostgreSQL 확장 | VS Code 계열, "서버 이름/포트/사용자/암호/데이터베이스" 입력 방식 |
| DBeaver | 무료, 크로스플랫폼 |
| pgAdmin 4 | PostgreSQL 공식 GUI |
| TablePlus | 가벼운 유료 GUI (무료 제한 모드 있음) |

## 5. 접속 테스트

```bash
PGPASSWORD=admin1234 psql -h 127.0.0.1 -p 5433 -U admin -d admin -c "SELECT count(*) FROM ohlcv;"
```

Docker 컨테이너 안에서 바로 확인하려면:

```bash
docker exec -it pg-stock psql -U admin -d admin
```

## 6. 트러블슈팅

- **`password authentication failed` (port 5432)**: 5432가 아니라 5433으로 접속해야 합니다. 5432는 호스트에 별도로 설치된 PostgreSQL입니다.
- **`database "pg-stock" does not exist`**: 데이터베이스 이름은 `admin`입니다. `pg-stock`은 컨테이너 이름일 뿐입니다.
- **컨테이너가 즉시 종료(Exited)되고 로그에 `pg_ctlcluster`/`major-version-specific directory` 메시지가 보임**: `postgres:18` 이상 이미지는 볼륨을 `/var/lib/postgresql/data`가 아니라 `/var/lib/postgresql`에 마운트해야 합니다(이 compose 파일은 이미 반영되어 있음).
