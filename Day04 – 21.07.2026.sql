--E10
SELECT role, avg(years_employed)
FROM employees
group by role

SELECT building,sum(years_employed) 
FROM employees
group by building


--E11
SELECT count() 
FROM employees
where role='Artist'

SELECT count() ,role
FROM employees
group by role

SELECT role,sum(years_employed)
FROM employees
where role='Engineer'


--E12
select count(title),director
from movies
group by director

SELECT director, sum(domestic_sales+international_sales) as sales 
FROM boxoffice
join movies
on movies.id=boxoffice.movie_id
group by director


--1661
select s.machine_id, round(AVG(e.timestamp-s.timestamp),3) as processing_time
from activity as s
join activity as e
on s.machine_id=e.machine_id AND s.process_id=e.process_id
where s.activity_type='start' AND e.activity_type='end'
group by machine_id


--577
select name,bonus from employee
left join bonus
on employee.empid=bonus.empid
where bonus<1000 OR bonus is null


--1280
# Write your MySQL query statement below
select students.student_id,students.student_name,subjects.subject_name,count(examinations.subject_name) as attended_exams 
from students
cross join subjects
left join examinations
on students.student_id=examinations.student_id AND subjects.subject_name=examinations.subject_name
group by students.student_id,
    students.student_name,
    subjects.subject_name
order by students.student_id,subjects.subject_name


--570
select e.name
from employee as e
join employee as m 
on e.id = m.managerid
group by e.name,e.id
having count(m.id)>=5


--1934
select s.user_id, ifnull(round(sum(case when c.action='confirmed' then 1 else 0 END)/count(c.user_id),2),0) as confirmation_rate
from signups as s
left join confirmations as c
on s.user_id=c.user_id
group by s.user_id
