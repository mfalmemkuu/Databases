/* Part 1 */

CREATE TABLE Members(
ID int NOT NULL,
first_name varchar(255),
last_name varchar(255),
middle_initial varchar(255),
date_of_birth date,
address varchar(255),
gender varchar(255),
phone int,
email varchar(255),
social_security_number int,
start_date date,
PRIMARY KEY(ID));

CREATE TABLE Donations(
ID int NOT NULL,
donorID int NOT NULL,
donation_type ENUM('money','products'),
donation_amount int,
donation_date date,
PRIMARY KEY(ID),
FOREIGN KEY(donorID) REFERENCES Members(ID));

CREATE TABLE Products(
ID int NOT NULL,
product_description varchar(255),
product_date date,
instock boolean DEFAULT TRUE,
weight int,
price int,
PRIMARY KEY(ID));

CREATE TABLE Sales(
ID int NOT NULL,
sale_date date,
amount int,
PRIMARY KEY(ID));

CREATE TABLE SalesItems(
saleID int NOT NULL,
productID int NOT NULL,
FOREIGN KEY(saleID) REFERENCES Sales(ID),
FOREIGN KEY(productID) REFERENCES Products(ID));

CREATE TABLE Donor(
ID int NOT NULL,
FOREIGN KEY(ID) REFERENCES Members(ID));

CREATE TABLE Client(
ID int NOT NULL,
FOREIGN KEY(ID) REFERENCES Members(ID));

CREATE TABLE Employee(
ID int NOT NULL,
title varchar(255),
salary int,
FOREIGN KEY(ID) REFERENCES Members(ID));

CREATE TABLE Expenses(
ID int NOT NULL,
presidentID int NOT NULL,
expense_date date,
amount int,
expense_type ENUM('rent','bill payment','charity payment'),
description varchar(255),
PRIMARY KEY(ID),
FOREIGN KEY(presidentID) REFERENCES Employee(ID));
/* d)
 I would add vice president ID to Expenses as a foreign key alongside president ID*/

CREATE TABLE Expenses(
ID int NOT NULL,
presidentID int NOT NULL,
vpID int NOT NULL,
expense_date date,
amount int,
expense_type ENUM('rent','bill payment','charity payment'),
description varchar(255),
PRIMARY KEY(ID),
FOREIGN KEY(vpID) REFERENCES Employee(ID)
FOREIGN KEY(presidentID) REFERENCES Employee(ID));

/* Part 2 */

/* a */

SELECT m.ID,m.first_name,m.last_name,m.middle_initial,m.date_of_birth,
m.address,m.gender,m.phone,m.email,m.social_security_number,e.title,m.start_date
FROM members m, employee e, donor d, client c
WHERE m.ID=e.ID AND e.ID = d.ID AND d.ID = c.ID AND e.salary = 0;

/* b */

SELECT e.ID, m.first_name , m.last_name, e.expense_date,
e.amount, e.expense_type, e.description 
FROM expenses e, employee ee, members m 
WHERE e.presidentID = ee.ID AND ee.ID = m.ID AND ee.title = 'president'
AND MONTH(expense_date) = 6 AND YEAR(expense_date) = 2023;


/* c */

/* added the donation ID as a foreign key to make the query possible */

ALTER TABLE sales 
ADD COLUMN clientID int;
ALTER TABLE sales 
ADD FOREIGN KEY(clientID) REFERENCES members(ID);
SELECT s.ID, s.sale_date, m.first_name, m.last_name, p.product_description,
p.price, p.weight 
FROM members m, sales s, salesitems si, products p
WHERE s.ID = si.saleID AND si.productID = p.ID AND s.clientID=m.ID 
AND LOCATE('Brossard', m.address) <> 0 AND MONTH(s.sale_date) = 6
AND YEAR(s.sale_date) = 2023
ORDER BY s.ID ASC, m.first_name ASC, m.last_name ASC, weight ASC;

/* d */

SELECT s.ID, s.sale_date, p.product_description, 
p.price, p.weight 
FROM sales s, products p, salesitems si
WHERE s.ID = si.saleID AND si.productID = p.ID 
AND s.amount = 0 AND MONTH(s.sale_date) = 6 AND YEAR(s.sale_date) = 2023
GROUP BY s.ID ASC, p.price ASC;


/* e */

SELECT m.first_name, m.last_name,
MIN(s.sale_date), MAX(s.sale_date),
COUNT(s.ID)
FROM members m, sales s
WHERE m.ID = s.clientID AND m.start_date <= s.sale_date 
GROUP BY m.ID 
HAVING MAX(s.amount)>=1000;