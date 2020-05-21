--1.1
USE Northwind

SELECT * FROM Customers c
WHERE c.City IN ('Paris', 'London')

--1.2

SELECT * FROM Products p
SELECT p.ProductName FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottle%'

--1.3

SELECT * FROM Suppliers s

SELECT p.ProductName, s.CompanyName, s.Country 
FROM Products p LEFT JOIN Suppliers s ON p.SupplierID=s.SupplierID
WHERE p.QuantityPerUnit LIKE '%bottle%'

--1.4

SELECT * FROM Products

SELECT p.CategoryID, SUM(od.Quantity)
AS "Number of Products"
FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
GROUP BY p.CategoryID
ORDER BY SUM(od.Quantity) DESC

--1.5

SELECT CONCAT(e.TitleOfCourtesy,' ',e.FirstName,' ',e.LastName), e.City
FROM Employees e
WHERE e.Country='UK'

--1.6

SELECT * FROM [Sales Totals by Amount]
SELECT * FROM Region
SELECT * FROM Territories
SELECT * FROM EmployeeTerritories
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT r.RegionDescription, /*od.OrderID, od.ProductID,*/ ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), -1) AS "Sales Totals for all Sales Regions"
FROM [Order Details] od 
INNER JOIN Orders o ON od.OrderID=o.OrderID 
INNER JOIN EmployeeTerritories et ON o.EmployeeID=et.EmployeeID 
INNER JOIN Territories t ON et.TerritoryID=t.TerritoryID 
INNER JOIN Region r ON t.RegionID=r.RegionID
GROUP BY r.RegionDescription--, od.OrderID, od.ProductID
HAVING SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>1000000

--1.7

SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT o.ShipCountry AS "Ship Country", COUNT(od.Quantity) AS "Number of Orders"
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
WHERE o.ShipCountry IN ('USA','UK') AND o.Freight>100
GROUP BY o.ShipCountry

--1.8

SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT o.OrderID, MAX(od.Discount) AS "Max Discount"
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY o.OrderID 
ORDER BY MAX(od.Discount) DESC



----
--EX2
--2.1
DROP TABLE spartans

--Creating a table with column titles listed within the brackets
CREATE TABLE spartans (
    Title VARCHAR(10),
    First_Name VARCHAR(30),
    Last_Name VARCHAR(30),
    University VARCHAR(30),
    Course VARCHAR(30),
    Mark VARCHAR(30)
)

--2.2

--Inserting values into the 'spartans' table. The values is in sequence with the its repective columns 
INSERT INTO spartans
VALUES (
    'Mr','Joe','Johnson','Sheffield','Art History','1st'
)

SELECT * FROM spartans


----
--EX3
--3.1

SELECT * FROM Employees

SELECT e.EmployeeID, e.ReportsTo
FROM Employees e 

--3.2

SELECT s.CompanyName, SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) AS "Total Sales"
FROM Suppliers s INNER JOIN Products p 
ON s.SupplierID=p.SupplierID INNER JOIN [Order Details] od 
ON p.ProductID=od.ProductID
GROUP BY s.CompanyName
HAVING SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>10000
ORDER BY SUM(od.Quantity*od.UnitPrice) DESC

--3.3

SELECT * FROM [Order Details]
SELECT * FROM Customers
SELECT * FROM [Orders]

SELECT TOP 10 c.CustomerID, (od.Quantity*od.UnitPrice) AS "Total Value of Orders Shipped", od.OrderID
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID=o.CustomerID INNER JOIN [Order Details] od 
ON o.OrderID=od.OrderID 
GROUP BY od.OrderID
ORDER BY "Total Value of Orders Shipped"

DATEDIFF(dd,'01-01-1998',o.ShippedDate)
--3.4
SELECT * FROM Orders

SELECT DATEPART(MM, o.ShippedDate) AS "Month", AVG(DATEDIFF(dd,o.ShippedDate,o.RequiredDate)) AS "Average Day"
FROM Orders o
GROUP BY DATEPART(MM, o.ShippedDate)
ORDER BY DATEPART(MM, o.ShippedDate)







