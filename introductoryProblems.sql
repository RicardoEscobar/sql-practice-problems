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

