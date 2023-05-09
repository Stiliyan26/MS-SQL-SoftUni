CREATE DATABASE NationalTouristSitesOfBulgaria
GO
USE NationalTouristSitesOfBulgaria
GO

--Problem 01
CREATE TABLE Categories(
	Id INT IDENTITY PRIMARY KEY 
	,Name VARCHAR(50) NOT NULL
)

CREATE TABLE Locations(
	Id INT IDENTITY PRIMARY KEY 
	,Name VARCHAR(50) NOT NULL
	,Municipality VARCHAR(50)
	,Province VARCHAR(50)
)

CREATE TABLE Sites(
	Id INT IDENTITY PRIMARY KEY 
	,Name VARCHAR(100) NOT NULL
	,LocationId INT NOT NULL FOREIGN KEY REFERENCES Locations(Id)
	,CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id)
	,Establishment VARCHAR(15)
)

CREATE TABLE Tourists(
	Id INT IDENTITY PRIMARY KEY 
	,Name VARCHAR(50) NOT NULL
	,Age INT NOT NULL CHECK(0 <= Age AND Age <= 120)
	,PhoneNumber VARCHAR(20) NOT NULL
	,Nationality VARCHAR(30) NOT NULL
	,Reward VARCHAR(20)
)	

CREATE TABLE SitesTourists(
	TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id)
	,SiteId INT NOT NULL FOREIGN KEY REFERENCES Sites(Id)
	,PRIMARY KEY(TouristId, SiteId)
)

CREATE TABLE BonusPrizes(
	Id INT IDENTITY PRIMARY KEY 
	,Name VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes(
	TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id)
	,BonusPrizeId INT NOT NULL FOREIGN KEY REFERENCES BonusPrizes(Id)
	,PRIMARY KEY(TouristId, BonusPrizeId)
)

--Problem 02
INSERT INTO Tourists(Name, Age, PhoneNumber, Nationality, Reward)
	VALUES
('Borislava Kazakova', 52, '+359896354244', 'Bulgaria',	NULL)
,('Peter Bosh',	48,	'+447911844141', 'UK', NULL)
,('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge')
,('Svilen Dobrev', 49, '+359986584786',	'Bulgaria',	'Silver badge')
,('Kremena Popova',	38,	'+359893298604', 'Bulgaria', NULL)


INSERT INTO Sites(Name, LocationId, CategoryId, Establishment)
	VALUES
('Ustra fortress', 90, 7, 'X')
,('Karlanovo Pyramids',	65,	7, NULL)
,('The Tomb of Tsar Sevt', 63, 8, 'V BC')
,('Sinite Kamani Natural Park',	17,	1, NULL)
,('St. Petka of Bulgaria – Rupite',	92,	6, '1994')

--Problem 03
UPDATE Sites
	SET Establishment = '(not defined)'
WHERE Id IN (
			 SELECT Id 
				FROM Sites
			 WHERE Establishment IS NULL
			)

--Problem 04
SELECT
	BonusPrizeId
FROM BonusPrizes 
	AS bp
	JOIN TouristsBonusPrizes 
	AS tbp
	ON bp.Id = tbp.BonusPrizeId
WHERE [Name] = 'Sleeping bag'

DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId = 5

DELETE FROM BonusPrizes
WHERE [Name] = 'Sleeping bag'

SELECT * FROM BonusPrizes

--Problem 05
SELECT 
	[Name]
	,Age
	,PhoneNumber
	,Nationality
FROM Tourists 
ORDER BY Nationality ASC, Age DESC, [Name] ASC	

--Problem 06
SELECT
	s.[Name] AS [Site]
	,l.[Name] AS [Location]
	,s.Establishment
	,c.[Name] AS Category
FROM Sites
	AS s
JOIN Locations
	AS l
	ON s.LocationId = l.Id
JOIN Categories
	AS c
	ON s.CategoryId = c.Id
