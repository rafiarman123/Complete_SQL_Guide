-- SQL SET Operator

-- UNION
-- Combine the data from employees and customers into one table

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION
SELECT 
	FirstName,
	LastName
FROM Sales.Employees;

-- UNION ALL
-- Combine the data from employees and customers into one table, including duplicates

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION ALL
SELECT 
	FirstName,
	LastName
FROM Sales.Employees;

-- EXCEPT
-- Find the employees who are not customers at the same time

SELECT 
	FirstName,
	LastName
FROM Sales.Employees
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Customers;

-- INTERSECT
-- Find the employees, who are also customers.

SELECT 
	FirstName,
	LastName
FROM Sales.Employees
INTERSECT
SELECT 
	FirstName,
	LastName
FROM Sales.Customers;

-- Orders data are stored in separate tables (Orders and OrdersArchive)
-- Combine all orders data into one report without duplicates.

SELECT
       'Orders' AS SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
       'OrdersArchive' AS SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID
;