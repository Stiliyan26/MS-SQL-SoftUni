USE MinionsDB

--Problem 01
SELECT 
	v.[Name] AS [VilianName]
	,COUNT(*) AS MinionsCount
  FROM Villains AS v
JOIN MinionsVillains 
  AS mv
  ON v.Id = mv.VillainId
JOIN Minions 
  AS m
  ON mv.MinionId = m.Id
GROUP BY v.[Name]
  HAVING COUNT(*) > 3
ORDER BY MinionsCount DESC

--Problem 02
SELECT
	v.[Name]
	FROM Villains
		AS v
WHERE v.Id = 1

SELECT
	ROW_NUMBER() OVER (ORDER BY m.[Name]) AS [RowNumber]
	,m.[Name]
	,m.[Age]
	FROM Minions
		AS m
JOIN MinionsVillains
	AS mv
	ON mv.MinionId = m.Id
JOIN Villains 
	AS v
	ON mv.VillainId = v.Id
WHERE v.Id = 2

--Problem 03
SELECT
	[Name]
FROM Towns
WHERE [Name] = 'Sofia'

INSERT INTO Towns([Name])
	VALUES
('Sofia')


--SELECT 
--	*
--FROM Villains AS v
--JOIN EvilnessFactors AS ef
--ON v.EvilnessFactorId = ef.Id

INSERT INTO Villains([Name], EvilnessFactorId)
	VALUES
('Kiril', (SELECT 
			Id
			FROM EvilnessFactors
			WHERE [Name] = 'Evil'))

INSERT INTO Minions
	([Name], Age, TownId)
	VALUES
('Bogdan', 20, 3)

SELECT
	[Id]
FROM Minions
WHERE [Name] = 'Bogdan' AND Age = 20 AND TownId = 3

INSERT INTO MinionsVillains
	(MinionId, VillainId)
	VALUES
(1, 3)

SELECT * FROM Villains AS v
JOIN MinionsVillains AS mv
ON v.Id = mv.VillainId
JOIN Minions as m
ON mv.MinionId = m.Id

GO

--Problem 06
SELECT
	[Id]
FROM Villains
WHERE [Id] = 1

DELETE FROM MinionsVillains
	WHERE VillainId = 1

DELETE FROM Villains
	WHERE Id = 1

GO

--Problem 09
EXEC dbo.usp_GetOlder 1

SELECT 
	[Name]
	,Age
FROM Minions
WHERE Id = 1