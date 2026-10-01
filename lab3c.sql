/*
Data Definition Language (DDL) commands in RDBMS Consider the database schemas given below. 
Write  ER  diagram  and  schema  diagram.  The  primary  keys  are underlined and the data types are specified. 
Create  tables  for  the  following  schema  listed  below  by  properly specifying the primary keys and foreign keys. 
Enter at least five tuples for each relation. Altering tables, Adding and Dropping different types of constraints. 
Also adding and dropping fields in to the relational schemas of the listed problems. 
Delete, Update operations 
C. Order processing database 
Customer (Cust#:int, cname: string, city: string) 
Order (order#:int, odate: date, cust#: int, order-amt: int) 
Order-item (order#:int, Item#: int, qty: int) 
Item (item#:int, unitprice: int) 
Shipment (order#:int, warehouse#: int, ship-date: date) 
Warehouse (warehouse#:int, city: string) 
*/

-- ER relationships: each customer may place many orders. Orders contain
-- items through OrderItem, and may be shipped from multiple warehouses.

CREATE TABLE Customer (
    cust_id  INT PRIMARY KEY,
    cname    VARCHAR(100) NOT NULL,
    city     VARCHAR(100) NOT NULL
);

CREATE TABLE `Order` (
    order_id   INT PRIMARY KEY,
    odate      DATE NOT NULL,
    cust_id    INT NOT NULL,
    order_amt  INT NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (cust_id)
        REFERENCES Customer (cust_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Item (
    item_id    INT PRIMARY KEY,
    unitprice  INT NOT NULL
);

CREATE TABLE OrderItem (
    order_id  INT NOT NULL,
    item_id   INT NOT NULL,
    qty       INT NOT NULL,
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orderitem_item FOREIGN KEY (item_id)
        REFERENCES Item (item_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Warehouse (
    warehouse_id  INT PRIMARY KEY,
    city          VARCHAR(100) NOT NULL
);

CREATE TABLE Shipment (
    order_id      INT NOT NULL,
    warehouse_id  INT NOT NULL,
    ship_date     DATE NOT NULL,
    PRIMARY KEY (order_id, warehouse_id),
    CONSTRAINT fk_shipment_order FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_shipment_warehouse FOREIGN KEY (warehouse_id)
        REFERENCES Warehouse (warehouse_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert at least five tuples into every relation.
INSERT INTO Customer (cust_id, cname, city) VALUES
(1, 'Aarav Sharma', 'Mysuru'),
(2, 'Diya Rao', 'Bengaluru'),
(3, 'Ishaan Kumar', 'Mangaluru'),
(4, 'Meera Nair', 'Hubballi'),
(5, 'Kabir Das', 'Mysuru');

INSERT INTO `Order` (order_id, odate, cust_id, order_amt) VALUES
(1001, '2025-01-05', 1, 1500),
(1002, '2025-01-12', 2, 2300),
(1003, '2025-02-03', 3, 800),
(1004, '2025-02-18', 4, 4200),
(1005, '2025-03-01', 5, 1250);

INSERT INTO Item (item_id, unitprice) VALUES
(201, 500),
(202, 750),
(203, 200),
(204, 1200),
(205, 350);

INSERT INTO OrderItem (order_id, item_id, qty) VALUES
(1001, 201, 3),
(1002, 202, 2),
(1003, 203, 4),
(1004, 204, 3),
(1005, 205, 2);

INSERT INTO Warehouse (warehouse_id, city) VALUES
(301, 'Mysuru'),
(302, 'Bengaluru'),
(303, 'Mangaluru'),
(304, 'Hubballi'),
(305, 'Shivamogga');

INSERT INTO Shipment (order_id, warehouse_id, ship_date) VALUES
(1001, 301, '2025-01-06'),
(1002, 302, '2025-01-13'),
(1003, 303, '2025-02-04'),
(1004, 304, '2025-02-19'),
(1005, 305, '2025-03-02');

-- Add and remove a field.
ALTER TABLE Customer ADD COLUMN phone VARCHAR(15);
ALTER TABLE Customer DROP COLUMN phone;

-- Add and remove constraints (MariaDB syntax).
ALTER TABLE OrderItem
    ADD CONSTRAINT chk_orderitem_qty CHECK (qty > 0);
ALTER TABLE OrderItem DROP CONSTRAINT chk_orderitem_qty;

ALTER TABLE Item ADD CONSTRAINT uq_item_unitprice UNIQUE (unitprice);
ALTER TABLE Item DROP INDEX uq_item_unitprice;

-- Update and delete examples.
UPDATE Customer SET city = 'Vijayanagar, Mysuru' WHERE cust_id = 1;
UPDATE `Order` SET order_amt = 1600 WHERE order_id = 1001;
UPDATE OrderItem SET qty = 4 WHERE order_id = 1001 AND item_id = 201;
UPDATE Shipment SET ship_date = '2025-01-07'
WHERE order_id = 1001 AND warehouse_id = 301;

DELETE FROM OrderItem WHERE order_id = 1005 AND item_id = 205;

-- Display the resulting tables.
SELECT * FROM Customer;
SELECT * FROM `Order`;
SELECT * FROM Item;
SELECT * FROM OrderItem;
SELECT * FROM Warehouse;
SELECT * FROM Shipment;