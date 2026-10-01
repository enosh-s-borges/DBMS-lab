/*
Data Definition Language (DDL) commands in RDBMS Consider the database schemas given below. 
Write  ER  diagram  and  schema  diagram.  The  primary  keys  are underlined and the data types are specified. 
Create  tables  for  the  following  schema  listed  below  by  properly specifying the primary keys and foreign keys. 
Enter at least five tuples for each relation. Altering tables, Adding and Dropping different types of constraints. 
Also adding and dropping fields in to the relational schemas of the listed problems. 
Delete, Update operations 
B. Insurance database 
PERSON (driver id#: string, name: string, address: string) 
CAR (regno: string, model: string, year: int) 
ACCIDENT (report_ number: int, acc_date: date, location: string) 
OWNS (driver id#: string, regno: string) 
PARTICIPATED(driver id#:string, regno:string, report_ number: 
int,damage_amount: int)
*/

-- ER relationships: PERSON and CAR are many-to-many through OWNS.
-- PARTICIPATED associates a person, car, and accident and stores the damage.

CREATE TABLE Person (
    driver_id  VARCHAR(20) PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    address    VARCHAR(200) NOT NULL
);

CREATE TABLE Car (
    regno      VARCHAR(20) PRIMARY KEY,
    model      VARCHAR(60) NOT NULL,
    `year`     INT NOT NULL
);

CREATE TABLE Accident (
    report_number  INT PRIMARY KEY,
    acc_date       DATE NOT NULL,
    location       VARCHAR(100) NOT NULL
);

CREATE TABLE Owns (
    driver_id  VARCHAR(20) NOT NULL,
    regno      VARCHAR(20) NOT NULL,
    PRIMARY KEY (driver_id, regno),
    CONSTRAINT fk_owns_person FOREIGN KEY (driver_id)
        REFERENCES Person (driver_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_owns_car FOREIGN KEY (regno)
        REFERENCES Car (regno) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Participated (
    driver_id      VARCHAR(20) NOT NULL,
    regno          VARCHAR(20) NOT NULL,
    report_number  INT NOT NULL,
    damage_amount  INT NOT NULL,
    PRIMARY KEY (driver_id, regno, report_number),
    CONSTRAINT fk_participated_person FOREIGN KEY (driver_id)
        REFERENCES Person (driver_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_participated_car FOREIGN KEY (regno)
        REFERENCES Car (regno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_participated_accident FOREIGN KEY (report_number)
        REFERENCES Accident (report_number) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert at least five tuples into every relation.
INSERT INTO Person (driver_id, name, address) VALUES
('D001', 'Aarav Sharma', 'Mysuru'),
('D002', 'Diya Rao', 'Bengaluru'),
('D003', 'Ishaan Kumar', 'Mangaluru'),
('D004', 'Meera Nair', 'Hubballi'),
('D005', 'Kabir Das', 'Mysuru');

INSERT INTO Car (regno, model, `year`) VALUES
('KA09AB1001', 'Honda City', 2020),
('KA03CD2002', 'Maruti Swift', 2018),
('KA19EF3003', 'Hyundai i20', 2022),
('KA25GH4004', 'Tata Nexon', 2021),
('KA09IJ5005', 'Toyota Innova', 2019);

INSERT INTO Accident (report_number, acc_date, location) VALUES
(5001, '2025-01-10', 'Mysuru'),
(5002, '2025-02-14', 'Bengaluru'),
(5003, '2025-03-08', 'Mangaluru'),
(5004, '2025-04-21', 'Hubballi'),
(5005, '2025-05-17', 'Mysuru');

INSERT INTO Owns (driver_id, regno) VALUES
('D001', 'KA09AB1001'),
('D002', 'KA03CD2002'),
('D003', 'KA19EF3003'),
('D004', 'KA25GH4004'),
('D005', 'KA09IJ5005');

INSERT INTO Participated (driver_id, regno, report_number, damage_amount) VALUES
('D001', 'KA09AB1001', 5001, 12000),
('D002', 'KA03CD2002', 5002, 8000),
('D003', 'KA19EF3003', 5003, 15000),
('D004', 'KA25GH4004', 5004, 22000),
('D005', 'KA09IJ5005', 5005, 5000);

-- Add and remove a field.
ALTER TABLE Person ADD COLUMN phone VARCHAR(15);
ALTER TABLE Person DROP COLUMN phone;

-- Add and drop a CHECK constraint (MariaDB syntax).
ALTER TABLE Participated
    ADD CONSTRAINT chk_damage_amount CHECK (damage_amount >= 0);
ALTER TABLE Participated DROP CONSTRAINT chk_damage_amount;

-- Add and drop a UNIQUE constraint.
ALTER TABLE Car ADD CONSTRAINT uq_car_regno_model UNIQUE (regno, model);
ALTER TABLE Car DROP CONSTRAINT uq_car_regno_model;

-- Update and delete examples.
UPDATE Person SET address = 'Vijayanagar, Mysuru' WHERE driver_id = 'D001';
UPDATE Car SET model = 'Honda City ZX' WHERE regno = 'KA09AB1001';
UPDATE Participated SET damage_amount = 13000
WHERE driver_id = 'D001' AND regno = 'KA09AB1001' AND report_number = 5001;

DELETE FROM Participated
WHERE driver_id = 'D005' AND regno = 'KA09IJ5005' AND report_number = 5005;

-- Display the resulting tables.
SELECT * FROM Person;
SELECT * FROM Car;
SELECT * FROM Accident;
SELECT * FROM Owns;
SELECT * FROM Participated;