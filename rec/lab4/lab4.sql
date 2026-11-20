/*Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.
Insurance database
PERSON(driver_id, name, address)
CAR(regno, model, year)
ACCIDENT(report_no, acc_date, location)
OWNS(driver_id, regno)
PARTICIPATED(driver_id, regno, report_no, dmg_amt)
Queries, View and Trigger
1. Find the total number of people who owned cars that were involved in accidents in 2021.
2. Find the number of accidents in which the cars belonging to “Smith” were involved.
3. Add a new accident to the database; assume any values for required attributes.
4. Delete the Mazda belonging to “Smith”.
5. Update the damage amount for the car with license number “KA01AB1234” in the accident with report number 43627.
6. A view that shows models and year of cars that are involved in accident.
7. A trigger that prevents a driver from participating in more than 3 accidents in a given year.
*/

DROP DATABASE IF EXISTS Insurance;
CREATE DATABASE Insurance;
USE Insurance;

-- Table for storing driver info
CREATE TABLE Person(
driver_id VARCHAR(20) PRIMARY KEY,
name TEXT NOT NULL,
address TEXT NOT NULL
);

-- Table for storing car info
CREATE TABLE Car(
regno VARCHAR(20) PRIMARY KEY,
model TEXT NOT NULL,
year INTEGER
);

-- Table for storing accident info
CREATE TABLE Accident(
report_no INT PRIMARY KEY,
acc_date DATE,
location TEXT
);

-- Table for storing ownership info
CREATE TABLE Owns(
driver_id VARCHAR(20),
regno VARCHAR(20),
FOREIGN KEY (driver_id) REFERENCES Person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (regno) REFERENCES Car(regno) ON DELETE CASCADE
);

-- Table for tracking accidents
CREATE TABLE Participated(
driver_id VARCHAR(20),
regno VARCHAR(20),
report_no INT,
dmg_amt FLOAT NOT NULL,
FOREIGN KEY (driver_id) REFERENCES Person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (regno) REFERENCES Car(regno) ON DELETE CASCADE,
FOREIGN KEY (report_no) REFERENCES Accident(report_no) ON DELETE CASCADE
);

INSERT INTO Person VALUES
('D101', 'Driver1', 'Address1'),
('D102', 'Driver2', 'Address2'),
('D103', 'Smith', 'Address3'),
('D104', 'Driver4', 'Address4'),
('D105', 'Driver5', 'Address5');
SELECT * FROM Person;

INSERT INTO Car VALUES
('KA01AB1234', 'Swift', 2020),
('KA02CD5678', 'Mazda', 2017),
('KA03EF9012', 'Alto', 2015),
('KA04GH3456', 'Triber', 2019),
('KA05IJ7890', 'Tiago', 2018);
SELECT * FROM Car;

INSERT INTO Accident VALUES
(43627, '2021-04-05', 'Location1'),
(43628, '2019-12-16', 'Location2'),
(43629, '2020-05-14', 'Location3'),
(43630, '2019-08-30', 'Location4'),
(43631, '2021-01-21', 'Location5'),
(43632, '2021-01-21', 'Location5');
SELECT * FROM Accident;

INSERT INTO Owns VALUES
('D101', 'KA01AB1234'),
('D102', 'KA02CD5678'),
('D103', 'KA03EF9012'),
('D104', 'KA04GH3456'),
('D105', 'KA05IJ7890');
SELECT * FROM Owns;

INSERT INTO Participated VALUES
('D101', 'KA01AB1234', 43627, 5000),
('D101', 'KA01AB1234', 43632, 4000),
('D102', 'KA02CD5678', 43628, 7000),
('D103', 'KA03EF9012', 43629, 6000),
('D104', 'KA04GH3456', 43630, 8000),
('D105', 'KA05IJ7890', 43631, 9000);
SELECT * FROM Participated;

-- 1. Find the total number of people who owned cars that were involved in accidents in 2021.
SELECT COUNT(driver_id) FROM Participated p, Accident a
WHERE p.report_no = a.report_no AND a.acc_date LIKE '2021%';

-- 2. Find the number of accidents in which the cars belonging to “Smith” were involved.
SELECT COUNT(DISTINCT a.report_no) FROM Accident a
WHERE EXISTS 
(SELECT * FROM Person p, Participated pa
WHERE p.driver_id = pa.driver_id AND p.name = 'Smith' AND a.report_no = pa.report_no);

-- 3. Add a new accident to the database; assume any values for required attributes.
INSERT INTO Accident VALUES (43633, '2021-04-05', 'Location6');
INSERT INTO Participated VALUES ('D101', 'KA01AB1234', 43633, 5500);
SELECT * FROM Accident WHERE report_no = 43633;
SELECT * FROM Participated WHERE report_no = 43633;

-- 4. Delete the Mazda belonging to “Smith”.
DELETE FROM Car WHERE model = 'Mazda' AND regno IN (
SELECT Car.regno FROM Person p, Owns o
WHERE p.driver_id = o.driver_id AND p.name = 'Smith'
);
SELECT * FROM Car;

-- 5. Update the damage amount for the car with license number “KA01AB1234” in the accident with report number 43627.
UPDATE Participated SET dmg_amt = 10000 WHERE report_no = 43627 AND regno = 'KA01AB1234';
SELECT * FROM Participated WHERE report_no = 43627 AND regno = 'KA01AB1234';

-- 6. A view that shows models and year of cars that are involved in accident.
CREATE VIEW AccidentCars AS
SELECT DISTINCT c.model, c.year FROM Car c, Participated p, Owns o
WHERE p.driver_id = o.driver_id;

SELECT * FROM AccidentCars;

-- 7. A trigger that prevents a driver from participating in more than 3 accidents in a given year.
DELIMITER //
CREATE TRIGGER PreventParticipation
BEFORE INSERT ON Participated
FOR EACH ROW
BEGIN
IF 3 <= (SELECT COUNT(*) FROM Participated p, Accident a 
WHERE p.report_no = a.report_no 
AND p.driver_id = NEW.driver_id 
AND YEAR(a.acc_date) = (SELECT YEAR(acc_date) 
FROM Accident WHERE report_no = NEW.report_no))
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Driver cannot participate in more than 3 accidents in a given year.';
END IF;
END; //
-- check
INSERT INTO Accident VALUES (43634, '2021-05-10', 'Location7');
INSERT INTO Participated VALUES ('D101', 'KA01AB1234', 43634, 6000);