SELECT * FROM Employees

GO
--Problem 01
CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT
		FirstName
		,LastName
	FROM Employees
	WHERE Salary > 35000
END

GO

EXEC dbo.usp_GetEmployeesSalaryAbove35000

GO
--Problem 02
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@minSalary DECIMAL(18, 4))
AS 
BEGIN
	SELECT
		FirstName
		,LastName
	FROM Employees
	WHERE Salary >= @minSalary
END

GO

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 


GO
--Problem 03
CREATE PROCEDURE usp_GetTownsStartingWith(@subStr VARCHAR(50))
AS
BEGIN
	SELECT
		[Name]
	FROM Towns
	WHERE LEFT([Name], LEN(@subStr)) = @subStr
END

GO

EXEC dbo.usp_GetTownsStartingWith 'B'
EXEC dbo.usp_GetTownsStartingWith 'C'

GO
--Problem 04
CREATE OR ALTER PROCEDURE usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
BEGIN
	SELECT
		FirstName
		,LastName
	FROM Employees as e
	LEFT JOIN Addresses as a
	ON e.AddressID = a.AddressID
	LEFT JOIN Towns as t
	ON a.TownID = t.TownID
	WHERE t.[Name] = @townName
END
GO

EXEC dbo.usp_GetEmployeesFromTown 'Sofia'

GO
--Problem 05
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
BEGIN
	DECLARE @salaryLevel VARCHAR(8)

	IF (@salary < 30000)
	BEGIN
		SET @salaryLevel = 'Low'
	END

	ELSE IF (@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @salaryLevel = 'Average'
	END

	ELSE IF (@salary > 50000)
	BEGIN
		SET @salaryLevel = 'High'
	END

	RETURN @salaryLevel
END
GO

SELECT
	Salary
	,dbo.ufn_GetSalaryLevel(Salary)
	AS SalaryLevel
FROM Employees

GO
--Problem 06
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(8))
AS
BEGIN
	SELECT 
		FirstName
		,LastName
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END
GO

EXEC dbo.usp_EmployeesBySalaryLevel 'Average'

GO
--Problem 08
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	DELETE FROM EmployeesProjects
		WHERE EmployeeID IN (
								SELECT 
									EmployeeID
								FROM Employees
								WHERE DepartmentID = @departmentId
							)
	UPDATE Employees
		SET ManagerID = NULL
	WHERE ManagerID IN (
							SELECT 
								EmployeeID
							FROM Employees
							WHERE DepartmentID = @departmentId
						)

	ALTER TABLE Departments
	ALTER COLUMN MangerId INT

	UPDATE Departments
		SET ManagerID = NULL
	WHERE ManagerId IN (
							SELECT 
								EmployeeID
							FROM Employees
							WHERE DepartmentID = @departmentId
						)
	DELETE FROM Employees
		WHERE DepartmentID = @departmentId

	DELETE FROM Departments
		WHERE DepartmentID = @departmentId

	SELECT COUNT(EmployeeId)
		FROM Employees
	WHERE DepartmentID = @departmentId
END
GO

--Problem13


GO

