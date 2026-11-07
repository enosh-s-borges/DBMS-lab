/*Data Manipulation Language (DML) and Data Control Language 
(DCL)
Write valid DML statements to retrieve tuples from the databases. The 
query may contain appropriate DML and DCL commands such as:
Select with
%like, between, where clause
Order by
Set Operations
Exists and not exists
Join operations
Aggregate functions
Group by
Group by having
Nested and correlated nested Queries
Grant and revoke permission

*/

/* Order_processing_DCL_DML DATABASE*/

USE Order_processing;

-- LIKE OPERATOR
SELECT * FROM Customer WHERE city LIKE '____2';

SELECT * FROM order_ WHERE odate LIKE '%11%';

DELETE FROM Shipment 
WHERE order_=203;

-- BETWEEN OPEARTOR;
SELECT * FROM Warehouse WHERE city BETWEEN 'City1' AND 'City5';

SELECT * FROM order_ WHERE odate BETWEEN '2023-04-12' AND '2023-04-14' 
AND cust IN (SELECT cust FROM Customer WHERE city = 'City2');

-- WHERE clause
SELECT * FROM Item WHERE unitprice=500;

-- Order By
SELECT * FROM Warehouse WHERE warehouse>903 ORDER BY warehouse DESC;
SELECT * FROM Warehouse WHERE warehouse>903 ORDER BY warehouse;

-- SET operation
-- UNION operation
SELECT cust,cname  FROM Customer
UNION
SELECT warehouse,city FROM Warehouse;

-- Intersect Opeartion
SELECT * FROM Warehouse WHERE 
warehouse IN (SELECT warehouse FROM Shipment);

-- MINUS operator
SELECT * FROM Warehouse WHERE 
warehouse NOT IN (SELECT warehouse FROM Shipment);

-- EXISTS command
SELECT * FROM order_ WHERE EXISTS (SELECT * FROM Shipment WHERE order_.order_ = Shipment.order_);

-- NOT EXISTS
  
SELECT * FROM order_ WHERE NOT EXISTS (SELECT * FROM Shipment WHERE order_.order_ = Shipment.order_);

-- JOIN 
-- INNER JOIN
SELECT * FROM order_ JOIN Shipment ON order_.order_=Shipment.order_;

-- LEFT JOIN
SELECT * FROM Warehouse LEFT JOIN Shipment ON Warehouse.warehouse=Shipment.warehouse;

-- RIGHT JOIN
SELECT * FROM Warehouse RIGHT JOIN Shipment ON Warehouse.warehouse=Shipment.warehouse;
  
-- FULL OUTER JOIN
 -- Using LEFT JOIN
SELECT Warehouse.*, Shipment.*
FROM Warehouse
LEFT JOIN Shipment ON Warehouse.warehouse = Shipment.warehouse
UNION
-- Using RIGHT JOIN
SELECT Warehouse.*, Shipment.*
FROM Warehouse
RIGHT JOIN Shipment ON Warehouse.warehouse = Shipment.warehouse
WHERE Warehouse.warehouse IS NULL;

-- Aggregate funnction;
SELECT Customer.cust, Customer.cname, SUM(order_.order_amt) AS total_order_amount FROM Customer JOIN order_ ON Customer.cust = order_.cust GROUP BY Customer.cust, Customer.cname;

-- Average amount
SELECT AVG(OrderItem.qty) AS avg_quantity_ordered
FROM OrderItem;

-- GROUP BY HAVING
SELECT Shipment.warehouse, COUNT(Shipment.order_) 
AS order_count FROM Shipment GROUP BY Shipment.warehouse HAVING order_count > 0;

-- nested queries
SELECT * FROM Warehouse WHERE warehouse IN (SELECT warehouse FROM Shipment);

-- corelated queries
SELECT * FROM order_ WHERE EXISTS (SELECT * FROM Shipment WHERE order_.order_=Shipment.order_);

-- grant command
GRANT select ON hussain.Shipment TO 'JOHN'@'localhost';
ERROR 1410 (42000): You are not allowed to create a user with GRANT

-- revoke command
 REVOKE select ON hussain.Shipment FROM 'JOHN'@'localhost';
ERROR 1147 (42000): There is no such grant defined for user 'JOHN' on host 'localhost' on table 'Shipment'