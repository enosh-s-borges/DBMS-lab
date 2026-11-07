/*Data Manipulation Language (DML) and Data Control Language (DCL)
Write valid DML statements to retrieve tuples from the databases.
The query may contain appropriate DML and DCL commands such as:
-Select with
-%like, between, where clause
-Order by
-Set Operations
-Exists and not exists
-Join operations
-Aggregate functions
-Group by
-Group by having
-Nested and correlated nested Queries
-Grant and revoke permission
*/

/*The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.

There are two wildcards often used in conjunction with the LIKE operator:
-The percent sign (%) represents zero, one, or multiple characters
-The underscore sign (_) represents one, single character
*/

@HUSSAIN Workbench

USE SAILORS;
-- LIKE OPERATOR
-- Select the boats with names containing 'Boat'
SELECT * FROM Boat WHERE bname LIKE '%B%'; -- Finds any values that have "B" in any position

SELECT * FROM Boat WHERE bname LIKE 'BO%'; -- Finds any values that start with "BO"

SELECT * FROM Boat WHERE bname LIKE '____2'; -- Finds value in which 2 occurs after 4 characters(BOAT2);

-- BETWEEN OPERATOR
/*The BETWEEN operator selects values within a given ridange. 
in BETWEEN operator begining and ending values are included*/

-- SELECT sailors aged between 26 and 29
SELECT * FROM Sailors WHERE age BETWEEN 26 AND 29; -- Selects sailors that have age in between 26 and 29

SELECT * FROM Sailors WHERE age NOT BETWEEN 26 AND 29; -- Selects sailors that have age in not between 26 and 29

SELECT * FROM Boat
WHERE color BETWEEN 'Blue' AND 'White' -- selects boat between whose name comes between 'B' and 'W'
ORDER BY bid;

-- WHERE CLAUSE
SELECT * FROM RServers WHERE sid=601; -- selects row in which sid=601

-- ORDER BY
/* Used to sort the rows in ascending or decending order
by default it sorts in ascneding order is ASEC or DESC is not specified*/

-- Retrieve sailors with a rating greater than 2.0, order by rating in descending order
SELECT * FROM Sailors WHERE rating > 2.0 ORDER BY rating DESC;

SELECT * FROM Sailors WHERE rating > 2.0 ORDER BY rating;-- by default in descending order

-- SET operations

-- UNION operation
SELECT sid,sname FROM Sailors
UNION
SELECT bid,bname FROM Boat;  -- combines the both column entries into single column sname

DELETE FROM RServers
WHERE sid = 603;

-- INTERSECT operation ( there is no INTERSECT command in Mysql instead we use this sub query)
SELECT sid,sname FROM Sailors
WHERE sid IN (SELECT sid FROM RServers);

-- MINUS opearation
-- Retrieve a list of sailors who did not make any reservations using NOT IN command
SELECT sname FROM Sailors
WHERE sid NOT IN (SELECT sid FROM RServers);

-- EXISTS  NOT EXISTS
-- this operator returns true or false value 

-- EXISTS
SELECT * FROM Sailors WHERE EXISTS 
(SELECT * FROM RServers WHERE Sailors.sid=RServers.sid); 

-- NOT EXISTS
SELECT * FROM Sailors WHERE NOT EXISTS 
(SELECT * FROM RServers WHERE Sailors.sid=RServers.sid); 

-- JOIN
-- it is used to combine row from two or more tables ,based on a related column between them
-- INNER JOIN,LEFT JOIN,RIGHT JOIN

-- INNER JOIN
SELECT * FROM Sailors
JOIN RServers
ON Sailors.sid=RServers.sid;

-- LEFT JOIN
SELECT * FROM Sailors
LEFT JOIN RServers
ON Sailors.sid=RServers.sid;

-- RIGHT JOIN
SELECT * FROM Sailors
RIGHT JOIN RServers
ON Sailors.sid=RServers.sid;

-- FULL OUTER JOIN 
SELECT * FROM Sailors
LEFT JOIN RServers
ON Sailors.sid=RServers.sid
UNION
SELECT * FROM Sailors
RIGHT JOIN RServers
ON Sailors.sid=RServers.sid; 

-- Aggregate functions
-- count,sum,min,max,avg

-- count() returns the total numbers of rows in the table
-- sum() returns the total sum of the numeric column
-- avg() calculates the avergae values of the set of values
-- min() returns lowest value in a set of non-null values
-- max() returns largest value in a set of non-null values

SELECT count(sid) FROM Sailors WHERE rating>4.0; -- returns total sailors whose rating is more than 4

SELECT sum(age) FROM Sailors;

SELECT avg(age) FROM Sailors;

SELECT min(sid) FROM RServers;

SELECT max(bid) FROM Boat;

-- GROUP
UPDATE Sailors
SET rating=4.1 WHERE sid=601;

-- GROUP BY
SELECT COUNT(sid),rating
FROM Sailors
GROUP BY rating;
-- shows the number of sailors who have the same rating

-- GROUP BY HAVING
-- HAVING condition is used because WHERE clause cannot be used in aggregate functions

SELECT COUNT(sid),rating
FROM Sailors
GROUP BY rating
HAVING COUNT(sid)>1;

-- nested queries
-- we first execute the inner query first and then the comapre the column atributes with the values
-- that we get in the inner query
SELECT * FROM Sailors WHERE sid IN (SELECT sid FROM RServers);

-- correlated queries 
-- defines relation between outer and inner query (in top down approach)
SELECT * FROM Sailors WHERE EXISTS 
(SELECT * FROM RServers WHERE Sailors.sid=RServers.sid); 

-- grant command
GRANT select ON hussain.Boat TO 'JOHN'@'localhost';
ERROR 1142 (42000): GRANT command denied to user 'sem5d2'@'localhost' for table 'boat'

-- revoke command

REVOKE select ON hussain.Boat FROM 'JOHN'@'localhost';
ERROR 1142 (42000): REVOKE command denied to user 'sem5d2'@'localhost' for table 'boat'