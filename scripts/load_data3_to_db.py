"""
Load every ticker OHLCV CSV in data-3/ into the pg-stock Postgres database
(tickers + ohlcv tables), without creating duplicate rows.

Idempotent by design: ohlcv has PRIMARY KEY (ticker_code, trade_date), and
every insert uses ON CONFLICT (ticker_code, trade_date) DO NOTHING, so
re-running over the same files on every scheduled run never duplicates rows
-- only genuinely new (ticker, date) rows get inserted.

Meant to be invoked hourly (e.g. by load_data3_to_db.sh via cron).
"""
import glob
import os
import re

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values

DATA_DIR = "/home/ubuntu/docker-class/data-3"

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
    required = {"trade_date", "open", "high", "low", "close", "adj_close", "volume"}
    if not required.issubset(df.columns):
        return None
    df = df[list(required)].dropna(subset=["trade_date"])
    return df


def main():
    csv_files = sorted(glob.glob(os.path.join(DATA_DIR, "*.csv")))
    if not csv_files:
        print(f"No CSV files found in {DATA_DIR}.")
        return

    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = False
    cur = conn.cursor()

    total_inserted = 0
    files_processed = 0
    files_skipped = 0

    for path in csv_files:
        code = ticker_code_from_filename(path)
        if not code:
            files_skipped += 1
            print(f"skip (no ticker code found): {os.path.basename(path)}")
            continue

        df = load_csv(path)
        if df is None or df.empty:
            files_skipped += 1
            print(f"skip (unexpected schema/empty): {os.path.basename(path)}")
            continue

        cur.execute(
            """
            INSERT INTO tickers (ticker_code)
            VALUES (%s)
            ON CONFLICT (ticker_code) DO NOTHING
            """,
            (code,),
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
            ON CONFLICT (ticker_code, trade_date) DO NOTHING
            RETURNING 1
            """,
            rows,
            fetch=True,
        )
        inserted = len(result)
        total_inserted += inserted
        files_processed += 1

    conn.commit()
    cur.close()
    conn.close()

    print(f"Files processed: {files_processed}, skipped: {files_skipped}, "
          f"new rows inserted: {total_inserted}")


if __name__ == "__main__":
    main()
