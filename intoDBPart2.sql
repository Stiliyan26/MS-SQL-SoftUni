CREATE DATABASE [Movies]

USE [Movies]

GO

CREATE TABLE [Directors] (
	[Id] INT PRIMARY KEY IDENTI	TY,
	[DirectorName] NVARCHAR(50) NOT NULL, 
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Genres] (
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX) 
)

CREATE TABLE [Categories] (
	[Id] INT PRIMARY KEY IDENTITY, 
	[CategoryName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Movies] (
 [Id] INT PRIMARY KEY IDENTITY,
 [Title] NVARCHAR(50) NOT NULL ,
 [DirectorId] INT,
 [CopyrightYear] DATETIME2 NOT NULL,
 [Length] INT,
 [GenreId] INT,
 [CategoryId] INT,
 [Rating] INT,
 [Notes] NVARCHAR(MAX)
)

INSERT INTO [Directors]([DirectorName])
	VALUES
('Kiro'),
('Andi'),
('Bogdan'),
('John'),
('asdda')

INSERT INTO [Genres] ([GenreName])
	VALUES
('Horror'),
('Triler'),
('SiFi'),
('Romantic'),
('Historic')

INSERT INTO [Categories] ([CategoryName])
	VALUES
('ADADDA'),
('ADAD'),
('ADADADAD'),
('CVZCZZC'),
('ADADAVC')

INSERT INTO [Movies] ([Title], [CopyrightYear])
	VALUES
('TITANIC', '2023-05-12'),
('HELL', '2022-06-13'),
('HALLOWEEN', '2012-04-12'),
('ADADAD', '1232-06-12'),
('dONT', '1232-05-12')

GO

/*ADD FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);*/

CREATE DATABASE [Softuni]

USE [Softuni]

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses] (
	[Id] INT PRIMARY KEY IDENTITY,
	[AddressText] NVARCHAR(50) NOT NULL,
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id])
)

CREATE TABLE [Departments] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Employees] (
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(50) NOT NULL,
	[MiddleName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[JobTitle] NVARCHAR(50) NOT NULL,
	[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL,
	[HireDate] DATE NOT NULL,
	[Salary] DECIMAL(6, 2),
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id])
)
GO
SELECT * FROM [Employees]

INSERT INTO [Towns] ([Name])
	VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO [Departments] ([Name])
	VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')
/*
DROP TABLE Employees
DROP TABLE Departments
DROP TABLE Addresses
DROP TABLE TOWNS
*/

SELECT * FROM [TOWNS]
SELECT * FROM [Departments]

INSERT INTO [Employees] ([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
	VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '02/01/2014', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03/02/2004', 4000.00 ),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08-28-2016', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '12-09-2007', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 2, '08-28-2016', 599.88)

SELECT 
	CONCAT ([FirstName], ' ', [MiddleName], ' ', [LastName], ' ') AS [Name],
	[JobTitle] as [Job Title],
	[DepartmentId],
	[HireDate],
	[Salary]	
FROM [Employees]

SELECT * FROM [TOWNS]
SELECT * FROM [Departments]
SELECT * FROM [Employees]

SELECT
	CONCAT ([FirstName], ' ', [MiddleName], ' ', [LastName], ' ') AS [Name],
	[JobTitle] as [Job Title],
	[Departments].[Name] AS [Department],
	[HireDate] as [Hire Date],
	[Salary]	
FROM [Employees]
INNER JOIN [Departments]
ON [Employees].DepartmentId = [Departments].Id

GO

SELECT * FROM [Towns]
ORDER BY [Name] ASC

SELECT * FROM [Departments]
ORDER BY [Name] ASC

SELECT * FROM [Employees]
ORDER BY [Salary] DESC

GO

SELECT 
[Name] 
FROM [Towns]
ORDER BY [Name] ASC

SELECT 
[Name] 
FROM [Departments]
ORDER BY [Name] ASC

SELECT
[FirstName],
[LastName],
[JobTitle],
[Salary]
FROM [Employees]
ORDER BY [Salary] DESC

GO

UPDATE	[Employees]
SET [Salary] = [Salary] * 1.1

SELECT [Salary] FROM [Employees]
