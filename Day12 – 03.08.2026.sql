--1378
select unique_id,name
from employeeuni
right join employees
on employeeuni.id=employees.id

--1068
select product_name,year,price
from Sales
join Product
on Sales.product_id=Product.product_id

--1581
select v.customer_id, count(*) as count_no_trans
from visits as v
left join transactions as t 
on v.visit_id=t.visit_id
where t.transaction_id is null
group by v.customer_id

--197
select today.id 
from weather as today
join weather as yesterday
on datediff(today.recorddate,yesterday.recorddate)=1
where today.temperature>yesterday.temperature
