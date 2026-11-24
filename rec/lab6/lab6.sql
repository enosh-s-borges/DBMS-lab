/*6. Consider the database schemas given below.
Write ER diagram and schema diagram. The primary keys are underlined and the data types are
specified.
Create tables for the following schema listed below by properly specifying the primary keys and
foreign keys.
Enter at least five tuples for each relation.
Student enrollment in courses and books adopted for each course
STUDENT (regno: string, name: string, major: string, bdate: date)
COURSE (course#:int, cname: string, dept: string)
ENROLL(regno:string, course#: int,sem: int,marks: int)
BOOK-ADOPTION (course#:int, sem: int, book-ISBN: int)
TEXT (book-ISBN: int, book-title: string, publisher: string,author: string)
1. Demonstrate how you add a new text book to the database and make this book be
adopted by some department.
2. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical
order for courses offered by the ‘CS’ department that use more than two books.
3. List any department that has all its adopted books published by a specific publisher.
4. List the students who have scored maximum marks in ‘DBMS’ course.
5. Create a view to display all the courses opted by a student along with marks obtained.
6. Create a trigger that prevents a student from enrolling in a course if the marks
prerequisite is less than 40.
*/

CREATE DATABASE IF NOT EXISTS EnrollmentDB;
USE EnrollmentDB;
CREATE TABLE Student(
    regno VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    major VARCHAR(50) NOT NULL,
    bdate DATE NOT NULL
);
CREATE TABLE Course(
    courseID INT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    dept VARCHAR(50) NOT NULL
);
CREATE TABLE Enroll(
    regno INT PRIMARY KEY,
    courseID INT,
    sem INT NOT NULL,
    marks INT NOT NULL,
    FOREIGN KEY (regno) REFERENCES Student(regno) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (courseID) REFERENCES Course(courseID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE BookAdoption(
    courseID INT,
    sem INT NOT NULL,
    bookISBN INT,
    FOREIGN KEY (courseID) REFERENCES Course(courseID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (bookISBN) REFERENCES Text(bookISBN) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Textbook(
    bookISBN INT PRIMARY KEY,
    bookTitle VARCHAR(100) NOT NULL,
    publisher VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL
);

INSERT INTO Student VALUES ('S001', 'Alice', 'CS', '2000-01-15');
