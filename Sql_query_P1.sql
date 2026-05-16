-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
             (
                 transactions_id INT PRIMARY KEY,
	             sale_date DATE,
	             sale_time TIME,
	             customer_id INT,
	             gender	VARCHAR(15),
	             age INT,
	             category VARCHAR(15),	
	             quantity INT,
	             price_per_unit FLOAT,	
	             cogs FLOAT,
	             total_sale FLOAT

             );
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_Sales;

-- Data Cleaning
SELECT * FROM retail_Sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_Sales
WHERE sale_date IS NULL;

SELECT * FROM retail_Sales
WHERE sale_time IS NULL;

SELECT * FROM retail_Sales
WHERE 
      transactions_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

DELETE FROM retail_Sales
WHERE 
      transactions_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

-- Data Exploration
-- How many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) AS total_sales 
FROM retail_Sales;

SELECT DISTINCT category 
FROM retail_Sales;

-- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales 
where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category='Clothing' 
AND TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) AS total_sales,
COUNT(*) AS total_orders,
AVG(total_sale) as avg_order_value FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2)AS avg_age
FROM retail_sales
WHERE category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(transactions_id) AS total_transactions 
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
   year,month,avg_sale
FROM
(
 SELECT
   EXTRACT (YEAR FROM sale_date) as year,
   EXTRACT (MONTH FROM sale_date) as month,
   AVG(total_sale) as avg_sale,
   RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) desc) AS rank
   FROM retail_sales
   GROUP BY year,month
) AS t1
WHERE rank=1
  --ORDER BY avg_sale desc;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT * FROM retail_sales;

SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales desc
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unique_cx
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS 
(
 SELECT *,
   CASE 
   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
   ELSE 'Evening'
 END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;

-- Q.11 Write a SQL query to find the customer who made the maximum number of transactions
SELECT customer_id, COUNT(transactions_id) as total_transactions
FROM retail_Sales
GROUP BY customer_id
ORDER BY total_transactions desc
LIMIT 1;

-- Q. 12 Write a SQL query to calculate the total revenue generated in each year
SELECT 
 EXTRACT(YEAR FROM sale_date)as year,
 SUM(total_sale)as total_revenue
 FROM retail_sales
 GROUP BY year;

-----END OF PROJECT