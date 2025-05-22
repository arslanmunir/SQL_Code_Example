-- Use this table for the answer to question 1:
-- List the overall top five names in alphabetical order and find out if each name is "Classic" or "Trendy."
select first_name,  count (year) as sum,  case when count(year)>= 50 then 'Classic' else 'Trendy' end as  popularity_type 
from baby_names 
group by first_name	
order by first_name limit 5 ;

-- Use this table for the answer to question 2:
-- What were the top 20 male names overall, and how did the name Paul rank?
select dense_rank() over(order by count(year) desc) name_rank,first_name,count(year) sum from baby_names
where sex ='M'
group by first_name
limit 20;

-- Use this table for the answer to question 3:
-- Which female names appeared in both 1920 and 2020?
select first_name,count(year) total_occurrences from baby_names
where sex='F' and year in ('1920','2020')
	group by first_name
	having count(year) >1
	order by first_name;