CREATE DATABASE [Service]

GO

USE [Service]

--Problem 01
CREATE TABLE Users(
	Id INT IDENTITY PRIMARY KEY 
	,Username VARCHAR(30) UNIQUE NOT NULL
	,[Password] VARCHAR(50) NOT NULL
	,[Name] VARCHAR(50)
	,Birthdate DATETIME
	,Age INT CHECK(14 <= Age AND Age <= 110)
	,Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments(
	Id INT IDENTITY PRIMARY KEY 
	,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
	Id INT IDENTITY PRIMARY KEY 
	,FirstName VARCHAR(25) 
	,LastName VARCHAR(25)
	,Birthdate DATETIME
	,Age INT CHECK(18 <= Age AND Age <= 110)
	,DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Categories(
	Id INT IDENTITY PRIMARY KEY 
	,[Name] VARCHAR(50) NOT NULL
	,DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id) 
)

CREATE TABLE [Status](
	Id INT IDENTITY PRIMARY KEY 
	,[Label] VARCHAR(20) NOT NULL
)

CREATE TABLE Reports(
	Id INT IDENTITY PRIMARY KEY 
	,CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id)
	,StatusId INT NOT NULL FOREIGN KEY REFERENCES [Status](Id)
	,OpenDate DATETIME NOT NULL
	,CloseDate DATETIME 
	,[Description] VARCHAR(200) NOT NULL
	,UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
	,EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

GO
--Problem 02
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
	VALUES
('Marlo', 'O ''Malley',	1958-9-21, 1)
,('Niki', 'Stanaghan', 1969-11-26, 4)
,('Ayrton', 'Senna', 1960-03-21, 9)
,('Ronnie',	'Peterson',	1944-02-14,	9)
,('Giovanna', 'Amati', 1959-07-20, 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
	VALUES
(1,	1,	2017-04-13,	NULL, 'Stuck Road on Str.133', 6,	2)
,(6, 3,	2015-09-05,	2015-12-06,	'Charity trail running', 3,	5)
,(14, 2, 2015-09-07, NULL, 'Falling bricks on Str.58', 5, 2)
,(4, 3,	2017-07-03,	2017-07-06,	'Cut off streetlight on Str.11', 1,	1)

--Problem 03
UPDATE Reports
	SET CloseDate = GETDATE()
	WHERE CloseDate IS NULL

--Problem 04
DELETE FROM Reports
WHERE Reports.StatusId = 4

--Problem 05
SELECT
	[Description]
	,FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
FROM Reports
	AS r
WHERE r.EmployeeId IS NULL
ORDER BY r.OpenDate ASC, [Description] ASC

--Problem 06
SELECT
	[Description]
	,c.[Name] AS CategoryName
FROM Reports
	AS r
JOIN Categories
	AS c
	ON c.Id = r.CategoryId
WHERE CategoryId IS NOT NULL
ORDER BY [Description]

--Problem 07
SELECT TOP(5)
	c.[Name] AS CategoryName
	,COUNT(*) AS ReportsNumber
FROM Reports
	AS r
JOIN Categories
	AS c
	ON c.Id = r.CategoryId
GROUP BY c.[Name]
ORDER BY ReportsNumber DESC, CategoryName

--Problem 08
SELECT
	Username
	,c.[Name] AS CategoryName
FROM Reports
	AS r
JOIN Categories
	AS c
	ON r.CategoryId = c.Id
JOIN Users
	AS u
	ON r.UserId = u.Id
WHERE MONTH(u.Birthdate) = MONTH(OpenDate) AND DAY(u.Birthdate) = DAY(OpenDate)
ORDER BY Username ASC, CategoryName ASC

--Problem 09
SELECT
	CONCAT(FirstName, ' ', LastName) AS FullName
	, CASE 
		WHEN r.EmployeeId IS NULL THEN 0
		ELSE COUNT(*) 
	END AS UsersCount
FROM Employees
	AS e
LEFT JOIN Reports
	AS r
	ON e.Id = r.EmployeeId
LEFT JOIN Users
	AS u
	ON u.Id = r.UserId
GROUP BY CONCAT(FirstName, ' ', LastName), r.EmployeeId
ORDER BY UsersCount DESC, FullName ASC

--Problem 10
SELECT
	CONCAT(FirstName, ' ', LastName) AS Employee
	,CASE 
		WHEN d.[Name] IS NULL THEN 'None'
		ELSE d.[Name]
	END AS Department	
	,CASE 
		WHEN c.[Name] IS NULL THEN 'None'
		ELSE c.[Name]
	END AS Category	
	,CASE 
		WHEN r.[Description] IS NULL THEN 'None'
		ELSE r.[Description]
	END AS [Description]	
	,CASE 
		WHEN r.OpenDate IS NULL THEN 'None'
		ELSE FORMAT(r.OpenDate, 'dd.MM.yyyy') 
	END AS OpenDate
	,CASE 
		WHEN s.[Label] IS NULL THEN 'None'
		ELSE s.[Label]
	END AS [Status]
	,CASE 
		WHEN u.[Name] IS NULL THEN 'None'
		ELSE u.[Name]
	END AS [User]
FROM Employees
	AS e
JOIN Reports
	AS r
	ON e.Id = r.EmployeeId
JOIN Users
	AS u
	ON u.Id = r.UserId
JOIN Status
	AS s
	ON s.Id = r.StatusId
JOIN Categories
	AS c
	ON c.Id = r.CategoryId
JOIN Departments
	AS d
	ON d.Id = e.DepartmentId
ORDER BY e.FirstName DESC, e.LastName DESC, Department ASC, Category ASC
,[Description] ASC,	OpenDate ASC, [Status] ASC, [User] ASC


--Problem 11
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS 
	BEGIN
		DECLARE @hoursToFinish INT

		IF(@StartDate IS NULL OR @EndDate IS NULL)
			BEGIN
				SET @hoursToFinish = 0
			END

		ELSE 
			BEGIN
				SET @hoursToFinish = DATEDIFF(HOUR, @StartDate, @EndDate)
			END

		RETURN @hoursToFinish
	END

SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
   FROM Reports
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS 
	BEGIN
		DECLARE @empDepartmentId INT = (
									SELECT
										DepartmentId
									 FROM Employees
										AS e
									JOIN Departments
										AS d
										ON d.Id = e.DepartmentId
									WHERE e.Id = @EmployeeId
								    )

		DECLARE @repDepartmentId INT = (
										SELECT
											DepartmentId
										FROM Reports
											AS r
										JOIN Categories
											AS c
											ON c.Id = r.CategoryId
										WHERE r.Id = @ReportId
										)		
		BEGIN TRY
			IF (@empDepartmentId = @repDepartmentId)
				BEGIN
					UPDATE Reports
						SET EmployeeId = @EmployeeId
					WHERE Reports.Id = @ReportId
				END
			ELSE
				THROW 5001, 'Employee doesn''t belong to the appropriate department!', 1
		END TRY
		BEGIN CATCH
			SELECT 'Employee doesn''t belong to the appropriate department!'
		END CATCH
	END
--Problem 12


EXEC usp_AssignEmployeeToReport 30, 1
EXEC usp_AssignEmployeeToReport 17, 2

