CREATE DATABASE TSQL_CTE
USE TSQL_CTE


CREATE TABLE Dept1
(
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Emp1
(
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Dept1(DeptID)
);

INSERT INTO Dept1 VALUES
(1,'IT'),
(2,'HR'),
(3,'Sales');


INSERT INTO Emp1 VALUES
(101,'Amit',60000,1),
(102,'Riya',70000,1),
(103,'Karan',70000,1),
(104,'Neha',50000,2),
(105,'Raj',55000,2),
(106,'Simran',55000,2),
(107,'Jay',45000,3),
(108,'Meera',48000,3),
(109,'Arjun',48000,3);

select * from emp1
select * from Dept1


--syntax
--ROW_NUMBER() OVER (
--    [PARTITION BY column]
--    ORDER BY column [ASC | DESC])


--ROW_NUMBER(): assigns a unique sequential number to each row
--PARTITION BY: optional; resets numbering for each group.
--ORDER BY: decides how rows are numbered (mandatory).

---ROW_NUMBER()
SELECT 
	EmpName, DeptID, Salary,
	ROW_NUMBER() OVER(ORDER BY DeptID ASC) AS RowNum
FROM Emp1;

SELECT * FROM EMP1

SELECT 
	EmpName, DeptID, Salary,
	ROW_NUMBER() OVER(ORDER BY Salary DESC) AS RowNum
FROM Emp1;




--Department Wise Ranking
--PARTITION BY means ranking inside each department
SELECT EmpName, DeptID, Salary,
ROW_NUMBER() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum
FROM Emp1;


--Department Wise Top 3 Salary
SELECT *
FROM
(
    SELECT EmpName, DeptID, Salary,
    ROW_NUMBER() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum
    FROM Emp1
) AS T
WHERE RowNum <= 3;


--CTE-Common Table Expression
--A CTE is a temporary named result set that you can use inside a SELECT, INSERT, UPDATE, or DELETE query.
--It is defined using the WITH keyword and exists only during the execution of that query.

--syntax

--WITH CTENAME AS
--(QUERY)
--SELECT * FROM CTENAME;


--EXAMPLE
WITH NAMESALARY AS
(
	SELECT EmpName,SALARY FROM EMP1 WHERE SALARY>=60000
)
SELECT * FROM NAMESALARY;


--deptid wise top 3 employee

WITH TopEmployees AS
(
    SELECT EmpName, DeptID, Salary,
    ROW_NUMBER() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum
    FROM Emp1
)
SELECT *
FROM TopEmployees
WHERE RowNum <= 3;



---RANK()
----If two salaries are same THEN same rank
--RANK() -- SKIP THE NUMBER IF TWO NUMBERS ARE SAME
---70000  RANK 1
--70000 RANK 1
--65000 RANK 3


WITH TopEmployees AS
(
    SELECT EmpName, DeptID, Salary,
    RANK() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum
    FROM Emp1
)
SELECT *
FROM TopEmployees
WHERE RowNum <= 3;



-----------
--DENSE_RANK()
--Salary	Rank
--70000	1
--70000	1
--65000	2
--60000 3


INSERT INTO EMP1 VALUES(111,'SONAL',65000,1)
WITH TopEmployees AS
(
    SELECT EmpName, DeptID, Salary,
    DENSE_RANK() OVER(PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum
    FROM Emp1
)

SELECT *
FROM TopEmployees WHERE RowNum <= 3;


select * from emp1


--ISNULL()
--If value is NULL, replace with 0.
INSERT INTO EMP1 VALUES(112,'GITA',null,1)


SELECT EmpName, ISNULL(Salary,0) AS Salary
FROM Emp1;