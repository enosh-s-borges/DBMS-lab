/*
Data Definition Language (DDL) commands in RDBMS 
Consider the database schemas given below. 
Write  ER  diagram  and  schema  diagram.  The  primary  keys  are underlined and the data types are specified. 
Create  tables  for  the  following  schema  listed  below  by  properly specifying the primary keys and foreign keys. 
Enter at least five tuples for each relation. 
Altering tables, Adding and Dropping different types of constraints. 
Also adding and dropping fields in to the relational schemas of the listed problems. 
Delete, Update operations 

A. Sailors database 
SAILORS (sid, sname, rating, age) 
BOAT(bid, bname, color) 
RSERVERS (sid, bid, date)
*/

CREATE TABLE Sailors (
    sid       INT PRIMARY KEY,
    sname     VARCHAR(50) NOT NULL,
    rating    TINYINT UNSIGNED NOT NULL,
    age       DECIMAL(4,1) NOT NULL
);

CREATE TABLE Boat (
    bid       INT PRIMARY KEY,
    bname     VARCHAR(50) NOT NULL,
    color     VARCHAR(30) NOT NULL
);

CREATE TABLE RServers (
    sid       INT NOT NULL,
    bid       INT NOT NULL,
    `date`    DATE NOT NULL,
    PRIMARY KEY (sid, bid, `date`),
    CONSTRAINT fk_rservers_sailor FOREIGN KEY (sid)
        REFERENCES Sailors (sid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rservers_boat FOREIGN KEY (bid)
        REFERENCES Boat (bid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- At least five tuples in each relation.
INSERT INTO Sailors (sid, sname, rating, age) VALUES
(1, 'Alex',   7, 25.5),
(2, 'Barbara', 8, 30.0),
(3, 'Charlie', 5, 22.0),
(4, 'Diana',   9, 35.0),
(5, 'Edward',  3, 28.5);

INSERT INTO Boat (bid, bname, color) VALUES
(101, 'Aurora', 'red'),
(102, 'Breeze', 'green'),
(103, 'Calypso', 'blue'),
(104, 'Dolphin', 'white'),
(105, 'Eclipse', 'black');

INSERT INTO RServers (sid, bid, `date`) VALUES
(1, 101, '2025-04-01'),
(1, 102, '2025-04-05'),
(2, 101, '2025-04-02'),
(3, 103, '2025-04-03'),
(4, 104, '2025-04-04');

-- Add and remove a column.
ALTER TABLE Sailors ADD COLUMN phone VARCHAR(15);
ALTER TABLE Sailors DROP COLUMN phone;

-- Add and remove constraints (MySQL syntax).
ALTER TABLE Sailors
    ADD CONSTRAINT chk_sailors_rating CHECK (rating BETWEEN 1 AND 10);
ALTER TABLE Sailors DROP CONSTRAINT chk_sailors_rating;

ALTER TABLE Boat ADD CONSTRAINT uq_boat_name UNIQUE (bname);
ALTER TABLE Boat DROP INDEX uq_boat_name;

-- Example update and delete operations.
UPDATE Sailors SET rating = 8 WHERE sid = 1;
UPDATE Boat SET color = 'yellow' WHERE bid = 103;
UPDATE RServers SET `date` = '2025-04-06'
WHERE sid = 1 AND bid = 102 AND `date` = '2025-04-05';

DELETE FROM RServers
WHERE sid = 4 AND bid = 104 AND `date` = '2025-04-04';

-- View the resulting relations.
SELECT * FROM Sailors;
SELECT * FROM Boat;
SELECT * FROM RServers;
