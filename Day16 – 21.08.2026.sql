--1075
select p.project_id, round(sum(e.experience_years)/count(*),2) as average_years
from project as p
left join employee as e
on p.employee_id=e.employee_id
group by p.project_id

--1633
select r.contest_id, round(sum(case when r.contest_id is null then 0 else 1 end)*100/(select count(distinct uu.user_id) from users as uu),2) as percentage
from users as u
left join register as r
on u.user_id=r.user_id
group by r.contest_id
order by percentage desc, r.contest_id asc

select r.contest_id, round(count(*)*100/(select count(distinct uu.user_id) from users as uu),2) as percentage
from users as u
join register as r
on u.user_id=r.user_id
group by r.contest_id
order by percentage desc, r.contest_id asc

