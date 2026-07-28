-- LeetCode 585: Investments in 2016
SELECT
    ROUND(SUM(i1.tiv_2016), 2) AS tiv_2016
FROM Insurance AS i1
WHERE EXISTS (
    SELECT 1
    FROM Insurance AS i2
    WHERE i2.tiv_2015 = i1.tiv_2015
      AND i2.pid <> i1.pid
)
AND NOT EXISTS (
    SELECT 1
    FROM Insurance AS i3
    WHERE i3.lat = i1.lat
      AND i3.lon = i1.lon
      AND i3.pid <> i1.pid
);

-- LeetCode 185: Department Top Three Salaries
SELECT
    Department,
    Employee,
    Salary
FROM (
    SELECT
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (
            PARTITION BY e.departmentId
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM Employee AS e
    JOIN Department AS d
        ON e.departmentId = d.id
) AS ranked_employee
WHERE salary_rank <= 3;
