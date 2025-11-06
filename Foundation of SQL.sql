-- Foundation of SQL
-- Retrieve each customer's name, country, and score

SELECT 
	first_name,
	country,
	score
FROM customers

-- Retrieve customers with a score not equal to 0

SELECT *
FROM customers
WHERE score != 0

-- Retrieve customers from Germany

SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany'

/* Retrieve all customers and sort the results by the highest score first. */

SELECT *
FROM customers
ORDER BY score DESC

-- Retrieve all customers and sort the results by the lowest score first

SELECT *
FROM customers
ORDER BY score ASC

-- Retrieve all customers and sort the results by the country and then by the highest score

SELECT *
FROM customers
ORDER BY country ASC, score DESC
		
-- Find the total score for each country

SELECT 
	country,
	SUM(score) AS total_score
FROM customers
GROUP BY country

-- Find the total score and total number of customers for each country

SELECT 
	country,
	SUM(score) AS total_score,
	COUNT(id) AS total_customers
FROM customers
GROUP BY country

/* Find the average score for each country 
considering only customers with a score not equal to 0
and return only those countries with an average score greater than 430
*/

SELECT 
	country,
	AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430

-- Return Unique list of all countries

SELECT DISTINCT
	country
FROM customers

-- Retrieve only 3 Customers

SELECT TOP 3 *
FROM customers

-- Retrieve the top 3 Customers with the Highest Scores

SELECT TOP 3 *
FROM customers
ORDER BY score DESC

-- Retrieve the Lowest 2 Customers based on the score

SELECT TOP 2 *
FROM customers
ORDER BY score ASC

-- Get the two Most Recent Orders

SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC

SELECT 123 AS static_number

SELECT 'Hello' AS static_string

SELECT 
	id,
	first_name,
	'New Customer' AS customer_type
FROM customers

/* Create a new table called persons with columns: id, person_name, birth_date, and phone */

CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

SELECT *
FROM persons

-- Add a new column called email to the persons table

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

-- Remove the column phone from the persons table

ALTER TABLE persons
DROP COLUMN phone

-- Delete the table persons from the database

DROP TABLE persons

SELECT *
FROM customers

INSERT INTO customers (id, first_name, country, score)
VALUES
	(6, 'Anna', 'USA', NULL),
	(7, 'Sam', NULL, 100)

-- Insert data from 'customers' into 'persons'

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers

SELECT *
FROM persons

-- Change the score of customers 6 to 0

UPDATE customers
SET score = 0
WHERE id = 6

SELECT *
FROM customers
WHERE id = 6

-- Change the score of customer 10 to 0 and update the country to UK

UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id = 7

-- Update all customers with a NULL score by setting their score 0

UPDATE customers 
SET score = 0
WHERE score IS NULL

SELECT *
FROM customers
WHERE score IS NULL

-- Delete all customers with an ID greater than 5

DELETE FROM customers
WHERE id > 5

SELECT *
FROM customers
WHERE id > 5

-- Delete all data from table persons

TRUNCATE TABLE persons

