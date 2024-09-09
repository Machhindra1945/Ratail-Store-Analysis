--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from sales
where sale_date = '2022-11-05'

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from sales
where category = 'Clothing' and quantiy >= 4 
and To_char(sale_date,'YYYY-MM') = '2022-11'

--3. Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sale, count(*) as total_orders from sales
group by 1 
-- group by 1 or group by category is ok

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, round(Avg(age),2) as Avg_age_customer from sales
where category = 'Beauty'
group by category

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from sales
where 
	total_sale > 1000
order by 
	total_sale desc

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category, 
	gender, 
	count(*) as total_sales 
from sales
group by 
	category,gender
order by 1

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year, month, avg_sales from
(
	select 
		extract(YEAR from sale_date) as year,
		extract(MONTH from sale_date) as month,
		round(avg(total_sale),2) as avg_sales,
		rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale)desc)as rank
	from sales
	group by 1,2
)as t1
where rank = 1

--8. Write a SQL query to find the top 5 customers based on the highest total sales.
select 
	customer_id, 
	sum(total_sale) as total_sales 
from sales
group by 1
order by 2 desc
limit 5


--9. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as No_of_customer from sales
group by category

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as 
(
select *, 
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternon'
		else 'Evening'
	end as shift
from sales
)
select shift,
		count(*) as total_sales
from hourly_sale
group by shift

