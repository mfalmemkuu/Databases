CREATE TABLE Donors(donorID int NOT NULL,
firstName varchar(255),
lastName varchar(255),
middleInitial varchar(255),
dateOfBirth date,
address int,
city varchar(255),
postalCode varchar(255),
province varchar(255),
gender varchar(1),
SSN int,
PRIMARY KEY (donorID));

CREATE TABLE Donations(dID int NOT NULL,
donorID int,
`Date` date,
`type` varchar(255),
amount int,
PRIMARY KEY (dID));

CREATE TABLE Products(pID int,
description varchar(255),
`date` date,
price int,
weight int,
PRIMARY KEY (pID));

CREATE TABLE Sales(sID int NOT NULL,
`date`date,
amount int,
deliveryFee int,
PRIMARY KEY (sID));

CREATE TABLE SalesItems(sID int,
pID int,
PRIMARY KEY (sID,pID));
ALTER TABLE Donors DROP middleInitial;
ALTER TABLE Donors ADD COLUMN (
phone varchar(255) DEFAULT "Unknown",
email varchar(255) DEFAULT "Unknown");

INSERT INTO Donors VALUES(3,"keith","richards",'1000-01-01', 1000, "Montreal","H2H", 
"Quebec", "M", 42536, "43534", "rwjjwr@fnal.com" );
INSERT INTO Donors VALUES(4,"mick","Jaggers",'1000-01-01', 1001, "Montreal","H2H", 
"Quebec", "M", 42436, "43564", "rwjjw75@fnal.com" );

INSERT INTO Donations VALUES(1, 3,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(2, 3,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(3, 4,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(4, 4,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(5, 4,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(6, 5,'2022-07-01', "product", 10 );
INSERT INTO Donations VALUES(7, 6,'2022-07-01', "product", 10 );

INSERT INTO Products VALUES(1,"dresser",'2022-07-01', 43, 10);
INSERT INTO Products VALUES(2,"shelf",'2013-07-14', 53, 1);
INSERT INTO Products VALUES(3,"bed",'2023-07-01', 20, 13);

INSERT INTO Sales VALUES(15,'2023-05-01', 132, 50);
INSERT INTO Sales VALUES(2,'2023-07-04', 52, 70);
INSERT INTO Sales VALUES(3,'2023-07-25', 15, 4);
INSERT INTO Sales VALUES(4,'2023-07-24', 64, 15);
INSERT INTO Sales VALUES(5,'2023-08-01', 132, 50);
INSERT INTO Sales VALUES(6,'2022-08-01', 132, 50);
INSERT INTO Sales VALUES(11,'2022-07-01', 132, 50);
INSERT INTO Sales VALUES(12,'2022-07-01', 153, 70);
INSERT INTO Sales VALUES(13,'2022-01-01', 132, 50);
INSERT INTO Sales VALUES(14,'2022-07-03', 135, 35);

INSERT INTO salesItems VALUES(1,2);

DELETE FROM Products;

DROP TABLE Donors;
DROP TABLE Donations;
DROP TABLE Products;
DROP TABLE Sales;
DROP TABLE salesItems;

SELECT * FROM Donations;

SELECT donorID, firstName, lastName, dateOfBirth, phone, email, SSN
FROM Donors
WHERE gender = 'F' AND province = 'Quebec';

SELECT s.sID, p.pID, p.description, p.price, p.weight
FROM Products p, Sales s, salesItems i
WHERE s.date = '2023-07-01' AND p.pID = i.pID AND s.sID = i.sID;

SELECT SUM(deliveryFee)
FROM Sales 
WHERE date >= '2023-07-01' AND date <= '2023-07-31';

SELECT MONTH(date) AS "month", COUNT(sID) AS numberOfSales, SUM(amount) AS "amount", 
SUM(deliveryFee) AS "delivery fees"
FROM Sales 
WHERE YEAR(date)=2022
GROUP BY MONTH(date);

SELECT firstName, lastName,d.donorID, SUM(amount)
FROM Donors d, Donations s
WHERE d.donorID = s.donorID AND YEAR(Date) =2022 AND city = 'Montreal'
GROUP BY d.donorID
ORDER BY gender ASC, lastName ASC, firstName ASC;