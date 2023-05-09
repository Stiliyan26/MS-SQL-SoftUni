CREATE DATABASE EntityRelations2022

GO

USE EntityRelations2022

GO

CREATE TABLE Passports (
	PassportID INT PRIMARY KEY IDENTITY(101, 1)
	,PassportNumber VARCHAR(10) NOT NULL,
)


CREATE TABLE Persons (
	PersonID INT PRIMARY KEY IDENTITY
	,FirstName NVARCHAR(30) NOT NULL
	,Salary DECIMAL(8, 2) NOT NULL
	,PassportID INT FOREIGN KEY REFERENCES Passports(PassportID) UNIQUE NOT NULL
)

INSERT INTO Passports(PassportNumber)
	VALUES 
('N34FG21B')
,('K65LO4R7')
,('ZE657QP2')

INSERT INTO Persons(FirstName, Salary, PassportID)
	VALUES
('Roberto', 43300.00, 102)
,('Tom', 56100.00, 103)
,('Yana', 60200.00, 101)

ALTER TABLE Passports
ADD UNIQUE(PassportNumber)

GO

CREATE TABLE Manufacturers(
	ManufacturerID INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(30) NOT NULL
	,EstablishedOn DATE NOT NULL
)

CREATE TABLE Models(
	ModelID INT PRIMARY KEY IDENTITY(101, 1)
	,[Name] VARCHAR(35) NOT NULL
	,ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL
)

INSERT INTO Manufacturers([Name], EstablishedOn)
	VALUES
('BMW', '07/03/1916')
,('Tesla', '01/01/2003')
,('Lada', '01/05/1966')

INSERT INTO Models([Name], ManufacturerID)
	VALUES
('X1', 1)
,('i6', 1)
,('Model S', 2)
,('Model X', 2)
,('Model 3', 2)
,('Nova', 3)


GO

CREATE TABLE Students(
	StudentID INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR(40) NOT NULL
)

CREATE TABLE Exams(
	ExamID INT PRIMARY KEY IDENTITY(101, 1)
	,[Name] NVARCHAR(70) NOT NULL
)

CREATE TABLE StudentsExams(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL
	,ExamID INT FOREIGN KEY REFERENCES Exams(ExamID) NOT NULL
	PRIMARY KEY(StudentID, ExamID)
)

INSERT INTO Students([Name])
	VALUES
('Mila')
,('Toni')
,('Ron')

INSERT INTO Exams([Name])
	VALUES
('SpringMVC')
,('Neo4j')
,('Oracle11g')

INSERT INTO StudentsExams(StudentID, ExamID)
	VALUES
(1, 101)
,(1, 102)
,(2, 101)
,(3, 103)
,(2, 102)
,(2, 103)

GO

CREATE TABLE Teachers(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1)
	,[Name] NVARCHAR(30) NOT NULL
	,ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers([Name], [ManagerID])
	VALUES
('John', NULL)
,('Maya', 106)
,('Silvia', 106)
,('Ted', 105)
,('Mark', 101)
,('Greta', 101)

GO

CREATE DATABASE OnlineStore

USE OnlineStore

CREATE TABLE Cities(
	CityID INT PRIMARY KEY
	,[Name] VARCHAR(50)
)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY
	,[Name] VARCHAR(50) 
	,Birthday DATE
	,CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY
	,[Name] VARCHAR(50)
)

CREATE TABLE Items(
	ItemID INT PRIMARY KEY
	,[Name] VARCHAR(50)
	,ItemTypeID INT REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY
	,CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID)
	,ItemID INT FOREIGN KEY REFERENCES Items(ItemID)
	PRIMARY KEY(OrderID, ItemID)
)

GO

CREATE DATABASE UniversityDatabase

USE UniversityDatabase

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY
	,SubjectName VARCHAR(50)
)

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY
	,[Name] VARCHAR(50)
)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY
	,StudentNumber INT 
	,StudentName VARCHAR(50)
	,MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)	

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY
	,PaymentDate DATE
	,PaymentAmount DECIMAL
	,StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
	,SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID)
	PRIMARY KEY(StudentID, SubjectID)
)

GO

USE [Geography]


SELECT 
	MountainRange
	,P.PeakName
	,P.Elevation
FROM Mountains as M
JOIN Peaks as P
ON M.Id = P.MountainId
WHERE M.MountainRange = 'Rila'
ORDER BY P.Elevation DESC