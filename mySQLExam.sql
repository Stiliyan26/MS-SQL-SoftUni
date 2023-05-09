CREATE DATABASE Boardgames

GO

USE Boardgames

--Problem 01
CREATE TABLE Categories(
	Id INT IDENTITY PRIMARY KEY
	,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses(
	Id INT IDENTITY PRIMARY KEY
	,StreetName NVARCHAR(100) NOT NULL
	,StreetNumber INT NOT NULL
	,Town VARCHAR(30) NOT NULL
	,Country VARCHAR(50) NOT NULL
	,ZIP INT NOT NULL
)

CREATE TABLE Publishers(
	Id INT IDENTITY PRIMARY KEY
	,[Name] VARCHAR(30) NOT NULL
	,AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
	,Website NVARCHAR(40)
	,Phone NVARCHAR(20)
)

CREATE TABLE PlayersRanges(
	Id INT IDENTITY PRIMARY KEY
	,PlayersMin INT NOT NULL
	,PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames(
	Id INT IDENTITY PRIMARY KEY
	,[Name] NVARCHAR(30) NOT NULL
	,YearPublished INT NOT NULL
	,Rating DECIMAL(13, 2) NOT NULL
	,CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL
	,PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL
	,PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL
)

CREATE TABLE Creators(
	Id INT IDENTITY PRIMARY KEY
	,FirstName NVARCHAR(30) NOT NULL
	,LastName NVARCHAR(30) NOT NULL
	,Email NVARCHAR(30) NOT NULL
)

CREATE TABLE CreatorsBoardgames(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL
	,BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL
	PRIMARY KEY(CreatorId, BoardgameId)
)

--Problem 02
INSERT INTO Boardgames([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
	VALUES
('Deep Blue', 2019,	5.67, 1, 15, 7)
,('Paris', 2016, 9.78, 7, 1, 5)
,('Catan: Starfarers', 2021, 9.87, 7, 13, 6)
,('Bleeding Kansas', 2020, 3.25, 3,	7, 4)
,('One Small Step',	2019, 5.75,	5, 9, 2)

INSERT INTO Publishers([Name],	AddressId,	Website, Phone)
	VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542')
,('Amethyst Games',	7,	'www.amethystgames.com', '+15558889992')
,('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

--Problem 03
UPDATE PlayersRanges 
	SET PlayersMax = PlayersMax + 1
WHERE PlayersMin = 2 AND PlayersMax = 2

UPDATE Boardgames
	SET [Name] = CONCAT([Name], 'V2')
WHERE YearPublished >= 2020

--Problem 04
DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (SELECT
							Id
						FROM Boardgames
						WHERE PublisherId IN (SELECT 
												Id
											FROM Publishers
											WHERE AddressId = 5))

DELETE FROM Boardgames
WHERE PublisherId IN (SELECT 
						Id
					FROM Publishers
					WHERE AddressId = 5)

DELETE FROM Publishers
WHERE AddressId = 5

DELETE FROM Addresses
WHERE LEFT(Town, 1) = 'L'

--Problem 05
SELECT
	[Name]
	,Rating
FROM Boardgames
ORDER BY YearPublished ASC, [Name] DESC

--Problem 06
SELECT
	b.Id AS Id
	,b.[Name] AS [Name]
	,YearPublished
	,c.[Name] AS CategoryName
FROM Boardgames 
	AS b
JOIN Categories
	AS c
	ON b.CategoryId = c.Id
WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC

--Problem 07
SELECT
	c.Id
	,CONCAT(FirstName, ' ', LastName) AS CreatorName
	,Email
FROM Creators
	 AS c
LEFT JOIN CreatorsBoardgames
	AS cb
	ON cb.CreatorId = c.Id
LEFT JOIN Boardgames
	AS b
	ON cb.BoardgameId = b.Id
WHERE cb.BoardgameId IS NULL

--Problem 08
SELECT TOP(5)
	b.[Name]
	,Rating
	,c.[Name] AS CategoryName
FROM Boardgames
	AS b
JOIN PlayersRanges
	AS pr
	ON b.PlayersRangeId = pr.Id
JOIN Categories
	AS c
	ON b.CategoryId = c.Id
WHERE (Rating > 7.00 AND b.[Name] LIKE '%a%') OR (Rating > 7.50 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5) 
ORDER BY b.[Name] ASC, Rating DESC

--Problem 09
SELECT
	CONCAT(FirstName, ' ',LastName) AS FullName
	,Email
	,MAX(Rating) AS Rating
FROM Creators
	AS c
JOIN CreatorsBoardgames
	AS cb
	ON	cb.CreatorId = c.Id
JOIN Boardgames
	 AS b
	 ON cb.BoardgameId = b.Id
WHERE RIGHT(Email, 4) = '.com'
GROUP BY CONCAT(FirstName, ' ',LastName), Email
ORDER BY FullName ASC

--Problem 10
SELECT 
	c.LastName AS LastName
	,CAST(AVG(CEILING(Rating)) AS INT) AS Rating
	,p.[Name] AS PublisherName
FROM Creators
	AS c
JOIN CreatorsBoardgames
	AS cb
	ON c.Id = cb.CreatorId
JOIN Boardgames
	AS b
	ON b.Id = cb.BoardgameId
JOIN Publishers
	AS p
	ON p.Id = b.PublisherId
WHERE cb.BoardgameId IS NOT NULL AND p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(Rating) DESC

--Problem 11
CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
	BEGIN
		DECLARE @count INT = (
								SELECT
									CASE
										WHEN CreatorId IS NULL THEN 0
									ELSE COUNT(FirstName)
									END AS [Counter]
								FROM Creators
									AS c
								LEFT JOIN CreatorsBoardgames
									AS cb
									ON cb.CreatorId = c.Id
								LEFT JOIN Boardgames
									AS b
									ON cb.BoardgameId = b.Id
								WHERE FirstName = @name
								GROUP BY FirstName, CreatorId
							 )
		RETURN @count
	END

--Problem 12
CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50))
AS
	BEGIN
		SELECT
			b.[Name]
			,YearPublished
			,Rating
			,c.[Name] AS CategoryName
			,p.[Name] AS PublisherName
			,CONCAT(PlayersMin, ' ', 'people') AS MinPlayers
			,CONCAT(PlayersMax, ' ', 'people') AS MaxPlayers
		FROM Boardgames
			AS b
		LEFT JOIN Categories
			AS c
			ON b.CategoryId = c.Id
		LEFT JOIN PlayersRanges
			AS pr
			ON b.PlayersRangeId = pr.Id
		LEFT JOIN Publishers
			AS p
			ON b.PublisherId = p.Id
		WHERE c.[Name] = @category
		ORDER BY PublisherName ASC, YearPublished DESC
	END

EXEC usp_SearchByCategory 'Wargames'