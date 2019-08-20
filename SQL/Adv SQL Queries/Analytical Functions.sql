
---------------------------
-- Why analytical functions
---------------------------
-- Bad example 1
select s.sales_date, s.order_id, s.product_id, s.customer_id, s.total_amount,
savg.avg_total_amount
from sales s,
(
select sales_date, avg(total_amount) as avg_total_amount
from sales
group by sales_date
) savg
where s.sales_date = savg.sales_date
order by s.sales_date
-- Good example 1 using Analytical function
select s.sales_date, s.order_id, s.product_id, s.customer_id, s.total_amount,
avg(total_amount) over (partition by sales_Date) as avg_total_amount
from sales s
order by s.sales_date

-- Good example 2: group by total, day, and month in 1 query
select s.sales_date, s.order_id, s.product_id, s.customer_id, s.total_amount,
avg(total_amount) over () as avg_total, -- AVG of whole table
avg(total_amount) over (partition by sales_date) as avg_by_day, -- AVG grouped by date
avg(total_amount) over (partition by trunc(sales_date, 'mon')) as avg_by_month -- AVG group by month
from sales s

---------------------------
-- Cumulative Sum for each row
---------------------------
select sales_date, order_id, product_id, sales_amount,
sum(sales_amount) over (order by sales_date, order_id, product_id) as cum_sum
from sales

---------------------------
-- Display percentage
---------------------------
select trunc(sales_date, 'mon') as sales_month,
sum(total_amount) as total_amount,
ratio_to_report(sum(total_amount)) over () * 100 as ratio_perc_1 -- ratio of whole data table
from sales
group by trunc(sales_date, 'mon')

---------------------------
-- Rank function: Top 3 salesperson
---------------------------
select * from (
select trunc(s.sales_date, 'mon') as sales_month, sp.first_name,
sum(total_amount) as total_amount,
rank() over (partition by trunc(s.sales_date, 'mon') order by sum(total_amount) desc) as salesperson_rank_top
from sales s, salesperson sp
where s.salesperson_id = sp.salesperson_id
group by trunc(s.sales_date, 'mon'), sp.first_name
)
where salesperson_rank_top <= 3

---------------------------
-- Divising into Bands
---------------------------
select sp.first_name,
sum(total_amount) as total_amount,
ntile(3) over (order by sum(total_amount) desc) as bucket_list
from sales s, salesperson sp
where s.salesperson_id = sp.salesperson_id
group by sp.first_name

---------------------------
-- Sales growth across time
---------------------------
select sales_month, sales_amount_current,
previous_month, next_month,
((sales_amount - previous_month) / previous_month) * 100 as growth_perc
from (
select trunc(sales_date, 'mon') as sales_month,
sum(sales_amount) as sales_amount_current,
lag(sum(sales_amount), 1) over (order by trunc(sales_date, 'mon')) as previous_month,
lead(sum(sales_amount), 1) over (order by trunc(sales_date, 'mon')) as next_month
from sales s
group by trunc(sales_date, 'mon')
)


