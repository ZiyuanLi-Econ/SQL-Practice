-- SQLBolt JOIN practice

SELECT *
FROM movies
INNER JOIN boxoffice
    ON movies.id = boxoffice.movie_id
ORDER BY rating DESC;

SELECT DISTINCT
    building_name,
    role
FROM buildings
LEFT JOIN employees
    ON building_name = building;

SELECT building_name
FROM buildings
LEFT JOIN employees
    ON building_name = building
WHERE building IS NULL;

SELECT
    (domestic_sales + international_sales) / 1000000.0 AS combined_sales,
    title
FROM boxoffice
JOIN movies
    ON movies.id = boxoffice.movie_id;

-- Modulo reminder: a number is even when number % 2 = 0.

-- LeetCode 1378: Replace Employee ID With The Unique Identifier
SELECT
    unique_id,
    name
FROM Employees
LEFT JOIN EmployeeUNI
    ON Employees.id = EmployeeUNI.id;

-- LeetCode 1068: Product Sales Analysis I
SELECT
    product_name,
    year,
    price
FROM Sales
JOIN Product
    ON Sales.product_id = Product.product_id;

-- LeetCode 1581: Customer Who Visited but Did Not Make Any Transactions
SELECT
    v.customer_id,
    COUNT(*) AS count_no_trans
FROM Visits AS v
LEFT JOIN Transactions AS t
    ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

-- LeetCode 197: Rising Temperature
SELECT today.id
FROM Weather AS today
JOIN Weather AS yesterday
    ON DATEDIFF(today.recordDate, yesterday.recordDate) = 1
WHERE today.temperature > yesterday.temperature;
