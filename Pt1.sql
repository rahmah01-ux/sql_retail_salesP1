--SQL Retail Sales Analysis - P1

CREATE DATABASE sql_project_p2;

-- CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	)


SELECT * 
FROM retail_sales
LIMIT 10

-- Have we imported the correct dataset (compare COUNT with excel)?
SELECT COUNT(*)
FROM retail_sales;

-- Data Cleaning 
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL 


SELECT * 
FROM retail_sales
WHERE sale_date IS NULL 

SELECT * 
FROM retail_sales
WHERE sale_time IS NULL 

SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL 

SELECT * 
FROM retail_sales
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

--
DELETE FROM retail_sales
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


-- Data Explorations

-- What is te total number of records?
SELECT COUNT(*) AS ret ail_sale
FROM retail_sales

-- How many unique customers do we have?
SELECT DISTINCT COUNT(*) customer_id 
FROM retail_sales;

-- How many categories are there?
SELECT COUNT(DISTINCT category)
FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- Q1) Write a query to retrieve all columns for sales made on'2022-22-05'?

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2) Write a query to retrieve where the category is 'clothing' AND the quantity sold is more than 4 in the month of nov-22


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
	category,
	SUM(total_sale) AS total_sales,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1


-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'beauty' category

SELECT ROUND(AVG(age),0)
FROM retail_sales
WHERE category = 'Beauty';

--Q5 Write a query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale >= 1000


--Q6 Write a SQL query to find the total number of transactions made by each gender in each category

SELECT 
		Category, 
		gender,
		COUNT(transactions_id)	
FROM retail_sales
GROUP BY 1,2
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT * 
FROM 
(    	SELECT 
				EXTRACT(YEAR FROM sale_date) AS year, 
				EXTRACT(MONTH FROM sale_date) AS month, 
				AVG(total_sale) AS average_sale,
				RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
		FROM retail_sales
		GROUP BY 1,2
) AS table_1
WHERE rank = 1

--ORDER BY 1,3 DESC


-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
		customer_id,
		SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
		

-- Q9 Write a SQL query to find the the number of unique customers who purchased items from each stock

SELECT 
		COUNT(DISTINCT(customer_id)) AS Unique_customers_count,
		category
FROM retail_sales
GROUP BY 2

--Q10 Write a SQL query to create each shift and number of orders(Example Morning <=12, Afternoon Between 12-17 and Evening >17)

SELECT *,
CASE 
		 WHEN sale_time <= '12:00:00' THEN 'Morning'
		 WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
		 ELSE 'Evening'
	END AS time_of_day
FROM retail_sales;

-- Use EXTRACT instead return the hour only and use a CTE 'common table expressions', then we can use a GROUP BY and COUNT

WITH hourly_rate
AS 
(
SELECT *,
	CASE 
		 WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
	END AS time_of_day
FROM retail_sales
)
SELECT time_of_day, COUNT(*) AS total_orders
FROM hourly_rate
GROUP BY time_of_day


-- END OF PROJECT









