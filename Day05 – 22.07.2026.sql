--620
select id, movie, description, rating
from cinema
where description != 'boring' AND id % 2 = 1
order by rating desc


--1251
select prices.product_id,
       ifnull(round(sum(price * units) / sum(units), 2), 0) as average_price
from prices
left join unitssold
on prices.product_id = unitssold.product_id
   AND purchase_date >= start_date
   AND purchase_date <= end_date
group by prices.product_id


--1075
select project_id,
       round(avg(experience_years), 2) as average_years
from project
left join employee
on project.employee_id = employee.employee_id
group by project_id


--1633
select contest_id,
       round(count(register.user_id) / (select count(*) from users) * 100, 2) as percentage
from register
left join users
on register.user_id = users.user_id
group by contest_id
order by percentage desc, contest_id asc


--1211
select query_name,
       round(avg(rating / position), 2) as quality,
       round(sum(case when rating < 3 then 1 else 0 end) / count(*) * 100, 2) as poor_query_percentage
from queries
group by query_name


--1193
select date_format(trans_date, '%Y-%m') as month,
       country,
       count(*) as trans_count,
       sum(case when state = 'approved' then 1 else 0 end) as approved_count,
       sum(amount) as trans_total_amount,
       sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from transactions
group by month, country


--1174
select round(
           sum(case when order_date = customer_pref_delivery_date then 1 else 0 end)
           / count(*) * 100,
           2
       ) as immediate_percentage
from delivery
where (customer_id, order_date) in (
    select customer_id, min(order_date)
    from delivery
    group by customer_id
)


--550
select round(
           count(distinct a.player_id)
           / (select count(distinct player_id) from activity),
           2
       ) as fraction
from activity as a
join activity as c
on a.player_id = c.player_id
where (a.player_id, a.event_date) in (
    select player_id, min(event_date)
    from activity
    group by player_id
)
AND datediff(c.event_date, a.event_date) = 1
