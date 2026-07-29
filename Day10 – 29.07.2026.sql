-- LeetCode 1667: Fix Names in a Table
SELECT
    user_id,
    CONCAT(
        UPPER(LEFT(name, 1)),
        LOWER(SUBSTRING(name, 2))
    ) AS name
FROM Users
ORDER BY user_id;

-- LeetCode 1527: Patients With a Condition
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%'
   OR conditions LIKE '% DIAB1%';

-- LeetCode 196: Delete Duplicate Emails
DELETE FROM Person
WHERE id NOT IN (
    SELECT id
    FROM (
        SELECT MIN(id) AS id
        FROM Person
        GROUP BY email
    ) AS keep_rows
);

-- LeetCode 176: Second Highest Salary
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

-- LeetCode 1484: Group Sold Products By The Date
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(
        DISTINCT product
        ORDER BY product
        SEPARATOR ','
    ) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

-- LeetCode 1517: Find Users With Valid E-Mails
SELECT user_id, name, mail
FROM Users
WHERE REGEXP_LIKE(
    mail,
    '^[A-Za-z][A-Za-z0-9_.-]*@leetcode[.]com$',
    'c'
);

-- SQLBolt Lesson 16: Creating tables
CREATE TABLE Database (
    Name TEXT,
    Version FLOAT,
    Download_count INTEGER
);

-- SQLBolt Lesson 17: Altering tables (syntax practice)
ALTER TABLE Database
ADD Description TEXT;

ALTER TABLE Database
DROP COLUMN Description;

ALTER TABLE Database
RENAME TO Databases;
