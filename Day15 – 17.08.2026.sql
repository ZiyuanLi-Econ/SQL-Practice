--620
select id,movie,description,rating 
from cinema
where id%2=1 and description != 'boring'
order by rating desc

--1251
select p.product_id, ifnull(round(sum(p.price*u.units)/sum(u.units),2),0) as average_price
from prices as p
left join unitssold as u
on p.product_id=u.product_id and u.purchase_date>=p.start_date and u.purchase_date<=p.end_date
group by p.product_id