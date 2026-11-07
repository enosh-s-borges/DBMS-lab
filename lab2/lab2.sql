/*
Create a table for the structure Student with attributes as SID,
NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL,
Insert atleast 10 tuples and perform the following operations using
SQL.
a. Insert a new student
b. Modify the address of the student based on SID
c. Delete a student
d. List all the students
e. List all the students of CSE branch.
f. List all the students of CSE branch and reside in Kuvempunagar.
*/

CREATE TABLE Student (
    SID       INT PRIMARY KEY,
    NAME      VARCHAR(100) NOT NULL,
    BRANCH    VARCHAR(20) NOT NULL,
    SEMESTER  TINYINT UNSIGNED NOT NULL,
    ADDRESS   VARCHAR(200),
    PHONE     VARCHAR(15),
    EMAIL     VARCHAR(254)
);

INSERT INTO Student (SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL) VALUES
(1001, 'Aarav Sharma',  'CSE', 3, 'Kuvempunagar, Mysuru', '9876500001', 'aarav@example.com'),
(1002, 'Diya Rao',      'ECE', 5, 'Vijayanagar, Mysuru',  '9876500002', 'diya@example.com'),
(1003, 'Ishaan Kumar',  'CSE', 3, 'Jayalakshmipuram, Mysuru', '9876500003', 'ishaan@example.com'),
(1004, 'Meera Nair',    'ISE', 7, 'Kuvempunagar, Mysuru', '9876500004', 'meera@example.com'),
(1005, 'Kabir Das',     'ME',  5, 'Saraswathipuram, Mysuru', '9876500005', 'kabir@example.com'),
(1006, 'Ananya Shetty', 'CSE', 1, 'Kuvempunagar, Mysuru', '9876500006', 'ananya@example.com'),
(1007, 'Rohan Patel',   'EEE', 7, 'Hebbal, Mysuru', '9876500007', 'rohan@example.com'),
(1008, 'Sara Khan',     'CSE', 5, 'Vijayanagar, Mysuru', '9876500008', 'sara@example.com'),
(1009, 'Vikram Joshi',  'CIVIL', 3, 'Kuvempunagar, Mysuru', '9876500009', 'vikram@example.com'),
(1010, 'Nisha Gupta',   'CSE', 7, 'Gokulam, Mysuru', '9876500010', 'nisha@example.com');

-- a. Insert a new student
INSERT INTO Student (SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL)
VALUES (1011, 'Pooja Verma', 'CSE', 1, 'Kuvempunagar, Mysuru', '9876500011', 'pooja@example.com');

-- b. Modify the address of the student based on SID
UPDATE Student
SET ADDRESS = 'Vijayanagar, Mysuru'
WHERE SID = 1001;

-- c. Delete a student
DELETE FROM Student
WHERE SID = 1010;

-- d. List all the students
SELECT * FROM Student;

-- e. List all the students of CSE branch
SELECT * FROM Student
WHERE BRANCH = 'CSE';

-- f. List CSE students who reside in Kuvempunagar
SELECT * FROM Student
WHERE BRANCH = 'CSE'
  AND ADDRESS LIKE '%Kuvempunagar%';
