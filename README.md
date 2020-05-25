# SQL_Project

> This SQL Project was used to strengthen what had been taught and learnt during the second week of Sparta training course.
>
>All answers are produced through the used of data in the **Northwind** database.
## Exercise 1
### 1.1 Write a query that lists all Customers in either Paris or London. Include Customer ID, Company Name and all address fields.
```
USE Northwind 

SELECT c.CustomerID, c.CompanyName, c.Address 
FROM Customers c
WHERE c.City IN ('Paris', 'London') --shorthand for OR operator
```
### 1.2 List all products stored in bottles.
```
SELECT * FROM Products p

SELECT p.ProductName 
FROM Products p
WHERE p.QuantityPerUnit LIKE '%bottle%' --wildcard % means zero or more random characters
```
### 1.3 Repeat question above, but add in the Supplier Name and Country.
```
SELECT * FROM Suppliers s

SELECT p.ProductName, s.CompanyName, s.Country 
FROM Products p INNER JOIN Suppliers s ON p.SupplierID=s.SupplierID --INNER JOIN combines tables when both values match 
WHERE p.QuantityPerUnit LIKE '%bottle%'
```
### 1.4 Write an SQL Statement that shows how many products there are in each category. Include Category Name in result set and list the highest number first.
```
SELECT * FROM Products

SELECT p.CategoryID, COUNT(p.ProductID) AS "Number of Products" --aliasing requires double quotes
FROM Products p
GROUP BY p.CategoryID --group the sum of quantity to the matched category
ORDER BY COUNT(p.ProductID) DESC --reverse order; default is ASC; here the most quantity is at top
```
### 1.5 List all UK employees using concatenation to join their title of courtesy, first name and last name together. Also include their city of residence.
```
SELECT CONCAT(e.TitleOfCourtesy,' ',e.FirstName,' ',e.LastName), e.City --concatenting strings together
FROM Employees e
WHERE e.Country='UK'
```
### 1.6 List Sales Totals for all Sales Regions (via the Territories table using 4 joins) with a Sales Total greater than 1,000,000. Use rounding or FORMAT to present the numbers. 
```
SELECT * FROM [Sales Totals by Amount]
SELECT * FROM Region
SELECT * FROM Territories
SELECT * FROM EmployeeTerritories
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT r.RegionID, ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), -1) AS "Sales Totals for all Sales Regions"
FROM [Order Details] od 
INNER JOIN Orders o ON od.OrderID=o.OrderID 
INNER JOIN EmployeeTerritories et ON o.EmployeeID=et.EmployeeID 
INNER JOIN Territories t ON et.TerritoryID=t.TerritoryID 
INNER JOIN Region r ON t.RegionID=r.RegionID
GROUP BY r.RegionID
HAVING SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>1000000 --filter the data when using a aggregate function such as SUM()

/*
ANOTHER WAY TO SHOWCASE TOTAL SALES IS AS BELOW (SHOWS DOLLARS)
FORMAT(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 'c')
*/
```
### 1.7 Count how many Orders have a Freight amount greater than 100.00 and either USA or UK as Ship Country.
```
SELECT * FROM Orders

SELECT COUNT(Freight) AS "Freight"
FROM Orders o
WHERE o.ShipCountry IN ('USA','UK') AND o.Freight>100
```
### 1.8 Write an SQL Statement to identify the Order Number of the Order with the highest amount of discount applied to that order.
```
SELECT * FROM Orders
SELECT * FROM [Order Details]

SELECT TOP 1 od.OrderID, SUM(od.UnitPrice*od.Quantity*od.Discount) AS "Discount Amount" --sum of all the discounts given
FROM [Order Details] od
GROUP BY od.OrderID
ORDER BY SUM(od.UnitPrice*od.Quantity*od.Discount) DESC
```
___
## Exercise 2
### 2.1 Write the correct SQL statement to create the following table: Spartans Table – include details about all the Spartans on this course. Separate Title, First Name and Last Name into separate columns, and include University attended, course taken and mark achieved. Add any other columns you feel would be appropriate. 
```
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
```
### 2.2 Write SQL statements to add the details of the Spartans in your course to the table you have created.
```
--Inserting values into the 'spartans' table. The values is in sequence with the its repective columns 
INSERT INTO spartans
VALUES (
    'Mr','Joe','Johnson','Sheffield','Art History','1st'
)

SELECT * FROM spartans
```
___
## Exercise 3
### 3.1 List all Employees from the Employees table and who they report to. No Excel required. (5 Marks)
```
SELECT * FROM Employees

SELECT e.TitleOfCourtesy+' '+e.FirstName+' '+e.LastName AS "Employee Name", ee.TitleOfCourtesy+' '+ee.FirstName+' '+ee.LastName AS "Reports To", e.ReportsTo
FROM Employees e LEFT JOIN Employees ee ON e.ReportsTo = ee.EmployeeID
```
### 3.2 List all Suppliers with total sales over $10,000 in the Order Details table. Include the Company Name from the Suppliers Table and present as a bar chart as below: (5 Marks)
```
SELECT s.CompanyName, SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) AS "Total Sales"
FROM Suppliers s INNER JOIN Products p 
ON s.SupplierID=p.SupplierID INNER JOIN [Order Details] od 
ON p.ProductID=od.ProductID
GROUP BY s.CompanyName
HAVING SUM(od.Quantity*od.UnitPrice*(1-od.Discount))>10000
ORDER BY SUM(od.Quantity*od.UnitPrice) DESC
```
![astbm](https://i.imgur.com/XH22e4O.png?4)
### 3.3 List the Top 10 Customers YTD for the latest year in the Orders file. Based on total value of orders shipped. No Excel required. (10 Marks)
```
SELECT * FROM Customers
SELECT * FROM [Orders]
SELECT * FROM [Order Details]

SELECT TOP 10 o.CustomerID, ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)),0) AS "Total Value of Orders Shipped", DATEPART(yy,o.ShippedDate) AS "Year"--YEAR(o.ShippedDate) AS "Year"
FROM Orders o INNER JOIN [Order Details] od 
ON o.OrderID=od.OrderID
WHERE DATEPART(yy,o.ShippedDate)=(SELECT MAX(DATEPART(yy,o.ShippedDate)) FROM Orders o) 
GROUP BY o.CustomerID, DATEPART(yy,o.ShippedDate)--, YEAR(o.ShippedDate)
ORDER BY /*Year(o.ShippedDate) DESC,*/ SUM(od.Quantity*od.UnitPrice*(1-od.Discount)) DESC

/*
SELECT TOP 10 c.CustomerID AS "Customer ID", c.CompanyName As "Company", FORMAT(SUM(UnitPrice * Quantity * (1-Discount)),'C') AS "YTD Sales"
FROM Customers c INNER JOIN Orders o ON o.CustomerID=c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
WHERE YEAR(o.ShippedDate)=(SELECT MAX(YEAR(ShippedDate)) 
                           From Orders)
GROUP BY c.CustomerID, c.CompanyName
ORDER BY SUM(UnitPrice * Quantity * (1-Discount)) DESC
*/
```
### 3.4 Plot the Average Ship Time by month for all data in the Orders Table using a line chart as below. (10 Marks)
```
SELECT * FROM Orders

SELECT CONCAT(MONTH(o.ShippedDate),'-',YEAR(o.ShippedDate)) AS "Month", AVG(DATEDIFF(dd,o.OrderDate,o.ShippedDate)) AS "Average Day"
FROM Orders o
GROUP BY YEAR(o.ShippedDate), MONTH(o.ShippedDate) 
ORDER BY YEAR(o.ShippedDate), MONTH(o.ShippedDate)

/*
3.4 other method
SELECT DATEPART(yy,o.OrderDate) AS "Year", DATENAME(MM,o.orderDate) AS "Month", AVG(DATEDIFF(dd,o.OrderDate,o.ShippedDate)) AS "Day"
FROM Orders o
--Date returns a specified part of a date in this case Months.
GROUP BY DATEPART(yy,o.OrderDate), DATEPART(MM,o.OrderDate), DATENAME(MM,o.orderDate)
ORDER BY DATEPART(yy,o.OrderDate), DATEPART(MM,o.OrderDate)
*/
```
![ts](https://i.imgur.com/gBqeAHk.png?2)
