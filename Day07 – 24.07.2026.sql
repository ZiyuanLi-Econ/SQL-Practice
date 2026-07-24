-- LeetCode 1731: The Number of Employees Which Report to Each Employee
SELECT
    manager.employee_id,
    manager.name,
    COUNT(employee.employee_id) AS reports_count,
    ROUND(AVG(employee.age)) AS average_age
FROM Employees AS manager
JOIN Employees AS employee
    ON manager.employee_id = employee.reports_to
GROUP BY manager.employee_id, manager.name
ORDER BY manager.employee_id;

-- LeetCode 1789: Primary Department for Each Employee
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'
   OR employee_id IN (
       SELECT employee_id
       FROM Employee
       GROUP BY employee_id
       HAVING COUNT(*) = 1
   );

-- SQLBolt Lesson 13: Inserting rows
INSERT INTO Movies
    (Id, Title, Director, Year, Length_minutes)
VALUES
    (15, 'Toy Story 4', 'Josh Cooley', 2019, 100);

INSERT INTO Boxoffice
    (Movie_id, Rating, Domestic_sales, International_sales)
VALUES
    (15, 8.7, 340000000, 270000000);

-- SQLBolt Lesson 14: Updating rows
UPDATE Movies
SET Director = 'John Lasseter'
WHERE Id = 2;

UPDATE Movies
SET Year = 1999
WHERE Id = 3;

UPDATE Movies
SET Title = 'Toy Story 3',
    Director = 'Lee Unkrich'
WHERE Id = 11;

-- SQLBolt Lesson 15: Deleting rows
DELETE FROM Movies
WHERE Year < 2005;

DELETE FROM Movies
WHERE Director = 'Andrew Stanton';
