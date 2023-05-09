USE SOFTUNI

GO

--Problem 01
SELECT TOP(5)
	EmployeeID
	,JobTitle
	,a.AddressID
	,a.AddressText
FROM Employees AS e
JOIN Addresses as a
ON e.AddressID = a.AddressID
ORDER BY e.AddressID

--Problem 02
SELECT TOP(50)
	FirstName
	,LastName
	,t.[Name]
	,a.AddressText
FROM Employees AS e
JOIN Addresses as a
ON e.AddressID = a.AddressID
JOIN Towns AS t
ON a.TownID = t.TownID
ORDER BY FirstName, LastName

--Problem 03
SELECT TOP(50)
	EmployeeID
	,FirstName
	,LastName
	,d.[Name] AS [DepartmentName]
FROM Employees AS e
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY EmployeeID
	
--Problem 04
SELECT TOP(5)
	EmployeeID
	,FirstName
	,Salary
	,d.[Name]
FROM Employees AS e
LEFT JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

--Problem 05
SELECT TOP(3)
	e.EmployeeID
	,FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL 
ORDER BY EmployeeID

--Problem 06
SELECT 
	FirstName
	,LastName
	,HireDate
	,d.[Name] AS DeptName
FROM Employees AS e
LEFT JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE HireDate > CAST('1999-01-01' AS DATE) AND d.[Name] IN ('Sales', 'Finance')
ORDER BY HireDate

--Problem 07
SELECT TOP(5)
	e.EmployeeID
	,FirstName
	,p.[Name] AS ProjectName
FROM Employees AS e
LEFT JOIN EmployeesProjects as ep
ON e.EmployeeID = ep.EmployeeID	
LEFT JOIN Projects as p
ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > CAST('2002-08-13' AS DATE) AND p.EndDate IS NULL
ORDER BY EmployeeID

--Problem 08
SELECT
	e.EmployeeID
	,FirstName
	,CASE 
		WHEN YEAR(p.StartDate) >= 2005 THEN NULL
		ELSE p.[Name]
	END AS ProjectName
FROM Employees AS e
LEFT JOIN EmployeesProjects as ep
ON e.EmployeeID = ep.EmployeeID	
LEFT JOIN Projects as p
ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--Problem 09
SELECT
	e.EmployeeID
	,e.FirstName
	,e.ManagerID
	,em.FirstName AS ManagerName
FROM Employees As e
JOIN Employees AS em
ON e.ManagerID = em.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID

--Problem 10
SELECT TOP(50)
	e.EmployeeID
	,CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName
	,CONCAT_WS(' ', em.FirstName, em.LastName) AS ManagerName
	,d.[Name] AS DepartmentName
FROM Employees AS E
JOIN Employees AS em
ON e.ManagerID = em.EmployeeID
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
ORDER BY EmployeeID

--Problem 11
SELECT
	MIN(MinAverageSalary) AS MinAverageSalary
	FROM 
	(
		SELECT
			AVG(e.Salary) AS MinAverageSalary
		FROM Employees AS e
		JOIN Departments AS d
		ON e.DepartmentID = d.DepartmentID
		GROUP BY d.[Name]
	) AS MINAVG

USE [Geography]

--Problem 12
SELECT
	c.CountryCode
	,m.MountainRange
	,p.PeakName
	,p.Elevation
FROM Peaks AS p
JOIN Mountains as m
ON p.MountainId = m.Id
JOIN MountainsCountries AS mc
ON m.Id = mc.MountainId
JOIN Countries AS c
ON mc.CountryCode = c.CountryCode
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--Problem 13
SELECT
    c.CountryCode
	,COUNT(m.MountainRange)
FROM Mountains as m
JOIN MountainsCountries AS mc
ON m.Id = mc.MountainId
JOIN Countries AS c
ON mc.CountryCode = c.CountryCode
WHERE c.CountryCode IN ('US', 'RU', 'BG')
GROUP BY c.CountryCode

--Problem 14
SELECT TOP(5)
	c.CountryName
	,r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers as cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
LEFT JOIN Continents AS co
ON c.ContinentCode = co.ContinentCode
WHERE co.ContinentName = 'Africa'
ORDER BY c.CountryName

--Problem 15
SELECT 
	ContinentCode
	,CurrencyCode
	,CurrencyUsage
FROM
	(
		SELECT
			*,
			DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY [CurrencyUsage] DESC)
			AS CurrencyRank
		FROM
			(	
				SELECT
					co.ContinentCode
					,cu.CurrencyCode
					,COUNT(cu.CurrencyCode) AS [CurrencyUsage]
				FROM Continents AS co
				LEFT JOIN Countries AS cu
				ON co.ContinentCode = cu.ContinentCode
				GROUP BY cu.CurrencyCode, co.ContinentCode
			) AS CurrencyUsageQuery
		WHERE CurrencyUsageQuery.[CurrencyUsage] > 1
	) AS CurrencyRankingQuery
WHERE CurrencyRank = 1

--Problem 16
SELECT 
	COUNT(*)
FROM Countries as c
LEFT JOIN MountainsCountries as mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains as m
ON mc.MountainId = m.Id
WHERE mc.MountainId IS NULL

--Problem 17
SELECT TOP(5)
	cu.CountryName
	,MAX(p.Elevation) AS HighestPeakElevation
	,MAX(r.[Length]) AS LongestRiverLength 
FROM Peaks AS p
LEFT JOIN Mountains AS m
ON m.Id = p.MountainId
LEFT JOIN MountainsCountries AS mc
ON m.Id = mc.MountainId
LEFT JOIN Countries AS cu
ON mc.CountryCode = cu.CountryCode
LEFT JOIN CountriesRivers AS cr
ON cu.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON r.Id = cr.RiverId
GROUP BY cu.[CountryName]
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, cu.CountryName

--Problem 18
SELECT TOP 5
	cu.CountryName AS Country
	,CASE
		WHEN p.PeakName IS NULL THEN '(no highest peak)' 
		ELSE p.PeakName
	END AS [Highest Peak Name]
	,CASE
		WHEN p.Elevation IS NULL THEN 0 
		ELSE p.Elevation
	END AS [Highest Peak Elevation]
	,CASE
		WHEN m.MountainRange IS NULL THEN '(no mountain)'
		ELSE m.MountainRange
	END AS [Mountain]
FROM Countries AS cu
LEFT JOIN MountainsCountries AS mc
ON cu.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
ON MC.MountainId = m.Id
LEFT JOIN Peaks AS p
ON m.Id = p.MountainId
ORDER BY cu.CountryName, [Highest Peak Name]