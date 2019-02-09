USE Northwind_SPP;
GO

-- 1. Which shippers do we have?
SELECT * FROM Shippers;

-- 2. Certain fields from categories
SELECT CategoryName, Description FROM Categories;

-- 3. Sales representatives
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales representative';

-- 4. Sales representatives in the United States
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales representative'
      AND Country = 'USA';

-- 5. Orders placed by specified EmployeeID
SELECT * FROM Orders WHERE EmployeeID = 5;

-- 6. Suppliers and ContactTitles
SELECT SupplierID, ContactName, ContactTitle
FROM Suppliers
WHERE ContactTitle <> 'Marketing Manager';

-- 7. Products with "queso" in ProductName
SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%queso%';

-- 8.