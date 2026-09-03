-- Stock OHLCV schema: one row per (ticker, trade_date), scales to any
-- number of tickers without creating a table per ticker.

CREATE TABLE IF NOT EXISTS tickers (
    ticker_code   VARCHAR(20) PRIMARY KEY,
    name          VARCHAR(100),
    market        VARCHAR(20) DEFAULT 'KOSPI',
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ohlcv (
    ticker_code   VARCHAR(20) NOT NULL REFERENCES tickers(ticker_code),
    trade_date    DATE NOT NULL,
    open          NUMERIC(14,4),
    high          NUMERIC(14,4),
    low           NUMERIC(14,4),
    close         NUMERIC(14,4),
    adj_close     NUMERIC(14,4),
    volume        BIGINT,
    PRIMARY KEY (ticker_code, trade_date)
);

CREATE INDEX IF NOT EXISTS idx_ohlcv_trade_date ON ohlcv (trade_date);
