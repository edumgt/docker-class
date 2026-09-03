-- Schema: tickers, ohlcv

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

-- Data: 삼성전자(005930) 200건

INSERT INTO tickers (ticker_code, name, market) VALUES ('005930', '삼성전자', 'KOSPI') ON CONFLICT (ticker_code) DO NOTHING;

INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-02','55500.0000','56000.0000','55000.0000','55200.0000','47320.6680','12993228');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-03','56000.0000','56600.0000','54900.0000','55500.0000','47577.8477','15422255');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-06','54900.0000','55600.0000','54600.0000','55500.0000','47577.8477','10278951');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-07','55700.0000','56400.0000','55600.0000','55800.0000','47835.0117','10009778');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-08','56200.0000','57400.0000','55900.0000','56800.0000','48692.2734','23501171');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-09','58400.0000','58600.0000','57400.0000','58600.0000','50235.3438','24102579');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-10','58800.0000','59700.0000','58300.0000','59500.0000','51006.8711','16000170');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-13','59600.0000','60000.0000','59100.0000','60000.0000','51435.5000','11359139');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-14','60400.0000','61000.0000','59900.0000','60000.0000','51435.5000','16906295');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-15','59500.0000','59600.0000','58900.0000','59000.0000','50578.2500','14300928');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-16','59100.0000','60700.0000','59000.0000','60700.0000','52035.5781','14381774');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-17','61900.0000','62000.0000','61000.0000','61300.0000','52549.9492','16025661');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-20','62000.0000','62800.0000','61700.0000','62400.0000','53492.9219','12528855');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-21','62000.0000','62400.0000','61200.0000','61400.0000','52635.6680','11142693');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-22','60500.0000','62600.0000','60400.0000','62300.0000','53407.1992','15339565');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-23','61800.0000','61800.0000','60700.0000','60800.0000','52121.3086','14916555');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-28','59400.0000','59400.0000','58300.0000','58800.0000','50406.7852','23664541');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-29','59100.0000','59700.0000','58800.0000','59100.0000','50663.9570','16446102');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-30','58800.0000','58800.0000','56800.0000','57200.0000','49035.1836','20821939');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-01-31','57800.0000','58400.0000','56400.0000','56400.0000','48349.3633','19749457');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-03','55500.0000','57400.0000','55200.0000','57200.0000','49035.1836','23995260');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-04','57100.0000','59000.0000','56800.0000','58900.0000','50492.5195','21800192');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-05','60000.0000','60200.0000','58900.0000','59500.0000','51006.8711','19278165');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-06','60100.0000','61100.0000','59700.0000','61100.0000','52378.4844','14727159');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-07','61100.0000','61200.0000','59700.0000','60400.0000','51778.4023','16402493');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-10','59200.0000','59800.0000','59100.0000','59700.0000','51178.3281','13107121');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-11','59800.0000','60700.0000','59700.0000','59900.0000','51349.7734','11071231');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-12','60300.0000','60700.0000','59700.0000','60500.0000','51864.1328','12904207');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-13','61200.0000','61600.0000','60500.0000','60700.0000','52035.5781','18449775');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-14','60900.0000','61900.0000','60200.0000','61800.0000','52978.5664','13276067');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-17','61600.0000','62000.0000','61200.0000','61500.0000','52721.3789','8740596');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-18','60800.0000','60900.0000','59700.0000','59800.0000','51264.0508','16674266');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-19','59800.0000','60400.0000','59400.0000','60200.0000','51606.9492','12951496');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-20','60700.0000','61300.0000','59600.0000','60000.0000','51435.5000','14591924');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-21','58800.0000','59800.0000','58500.0000','59200.0000','50749.6953','13777393');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-24','57400.0000','58100.0000','56800.0000','56800.0000','48692.2734','25627537');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-25','56200.0000','58000.0000','56200.0000','57900.0000','49635.2578','23885408');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-26','56000.0000','57000.0000','56000.0000','56500.0000','48435.1016','25483102');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-27','56300.0000','56900.0000','55500.0000','55900.0000','47920.7383','23209541');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-02-28','55000.0000','55500.0000','54200.0000','54200.0000','46463.3984','30054227');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-02','54300.0000','55500.0000','53600.0000','55000.0000','47149.2070','30403412');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-03','56700.0000','56900.0000','55100.0000','55400.0000','47492.1133','30330295');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-04','54800.0000','57600.0000','54600.0000','57400.0000','49206.6211','24765728');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-05','57600.0000','58000.0000','56700.0000','57800.0000','49549.5273','21698990');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-06','56500.0000','57200.0000','56200.0000','56500.0000','48435.1016','18716656');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-09','56500.0000','56500.0000','56500.0000','56500.0000','48435.1016','0');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-10','53800.0000','54900.0000','53700.0000','54600.0000','46806.3125','32106554');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-11','54300.0000','54400.0000','52000.0000','52100.0000','44663.1602','45707281');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-12','52100.0000','52100.0000','52100.0000','52100.0000','44663.1602','0');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-13','47450.0000','51600.0000','46850.0000','49950.0000','42820.0547','59462933');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-16','50100.0000','50900.0000','48800.0000','48900.0000','41919.9297','33339821');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-17','46900.0000','49650.0000','46700.0000','47300.0000','40548.3281','51218151');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-18','47750.0000','48350.0000','45600.0000','45600.0000','39090.9844','40152623');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-19','46400.0000','46650.0000','42300.0000','42950.0000','36819.2539','56925513');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-20','44150.0000','45500.0000','43550.0000','45400.0000','38919.5273','49730008');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-23','42600.0000','43550.0000','42400.0000','42500.0000','36433.4766','41701626');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-24','43850.0000','46950.0000','43050.0000','46950.0000','40248.2773','49801908');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-25','48950.0000','49600.0000','47150.0000','48650.0000','41705.6133','52735922');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-26','49000.0000','49300.0000','47700.0000','47800.0000','40976.9453','42185129');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-27','49600.0000','49700.0000','46850.0000','48300.0000','41405.5859','39896178');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-30','47050.0000','48350.0000','46550.0000','47850.0000','41322.6680','26797395');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-03-31','48000.0000','48500.0000','47150.0000','47750.0000','41236.3125','30654261');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-01','47450.0000','47900.0000','45800.0000','45800.0000','39552.3203','27259532');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-02','46200.0000','46850.0000','45350.0000','46800.0000','40415.9063','21621076');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-03','47400.0000','47600.0000','46550.0000','47000.0000','40588.6172','22784682');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-06','47500.0000','48800.0000','47250.0000','48700.0000','42056.7305','23395726');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-07','49650.0000','50200.0000','49000.0000','49600.0000','42833.9375','31524034');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-08','49600.0000','49750.0000','48600.0000','48600.0000','41970.3633','25010314');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-09','49750.0000','49800.0000','48700.0000','49100.0000','42402.1641','22628058');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-10','48950.0000','49250.0000','48650.0000','49250.0000','42531.6953','17839111');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-13','48650.0000','48900.0000','48300.0000','48300.0000','41711.2813','14431800');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-14','48800.0000','49200.0000','48300.0000','49000.0000','42315.7930','14206216');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-16','49350.0000','49350.0000','48550.0000','49000.0000','42315.7930','23349760');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-17','50800.0000','52000.0000','50300.0000','51400.0000','44388.3984','32041675');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-20','51400.0000','51400.0000','50000.0000','50100.0000','43265.7383','21866354');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-21','49400.0000','49700.0000','48700.0000','49250.0000','42531.6953','27407543');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-22','48700.0000','50000.0000','48350.0000','49850.0000','43049.8477','18613864');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-23','50200.0000','50300.0000','49500.0000','49850.0000','43049.8477','18754442');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-24','49650.0000','49750.0000','49000.0000','49350.0000','42618.0625','15618347');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-27','49350.0000','50000.0000','49100.0000','49850.0000','43049.8477','14049471');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-28','49850.0000','50100.0000','49300.0000','50100.0000','43265.7383','16095399');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-04-29','49900.0000','50500.0000','49600.0000','50000.0000','43179.3945','15604533');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-04','48900.0000','49100.0000','48500.0000','48500.0000','41884.0078','26083749');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-06','49000.0000','49200.0000','48500.0000','49200.0000','42488.5156','18070225');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-07','49200.0000','49300.0000','48700.0000','48800.0000','42143.0781','13884411');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-08','49100.0000','49350.0000','48800.0000','48800.0000','42143.0781','15319700');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-11','48900.0000','49250.0000','48300.0000','48400.0000','41797.6484','16357743');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-12','48400.0000','48500.0000','47550.0000','47900.0000','41365.8555','23433590');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-13','47250.0000','48550.0000','47200.0000','48550.0000','41927.1836','20223277');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-14','47750.0000','48100.0000','47650.0000','48000.0000','41452.2070','19305974');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-15','48400.0000','48450.0000','47700.0000','47850.0000','41322.6680','18463118');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-18','47950.0000','49100.0000','47600.0000','48800.0000','42143.0781','20481981');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-19','50100.0000','50500.0000','49700.0000','50300.0000','43438.4688','25168295');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-20','50000.0000','50200.0000','49800.0000','50000.0000','43179.3945','14896899');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-21','50300.0000','50400.0000','49850.0000','49950.0000','43136.2109','14949266');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-22','49600.0000','49800.0000','48600.0000','48750.0000','42099.8984','19706284');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-25','48750.0000','48900.0000','48450.0000','48850.0000','42186.2617','14337913');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-26','48700.0000','49450.0000','48600.0000','49250.0000','42531.6953','15127490');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-27','48950.0000','50000.0000','48800.0000','49900.0000','43093.0117','19548479');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-28','51100.0000','51200.0000','49900.0000','50400.0000','43524.8203','31309318');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-05-29','50000.0000','50700.0000','49700.0000','50700.0000','43783.8867','27596961');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-01','50800.0000','51200.0000','50600.0000','51200.0000','44215.6875','16949183');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-02','51000.0000','51500.0000','50800.0000','51400.0000','44388.3984','14247933');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-03','51800.0000','55000.0000','51700.0000','54500.0000','47065.5313','49257814');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-04','55800.0000','57000.0000','54600.0000','54600.0000','47151.8906','40220334');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-05','54400.0000','55900.0000','54000.0000','55500.0000','47929.1172','22743629');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-08','56400.0000','56500.0000','54700.0000','54900.0000','47410.9648','25634965');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-09','55800.0000','56500.0000','54400.0000','55500.0000','47929.1172','23998831');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-10','55100.0000','55900.0000','54900.0000','55400.0000','47842.7539','16742493');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-11','54500.0000','55100.0000','53200.0000','54300.0000','46892.8164','33815123');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-12','52100.0000','52800.0000','51500.0000','52300.0000','45165.6367','26976019');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-15','51400.0000','52000.0000','49900.0000','49900.0000','43093.0117','28772921');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-16','51200.0000','52100.0000','50600.0000','52100.0000','44992.9375','21808375');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-17','52100.0000','52900.0000','51300.0000','52200.0000','45079.2852','26672595');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-18','52200.0000','52300.0000','51600.0000','52300.0000','45165.6367','15982926');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-19','52600.0000','52900.0000','51600.0000','52900.0000','45683.7930','18157985');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-22','52000.0000','52600.0000','51800.0000','52000.0000','44906.5547','13801350');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-23','52500.0000','52800.0000','51100.0000','51400.0000','44388.3984','18086152');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-24','51900.0000','53900.0000','51600.0000','52900.0000','45683.7930','24519552');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-25','52100.0000','53000.0000','51900.0000','51900.0000','44820.2031','18541624');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-26','52800.0000','53900.0000','52200.0000','53300.0000','46029.2188','21575360');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-29','52500.0000','53200.0000','52000.0000','52400.0000','45554.5547','17776925');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-06-30','53900.0000','53900.0000','52800.0000','52800.0000','45902.2930','21157172');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-01','53400.0000','53600.0000','52400.0000','52600.0000','45728.4258','16706143');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-02','52100.0000','52900.0000','52100.0000','52900.0000','45989.2383','14142583');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-03','53000.0000','53600.0000','52700.0000','53600.0000','46597.7891','11887868');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-06','54000.0000','55000.0000','53800.0000','55000.0000','47814.9023','19856623');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-07','55800.0000','55900.0000','53400.0000','53400.0000','46423.9102','30760032');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-08','53600.0000','53900.0000','52900.0000','53000.0000','46076.1719','19664652');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-09','53200.0000','53600.0000','52800.0000','52800.0000','45902.2930','17054850');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-10','53100.0000','53200.0000','52300.0000','52700.0000','45815.3516','13714746');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-13','53300.0000','53800.0000','53100.0000','53400.0000','46423.9102','12240188');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-14','53700.0000','53800.0000','53200.0000','53800.0000','46771.6563','14269484');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-15','54400.0000','55000.0000','54300.0000','54700.0000','47554.0859','24051450');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-16','54800.0000','54800.0000','53800.0000','53800.0000','46771.6563','16779127');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-17','54200.0000','54700.0000','54100.0000','54400.0000','47293.2734','10096174');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-20','54800.0000','54800.0000','54000.0000','54200.0000','47119.4063','10507530');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-21','55200.0000','55400.0000','54800.0000','55300.0000','48075.7070','18297260');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-22','55300.0000','55500.0000','54700.0000','54700.0000','47554.0859','12885057');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-23','54700.0000','54700.0000','53800.0000','54100.0000','47032.4766','16214932');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-24','54000.0000','54400.0000','53700.0000','54200.0000','47119.4063','10994535');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-27','54300.0000','55700.0000','54300.0000','55600.0000','48336.5156','21054421');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-28','57000.0000','58800.0000','56400.0000','58600.0000','50944.5938','48431566');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-29','60300.0000','60400.0000','58600.0000','59000.0000','51292.3398','36476611');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-30','59700.0000','60100.0000','59000.0000','59000.0000','51292.3398','19285354');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-07-31','59500.0000','59600.0000','57700.0000','57900.0000','50336.0430','21943345');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-03','57800.0000','57900.0000','56700.0000','56800.0000','49379.7422','21158940');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-04','57200.0000','58100.0000','57000.0000','57300.0000','49814.4297','19419694');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-05','57300.0000','57500.0000','56300.0000','56900.0000','49466.6797','17739706');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-06','57100.0000','58400.0000','57100.0000','58000.0000','50422.9805','21625874');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-07','57900.0000','58400.0000','57100.0000','57500.0000','49988.2969','18751717');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-10','57600.0000','58300.0000','57500.0000','57800.0000','50249.1016','17774291');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-11','58000.0000','59500.0000','57800.0000','58200.0000','50596.8555','24907912');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-12','58200.0000','59000.0000','57700.0000','59000.0000','51292.3398','18573934');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-13','59400.0000','59600.0000','58000.0000','58700.0000','51031.5313','22089460');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-14','58000.0000','58400.0000','57700.0000','58000.0000','50422.9805','15672548');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-18','58900.0000','59900.0000','58000.0000','58400.0000','50770.7227','25307825');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-19','59000.0000','59200.0000','57800.0000','57800.0000','50249.1016','16930719');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-20','57600.0000','57600.0000','55300.0000','55400.0000','48162.6367','30386029');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-21','56200.0000','56900.0000','55800.0000','55900.0000','48597.3125','21142288');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-24','55800.0000','56600.0000','55400.0000','56100.0000','48771.1953','15055896');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-25','56400.0000','56800.0000','56100.0000','56400.0000','49032.0078','14021705');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-26','56400.0000','56500.0000','55700.0000','56400.0000','49032.0078','17651593');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-27','56300.0000','56300.0000','55600.0000','55600.0000','48336.5156','16196568');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-28','56100.0000','56300.0000','55400.0000','55400.0000','48162.6367','14619888');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-08-31','56000.0000','56100.0000','54000.0000','54000.0000','46945.5352','32671367');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-01','54100.0000','54800.0000','54100.0000','54200.0000','47119.4063','19363117');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-02','54600.0000','55100.0000','54100.0000','54400.0000','47293.2734','16905723');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-03','55600.0000','56700.0000','55500.0000','56400.0000','49032.0078','28384920');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-04','55200.0000','55800.0000','55100.0000','55600.0000','48336.5156','22139109');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-07','56100.0000','57300.0000','55800.0000','56500.0000','49118.9375','18685880');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-08','57400.0000','58700.0000','57200.0000','58700.0000','51031.5313','31517520');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-09','58200.0000','59300.0000','57800.0000','58400.0000','50770.7227','30597399');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-10','59900.0000','60000.0000','59100.0000','59200.0000','51466.2070','29923293');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-11','59300.0000','59400.0000','58200.0000','59000.0000','51292.3398','16017098');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-14','60200.0000','60800.0000','59900.0000','60400.0000','52509.4414','20648281');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-15','60900.0000','61000.0000','60500.0000','61000.0000','53031.0586','17877075');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-16','61100.0000','61300.0000','60600.0000','61000.0000','53031.0586','17041444');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-17','60700.0000','60800.0000','59300.0000','59500.0000','51727.0195','25108356');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-18','59800.0000','59900.0000','59100.0000','59300.0000','51553.1484','18884571');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-21','59100.0000','60000.0000','59000.0000','59200.0000','51466.2070','15140387');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-22','59100.0000','59700.0000','57800.0000','58200.0000','50596.8555','20830381');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-23','58400.0000','58800.0000','57400.0000','58600.0000','50944.5938','20111398');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-24','57700.0000','58600.0000','57600.0000','57800.0000','50249.1016','17564020');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-25','57700.0000','58200.0000','57700.0000','57900.0000','50336.0430','11444683');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-28','58300.0000','58800.0000','57900.0000','58200.0000','50908.1016','12614080');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-09-29','58300.0000','59000.0000','58200.0000','58200.0000','50908.1016','15503563');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-05','57500.0000','59200.0000','57500.0000','58700.0000','51345.4648','20228289');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-06','59400.0000','59900.0000','58700.0000','59000.0000','51607.8789','14463826');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-07','58700.0000','59900.0000','58500.0000','59900.0000','52395.1133','14861838');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-08','60500.0000','60700.0000','59500.0000','59700.0000','52220.1719','24589924');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-12','60000.0000','60400.0000','59900.0000','60400.0000','52832.4609','16145837');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-13','61000.0000','61400.0000','60400.0000','60900.0000','53269.8242','19247631');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-14','61000.0000','61100.0000','60500.0000','60900.0000','53269.8242','16086716');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-15','60700.0000','60800.0000','59700.0000','60000.0000','52482.5742','17756232');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-16','60000.0000','60400.0000','59000.0000','59500.0000','52045.2266','16554190');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-19','59600.0000','60200.0000','59500.0000','60000.0000','52482.5742','14474985');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-20','60300.0000','60900.0000','60100.0000','60900.0000','53269.8242','19326115');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-21','61200.0000','61500.0000','60600.0000','60900.0000','53269.8242','15703443');
INSERT INTO ohlcv (ticker_code, trade_date, open, high, low, close, adj_close, volume) VALUES ('005930','2020-10-22','60300.0000','60500.0000','59800.0000','60100.0000','52570.0469','14294095');
