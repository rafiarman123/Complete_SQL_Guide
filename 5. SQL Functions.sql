-- SQL Functions
-- String Functions

-- Manipulation
-- CONCAT / LOWER / UPPER
-- Show a list of customers' first names together with their country in one column
-- Transform the customer's first name to lowercase
-- Transform the customer's first name to uppercase

USE MyDatabase

SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ', country) AS name_country,
	LOWER(first_name) AS low_name,
	UPPER(first_name) AS up_name
	FROM customers;

-- TRIM
-- Find customers whose first name contains leading or trailing spaces

SELECT
	first_name,
	LEN(first_name) AS len_name,
	LEN(TRIM(first_name)) AS len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name));
-- WHERE first_name != TRIM(first_name)

-- REPLACE
-- Remove dashes (-) from a phone number

SELECT
	'123-456-7890' AS phone,
	REPLACE('123-456-7890', '-', '') AS clean_phone;

-- Replace File Extence from text to csv

SELECT
	'report.txt' AS old_filename,
	REPLACE('report.txt', '.txt', '.csv') AS new_filename;

-- Calculation
-- LEN
-- Calculate the length of each customer's first name

SELECT 
	first_name,
	LEN(first_name) AS len_name
FROM customers;

-- String Extraction
-- LEFT & RIGHT
-- Retrieve the first two characters of each first name
-- Retrieve the last two characters of each first name

SELECT 
	first_name,
	LEFT(TRIM(first_name), 2) first_2_char,
	RIGHT(TRIM(first_name), 2) last_2_char
FROM customers;

-- SUBSTRING
-- Retrieve a list of customers' first names after removing the first character

SELECT
	first_name,
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) sub_name
FROM customers;

-- Number Functions
-- ROUND

SELECT
	3.516,
	ROUND(3.516, 2) round_2,
	ROUND(3.516, 1) round_1,
	ROUND(3.516, 0) round_0;

-- ABS

SELECT
	-10,
	ABS(-10),
	ABS(10);

-- Date & Time Functions
-- Date Column From a Table
-- Hardcoded Constant String Value
-- GETDATE Function

USE SalesDB

SELECT 
	OrderID,
	CreationTime,
	'2025-08-20' HardCoded,
	GETDATE() Today
FROM Sales.Orders;

-- Part Extration
-- DAY/MONTH/YEAR
-- DATEPART
-- DATENAME
-- DATETRUNC

SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) Year,
	MONTH(CreationTime) Month,
	DAY(CreationTime) Day,

	DATEPART(year, CreationTime) Year_dp,
	DATEPART(month, CreationTime) Month_dp,
	DATEPART(day, CreationTime) Day_dp,
	DATEPART(hour, CreationTime) Hour_dp,
	DATEPART(quarter, CreationTime) Quarter_dp,
	DATEPART(week, CreationTime) Week_dp,

	DATENAME(month, CreationTime) Month_dn,
	DATENAME(weekday, CreationTime) Weekday_dn,

	DATETRUNC(minute, CreationTime) Minute_dt,
	DATETRUNC(day, CreationTime) Day_dt,
	DATETRUNC(year, CreationTime) Year_dt
FROM Sales.Orders;

-- Usefulness of DATETRUNC

SELECT 
	DATETRUNC(month, CreationTime) Creation,
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime);

-- EOMONTH

SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) EndOfMonth,
	CAST(DATETRUNC(month, CreationTime) AS DATE) StartofMonth
FROM Sales.Orders;

-- How many orders were placed each year?

SELECT 
	YEAR(OrderDate) Year,
	COUNT(*) NumberOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

-- How many orders were placed each month?  

SELECT 
	DATENAME(month, OrderDate) Month,
	COUNT(*) NumberOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

-- Show all orders that were placed during the month of february

SELECT 
	*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

-- Formating & Casting
-- FORMAT

