
--Activity 1--
--Part 1--
create database SuperbMart2_DB;

use SuperbMart2_DB;

--Part 2--
CREATE TABLE Customers 
(CustomerID INT PRIMARY KEY IDENTITY(1,1) NOT NULL, FirstName VARCHAR(MAX) NOT NULL,
LastName VARCHAR(MAX) NOT NULL,
City VARCHAR(15) NOT NULL,
Phone VARCHAR(10) NULL, Email VARCHAR(MAX) NOT NULL);

CREATE TABLE Orders 
(OrderID INT PRIMARY KEY IDENTITY(100,1)  NOT NULL,
CustomerID INT NOT NULL, 
OrderDate DATE NOT NULL,
StatusCode CHAR(1) NOT NULL, 
Total_Amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

--Extra--
SELECT * FROM Customers;
SELECT * FROM Orders;

DROP TABLE Customers;
DROP TABLE Orders;

--Activity 2--

INSERT INTO Customers 
VALUES
('Mary',	'Jones',			'Joburg',		'0870980987',	'maryjones13456@gmail.com'),
('James',	'Borous',			'Durban',		NULL ,			'james45y7borous.co.za'),
('Harold',	'Carols',			'Shenghai',		'0870980768',	'haroldcarols67@gmail.com'),
('Snow',	'Jackson',			'Polokwane',	NULL  ,			'meatslayer778@gmail.com'),
('Sou',		'Waters',			'Cape Town',	'0896745231',	'theblueygurl77@gmail.com'),
('Jack',	'Van de Tray',		'Pretoria',		'0987654321',	'miricalemakertt7@gmail.com'),
('Nora',	'Iggy',				'Madrid'	,	'0986533238',	'noraiggyzz780@gmail.com');

INSERT INTO Orders  VALUES
(1,	'2026-12-01','P', 50.99),
(2,	'2026-12-11','D',90.99),
(3,	'2026-10-13','C',30.99),
(4,	'2026-06-05','C',16.99),
(5,	'2026-06-10','C',83.99),
(6,	'2026-07-11','P',92.99),
(7,	'2026-12-17','P',43.99),
(8,	'2026-04-02','D',89.99),
(9,	'2026-05-18','D',24.99),
(10,'2026-03-31','D',89.99);

---Activity 3---
SELECT 
	CustomerID,
CONCAT(FirstName ,' ' , LastName) AS 'Customers Name',
	City, 
COALESCE(Phone, 'No Phone Number') AS ContactDetails  
FROM Customers;


---Activity 4---
--PART 1--
SELECT FirstName + ' ' + LastName AS CustomersName, Email, City from Customers
WHERE City IN ('Joburg','Pretoria') ;

---Part 2---
SELECT OrderID, CustomerID, OrderDate, StatusCode AS 'Status',
Total_Amount 
FROM Orders
WHERE OrderDate 
BETWEEN '1 January 2026' AND '31 March 2026';

--Activity 5--
SELECT 
	(FirstName + LastName ) AS CustomerName,
	c.OrderID,
	c.OrderDate,
	c.Total_Amount
FROM  Customers AS s
INNER JOIN Orders AS c
ON s.CustomerID = c.CustomerID;

--Part 2--
SELECT 
	(FirstName + LastName ) AS CustomerName,
	c.OrderID,
	c.OrderDate,
	c.Total_Amount
FROM  Customers AS s
LEFT JOIN Orders AS c
ON s.CustomerID = c.CustomerID;

--Part 3-- 
SELECT 
	(FirstName + LastName ) AS CustomerName,
	c.OrderID,
	c.OrderDate,
	c.Total_Amount
FROM  Customers AS s
RIGHT JOIN Orders AS c
ON s.CustomerID = c.CustomerID;

--Part 4--
SELECT 
	(FirstName + LastName ) AS CustomerName,
	c.OrderID,
	c.OrderDate,
	c.Total_Amount
FROM  Customers AS s
FULL OUTER JOIN Orders AS c
ON s.CustomerID = c.CustomerID;

--Activity 6--
--Part 1--
SELECT 
	UPPER(FirstName + LastName ) AS [CustomerName],
	City,
	LEN(FirstName) AS [Lenghth of FirstName]
FROM Customers
ORDER BY FirstName ASC;

--Part 2--
SELECT 
	City,
	COUNT(*) AS [Total Customers]
FROM Customers
GROUP BY City
ORDER BY [Total Customers] DESC;

--Part 3--
SELECT 
	COUNT(*) AS [Total Number of Orders],
	AVG(Total_Amount) AS [Avg Amount],
	MAX(Total_Amount) AS [Highest Amount],
	MIN(Total_Amount) AS [Lowest Amount]
FROM Orders;

--Part 4--
SELECT 
	OrderID,
	OrderDate,
	YEAR(OrderDate) AS [Year of Order],
	MONTH(OrderDate) AS [Month of Order],
	DATEDIFF(DAY,OrderDate,GETDATE()) AS [Days Since Order]
FROM Orders
ORDER BY Total_Amount DESC;

--Activity 7--
--SubQuery 1: Section A (Using IN)--
SELECT
	CustomerID,
	(FirstName +' ' + LastName ) AS [Customer Name],
	City
FROM Customers
WHERE CustomerID IN
(
	SELECT CustomerID
	FROM Orders
);

--Section A (Using EXISTS)--
SELECT 
	s.CustomerID,
	(FirstName + ' ' + LastName ) AS [Customer Name],
	s.City
FROM Customers s
WHERE EXISTS
(	
	SELECT 1
	FROM Orders c
	WHERE c.CustomerID = s.CustomerID
);

--Section B (View and CTE)--
CREATE VIEW CustomerOrders
AS
SELECT 
	(FirstName + ' ' + LastName) AS [Customer Name],
	o.OrderDate,
	o.Total_Amount
FROM Customers c
INNER JOIN Orders o
	ON c.CustomerID = O.CustomerID;
GO

--To Test the view:--

SELECT *
FROM CustomerOrders;

--To Delete the view;
DROP VIEW CustomerOrders;

--CTE--
WITH CustomerOrdersCount AS
(
SELECT 
	CustomerID,
	COUNT(*) AS [NumberofOrders]
FROM Orders
GROUP BY CustomerID
)
SELECT
	(FirstName + ' ' + LastName) AS [Customer Name],
	COALESCE(coc.NumberofOrders,0) AS [Number of Orders]
FROM Customers c
LEFT JOIN CustomerOrdersCount coc
	ON c.CustomerID = coc.CustomerID;

--Section C--
CREATE PROCEDURE GetCustomerOrders
	@CustomerID INT
	
	AS
	BEGIN
		SELECT
			OrderID,
			OrderDate,
		CASE StatusCode
			WHEN 'P' THEN 'Pending'
			WHEN 'D' THEN 'Delivering'
			WHEN 'C' THEN 'Cancelling'
		END AS [Order Status],
				Total_Amount
		FROM Orders
		WHERE CustomerID = @CustomerID;
		END;
		GO

--Code to execute the procedure--
EXEC GetCustomerOrders @CustomerID =1;