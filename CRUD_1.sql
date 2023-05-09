USE SOFTUNI

SELECT
	CONCAT(FirstName, '.', LastName, '@softuni.bg') AS [Full Email Address]
FROM Employees

GO

SELECT DISTINCT Salary
FROM Employees

SELECT
	EmployeeID
	,FirstName
	,LastName
	,MiddleName
	,JobTitle
	,DepartmentID
	,ManagerID
	,HireDate
	,Salary
	,AddressID
FROM Employees
WHERE JobTitle = 'Sales Representative'

GO

SELECT
	FirstName
	,LastName
	,JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

GO

SELECT
	CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name]
FROM Employees
WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

GO

SELECT 
	FirstName
	,LastName
FROM Employees
WHERE ManagerID IS Null

GO

SELECT 
	FirstName
	,LastName
FROM Employees
WHERE NOT DepartmentID = 4

GO

SELECT
	EmployeeID
	,FirstName
	,LastName
	,MiddleName
	,JobTitle
	,DepartmentID
	,ManagerID
	,HireDate
	,Salary
	,AddressID
FROM Employees
ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName

GO

CREATE VIEW V_EmployeesSalaries
AS 
SELECT 
	FirstName
	,LastName
	,Salary
FROM Employees

GO

CREATE VIEW V_EmployeeNameJobTitle
AS 
SELECT 
	CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name]
	, JobTitle
FROM Employees

GO

SELECT DISTINCT
	JobTitle
FROM Employees

GO

SELECT TOP(10) 
	*
FROM Projects
ORDER BY StartDate, [Name]

GO

SELECT TOP(7)
	FirstName
	,LastName
	,HireDate
FROM Employees
ORDER BY HireDate DESC

GO

--SELECT 
--	Salary
--FROM Employees
--INNER JOIN Departments
--ON Employees.DepartmentID = Departments.DepartmentID
--WHERE Departments.[Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services') 

--UPDATE Employees
--SET Salary = Salary * 1.12


UPDATE Employees
	SET Salary += Salary * 0.12
	WHERE DepartmentID IN (
		SELECT DepartmentID
		FROM Departments
		WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
	)

SELECT Salary
FROM Employees