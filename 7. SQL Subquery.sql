-- Subquery

-- Result Types
-- Scalar Subquery

SELECT
	AVG(Sales) Avg_Sales
FROM Sales.Orders

-- Row Subquery

SELECT
	CustomerID
FROM Sales.Orders

-- Table Subquery

SELECT
	OrderID,
	OrderDate
FROM Sales.Orders

-- Location Types
-- FROM Subquery
-- Find the products that have a price higher than the average price of all products

-- Main query
SELECT
	*
FROM (
	-- Subquery
	SELECT 
		ProductID,
		Price,
		AVG(Price) OVER() AvgPrice
	FROM Sales.Products
)t
WHERE Price > AvgPrice;

-- Rank Customers based on their total amount of sales

-- Main query
SELECT
	*,
	RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
FROM (
	-- Subquery
	SELECT
		CustomerID,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t

-- SELECT Subquery
-- Show the Product IDs, Product Names, Prices and the total number of orders

-- Main query
SELECT
	ProductID,
	Product,
	Price,
	-- Subquery
	(SELECT COUNT(*) FROM Sales.Orders) TotalOrders
FROM Sales.Products;

-- JOIN Subquery
-- Show all customer details and find the total orders for each customer

--Main query
SELECT
	c.*,
	o.TotalOrders
FROM Sales.Customers c
LEFT JOIN(
	-- Subquery
	SELECT 
		CustomerID,
		COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID;

-- WHERE Subquery
-- Find the products that have a price higher than the average price of all products

-- Main query
SELECT
	ProductID,
	Price,
	(SELECT AVG(Price) FROM Sales.Products) AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

-- Show the details of orders made by customers in Germany

SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN
				(SELECT
					CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany')

-- Show the details of orders made by customers not in Germany

SELECT
	*
FROM Sales.Orders
WHERE CustomerID NOT IN
				(SELECT
					CustomerID
				FROM Sales.Customers
				WHERE Country = 'Germany')

-- Find female employees whose salaries are greater than the salaries of any male employees

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

-- Find female employees whose salaries are greater than the salaries of all male employees

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

-- Dependency Type
-- Correlated Subquery
-- Show all customer details and find the total orders of each customer

SELECT
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c

-- Show the details of orders made by customers in Germany

SELECT
	*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1
			  FROM Sales.Customers c
			  WHERE Country = 'Germany'
			  AND o.CustomerID = c.CustomerID)

-- Show the details of orders made by customers not in Germany

SELECT
	*
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT 1
			  FROM Sales.Customers c
			  WHERE Country = 'Germany'
			  AND o.CustomerID = c.CustomerID)