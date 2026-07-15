--1757
select product_id
from Products
where low_fats = 'Y' AND recyclable = 'Y';

--584
select name
from Customer
where referee_id !=2
or referee_id is null ;

--595
select name, population, area
from world
where area >=3000000
or population >= 25000000;

--1148
select distinct author_id as id
from Views
where author_id=viewer_id
order by id asc;

--1683
select tweet_id
from Tweets
where length(content)>15;