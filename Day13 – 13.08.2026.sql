--197
select w2.id
from weather as w1
join weather as w2
on datediff(w2.recorddate,w1.recorddate)=1
where w1.temperature<w2.temperature

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
