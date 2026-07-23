--2356 
select teacher_id, count(distinct subject_id) AS cnt
from teacher
group by teacher_id

--1141
select activity_date as day, count(distinct user_id) as active_users
from activity
where activity_date>='2019-06-28' AND activity_date<='2019-07-27' 
group by activity_date

--1070
select product_id, year as first_year, quantity, price
from sales
where (product_id,year)
in(select product_id,min(year)
from sales
group by product_id)

--596
select class
from courses
group by class
having count(*)>=5

--1729
select user_id, count(*) AS followers_count
from followers
group by user_id
order by user_id asc

--619
select max(num) as num
from (select num
from mynumbers
group by num
having count(num)=1) as t

--1045
select customer_id
from customer
group by customer_id
having count(DISTINCT product_key) = (select count(*) from product)
