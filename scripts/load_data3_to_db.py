"""
Load every ticker OHLCV CSV in data-3/ into the pg-stock Postgres database
(tickers + ohlcv tables), without creating duplicate rows.

Idempotent by design: ohlcv has PRIMARY KEY (ticker_code, trade_date). Existing
rows are updated only when the source value actually changed, so provider
corrections (including adjusted close) are reflected without duplicate rows.

Meant to be invoked hourly (e.g. by load_data3_to_db.sh via cron).
"""
import glob
import os
import re

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

DATA_DIR = "/home/ubuntu/docker-class/data-3"
METADATA_PATH = os.path.join(DATA_DIR, "ticker_metadata.csv")
OHLCV_COLUMNS = ["trade_date", "open", "high", "low", "close", "adj_close", "volume"]

DB_CONFIG = dict(
    host="127.0.0.1",
    port=5433,
    user="admin",
    password="admin1234",
    dbname="admin",
)

TICKER_CODE_RE = re.compile(r"^[0-9A-Za-z]{6}$")


def ticker_code_from_filename(filename):
    stem = os.path.splitext(os.path.basename(filename))[0]
    for part in stem.split("_"):
        if TICKER_CODE_RE.match(part):
            return part
    return None


def load_metadata():
    """Read the current universe snapshot written by the collector."""
    if not os.path.exists(METADATA_PATH):
        return {}
    try:
        df = pd.read_csv(METADATA_PATH, dtype={"ticker_code": str})
        required = {"ticker_code", "name", "market"}
        if not required.issubset(df.columns):
            print("metadata unavailable: required columns are missing")
            return {}
        return {
            str(row.ticker_code).zfill(6): (str(row.name).strip(), str(row.market).strip())
            for row in df[["ticker_code", "name", "market"]].dropna(subset=["ticker_code"]).itertuples(index=False)
        }
    except Exception as exc:
        print(f"metadata unavailable: {exc}")
        return {}


def load_csv(path):
    df = pd.read_csv(path)
    df = df.rename(columns={
        "Date": "trade_date",
        "Open": "open",
        "High": "high",
        "Low": "low",
        "Close": "close",
        "Adj Close": "adj_close",
        "Volume": "volume",
    })
    if not set(OHLCV_COLUMNS).issubset(df.columns):
        return None, [], "unexpected schema"
    df = df[OHLCV_COLUMNS].copy()
    df["trade_date"] = pd.to_datetime(df["trade_date"], errors="coerce").dt.date
    for column in OHLCV_COLUMNS[1:]:
        df[column] = pd.to_numeric(df[column], errors="coerce")
    null_mask = df.isna().any(axis=1)
    invalid_value_mask = (df[["open", "high", "low", "close", "adj_close"]] <= 0).any(axis=1) | (df["volume"] < 0)
    range_mask = (df["high"] < df[["open", "low", "close"]].max(axis=1)) | (df["low"] > df[["open", "high", "close"]].min(axis=1))
    duplicate_mask = df["trade_date"].duplicated(keep=False)
    rejected_mask = null_mask | invalid_value_mask | range_mask | duplicate_mask
    reasons = []
    for _, row in df[rejected_mask].iterrows():
        row_reasons = []
        if null_mask.loc[row.name]: row_reasons.append("null or non-numeric value")
        if invalid_value_mask.loc[row.name]: row_reasons.append("non-positive price or negative volume")
        if range_mask.loc[row.name]: row_reasons.append("OHLC range violation")
        if duplicate_mask.loc[row.name]: row_reasons.append("duplicate trade_date")
        reasons.append((row["trade_date"], "; ".join(row_reasons)))
    valid = df[~rejected_mask].copy()
    if valid.empty:
        return None, reasons, "no valid rows"
    return valid, reasons, None


def ensure_quality_issue_table(cur):
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS ohlcv_data_quality_issues (
            ticker_code VARCHAR(20) NOT NULL,
            trade_date DATE NOT NULL,
            reason TEXT NOT NULL,
            source_file TEXT NOT NULL,
            detected_at TIMESTAMPTZ NOT NULL DEFAULT now(),
            PRIMARY KEY (ticker_code, trade_date, reason)
        )
        """
    )


def main():
    csv_files = sorted(glob.glob(os.path.join(DATA_DIR, "*_ohlcv.csv")))
    if not csv_files:
        print(f"No CSV files found in {DATA_DIR}.")
        return

    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = False
    cur = conn.cursor()
    ensure_quality_issue_table(cur)

    metadata = load_metadata()
    total_inserted = 0
    total_updated = 0
    rejected_rows = 0
    files_processed = 0
    files_skipped = 0

    for path in csv_files:
        code = ticker_code_from_filename(path)
        if not code:
            files_skipped += 1
            print(f"skip (no ticker code found): {os.path.basename(path)}")
            continue

        df, issues, error = load_csv(path)
        if df is None or df.empty:
            files_skipped += 1
            print(f"skip ({error or 'empty'}): {os.path.basename(path)}")
            continue

        if issues:
            execute_values(
                cur,
                """
                INSERT INTO ohlcv_data_quality_issues (ticker_code, trade_date, reason, source_file)
                VALUES %s
                ON CONFLICT (ticker_code, trade_date, reason) DO NOTHING
                """,
                [(code, trade_date, reason, os.path.basename(path)) for trade_date, reason in issues],
            )
            rejected_rows += len(issues)
            print(f"quarantine {len(issues)} row(s): {os.path.basename(path)}")

        name, market = metadata.get(code, (None, None))

        cur.execute(
            """
            INSERT INTO tickers (ticker_code, name, market)
            VALUES (%s, %s, COALESCE(%s, 'UNKNOWN'))
            ON CONFLICT (ticker_code) DO UPDATE
            SET name = COALESCE(EXCLUDED.name, tickers.name),
                market = CASE WHEN EXCLUDED.market = 'UNKNOWN' THEN tickers.market ELSE EXCLUDED.market END
            """,
            (code, name, market),
        )

        rows = [
            (code, r.trade_date, r.open, r.high, r.low, r.close, r.adj_close, r.volume)
            for r in df.itertuples(index=False)
        ]

        result = execute_values(
            cur,
            """
            INSERT INTO ohlcv
                (ticker_code, trade_date, open, high, low, close, adj_close, volume)
            VALUES %s
            ON CONFLICT (ticker_code, trade_date) DO UPDATE
            SET open = EXCLUDED.open, high = EXCLUDED.high, low = EXCLUDED.low,
                close = EXCLUDED.close, adj_close = EXCLUDED.adj_close, volume = EXCLUDED.volume
            WHERE (ohlcv.open, ohlcv.high, ohlcv.low, ohlcv.close, ohlcv.adj_close, ohlcv.volume)
                  IS DISTINCT FROM
                  (EXCLUDED.open, EXCLUDED.high, EXCLUDED.low, EXCLUDED.close, EXCLUDED.adj_close, EXCLUDED.volume)
            RETURNING (xmax = 0) AS inserted
            """,
            rows,
            fetch=True,
        )
        inserted = sum(row[0] for row in result)
        total_updated += len(result) - inserted
        total_inserted += inserted
        files_processed += 1

    conn.commit()
    cur.close()
    conn.close()

    print(f"Files processed: {files_processed}, skipped: {files_skipped}, "
          f"new rows inserted: {total_inserted}, corrected rows updated: {total_updated}, "
          f"quarantined rows: {rejected_rows}")


if __name__ == "__main__":
    main()
