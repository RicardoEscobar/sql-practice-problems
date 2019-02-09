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

-- 8. Orders shipping to France or Belgium
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('France', 'Belgium');

-- 9. Orders shipping to any country in Latin America
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela');

-- 10. Employees in order of age
SELECT FirstName, LastName, Title, BirthDate
FROM Employees
ORDER BY BirthDate;

-- 11. Showing only the date with a dateTime field
SELECT FirstName, LastName, Title, CONVERT(DATE, BirthDate)
FROM Employees
ORDER BY BirthDate;

-- 12. Employees full name
SELECT FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;

-- 13. OrderDetails amount per line item
SELECT OrderID, ProductID, UnitPrice, Quantity, UnitPrice * Quantity AS TotalPrice
FROM OrderDetails
ORDER BY OrderID, ProductID;

-- 14. How many customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 15. When was the first order?
SELECT MIN(OrderDate) AS FirstOrder FROM Orders;

-- 16. Countries where there are customers
SELECT Country FROM Customers
GROUP BY Country;

-- 17. Contact titles for customers
SELECT ContactTitle, COUNT(ContactTitle) AS TotalContactTitle
FROM Customers
GROUP BY ContactTitle;

-- 18. Products with associated supplier names
SELECT ProductID, ProductName, CompanyName
FROM Products
JOIN Suppliers on Products.SupplierID = Suppliers.SupplierID;