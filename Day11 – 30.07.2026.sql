--185
select department, employee, salary
from(select department.name as department, employee.name as employee, employee.salary as salary,
dense_rank() over (
partition by employee.departmentid
order by employee.salary desc) as salary_rank
from employee
left join department
on employee.departmentid=department.id) as abc
where salary_rank<=3

--196
delete from person
where id not in(
    select id
    from(
        select min(id) as id
        from person
        group by email
    ) as abc
)

--1517
select user_id,name,mail
from users
where regexp_like(mail,'^[A-Za-z][A-Za-z0-9_.-]*@leetcode[.]com$','c')