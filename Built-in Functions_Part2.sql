USE [Geography]

--Problem 12
SELECT
	CountryName,
	IsoCode
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

--Problem 13
SELECT * FROM
	(
		SELECT 
			p.PeakName
			,r.RiverName
			,LOWER(CONCAT(LEFT(p.PeakName, LEN(P.PeakName) - 1), r.RiverName)) AS Mix
		FROM Rivers as r, Peaks AS p
		WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
	) AS MixPeaks
ORDER BY Mix

USE Diablo

SELECT 
	[Name]
FROM Games

--Problem 14
SELECT TOP(50)
	[Name]
	,FORMAT([START], 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE YEAR([START]) = 2011 OR YEAR([START]) = 2012
ORDER BY [START], [NAME]


--Problem 15
SELECT 
 USERNAME
 ,[Email Provider]
 FROM 
	(SELECT 
		USERNAME
		, SUBSTRING(EMAIL, CHARINDEX('@', EMAIL, 1) + 1, 
		LEN(EMAIL) - CHARINDEX('@', EMAIL, 1)) AS [Email Provider]
	FROM [Users])
AS EmailProvider
ORDER BY [Email Provider], USERNAME

--Problem 16	
SELECT
	Username
	,IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'  
ORDER BY USERNAME

--Problem 17
SELECT 
	[Name]
	, CASE 
		WHEN DATEPART(HOUR, [START]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR, [START]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	 END AS [Part of the day]
	, CASE
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	 END AS Duration
FROM Games as g
ORDER BY g.[Name], [Duration]

--Problem 18
USE Orders

SELECT 
	ProductName
	,OrderDate
	,DATEADD(DAY, 3, OrderDate) AS [Pay Due]
	,DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM ORDERS