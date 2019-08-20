---------------------------
-- Display sub-total
---------------------------
select trunc(sales_date, 'mon') as sales_month, p.product_name,
sum(sales_amount) as sales_amount
from sales s, product p
where s.product_id = p.product_id
group by rollup(trunc(s.sales_date, 'mon'), p.product_name)
order by trunc(s.sales_date, 'mon'), p.product_name

---------------------------
-- Display sub-total & brand-total
---------------------------
select trunc(sales_date, 'mon') as sales_month, p.product_name,
sum(sales_amount) as sales_amount
from sales s, product p
where s.product_id = p.product_id
group by cube(trunc(s.sales_date, 'mon'), p.product_name)
order by trunc(s.sales_date, 'mon'), p.product_name

---------------------------
-- Display sub-total & brand-total in flags
---------------------------
select trunc(sales_date, 'mon') as sales_month, p.product_name,
sum(sales_amount) as sales_amount,
grouping(trunc(sales_date, 'mon')) as flag_1,
grouping(product_name) as flag_2
from sales s, product p
where s.product_id = p.product_id
group by cube(trunc(s.sales_date, 'mon'), p.product_name)
order by trunc(s.sales_date, 'mon'), p.product_name
