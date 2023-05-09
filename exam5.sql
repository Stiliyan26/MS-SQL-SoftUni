CREATE DATABASE Airport
GO
USE Airport
GO

--Problem 01
CREATE TABLE Passengers(
	Id INT IDENTITY PRIMARY KEY 
	,FullName VARCHAR(100) UNIQUE NOT NULL
	,Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots(
	Id INT IDENTITY PRIMARY KEY 
	,FirstName VARCHAR(30) UNIQUE NOT NULL
	,LastName VARCHAR(30) UNIQUE NOT NULL
	,Age TinyInt CHECK(21 <= Age AND Age <= 62)	NOT NULL
	,Rating FLOAT CHECK(0.0 <= Rating AND Rating <= 10.0)
)


CREATE TABLE AircraftTypes(
	Id INT IDENTITY PRIMARY KEY 
	,TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft(
	Id INT IDENTITY PRIMARY KEY 
	,Manufacturer VARCHAR(25) NOT NULL
	,Model VARCHAR(30) NOT NULL
	,[Year] INT NOT NULL
	,FlightHours INT 
	,Condition CHAR NOT NULL
	,TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL
	,PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL
	,PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE Airports(
	Id INT IDENTITY PRIMARY KEY 
	,AirportName VARCHAR(70) UNIQUE NOT NULL
	,Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations(
	Id INT IDENTITY PRIMARY KEY 
	,AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL
	,[Start] DateTime NOT NULL
	,AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL
	,PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL
	,TicketPrice DECIMAL(16, 2) DEFAULT 15 NOT NULL 
)

--Problem 02
INSERT INTO Passengers
SELECT 
	CONCAT(FirstName, ' ', LastName) AS FullName  
	,CONCAT(FirstName, LastName, '@gmail.com') AS Email 
FROM Pilots
WHERE Id BETWEEN 5 AND 15

GO
--Problem 03
UPDATE Aircraft
	SET Condition = 'A'
FROM Aircraft
WHERE 
	(Condition = 'C' OR Condition = 'B') AND 
	(FlightHours IS NULL OR FlightHours <= 100) AND
	(2013 <= [Year])

--Problem 04
DELETE FROM Passengers
WHERE LEN(FullName) <= 10

--Problem 05
SELECT
	Manufacturer
	,Model
	,FlightHours
	,Condition
FROM Aircraft
ORDER BY FlightHours DESC

--Problem 06
	SELECT
		p.FirstName
		,p.LastName
		,a.Manufacturer
		,a.Model
		,a.FlightHours
	FROM Aircraft 
		AS a
	JOIN PilotsAircraft
		AS pa
		ON a.Id = pa.AircraftId
	JOIN Pilots
		AS p
		ON pa.PilotId = p.Id
	WHERE FlightHours < 304
	ORDER BY FlightHours DESC, p.FirstName

--Problem 07
SELECT TOP(20)
	fd.Id AS DestinationId
	,fd.[Start]
	,p.FullName AS FullName 
	,AirportName
	,TicketPrice
FROM FlightDestinations
	AS fd
JOIN Passengers
	AS p
	ON fd.PassengerId = p.Id
JOIN Airports
	AS ap
	ON ap.Id = fd.AirportId
WHERE DAY([Start]) % 2 = 0
ORDER BY TicketPrice DESC, AirportName ASC

--Problem 08
SELECT
	AircraftId
	, Manufacturer
	,FlightHours
	,COUNT(*) AS FlightDestinationsCount
	,ROUND(AVG(TicketPrice), 2) AS AvgPrice
FROM Aircraft
	AS a
LEFT JOIN FlightDestinations
	AS fd
	ON fd.AircraftId = a.Id
GROUP BY AircraftId, Manufacturer, FlightHours
HAVING COUNT(*) >= 2
ORDER BY FlightDestinationsCount DESC, AircraftId ASC

--Problem 09
SELECT
	FullName
	,COUNT(*) AS CountOfAircraft 
	,SUM(TicketPrice) AS TotalPayed
FROM Passengers
	AS p
JOIN FlightDestinations
	AS fa
	ON fa.PassengerId = p.Id
JOIN Aircraft
	AS a
	ON fa.AircraftId = a.Id
WHERE SUBSTRING(FullName, 2, 1) = 'a'  
GROUP BY FullName
HAVING COUNT(*) > 1
ORDER BY FullName

--Problem 10
SELECT
	AirportName
	,[Start] AS DayTime
	,TicketPrice
	,FullName
	,Manufacturer
	,Model
FROM FlightDestinations
	AS fd
JOIN Airports
	AS a
	ON fd.AirportId = a.Id
JOIN Passengers
	AS p
	ON fd.PassengerId = p.Id
JOIN Aircraft
	AS ac
	ON fd.AircraftId = ac.Id
WHERE (DATEPART(HOUR, [Start]) BETWEEN 6 AND 20)
	AND TicketPrice > 2500
ORDER BY Model ASC

--Problem 11
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS 
	BEGIN
		DECLARE @count INT = (
							SELECT
								COUNT(*) 
							FROM Passengers
								AS p
							JOIN FlightDestinations
								AS fd
								ON fd.PassengerId = p.Id
							WHERE @email = p.Email
							GROUP BY FullName
						 )
		IF (@count IS NULL)
			BEGIN
				SET @count = 0
			END
		
		RETURN @count
	END

SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')

SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')

CREATE PROCEDURE usp_SearchByAirportName(@airportName VARCHAR(70))
AS
	BEGIN
		SELECT
			AirportName
			,FullName
			,CASE
				WHEN TicketPrice <= 400 THEN 'Low'
				WHEN TicketPrice BETWEEN 401 AND 1500 THEN 'Medium' 
				WHEN TicketPrice > 1501 THEN 'High'
			END AS LevelOfTickerPrice 
			,Manufacturer
			,Condition
			,TypeName
		FROM Airports
			AS a
		JOIN FlightDestinations
			AS fd
			ON a.Id = fd.AirportId
		JOIN Passengers
			AS p
			ON p.Id = fd.PassengerId
		JOIN Aircraft
			AS ac
			ON ac.Id = fd.AircraftId
		JOIN AircraftTypes
			AS at
			ON at.Id = ac.TypeId
		WHERE AirportName = @airportName
		ORDER BY Manufacturer, FullName
	END

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'