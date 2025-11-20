-- Aggregation & Analytical Functions

-- Find the total number of orders
-- Find the total sales of all orders
-- Find the average sales of all orders
-- Find the highest sales of all orders
-- Find the lowest sales of all orders

USE MyDatabase

SELECT
	customer_id,
	COUNT(*) AS total_nr_orders,
	SUM(sales) AS total_sales,
	AVG(sales) AS avg_sales,
	MAX(sales) AS highest_sales,
	MIN(sales) AS lowest_sales
FROM orders
GROUP BY customer_id

-- Window Functions
-- Find the total sales across all orders. Additionally provide details such Order Id, Order Date

USE SalesDB

SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER () TotalSales
FROM Sales.Orders

-- Find the total sales for each product. Additionally provide details such Order ID, Order Date

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

/* Find the total sales across all orders 
   Find the total sales for each product
   Find the total sales for each combination of product and order status
   Additionally provide details such Order Id, Order Date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts,
	SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders

/* Rank each order based on their sales from highest to lowest.
Additionally provide details such as Order Id, Order Date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders

-- Window Frame

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

-- Rank Customers based on their total sales

SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID

-- Window Aggregate
-- Find the total number of Orders. Additionally provide details such Order ID, Order Date

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders

/* Find the total number of customers. 
Find the total number of scores for the customers.
Find the total number of countries for the customers.
Additionally provide All customers details */

SELECT
	*,
	COUNT(*) OVER() TotalCustomersStar,
	COUNT(1) OVER() TotalCustomersOne,
	COUNT(Score) OVER() TotalScores,
	COUNT(Country) OVER() TotalCountries
FROM Sales.Customers

-- Check whether the table 'Orders Archieve' contains any duplicate rows

SELECT
	*
FROM(
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
)t WHERE CheckPK > 1

/* Find the total sales across all orders
Find the total sales for each product
Additionally provide details such Order ID, Order Date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesByProduct
FROM Sales.Orders

-- Find the percentage contribution of each product's sales to the total sales

SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
	ROUND(CAST(Sales AS Float) / SUM(Sales) OVER() * 100, 2) PercentageOfTotal
FROM Sales.Orders

/* Find the average sales across all orders
Find the average sales for each product
Additionally provide details such Order ID, Order Date */

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders

/* Find the average scores of customers. 
Additionally provide details such CustomerID and LastName */

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) CustomerScore,
	AVG(Score) OVER() AvgScore,
	AVG(COALESCE(Score,0)) OVER() AvgScoreWithoutNull
FROM Sales.Customers

--Find all orders where sales are higher than the average sales across all orders

SELECT
	*
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
)t WHERE Sales > AvgSales

/* Find the highest and lowest sales of all orders
Find the highest and lowest sales for each product
Additionally provide details such Order ID, Order Date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) OVER() LowestSales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
	MAX(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct
FROM Sales.Orders

--Show the employees who have the highest salaries

SELECT
	*
FROM(
	SELECT
		*,
		MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
)t WHERE Salary = HighestSalary

-- Find the deviation of each sales from the minimum and maximum sales amounts

SELECT
	*,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders

-- Running Total & Rolling Total
-- Moving Average
-- Calculate moving average of sales for each product over time
-- Calculate moving average of sales for each product over time, including only the next order

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) SalesByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders

-- Window Ranking
-- Top/Bottom N Analysis (Integer-based Ranking)

-- ROW_NUMBER()
-- RANK()
-- DENSE_RANK()
-- Rank the orders based on their sales from highest to lowest

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) RowNumberSales,
	RANK() OVER(ORDER BY Sales DESC) RankSales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) DenseRankSales
FROM Sales.Orders 

-- TOP-N Analysis
-- Find the top highest sales for each product

SELECT *
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
	FROM Sales.Orders
)t WHERE RankByProduct = 1

-- BOTTOM-N Analysis
-- Find the lowest 2 Customers based on their total sales

SELECT *
FROM(
	SELECT
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
	FROM Sales.Orders
	GROUP BY CustomerID
)t WHERE RankCustomers <= 2

-- Generate UNIQUE IDs
-- Assign unique IDs to the rows of the 'Orders Archive' table

SELECT
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive

-- Identify Duplicates
/* Identify duplicate rows in the table 'Orders Archive' 
and return a clean result without any duplicates */

SELECT *
FROM(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) RowNumber,
		*
	FROM Sales.OrdersArchive
)t WHERE RowNumber = 1

-- NTILE()

SELECT
	OrderID,
	Sales,
	NTILE(4) OVER(ORDER BY Sales DESC) FourBucket,
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
	NTILE(1) OVER(ORDER BY Sales DESC) OneBucket
FROM Sales.Orders

-- Data Segmentation
-- Segment all orders into 3 categories: high, medium and low sales.

SELECT
	*,
	CASE WHEN Buckets = 1 THEN 'High'
		 WHEN Buckets = 2 THEN 'Medium'
		 WHEN Buckets = 3 THEN 'Low'
	END SaleSegmentation
FROM(
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.Orders
)t

-- Equalizing LOAD
-- In order to export the data, divide the orders into 2 groups

SELECT
	NTILE(2) OVER(ORDER BY OrderID) Buckets,
	*
FROM Sales.Orders

-- Distribution Analysis (Percentage-based Ranking)
-- CUME_DIST
-- Find the products that fall within the highest 40% of the prices

SELECT 
	*,
	CONCAT(DistRank * 100, '%') DistRankPerc
FROM(
	SELECT
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) DistRank
	FROM Sales.Products
)t
WHERE DistRank <= 0.4

-- PERCENT_RANK
-- Find the products that fall within the highest 40% of the prices

SELECT 
	*,
	CONCAT(PercentRank * 100, '%') DistRankPerc
FROM(
	SELECT
		Product,
		Price,
		PERCENT_RANK() OVER(ORDER BY Price DESC) PercentRank
	FROM Sales.Products
)t
WHERE PercentRank <= 0.4

-- Value Window Functions
-- LEAD / LAG
-- Time Series Analysis 
-- Month-Over-Month Analysis
/* Analyze the month-over-month performance by finding the percentage change
in sales between the current and previous months */

SELECT
	*,
	CurrentMonthSales - PreviousMonthSales MoM_Change,
	ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100, 1) MoM_Perc
FROM(
	SELECT
		MONTH(OrderDate) OrderMonth,
		SUM(Sales) CurrentMonthSales,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)t 

-- Customer Retention Analysis
/* In order to analyze customer loyality, 
rank customers based on the average days between their orders */

SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AvgDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 9999999)) RankAvg
FROM(
	SELECT
		OrderID,
		CustomerID,
		OrderDate CurrentOrder,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
		DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders
)t
GROUP BY CustomerID
 
-- FIRST_VALUE()
-- LAST_VALUE()
/* Find the lowest and highest sales for each product.
Find the difference in sales between the current and the lowest sales */

SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSales1,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSales3,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) SalesDifference
FROM Sales.Orders