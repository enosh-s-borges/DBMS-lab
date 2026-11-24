/*Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.
Order processing database
Customer (Cust#:int, cname: string, city: string)
Order (order#:int, odate: date, cust#: int, order-amt: int)
Order-item (order#:int, Item#: int, qty: int)
Item (item#:int, unitprice: int)
Shipment (order#:int, warehouse#: int, ship-date: date)
Warehouse (warehouse#:int, city: string)
1. List the Order# and Ship_date for all orders shipped from Warehouse# "W2".
2. List the Warehouse information from which the Customer named "Kumar" was supplied his orders. Produce a listing of Order#, Warehouse#.
3. Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total number of orders by the customer 
and the last column is the average order amount for that customer. (Use aggregate functions)
4. Delete all orders for customer named "Kumar".
5. Find the item with the maximum unit price.
6. A trigger that updates order_amout based on quantity and unitprice of order_item
7. Create a view to display orderID and shipment date of all orders shipped from a warehouse
*/

CREATE DATABASE IF NOT EXISTS OrderProcessing;
USE OrderProcessing;

CREATE TABLE Customer(
    custID INT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);
CREATE TABLE OrderTable(
    orderID INT PRIMARY KEY,
    odate DATE NOT NULL,
    custID INT NOT NULL,
    orderAmt INT NOT NULL,
    FOREIGN KEY (custID) REFERENCES Customer(custID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Items(
    itemID INT PRIMARY KEY,
    unitPrice INT NOT NULL
);
CREATE TABLE OrderItem(
    orderID INT NOT NULL,
    itemID INT NOT NULL,
    qty INT NOT NULL,
    FOREIGN KEY (orderID) REFERENCES OrderTable(orderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Warehouse(
    warehouseID INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);
CREATE TABLE Shipment(
    orderID INT NOT NULL,
    warehouseID INT NOT NULL,
    shipDate DATE NOT NULL,
    FOREIGN KEY (orderID) REFERENCES OrderTable(orderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (warehouseID) REFERENCES Warehouse(warehouseID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Customer VALUES
(001, 'Ravi', 'Mysuru'),
(002, 'Ram', 'Bengaluru'),
(003, 'Kumar', 'Mumbai'),
(004, 'Kiran', 'Delhi'),
(005, 'Chethan', 'Bengaluru');
SELECT * FROM Customer;

INSERT INTO OrderTable (orderID, odate, custID, orderAmt) VALUES
(101, '2020-01-14', 001, 2000),
(102, '2021-01-16', 002, 600),
(103, '2023-02-15', 003, 2500),
(104, '2019-09-13', 004, 1000),
(105, '2020-12-13', 005, 200);
SELECT * FROM OrderTable;

INSERT INTO Items VALUES
(001, 400),
(002, 200),
(003, 1000),
(004, 100),
(005, 500);
SELECT * FROM Items;

INSERT INTO Warehouse VALUES
(001, 'Mysuru'),
(002, 'Bengaluru'),
(003, 'Mumbai'),
(004, 'Delhi'),
(005, 'Chennai');
SELECT * FROM Warehouse;

INSERT INTO OrderItem VALUES
(101, 001, 5),
(102, 002, 4),
(103, 003, 1),
(104, 004, 3),
(105, 005, 4);
SELECT * FROM OrderItem;

INSERT INTO Shipment VALUES
(101, 001, '2020-01-15'),
(102, 002, '2021-01-17'),
(103, 003, '2023-02-16'),
(104, 004, '2019-09-14'),
(105, 005, '2020-12-14');
SELECT * FROM Shipment;

-- 1. List the Order# and Ship_date for all orders shipped from Warehouse# "W2".
SELECT orderID, shipDate FROM Shipment 
WHERE warehouseID = 002;

-- 2. List the Warehouse information from which the Customer named "Kumar" was supplied his orders. Produce a listing of Order#, Warehouse#.
SELECT orderID, warehouseID FROM Warehouse
NATURAL JOIN Shipment 
WHERE orderID IN (SELECT orderID FROM OrderTable 
WHERE custID IN (SELECT custID FROM Customer WHERE cname = 'Kumar'));

/* 3. Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total number of orders by the customer
and the last column is the average order amount for that customer. (Use aggregate functions) */
SELECT cname, COUNT(*) AS NumberOfOrders, AVG(orderAmt) AS AvgOrderAmount
FROM Customer c, OrderTable o
WHERE c.custID = o.custID
GROUP BY cname;

-- 4. Delete all orders for customer named "Kumar".
DELETE FROM OrderTable
WHERE custID IN (SELECT custID FROM Customer WHERE cname = 'Kumar');

-- 5. Find the item with the maximum unit price.
SELECT MAX(unitPrice) FROM Items;

-- 6. A trigger that updates order_amout based on quantity and unitprice of order_item
DELIMITER //
CREATE TRIGGER update_order_amount
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    DECLARE totalAmount INT;
    SELECT SUM(qty * unitPrice) INTO totalAmount
    FROM OrderItem oi
    JOIN Items i ON oi.itemID = i.itemID
    WHERE oi.orderID = NEW.orderID;
    UPDATE OrderTable
    SET orderAmt = totalAmount
    WHERE orderID = NEW.orderID;
END;
//
DELIMITER ;
-- check
INSERT INTO OrderItem VALUES (101, 002, 3);
SELECT * FROM OrderTable WHERE orderID = 101;

--- 7. Create a view to display orderID and shipment date of all orders shipped from a warehouse
CREATE VIEW OrderShipmentView AS
SELECT orderID, shipDate
FROM Shipment WHERE warehouseID = 002;
SELECT * FROM OrderShipmentView;
