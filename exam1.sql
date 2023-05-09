CREATE DATABASE Bitbucket

GO 
--Problem 01
CREATE TABLE Users (
	Id INT PRIMARY KEY IDENTITY
	,Username VARCHAR(30) NOT NULL
	,[Password] VARCHAR(30) NOT NULL
	,Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories(	
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors(
	RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id)
	,ContributorId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
	PRIMARY KEY(RepositoryId, ContributorId)
)

CREATE TABLE Issues(
	Id INT PRIMARY KEY IDENTITY
	,Title VARCHAR(255) NOT NULL
	,IssueStatus VARCHAR(6) NOT NULL
	,RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id)
	,AssigneeId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
)

CREATE TABLE Commits(
	Id INT PRIMARY KEY IDENTITY
	,[Message] VARCHAR(255) NOT NULL
	,IssueId INT FOREIGN KEY REFERENCES Issues(Id)
	,RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id)
	,ContributorId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
)

CREATE TABLE Files(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR(100) NOT NULL
	,Size DECIMAL(15, 2) NOT NULL
	,ParentId INT FOREIGN KEY REFERENCES Files(Id)
	,CommitId INT NOT NULL FOREIGN KEY REFERENCES Commits(Id)
)

GO

--Problem 02
INSERT INTO Files([Name], Size, ParentId, CommitId)
	VALUES
('Trade.idk', 2598, 1, 1)
,('menu.net', 9238.31, 2, 2)
,('Administrate.soshy', 1246.93, 3, 3)
,('Controller.php', 7353.15, 4, 4)
,('Find.java', 9957.86, 5, 5)
,('Controller.json', 14034.87, 3, 6)
,('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
	VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4)
,('Typo fix in Judge.html', 'open', 4, 3)
,('Implement documentation for UsersService.cs', 'closed', 8, 2)
,('Unreachable code in Index.cs', 'open', 9, 8)

GO

--Problem 03
UPDATE Issues
	SET IssueStatus = 'closed'
WHERE AssigneeId = 6

GO
--Problem 04
DELETE FROM RepositoriesContributors
	WHERE RepositoryId = (
			SELECT
				Id
			FROM Repositories
			WHERE [Name] = 'Softuni-Teamwork'
		) 

DELETE FROM Commits
WHERE IssueId IN 
				(
				SELECT
					Id
				FROM Issues
				 WHERE RepositoryId = 
						(
							SELECT 
								Id
							FROM Repositories
							WHERE [Name] = 'Softuni-Teamwork'
						)
				)

DELETE FROM Issues
 WHERE RepositoryId = 
		(
			SELECT 
				Id
			FROM Repositories
			WHERE [Name] = 'Softuni-Teamwork'
		)

--Problem 05
SELECT 
	Id
	,[Message]
	,RepositoryId
	,ContributorId
FROM Commits 
ORDER BY Id, [Message], RepositoryId, ContributorId

--Problem 06
SELECT
	Id
	,[Name]
	,Size
FROM Files
WHERE Size > 1000 AND CHARINDEX('html', [Name]) > 0
ORDER BY Size DESC, Id, [Name]


--WHERE Size > 1000 AND [Name] LIKE '%html%'

--Problem 07
SELECT
	I.Id
	,CONCAT(u.Username, ' : ', i.Title) AS IssueAssignee
FROM Issues as i
LEFT JOIN Users AS u
ON i.AssigneeId = u.Id
ORDER BY i.Id DESC, IssueAssignee


--Problem 08
SELECT 
	fp.Id
	,fp.[Name]
	,CONCAT(fp.[Size], 'KB') AS Size
FROM Files AS fch
FULL OUTER JOIN Files AS fp
	ON fch.ParentId = fp.Id
WHERE fch.Id IS NULL
ORDER BY fp.Id, fp.[Name], fp.Size

--Problem 09
SELECT TOP(5) 
	r.Id
	,r.[NAME]
	,COUNT(c.Id) AS Commits
FROM Repositories AS r
LEFT JOIN Commits AS c
ON c.RepositoryId = r.Id
LEFT JOIN RepositoriesContributors AS rc
ON rc.RepositoryId = r.Id
GROUP BY r.Id, r.[NAME]
ORDER BY Commits DESC, r.Id, r.[NAME]

--Problem 10
SELECT	
	u.Username
	,AVG(f.Size) AS Size
FROM Users AS u
JOIN Commits AS c
ON c.ContributorId = u.Id
JOIN Files AS f
ON c.Id = f.CommitId
GROUP By u.Username
ORDER BY Size DESC, u.Username	

--Problem 11
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
	AS
	BEGIN
		DECLARE @userId INT = (
								SELECT
									Id
								FROM Users
								WHERE Username = @username
							  )
		DECLARE @counter INT = (
							     SELECT
									COUNT(*)
								 FROM Commits
								 WHERE ContributorId = @userId
							   )
		RETURN @counter
	END

--Problem 12
CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(98))
AS
BEGIN
	SELECT
		Id
		,[Name]
		,CONCAT(Size, 'KB') AS Size
	FROM Files AS f
	WHERE RIGHT(f.[Name], LEN(@fileExtension)) = @fileExtension
	ORDER BY Id, [Name], f.Size DESC
END

--WHERE f.[Name] LIKE CONCAT('%[.]', @fileExtension )