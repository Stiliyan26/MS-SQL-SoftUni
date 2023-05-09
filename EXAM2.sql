CREATE DATABASE CigarShop
USE CigarShop
GO

--Problem 01
CREATE TABLE Sizes(
	Id INT PRIMARY KEY IDENTITY
	,[Length] INT NOT NULL CHECK([Length] >= 10 AND [Length] <= 25)
	,RingRange DECIMAL(10, 2) NOT NULL CHECK(RingRange >= 1.5 AND RingRange <= 7.5)
)

CREATE TABLE Tastes(
	Id INT PRIMARY KEY IDENTITY
	,TasteType VARCHAR(20) NOT NULL
	,TasteStrength VARCHAR(15) NOT NULL
	,ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands(
	Id INT PRIMARY KEY IDENTITY
	,BrandName VARCHAR(30) UNIQUE NOT NULL
	,BrandDescription VARCHAR(MAX) 
)

CREATE TABLE Cigars(
	Id INT PRIMARY KEY IDENTITY
	,CigarName VARCHAR(80) NOT NULL
	,BrandId INT NOT NULL FOREIGN KEY REFERENCES Brands(Id) 
	,TastId INT NOT NULL FOREIGN KEY REFERENCES Tastes(Id) 
	,SizeId INT NOT NULL FOREIGN KEY REFERENCES Sizes(Id) 
	,PriceForSingleCigar MONEY NOT NULL
	,ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY
	,Town VARCHAR(30) NOT NULL
	,Country NVARCHAR(30) NOT NULL
	,Streat NVARCHAR(100) NOT NULL
	,ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients(
	Id INT PRIMARY KEY IDENTITY
	,FirstName NVARCHAR(30) NOT NULL
	,LastName NVARCHAR(30) NOT NULL
	,Email NVARCHAR(50) NOT NULL
	,AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE ClientsCigars(
	ClientId INT NOT NULL FOREIGN KEY REFERENCES Clients(Id)
	,CigarId INT NOT NULL FOREIGN KEY REFERENCES Cigars(Id)
	PRIMARY KEY(ClientId, CigarId)
)

GO

--Problem 02
INSERT INTO Cigars(CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
	VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg')
,('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg')
,('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg')
,('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg')
,('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses(Town, Country, Streat, ZIP)
	VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000)
,('Athens',	'Greece', '4342 McDonald Avenue', 10435)
,('Zagreb',	'Croatia', '4333 Lauren Drive', 10000)

GO
--Problem 03
SELECT 
	*
FROM Cigars AS c
LEFT JOIN Tastes AS t
ON c.TastId = t.Id
WHERE t.TasteType = 'Spicy'

UPDATE Cigars
	SET PriceForSingleCigar = PriceForSingleCigar * 1.2
WHERE TastId = 1

SELECT * FROM Brands
UPDATE Brands
	SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

GO

--Problem 04
DELETE FROM Clients
WHERE AddressId IN (
					SELECT
						Id
					FROM Addresses
					WHERE LEFT(Country, 1) = 'C'
				)

DELETE FROM Addresses
WHERE LEFT(Country, 1) = 'C'

--Problem 05
SELECT
	CigarName
	,PriceForSingleCigar
	,ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

--Problem 06
SELECT 
	c.Id
	,c.CigarName
	,c.PriceForSingleCigar
	,t.TasteType
	,t.TasteStrength
FROM Cigars AS c
JOIN Tastes AS t
ON c.TastId = t.Id
WHERE t.TasteType = 'Earthy' OR t.TasteType = 'Woody'
ORDER BY PriceForSingleCigar DESC

--Problem 07
SELECT
	Id
	,CONCAT(FirstName, ' ', LastName) AS ClientName
	,Email
FROM Clients as c
LEFT JOIN ClientsCigars AS cr
ON c.Id = cr.ClientId
WHERE cr.ClientId IS NULL
ORDER BY ClientName

--Problem 08
SELECT TOP(5)
	CigarName
	,PriceForSingleCigar
	,ImageURL
FROM Cigars AS c
LEFT JOIN Sizes AS s
ON c.SizeId = s.Id
WHERE s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' OR c.PriceForSingleCigar > 50) AND s.RingRange > 2.55
ORDER BY CigarName, PriceForSingleCigar DESC	

--Problem 09
SELECT 
	CONCAT(FirstName, ' ', LastName) AS FullName
	,a.Country
	,a.ZIP
FROM Clients AS c
LEFT JOIN Addresses AS a
ON c.AddressId = a.Id
LEFT JOIN ClientsCigars AS cc
ON c.Id = cc.ClientId
LEFT JOIN Cigars AS cr
ON cc.CigarId = cr.Id
