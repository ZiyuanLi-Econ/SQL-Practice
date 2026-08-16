--1280
with combined as(
select s.student_id,s.student_name,su.subject_name
from students as s
cross join subjects as su) 

select co.student_id,co.student_name,co.subject_name,count(e.subject_name) as attended_exams
from combined as co
left join examinations as e 
on co.subject_name=e.subject_name and co.student_id = e.student_id
group by co.student_id,co.student_name,co.subject_name
order by s.student_id,su.subject_name

--570
select e1.name
from employee as e1
left join employee as e2
on e1.id=e2.managerID
group by e1.id
having count(*)>=5

--1934
select s.user_id, ifnull(round(count(case when c.action='confirmed' then 1 end)/count(*),2),0) as confirmation_rate
from signups as s
left join confirmations as c
on s.user_id = c.user_id
group by s.user_id
