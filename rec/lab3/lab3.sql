/*Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types
are specified.
Create tables for the following schema listed below by properly specifying the primary keys
and foreign keys.
Enter at least five tuples for each relation.
Sailors database
SAILORS (sid, sname, rating, age)
BOAT(bid, bname, color)
RSERVERS (sid, bid, date)
Queries, View and Trigger
1. Find the colours of boats reserved by Albert
2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order.
4. Find the names of sailors who have reserved all boats.
5. Find the name and age of the oldest sailor.
6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and the average age of such sailors.
7. Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.
8. Create a trigger that prevents boats from being deleted if they have active reservations.
*/

DROP DATABASE IF EXISTS Sailors;
CREATE DATABASE Sailors;
USE Sailors;

CREATE TABLE Sailors(
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    rating INT,
    age INT
);

CREATE TABLE Boat(
    bid INT PRIMARY KEY,
    bname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Reserves(
    sid INT,
    bid INT,
    date DATE,
    FOREIGN KEY (sid) REFERENCES Sailors(sid),
    FOREIGN KEY (bid) REFERENCES Boat(bid)
);

INSERT INTO Sailors VALUES
(1, 'Albert', 8, 41),
(2, 'Bob', 9, 45),
(3, 'Charlie', 9, 49),
(4, 'David', 7, 35),
(5, 'Eve', 6, 30);

SELECT * FROM Sailors;

INSERT INTO Boat VALUES
(101, 'Boat1', 'Red'),
(102, 'Boat2', 'Blue'),
(103, 'Stormy', 'Green'),
(104, 'Boat4', 'Yellow'),
(105, 'Boat5', 'Black');

SELECT * FROM Boat;

INSERT INTO Reserves VALUES
(1, 101, '2024-01-01'),
(1, 102, '2024-01-02'),
(2, 103, '2024-01-03'),
(3, 104, '2024-01-04'),
(4, 105, '2024-01-05'),
(5, 101, '2024-01-06'),
(2, 102, '2024-01-07'),
(3, 103, '2024-01-08'),
(4, 104, '2024-01-09'),
(5, 105, '2024-01-10');

SELECT * FROM Reserves;

-- 1. Find the colours of boats reserved by Albert
-- Method 1: Using JOIN
SELECT b.color
FROM Boat b
JOIN Reserves r ON b.bid = r.bid
JOIN Sailors s ON r.sid = s.sid
WHERE s.sname = 'Albert';
-- Method 2: Using Subquery
SELECT b.color
FROM Boat b
JOIN Reserves r ON b.bid = r.bid
WHERE r.sid = (SELECT sid FROM Sailors WHERE sname = 'Albert');

-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
/*LEFT JOIN is used to ensure that all rows from the Sailors table are included in the result set, 
regardless of whether they have a matching row in the Reserves table.*/
SELECT DISTINCT s.sid
FROM Sailors s
LEFT JOIN Reserves r ON s.sid = r.sid
WHERE s.rating >= 8 OR r.bid = 103;

-- 3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order.
-- "storm" order the names in ascending order.
SELECT s.sname
FROM Sailors s
WHERE s.sid NOT IN (
    SELECT r.sid
    FROM Reserves r
    JOIN Boat b ON r.bid = b.bid
    WHERE b.bname LIKE '%storm%'
)
ORDER BY s.sname ASC;

-- 4. Find the names of sailors who have reserved all boats.
-- Method 1: Using NOT EXISTS
SELECT s.sname
FROM Sailors s
WHERE NOT EXISTS (
    SELECT b.bid
    FROM Boat b
    WHERE NOT EXISTS (
        SELECT r.bid
        FROM Reserves r
        WHERE r.sid = s.sid AND r.bid = b.bid
    )
);
-- Method 2: Using COUNT
SELECT s.sname
FROM Sailors s
JOIN Reserves r ON s.sid = r.sid
GROUP BY s.sid
HAVING COUNT(DISTINCT r.bid) = (SELECT COUNT(*) FROM Boat);

-- 5. Find the name and age of the oldest sailor.
SELECT sname, age
FROM Sailors
ORDER BY age DESC
LIMIT 1;
-- Other Query:
SELECT sname, age
FROM Sailors
WHERE age = (SELECT MAX(age) FROM Sailors);

-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and the average age of such sailors.
SELECT r.bid AS Boat_id, AVG(s.age) AS avg_age
FROM Reserves r
JOIN Sailors s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY r.bid
HAVING COUNT(r.sid) >= 5;

-- 7. Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating.
CREATE VIEW BoatsReservedByRating AS
SELECT DISTINCT s.sname AS Sailor_Name, b.bname AS Boat_Name, b.color AS Boat_Color
FROM Sailors s
JOIN Reserves r ON s.sid = r.sid
JOIN Boat b ON r.bid = b.bid
WHERE s.rating = 8;
-- check
SELECT * FROM BoatsReservedByRating;

-- 8. Create a trigger that prevents boats from being deleted if they have active reservations.
DELIMITER //
CREATE TRIGGER PreventBoatDeletion
BEFORE DELETE ON Boat
FOR EACH ROW
BEGIN
DECLARE reservation_count INT;
-- Check if boat has active reservations
SELECT COUNT(*) INTO reservation_count
FROM Reserves
WHERE bid = OLD.bid;
-- If there are active reservations, prevent deletion
IF reservation_count > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete boat with active reservations.';
END IF;
END //
DELIMITER ;
-- Check trigger
DELETE FROM Boat WHERE bid = 101;