ORDER BY c.[Name] DESC, [Location] ASC, [Site] ASC

--Problem 07
SELECT
	l.Province AS Province
	,l.Municipality AS Municipality
	,l.[Name] AS [Location]
	,COUNT(*) AS CountOfSites
FROM Locations
	AS l
JOIN Sites
	AS s
	ON l.Id = s.LocationId
WHERE Province = 'Sofia'
GROUP BY LocationId, l.[Name], l.Municipality, l.Province
ORDER BY CountOfSites DESC, l.[Name] ASC

--Problem 08
SELECT
	s.[Name] AS [Site]
	,l.Name AS [Location]
	,l.Municipality AS Municipality
	,l.Province AS Province
	,s.Establishment AS Establishment
FROM Locations
	AS l
LEFT JOIN Sites
	AS s
	ON l.Id = s.LocationId
WHERE NOT LEFT(l.[Name], 1) IN ('B', 'M', 'D') AND s.Establishment LIKE '%BC%'
ORDER BY [Site] ASC

--Problem 09
SELECT
	t.[Name] AS [Name]
	,t.Age
	,t.PhoneNumber
	,t.Nationality
	,CASE 
		WHEN bp.[Name] IS NULL THEN '(no bonus prize)'
		ELSE bp.[Name]
	END AS Reward
FROM Tourists
	AS t
LEFT JOIN TouristsBonusPrizes
	AS tbp
	ON t.Id = tbp.TouristId
LEFT JOIN BonusPrizes
	AS bp
	ON tbp.BonusPrizeId = bp.Id
ORDER BY t.[Name] ASC

--Problem 10
SELECT
	SUBSTRING(t.Name, CHARINDEX(' ', t.Name) + 1, LEN(t.Name)) AS LastName
	,Nationality
	,Age
	,PhoneNumber
FROM Tourists 
	AS t
JOIN SitesTourists
	AS st
	ON st.TouristId = t.Id
JOIN Sites
	AS s
	ON st.SiteId = s.Id
JOIN Categories
	AS c
	ON s.CategoryId = c.Id
WHERE c.Name = 'History and archaeology' 
GROUP BY SUBSTRING(t.Name, CHARINDEX(' ', t.Name) + 1, LEN(t.Name)), Nationality, Age, PhoneNumber
ORDER BY LastName ASC

--Problem 11 
CREATE FUNCTION udf_GetTouristsCountOnATouristSite(@Site VARCHAR(100))
RETURNS INT
AS
	BEGIN
		DECLARE @Count INT = (
								SELECT
									COUNT(*)
								FROM Tourists 
									AS t
								JOIN SitesTourists
									AS st
									ON st.TouristId = t.Id
								JOIN Sites
									AS s
									ON st.SiteId = s.Id
								JOIN Locations
									AS l
									ON s.LocationId = l.Id
								WHERE s.Name = @Site
								)
		RETURN @Count
	END

SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Samuil’s Fortress')

--Problem 12
CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
	BEGIN
	DECLARE @count INT = (SELECT 
							COUNT(*)
						FROM Tourists 
							AS t
						JOIN SitesTourists
							AS st
							ON st.TouristId = t.Id
						JOIN Sites
							AS s
							ON st.SiteId = s.Id
						JOIN Categories
							AS c
							ON c.Id = s.CategoryId
						WHERE t.Name = @TouristName)
		UPDATE Tourists
			SET Reward = (
				CASE
					WHEN @count >= 100 THEN 'Gold badge'
					WHEN @count >= 50 THEN 'Silver badge'
					WHEN @count >= 25 THEN 'Bronze badge'
				END
				)
			WHERE Name = @TouristName

		SELECT
			Name
			,Reward
		FROM Tourists
		WHERE Name = @TouristName
	END

EXEC usp_AnnualRewardLottery 'Teodor Petrov'

EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'

EXEC usp_AnnualRewardLottery 'Zac Walsh'


