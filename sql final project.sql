-- SQL Reatil Sales Analysis -P1
create database sql_project_p1;

---Create table
DROP TABLE IF EXISTS retail_sales;

Create table retail_sales(
              transactions_id INT PRIMARY KEY,
			  sale_date DATE,
			  sale_time	 TIME,
			  customer_id INT,	
			  gender  VARCHAR(15),
			  age INT,
			  category VARCHAR(15),	
			  quantiy INT,
			  price_per_unit FLOAT,	
			  cogs	FLOAT,
			  total_sale FLOAT);
 select * from retail_sales;
 select count(*) from retail_sales;
 ----Data cleaning
 select * from retail_sales WHERE transactions_id IS NULL
 select * from retail_sales
 where 
 transactions_id IS NULL
 OR sale_date IS NULL
 OR sale_time Is Null
 OR customer_id IS NULL
 OR gender IS NULL
 OR category IS NULL
 OR quantiy IS NULL
 OR cogs IS NUll
 OR total_sale IS NULL
 --- Data exploration
 --- How many sales we have?
 select count(*) as total_sale from retail_sales
 ---How many unique customers we have?
 select count(distinct customer_id) as total_sale from retail_sales
 select DISTINCT category FROM retail_sales

 --- Data Analysis & Business Key Problems & Answers
 --- Q1.Write a sql query on retrive all coloumns for sales made on '2022-11-05'
 
 Select * FROM retail_sales where sale_date = '2022-11-05';
 --- Q2 Write a SQL query to retrive all transactions where the category is 'Clothing and the quantity sold is more than 4 in the month of Nov-2022
  SELECT * FROM retail_sales where category = 'Clothing' 
  AND 
  sale_date LIKE '2022-11%'
  AND 
  quantiy >= 4
---Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
   SELECT
   category,
   SUM(CAST(total_sale AS FLOAT)) as net_sale,
   COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;
---Q4 Write a SQL query to find the average age of customer who purchased items from the "Beauty' category.
   SELECT
       ROUND(AVG(CAST(age AS FLOAT)) , 2) AS avg_age
	   FROM retail_sales
	   where category ='Beauty'
---Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
    SELECT * FROM retail_sales WHERE total_sale > 1000
---Q6 Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category.
    SELECT
	category,
	gender,
	COUNT(*)  as total_trans
	FROM retail_sales
	GROUP
	BY
	category,
	gender
	order by 1
---Q7 Write a SQL query to calculate the average sale for each month.Find out best selling month in each year
  with MonthlySales AS (
	SELECT
	YEAR (sale_date) as year,
	MONTH(sale_date) as month,
	AVG(CAST(total_sale as float)) as avg_sale
	FROM retail_sales
	GROUP BY YEAR(sale_date),MONTH(sale_date)),
	RankedSales as(
	Select *,
	RANK() OVER(PARTITION BY YEAR ORDER BY avg_sale DESC) as sale_rank
	From Monthlysales)
	Select * FROM RankedSales WHERE sale_rank = 1
	order by year;
---Q8 Write a SQL query to find the top 5 customers based on the highest total sales
    
	SELECT TOP 5
	    customer_id,
		SUM(CAST(total_sale as float)) as total_sales
	 FROM retail_sales
	 GROUP by customer_id
	 order  by total_sales DESC;
---Q9 Write a SQL query to find the number of unique customer who purchased items from each category.
   SELECT
        category,
	COUNT(DISTINCT customer_id)as cnt_unique_cs
	 FROM retail_sales
	 GROUP BY category
---Q10 Write a SQL query to create each shiftt and number of orders (Example Moring <=12, Afternoon Between 12 7 17, Evening >17)
    WITH hourly_sale
	AS
	(
	SELECT *,
	CASE
	WHEN DATEPART(HOUR, sale_time)< 12 THEN 'Morning'
	WHEN DATEPART(HOUR,sale_time) BETWEEN 12 and 17 THEn 'Afternoon'
	ELSE 'Evening'
	END as shift
	FROM retail_sales
	)
	SELECT 
	shift,
	COUNT(*) as order_count
FROM hourly_sale
GROUP BY shift;
--- END of project