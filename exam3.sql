CREATE DATABASE Zoo
USE Zoo

GO

--Problem 01
CREATE TABLE Owners(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL
	,PhoneNumber VARCHAR(15) NOT NULL
	,[Address] VARCHAR(50) 
)

CREATE TABLE AnimalTypes(
	Id INT PRIMARY KEY IDENTITY
	,AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages(
	Id INT PRIMARY KEY IDENTITY
	,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(30) NOT NULL
	,BirthDate DATE NOT NULL
	,OwnerId INT FOREIGN KEY REFERENCES Owners(Id)
	,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages(
	CageId INT NOT NULL FOREIGN KEY REFERENCES Cages(Id)
	,AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id)
	PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments(
	Id INT PRIMARY KEY IDENTITY
	,DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL
	,PhoneNumber VARCHAR(15) NOT NULL
	,[Address] VARCHAR(50) 
	,AnimalId INT FOREIGN KEY REFERENCES Animals(Id)
	,DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)

GO

--Problem 02
INSERT INTO Volunteers
	VALUES
('Anita Kostova', '0896365412',	'Sofia, 5 Rosa str.',	15,	1)
,('Dimitur Stoev', '0877564223', null, 42,	4)
,('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7)
,('Stoyan Tomov', '0898564100',	'Montana, 1 Bor str.', 18, 8)
,('Boryana Mileva',	'0888112233', null,	31,	5)

INSERT INTO Animals
	VALUES
('Giraffe',	'2018-09-21', 21, 1)
,('Harpy Eagle', '2015-04-17', 15, 3)
,('Hamadryas Baboon', '2017-11-02',	null, 1)
,('Tuatara', '2021-06-30', 2, 4)

GO

--Problem 03
UPDATE Animals
	SET OwnerId = (SELECT Id 
					FROM Owners
					WHERE [Name] = 'Kaloqn Stoqnov')
	WHERE OwnerId IS NULL

GO
--Problem 04
DELETE FROM Volunteers
WHERE DepartmentId = (
						SELECT Id
					FROM VolunteersDepartments
					WHERE DepartmentName = 'Education program assistant'
					)

DELETE FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

GO
--Problem 05
SELECT 
	[Name]
	,PhoneNumber
	,[Address]
	,AnimalId
	,DepartmentId
FROM Volunteers
ORDER BY [Name] ASC, AnimalId ASC, DepartmentId ASC

GO
--Problem 06
SELECT 
	[Name]
	,aty.AnimalType
	,FORMAT(BirthDate, 'dd.MM.yyyy')
FROM Animals AS a 
LEFT JOIN AnimalTypes AS aty
ON a.AnimalTypeId = aty.Id
ORDER BY [Name]

GO
--Problem 07
SELECT TOP(5)
	o.[Name]
	,COUNT(*)
FROM Owners AS o
LEFT JOIN Animals AS a
ON o.Id = a.OwnerId
GROUP BY o.[Name]
ORDER BY COUNT(*) DESC, o.[Name]

GO
--Problem 08
SELECT
	CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals
	,o.PhoneNumber
	,c.Id AS CageId
FROM Owners AS o
JOIN Animals AS a ON o.Id = a.OwnerId
JOIN AnimalTypes AS aty ON a.AnimalTypeId = aty.Id
JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
JOIN Cages AS c ON c.Id = ac.CageId
WHERE aty.AnimalType = 'Mammals'
ORDER BY o.[Name] ASC,	a.[Name] DESC

GO
--Problem 09
SELECT 
	v.[Name]
	,v.PhoneNumber
	,SUBSTRING(v.[Address], CHARINDEX(',', v.[Address]) + 2, LEN(v.[Address])) AS [Address]
FROM Volunteers AS v
JOIN VolunteersDepartments AS vd 
ON v.DepartmentId = vd.Id
WHERE vd.DepartmentName = 'Education program assistant' AND v.[Address] LIKE '%Sofia%'
ORDER BY v.[Name] ASC

--Problem 10
SELECT 
	a.[Name]
	,YEAR(a.BirthDate) AS BirthYear
	,at.AnimalType 
FROM Animals AS a
JOIN AnimalTypes AS at 
ON a.AnimalTypeId = at.Id
WHERE OwnerId IS NULL AND DATEDIFF(YY, BirthDate , '01/01/2022') < 5 AND NOT at.AnimalType = 'Birds'
ORDER BY a.[Name] ASC

GO
--Problem 11
CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS 
BEGIN
	DECLARE @count INT = (
						SELECT
						COUNT(*)
					FROM Volunteers AS v
					JOIN VolunteersDepartments AS vd
					ON v.DepartmentId = vd.Id
					WHERE vd.[DepartmentName] = @VolunteersDepartment
					)
	RETURN @count
END

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
Output

GO
--Problem 12
CREATE OR ALTER PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
BEGIN
	SELECT 
		a.[Name]
		,CASE
			WHEN o.[Name] IS NULL THEN 'For adoption'
			ELSE o.[Name]
		END AS OwnerName
	FROM Owners AS o
	RIGHT JOIN Animals AS a
	ON o.Id = a.OwnerId
	WHERE a.[Name] = @AnimalName
END

EXEC usp_AnimalsWithOwnersOrNot 'Hippo'