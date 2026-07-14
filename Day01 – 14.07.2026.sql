CREATE TABLE stock_prices (
    price_id INTEGER PRIMARY KEY,
    ticker VARCHAR(10),
    company_name VARCHAR(100),
    sector VARCHAR(50),
    trade_date DATE,
    close_price DECIMAL(10,2),
    volume INTEGER
);

INSERT INTO stock_prices
    (price_id, ticker, company_name, sector, trade_date, close_price, volume)
VALUES
    (1, 'BMW', 'BMW Group', 'Automotive', '2026-07-01', 83.50, 1200000),
    (2, 'BMW', 'BMW Group', 'Automotive', '2026-07-02', 84.20, 1350000),
    (3, 'MBG', 'Mercedes-Benz', 'Automotive', '2026-07-01', 52.40, 1800000),
    (4, 'MBG', 'Mercedes-Benz', 'Automotive', '2026-07-02', 51.90, 1650000),
    (5, 'SAP', 'SAP SE', 'Technology', '2026-07-01', 228.30, 950000),
    (6, 'SAP', 'SAP SE', 'Technology', '2026-07-02', 231.10, 1100000),
    (7, 'ALV', 'Allianz SE', 'Financials', '2026-07-01', 352.80, 620000),
    (8, 'ALV', 'Allianz SE', 'Financials', '2026-07-02', 355.40, 710000),
    (9, 'DTE', 'Deutsche Telekom', 'Telecom', '2026-07-01', 31.20, 2500000),
    (10, 'DTE', 'Deutsche Telekom', 'Telecom', '2026-07-02', 31.55, 2700000);

--Questions
SELECT *FROM stock_prices;

--1
select price_id,trade_date,close_price from stock_prices;

--2
select * from stock_prices
where ticker = 'SAP';

--3
select*from stock_prices
where close_price > 100;

--4
select* from stock_prices
where sector = 'Automotive' AND volume >1300000;

--5
select* from stock_prices
where ticker in ('SAP','ALV');

--6
select* from stock_prices
where close_price between 50 and 100;

--7
select * from stock_prices
order by close_price desc;

--8
select* from stock_prices
order by close_price desc
limit 3;

--9
select distinct sector from stock_prices;

--10
select distinct company_name from stock_prices
where company_name like '%Deutsche%';

