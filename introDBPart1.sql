CREATE DATABASE [Minions]

USE [Minions]

GO

CREATE TABLE [MINIONS] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT NOT NULL
)

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(70) NOT NULL,
)

ALTER TABLE [MINIONS]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

ALTER TABLE [MINIONS] 
ALTER COLUMN [Age] INT

GO	

INSERT INTO [Towns] ([Id], [Name])
	VALUES
(1, 'Sofia'), 
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [Minions] ([Id], [Name], [Age], [TownId])
	VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL , 2)

GO

SELECT * FROM [Towns]
SELECT * FROM [Minions]


CREATE TABLE [People] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3, 2),
	[Weight] DECIMAL(5, 2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)


INSERT INTO [People] ([Name], [Height], [Weight], [Gender], [Birthdate]) 
	VALUES
('Pesho', 1.77, 75.2, 'm', '1998-05-25'),
('Gosho', NULL, NULL, 'm', '1977-05-25'),
('Maria', 1.65, 42.2, 'f', '1988-01-12'),
('Bogdan', 1.80, 90, 'm', '2003-05-16'),
('Pepsi', 1.75, 79, 'm', '2003-07-20')

SELECT * FROM [People]

GO

/* Create and Insert Table [Users] */
CREATE TABLE [Users] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL UNIQUE,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	CHECK (DATALENGTH([ProfilePicture]) <= 900000),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT
)

INSERT INTO [Users] ([Username], [Password], [IsDeleted])
	VALUES
('Pepsi26', '123425', 1),
('Kiril', '12342', 0),
('Stili26', '213221', 1),
('Andi', '12312', 0),
('Bogdan', '54122', 1)


SELECT * FROM [Users]

GO

/* DELETE and SET Primary key to two columns */
ALTER TABLE [Users] 
DROP CONSTRAINT PK__Users__3214EC07C314B81D

ALTER TABLE [Users]
ADD CONSTRAINT PK_Users PRIMARY KEY ([Password], [Username])
 
GO

/*Add Check Constraint*/
ALTER TABLE [Users]
ADD CHECK(DATALENGTH([Password]) >= 5)

GO

/* Set default value to lastloggedin */

ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLogin DEFAULT (GETDATE()) FOR  [LastLoginTime]

INSERT INTO [Users] ([Username], [Password], [IsDeleted])
	VALUES
('Pepsi', '123425', 1)

SELECT * FROM [Users]

Go

/* Set Unique Field */

ALTER TABLE [Users]
DROP CONSTRAINT PK_Users

ALTER TABLE [Users]
ADD CONSTRAINT PK_Users PRIMARY KEY([Id])

ALTER TABLE [Users]
ADD CONSTRAINT UQ_Username UNIQUE([Username])

ALTER TABLE [Users]
ADD CHECK(DATALENGTH([Username]) >= 3)

GO

