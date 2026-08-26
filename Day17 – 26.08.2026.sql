--1211
select q1.query_name,
round(avg(q1.rating/q1.position),2) as quality,
ifnull(round((select count(q2.rating) from queries as q2 where rating<3 and q2.query_name=q1.query_name group by q2.query_name)*100/count(*),2),0) as poor_query_percentage
from queries as q1
group by q1.query_name

select q1.query_name,
round(avg(q1.rating/q1.position),2) as quality,
round(sum(case when rating<3 then 1 else 0 end)*100/count(*),2) as poor_query_percentage
from queries as q1
group by q1.query_name