SELECT
	OrderID,
	CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') USA_Format,
	FORMAT(CreationTime, 'dd-MM-yyyy') EURO_Format,
	FORMAT(CreationTime, 'dd') dd,
	FORMAT(CreationTime, 'ddd') ddd,
	FORMAT(CreationTime, 'dddd') dddd,
	FORMAT(CreationTime, 'MM') MM,
	FORMAT(CreationTime, 'MMM') MMM,
	FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders;

-- Show CreationTime using the following format: Day Wed Jan Q1 2025 12:34:56 PM

SELECT
	OrderID,
	CreationTime,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') +
	' Q' + DATENAME(quarter, CreationTime) + ' ' +
	FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;

-- Sample Data Aggregation

SELECT
	FORMAT(OrderDate, 'MMM yy') OrderDate,
	COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy');

-- CONVERT

SELECT
	CONVERT(INT, '123') AS [String to INT CONVERT],
	CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
	CreationTime,
	CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
	CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
	CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders

-- CAST

SELECT
	CAST('123' AS INT) AS [String to INT],
	CAST(123 AS VARCHAR) AS [INT to String],
	CAST('2025-08-20' AS DATE) AS [String to Date],
	CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
	CreationTime,
	CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders

-- Date Calculation
-- DATEADD

SELECT 
	OrderID,
	OrderDate,
	DATEADD(year, 2, OrderDate) AS TwoYearsLater,
	DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
	DATEADD(day, -10, OrderDate) AS TenDaysBefore
FROM Sales.Orders 

-- DATEDIFF
-- Calculate the age of employees

SELECT 
	EmployeeID,
	BirthDate,
	DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees

-- Find the average shipping duration in days for each month

SELECT 
	MONTH(OrderDate) AS OrderDate,
	AVG(DATEDIFF(day, OrderDate, ShipDate)) AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

-- Time Gap Analysis
-- Find the number of days between each order and the previous order 

SELECT
	OrderID,
	OrderDate CurrentOrderDate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
	DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) 
FROM Sales.Orders

-- Date Validation
-- ISDATE

SELECT
	ISDATE('123') DateCheck1,
	ISDATE('2025-08-20') DateCheck1,
	ISDATE('20-08-2025') DateCheck1,
	ISDATE('2025') DateCheck1,
	ISDATE('08') DateCheck1

-- Practical example

SELECT 
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
)t
WHERE ISDATE(OrderDate) = 0;

-- NULL Function
-- ISNULL
-- COALESCE
-- Find the average scores of the customers

SELECT
	CustomerID,
	Score,
	COALESCE(Score,0) Score2,
	AVG(Score) OVER() AvgScores,
	AVG(COALESCE(Score,0)) OVER() AvgScores2
FROM Sales.Customers;

-- Display the full name of customers in a single field by merging their first and last names,
-- and add 10 bonus points to each customer's score.

SELECT
	CustomerID,
	FirstName,
	LastName,
	FirstName + ' ' + COALESCE(LastName, '') AS FullName,
	Score,
	COALESCE(Score, 0) + 10 AS ScoreWithBonus
FROM Sales.Customers;

-- Sorting the data
-- Sort the customers from lowest to highest scores, with null appearing last

SELECT
	CustomerID,
	Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score;

-- NULLIF()
-- Find the sales price for each order by deviding sales by quantity

SELECT
	OrderID,
	Sales,
	Quantity,
	Sales / NULLIF(Quantity, 0) AS Price
FROM Sales.Orders

-- IS NULL / IS NOT NULL
-- Identify the customers who have no scores

SELECT *
FROM Sales.Customers
WHERE Score IS NULL

-- List all customers who have scores

SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

-- List all details for customers who have not placed any orders

SELECT 
	c.*,
	o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

-- Data Policy

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)

SELECT 
	*,
	DATALENGTH(Category) CategoryLen,
	DATALENGTH(TRIM(Category)) Policy1,
	TRIM(Category) Policy2,
	NULLIF(TRIM(Category), '') Policy3,
	COALESCE(NULLIF(TRIM(Category), ''), 'unknown') Policy4
FROM Orders;