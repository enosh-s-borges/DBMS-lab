/*Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.
Insurance database
PERSON (driver id#: string, name: string, address: string)
CAR (regno: string, model: string, year: int)
ACCIDENT (report_ number: int, acc_date: date, location: string)
OWNS (driver id#: string, regno: string)
PARTICIPATED(driver id#:string, regno:string, report_ number: int,damage_amount: int)
1.Find the total number of people who owned cars that were involved in accidents in 2021.
2.Find the number of accidents in which the cars belonging to “Smith” were involved.
3.Add a new accident to the database; assume any values for required attributes.
4.Delete the Mazda belonging to “Smith”.
5.Update the damage amount for the car with license number “KA09MA1234” in the accident
with report.
6.A view that shows models and year of cars that are involved in accident.
7.A trigger that prevents a driver from participating in more than 3 accidents in a given year.*/

DROP DATABASE IF EXISTS Insurance;
CREATE DATABASE Insurance;
USE Insurance;

--Table for storing driver info
CREATE TABLE Person(
    driver_id VARCHAR(20) PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL
);

--Table for storing car info
CREATE TABLE Car(
    regno VARCHAR(20) PRIMARY KEY,
    model TEXT NOT NULL,
    year INTEGER
);

--Table for storing accident info
CREATE TABLE Accident(
    report_no INT PRIMARY KEY,
    acc_date DATE,
    location TEXT
);

--Table for storing ownership info
CREATE TABLE Owns(
    driver_id VARCHAR(20),
    regno VARCHAR(20),
    FOREIGN KEY (driver_id) REFERENCES Person(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (regno) REFERENCES Car(regno) ON DELETE CASCADE
);

--Table for tracking accidents
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
('D103', 'Driver3', 'Address3'),
('D104', 'Driver4', 'Address4'),
('D105', 'Driver5', 'Address5');

INSERT INTO Car VALUES
('KA01AB1234', 'Swift', 2018),
('KA02CD5678', 'Baleno', 2019),
('KA03EF9012', 'Creta', 2020),
('KA04GH3456', 'Verna', 2021),
('KA05IJ7890', 'Polo', 2022);

INSERT INTO Accident VALUES
(43627, '2021-05-10', 'Location1'),
(43628, '2021-06-15', 'Location2'),
(43629, '2021-07-20', 'Location3'),
(43630, '2021-08-25', 'Location4'),
(43631, '2021-09-30', 'Location5');

INSERT INTO Owns VALUES
('D101', 'KA01AB1234'),
('D102', 'KA02CD5678'),
('D103', 'KA03EF9012'),
('D104', 'KA04GH3456'),
('D105', 'KA05IJ7890');

INSERT INTO Participated VALUES
('D101', 'KA01AB1234', 43627, 5000),
('D102', 'KA02CD5678', 43628, 7000),
('D103', 'KA03EF9012', 43629, 6000),
('D104', 'KA04GH3456', 43630, 8000),
('D105', 'KA05IJ7890', 43631, 9000);

--1. Find the total number of people who owned cars that were involved in accidents in 2021.
SELECT COUNT(driver_id) FROM Participated p, Accident a
WHERE p.report_no = a.report_no AND a.acc_date LIKE '2021%';

--2. Find the number of accidents in which the cars belonging to “Smith” were involved.
SELECT COUNT(DISTINCT a.report_no) FROM Accident a
WHERE EXISTS 
    (SELECT * FROM Person p, Participated pa
    WHERE p.driver_id = pa.driver_id AND p.name = 'Smith' AND a.report_no = pa.report_no);

--3. Add a new accident to the database; assume any values for required attributes.
INSERT INTO Accident VALUES (43632, '2021-10-15', 'Location6');
INSERT INTO Participated VALUES ('D101', 'KA01AB1234', 43632, 4000);

--4. Delete the Mazda belonging to “Smith”.
DELETE FROM Car c WHERE model = 'Mazda' AND regno IN (SELECT c.regno FROM Person p, Owns o
    WHERE p.driver_id = o.driver_id AND o.regno = c.regno AND p.name = 'Smith');

--5. Update the damage amount for the car with license number “KA09MA1234” in the accident with report number 43627.
UPDATE Participated SET dmg_amt = 10000 WHERE report_no = 43627 AND regno = 'KA09MA1234';

--6. A view that shows models and year of cars that are involved in accident.
CREATE VIEW AccidentCars AS
SELECT DISTINCT c.model, c.year FROM Car c, Participated p
WHERE p.driver_id = o.driver_id;

SELECT * FROM AccidentCars;

