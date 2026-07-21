-- SQLBolt aggregate practice (Lessons 10–12)

-- Lesson 10
SELECT MAX(years_employed)
FROM employees;

SELECT
    role,
    AVG(years_employed)
FROM employees
GROUP BY role;

SELECT
    building,
    SUM(years_employed)
FROM employees
GROUP BY building;

-- Lesson 11
SELECT COUNT(*)
FROM employees
WHERE role = 'Artist';

SELECT
    role,
    COUNT(*)
FROM employees
GROUP BY role;

SELECT SUM(years_employed)
FROM employees
WHERE role = 'Engineer';

-- Lesson 12
SELECT
    director,
    COUNT(title)
FROM movies
GROUP BY director;

SELECT
    director,
    SUM(domestic_sales + international_sales)
FROM movies
JOIN boxoffice
    ON movies.id = boxoffice.movie_id
GROUP BY director;

-- LeetCode 1661: Average Time of Process per Machine
SELECT
    s.machine_id,
    ROUND(AVG(e.timestamp - s.timestamp), 3) AS processing_time
FROM Activity AS s
JOIN Activity AS e
    ON s.machine_id = e.machine_id
    AND s.process_id = e.process_id
WHERE s.activity_type = 'start'
    AND e.activity_type = 'end'
GROUP BY s.machine_id;

-- LeetCode 577: Employee Bonus
SELECT
    e.name,
    b.bonus
FROM Employee AS e
LEFT JOIN Bonus AS b
    ON e.empId = b.empId
WHERE b.bonus < 1000
    OR b.bonus IS NULL;

-- LeetCode 1280: Students and Examinations
SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students AS s
CROSS JOIN Subjects AS sub
LEFT JOIN Examinations AS e
    ON s.student_id = e.student_id
    AND sub.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY
    s.student_id,
    sub.subject_name;

-- LeetCode 570: Managers with at Least 5 Direct Reports
SELECT e.name
FROM Employee AS e
JOIN Employee AS m
    ON e.id = m.managerId
GROUP BY
    e.id,
    e.name
HAVING COUNT(*) >= 5;
