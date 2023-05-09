USE Softuni

--Problem 01
SELECT 
	FirstName,
	LastName
FROM Employees
--WHERE FirstName LIKE 'Sa%'
WHERE LEFT(FirstName, 2) = 'Sa'

--Problem 02
SELECT 
	FirstName,
	LastName
FROM Employees
--WHERE LastName LIKE '%ei%'
WHERE CHARINDEX('ei', LastName) <> 0

--Problem 03
SELECT 
	FirstName
FROM Employees
WHERE 
DepartmentID IN (3, 10)
AND YEAR(HireDate) BETWEEN 1995 AND 2005
--AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--Problem 04
SELECT 
	FirstName,
	LastName
FROM Employees
WHERE JobTitle NOT LIKE('%engineer%')


--Problem 05
SELECT 
	[Name]
FROM TOWNS
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name] ASC

--Problem 06
SELECT
	TownID,
	[Name]
FROM Towns
WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

--Problem 07
SELECT
	TownID,
	[Name]
FROM Towns
WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

--Problem 08
CREATE VIEW V_EmployeesHiredAfter2000
AS
SELECT
	FirstName,
	LastName
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

--Problem 09
SELECT 
	FirstName,
	LastName
FROM Employees
WHERE LEN(LastName) = 5

--Problem 10
SELECT
	EmployeeID
	,FirstName
	,LastName
	,Salary
	,DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--Problem 11

SELECT *
FROM 
	(
		SELECT
			EmployeeID
			,FirstName
			,LastName
			,Salary
			,DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
		FROM Employees
		WHERE Salary BETWEEN 10000 AND 50000
	)
AS [RankingSubquery]
WHERE [Rank] = 2
ORDER BY Salary DESC

	 
