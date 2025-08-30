CREATE DATABASE fmcg;

SELECT * FROM fmcg_2022_2024;
SELECT COUNT(*) FROM fmcg_2022_2024;

-- DATA PREPROCESSING
-- Cek Duplicate
SELECT date, sku, brand, segment, category, channel, region, pack_type,
       price_unit, promotion_flag, delivery_days, stock_available, units_sold
       COUNT(*) AS total
FROM fmcg_2022_2024
GROUP BY date, sku, brand, segment, category, channel, region, pack_type,
         price_unit, promotion_flag, delivery_days, stock_available, units_sold
HAVING COUNT(*) > 1;
-- note. tidak ada data duplikat

-- Cek Null
SELECT *
FROM fmcg_2022_2024
WHERE date IS NULL OR sku IS NULL OR brand IS NULL OR segment IS NULL OR category IS NULL OR channel IS NULL OR region IS NULL OR pack_type IS NULL OR
         price_unit IS NULL OR promotion_flag IS NULL OR delivery_days IS NULL OR stock_available IS NULL;
-- note. tidak ada data null

-- DATA EXPLORATION
CREATE VIEW fmcg AS (SELECT *, (price_unit*units_sold) revenue
FROM fmcg_2022_2024);
SELECT * FROM fmcg;
SHOW TABLES;

-- Key metrics
SELECT SUM(revenue) as revenue, sum(units_sold) as sold_qty, sum(delivered_qty) as delivered_qty, sum(stock_available) as stocks
from fmcg;

-- Products Insights
SELECT category, ROUND(sum(revenue),2) as revenue
FROM fmcg
GROUP BY category
ORDER BY revenue DESC;

SELECT segment, ROUND(sum(revenue), 2) as revenue, round(sum(units_sold), 2) as sold_qty
FROM fmcg
GROUP BY segment
ORDER BY revenue DESC, sold_qty DESC
LIMIT 5;

SELECT date_format(date, '%M') as bulan,
round(sum(case when year(date) = 2022 then revenue end), 2) as rev2022,
round(sum(case when year(date) = 2023 then revenue end), 2) as rev2023,
round(sum(case when year(date) = 2024 then revenue end), 2) as rev2024,
round(sum(revenue)/3, 2) as avgrev
FROM fmcg
group by bulan;

SELECT region, round(sum(revenue), 2) as revenue
FROM fmcg
group by region
order by revenue DESC;

SELECT channel, round(sum(revenue), 2) as revenue
FROM fmcg
group by channel
order by revenue DESC;

SELECT channel, count(revenue) as total_orders
FROM fmcg
group by channel
order by total_orders DESC;