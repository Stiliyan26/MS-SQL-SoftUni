USE [Geography]

SELECT 
	PeakName
FROM Peaks
ORDER BY PeakName

GO

SELECT TOP(30)
	CountryName
	, [Population]
FROM Countries
INNER JOIN Continents
ON Countries.ContinentCode = Continents.ContinentCode
WHERE Continents.ContinentName = 'Europe'
ORDER BY Countries.[Population] DESC, Continents.ContinentName

GO

SELECT
	CountryName
	,CountryCode
	,CASE
		WHEN CurrencyCode = 'EUR' THEN 'Euro'
		ELSE 'Not Euro'
	END AS Currency
FROM Countries
ORDER BY CountryName

GO

USE Diablo

SELECT 
	[Name]
FROM Characters
ORDER BY [Name]