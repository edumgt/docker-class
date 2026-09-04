"""
Gather full-year (Jan 1 ~ Dec 31) OHLCV data for every KOSPI/KOSDAQ-listed
ticker into data-1/, one CSV per ticker per year, via yfinance.

Meant to be invoked repeatedly (e.g. once a minute by cron through
fetch_ohlcv_batch.sh). Each run processes a small batch of not-yet-fetched
tickers for the first not-yet-complete year in YEARS and remembers where it
left off in state/ohlcv_cursor_<year>.json, so the full ticker universe is
covered gradually instead of hammering Yahoo Finance all at once. Once a
year's tickers are all fetched, the next run moves on to the following year.
Tickers that already have a CSV in data-1 are skipped.
"""
import json
import os

import FinanceDataReader as fdr
import yfinance as yf

DATA_DIR = "/home/ubuntu/docker-class/data-1"
STATE_DIR = "/home/ubuntu/docker-class/scripts/state"
BATCH_SIZE = 50
# 2025 first (already in progress), then the rest in chronological order.
YEARS = ["2025", "2020", "2021", "2022", "2023", "2024"]


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


def state_file(year):
    return os.path.join(STATE_DIR, f"ohlcv_cursor_{year}.json")


def load_cursor(year, total):
    path = state_file(year)
    if os.path.exists(path):
        with open(path) as f:
            state = json.load(f)
        if state.get("total") == total:
            return state.get("cursor", 0)
    return 0


def save_cursor(year, cursor, total):
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(state_file(year), "w") as f:
        json.dump({"cursor": cursor, "total": total}, f)


def out_path(code, year):
    return os.path.join(DATA_DIR, f"{code}_{year}_ohlcv.csv")


def already_fetched(code, year):
    path = out_path(code, year)
    return os.path.exists(path) and os.path.getsize(path) > 0


def pick_batch(tickers, year):
    total = len(tickers)
    cursor = load_cursor(year, total)
    idx = cursor
    scanned = 0
    batch = []
    while len(batch) < BATCH_SIZE and scanned < total:
        code, symbol = tickers[idx]
        if not already_fetched(code, year):
            batch.append((code, symbol))
        idx = (idx + 1) % total
        scanned += 1
    save_cursor(year, idx, total)
    return batch


def fetch_and_save(batch, year):
    symbols = [s for _, s in batch]
    data = yf.download(
        symbols,
        start=f"{year}-01-01",
        end=f"{int(year) + 1}-01-01",  # yfinance end date is exclusive
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
            df.to_csv(out_path(code, year))
            saved += 1
        except Exception as exc:
            print(f"skip {code} ({symbol}): {exc}")
    return saved


def pick_year(tickers):
    """First year in YEARS that still has unfetched tickers, or None."""
    total = len(tickers)
    for year in YEARS:
        cursor = load_cursor(year, total)
        idx = cursor
        for _ in range(total):
            code, _ = tickers[idx]
            if not already_fetched(code, year):
                return year
            idx = (idx + 1) % total
    return None


def main():
    tickers = load_ticker_list()
    total = len(tickers)

    year = pick_year(tickers)
    if year is None:
        print(f"All {total} tickers already fetched for years {YEARS} in {DATA_DIR}.")
        return

    batch = pick_batch(tickers, year)
    if not batch:
        print(f"All {total} tickers already fetched for {year} in {DATA_DIR}.")
        return

    saved = fetch_and_save(batch, year)
    print(f"[{year}] Requested {len(batch)} tickers, saved {saved} CSVs. "
          f"({total - len(batch)}/{total} previously done or in this batch)")


if __name__ == "__main__":
    main()
