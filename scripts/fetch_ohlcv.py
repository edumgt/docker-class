"""
Gather 2025 (2025-01-01 ~ 2025-12-31) OHLCV data for every KOSPI/KOSDAQ-listed
ticker into data-1/, one CSV per ticker, via yfinance.

Meant to be invoked repeatedly (e.g. once a minute by cron through
fetch_ohlcv_batch.sh). Each run processes a small batch of not-yet-fetched
tickers and remembers where it left off in state/ohlcv_cursor.json, so the
full ticker universe is covered gradually instead of hammering Yahoo Finance
all at once. Tickers that already have a CSV in data-1 are skipped.
"""
import json
import os

import FinanceDataReader as fdr
import yfinance as yf

DATA_DIR = "/home/ubuntu/docker-class/data-1"
STATE_FILE = "/home/ubuntu/docker-class/scripts/state/ohlcv_cursor.json"
BATCH_SIZE = 50
START_DATE = "2025-01-01"
END_DATE = "2026-01-01"  # yfinance end date is exclusive


def load_ticker_list():
    krx = fdr.StockListing("KRX")
    krx = krx[krx["Market"].isin(["KOSPI", "KOSDAQ", "KOSDAQ GLOBAL"])]
    tickers = []
    for _, row in krx.iterrows():
        code = str(row["Code"])
        suffix = ".KS" if row["Market"] == "KOSPI" else ".KQ"
        tickers.append((code, code + suffix))
    tickers.sort(key=lambda t: t[0])
    return tickers


def load_cursor(total):
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE) as f:
            state = json.load(f)
        if state.get("total") == total:
            return state.get("cursor", 0)
    return 0


def save_cursor(cursor, total):
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump({"cursor": cursor, "total": total}, f)


def out_path(code):
    return os.path.join(DATA_DIR, f"{code}_2025_ohlcv.csv")


def already_fetched(code):
    path = out_path(code)
    return os.path.exists(path) and os.path.getsize(path) > 0


def pick_batch(tickers):
    total = len(tickers)
    cursor = load_cursor(total)
    idx = cursor
    scanned = 0
    batch = []
    while len(batch) < BATCH_SIZE and scanned < total:
        code, symbol = tickers[idx]
        if not already_fetched(code):
            batch.append((code, symbol))
        idx = (idx + 1) % total
        scanned += 1
    save_cursor(idx, total)
    return batch


def fetch_and_save(batch):
    symbols = [s for _, s in batch]
    data = yf.download(
        symbols,
        start=START_DATE,
        end=END_DATE,
        group_by="ticker",
        auto_adjust=False,
        threads=True,
        progress=False,
    )

    saved = 0
    for code, symbol in batch:
        try:
            df = data[symbol] if len(symbols) > 1 else data
            df = df.dropna(how="all")
            if df.empty:
                continue
            df.index.name = "Date"
            df.to_csv(out_path(code))
            saved += 1
        except Exception as exc:
            print(f"skip {code} ({symbol}): {exc}")
    return saved


def main():
    tickers = load_ticker_list()
    total = len(tickers)
    batch = pick_batch(tickers)

    if not batch:
        print(f"All {total} tickers already fetched in {DATA_DIR}.")
        return

    saved = fetch_and_save(batch)
    print(f"Requested {len(batch)} tickers, saved {saved} CSVs. "
          f"({total - len(batch)}/{total} previously done or in this batch)")


if __name__ == "__main__":
    main()
