--Problem 05
SELECT
	DepositGroup
	,SUM(DepositAmount)
FROM WizzardDeposits
GROUP BY DepositGroup

--Problem 06
SELECT
	DepositGroup
	,SUM(DepositAmount) as TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--Problem 07
SELECT
	DepositGroup
	,SUM(DepositAmount) as TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY SUM(DepositAmount) DESC

--Problem 08
SELECT 
	DepositGroup
	,MagicWandCreator
	,MIN(DepositCharge)
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

--Problem 09
SELECT 
	AgeGroup
	,COUNT(*)
FROM
	(
		SELECT 
			CASE 
				WHEN AGE BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN AGE BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN AGE BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN AGE BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN AGE BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN AGE BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]'
			END AS AgeGroup
		FROM WizzardDeposits
	) AS SUBQUERY
GROUP BY AgeGroup

--Problem 10
SELECT * FROM
	(
		SELECT
			LEFT(FirstName, 1) AS FirstLetter
		FROM WizzardDeposits
		WHERE DepositGroup = 'Troll Chest'
	) AS SB
GROUP BY FirstLetter
ORDER BY FirstLetter

--Problem 11
SELECT 
	DepositGroup
	,IsDepositExpired
	,AVG(DepositInterest)
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

SELECT * FROM WizzardDeposits

SELECT *
FROM WizzardDeposits AS wd1
INNER JOIN WizzardDeposits AS wd2
ON wd1.Id + 1 = wd2.Id

SELECT
	SUM([Host Wizard Deposit] - [Guest Wizard Deposit]) AS Diffrence
FROM (
	SELECT
		FirstName AS [Host Wizard]
		,DepositAmount AS [Host Wizard Deposit]
		,LEAD(FirstName) OVER(ORDER BY Id) AS [Guest Wizard]
		,LEAD(DepositAmount) OVER(ORDER BY Id) AS [Guest Wizard Deposit]
	FROM WizzardDeposits	
	) AS [HostWizardQuery]
WHERE [Guest Wizard] IS NOT NULL

USE SoftUni

--Problem 18
SELECT DISTINCT
	DepartmentID
	,Salary
FROM
	(SELECT 
		DepartmentID
		,Salary
		,DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) as SalaryRank
	 FROM Employees
	 ) AS SUBQUERY
WHERE SalaryRank = 3

--Problem 19
SELECT TOP(10)
	FirstName
	,LastName
	,DepartmentId
FROM Employees AS e
WHERE е.Salary > (
					SELECT AVG(Salary) AS AverageSalary
					 FROM Employees AS esub
					 WHERE esub.DepartmentID = e.DepartmentID
					 GROUP BY DepartmentID
				 )
GROUP BY e.DepartmentID