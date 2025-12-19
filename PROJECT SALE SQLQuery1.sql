-- sql retail sales analtsis
 use sql_project_p1

--creating table
 create table retail_sales
 (
 transactions_id int primary key,
 sale_date date,
 sale_time time,	
 customer_id int,
 gender varchar(15),
 age int,	
 category	varchar(15),
 quantity int, 	
 price_per_unit float, 
 cogs float,	
 total_sale float
 );

--Check for any null values in the dataset and delete records with missing data.

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR 
    gender IS NULL OR 
    age IS NULL OR
    category IS NULL OR 
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL or 
    price_per_unit = 0;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR
    sale_time IS NULL OR 
    customer_id IS NULL OR 
    gender IS NULL OR
    age IS NULL OR 
    category IS NULL OR 
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL or
    price_per_unit = 0;

--Data exploratition

--How many sales we have?
 
select count(*) as total_sale from retail_sales

select count(distinct customer_id) as total_sale from retail_sales

select distinct category from retail_sales

--Data analysis & business key problem & answer

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

select * from retail_sales
where sale_date = '2022-11-05'

/*2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022*/

select  * from retail_sales
where category ='clothing'
and 
year(sale_date) = 2022
and 
month(sale_date) = 11
and 
quantity >= 4

--3. **Write a SQL query to calculate the total sales (total_sale) for each category.

select 
category,
sum (total_sale) as net_sales,
count(*) as total_orders
from retail_sales
group by category

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
avg(age) as avg_age
from retail_sales
where category= 'beauty'

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
category,
gender,
count(*) as total_sales
from retail_sales
group by 
category, 
gender
order by  
category,
gender


--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from
( 
   select
         year(sale_date) as sale_year,
         month(sale_date) as sale_month,
         avg (total_sale) as avg_sale,
         rank()over (partition by year(sale_date) order by avg (total_sale)desc) as rank
from retail_sales
group by year(sale_date),
         month(sale_date)
) as t1
where rank = 1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales

select top 5
     customer_id,
     sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc ;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.

select 
      category,
      count(distinct customer_id) as unique_customer
from retail_sales
group by category


/*10. Write a SQL query to create each shift and number of
orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/

;with hourly_sale
as(
select *,
     case
         when datepart(hour,sale_time)< 12 then 'Morning'
         when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
         else 'Evening'
     end as shift
from retail_sales
)
select 
      shift,
      count(*) as total_sales
from hourly_sale
group by shift;


--END OF PROJECT
