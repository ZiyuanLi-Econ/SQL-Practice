-- LeetCode 610: Triangle Judgement
SELECT
    x,
    y,
    z,
    CASE
        WHEN x + y > z
         AND x + z > y
         AND y + z > x
        THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle;

-- LeetCode 180: Consecutive Numbers
SELECT DISTINCT
    lo1.num AS ConsecutiveNums
FROM Logs AS lo1
JOIN Logs AS lo2
    ON lo2.id = lo1.id + 1
JOIN Logs AS lo3
    ON lo3.id = lo2.id + 1
WHERE lo1.num = lo2.num
  AND lo2.num = lo3.num;

-- LeetCode 1164: Product Price at a Given Date
SELECT DISTINCT
    p1.product_id,
    IFNULL(
        (
            SELECT p2.new_price
            FROM Products AS p2
            WHERE p2.product_id = p1.product_id
              AND p2.change_date <= '2019-08-16'
            ORDER BY p2.change_date DESC
            LIMIT 1
        ),
        10
    ) AS price
FROM Products AS p1;

-- LeetCode 1204: Last Person to Fit in the Bus
SELECT
    qu1.person_name
FROM Queue AS qu1
JOIN Queue AS qu2
    ON qu2.turn <= qu1.turn
GROUP BY
    qu1.person_id,
    qu1.person_name,
    qu1.turn
HAVING SUM(qu2.weight) <= 1000
ORDER BY qu1.turn DESC
LIMIT 1;

-- LeetCode 1907: Count Salary Categories
SELECT
    'Low Salary' AS category,
    COUNT(CASE WHEN income < 20000 THEN 1 END) AS accounts_count
FROM Accounts

UNION ALL

SELECT
    'Average Salary' AS category,
    COUNT(CASE WHEN income BETWEEN 20000 AND 50000 THEN 1 END) AS accounts_count
FROM Accounts

UNION ALL

SELECT
    'High Salary' AS category,
    COUNT(CASE WHEN income > 50000 THEN 1 END) AS accounts_count
FROM Accounts;
