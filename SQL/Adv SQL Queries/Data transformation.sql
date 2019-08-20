---------------------------
-- Case statement
---------------------------
select
trunc(sales_date, 'mon') as sales_month,
sum(case when product_id=100 then total_amount else 0 end) as total_100,
sum(case when product_id=101 then total_amount else 0 end) as total_101
from sales
group by trunc(sales_date, 'mon')
order by trunc(sales_date, 'mon')

---------------------------
-- Union statement
---------------------------
