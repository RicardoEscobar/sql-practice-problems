-- 20. Categories and the total products in each category
SELECT CategoryName, COUNT(CategoryName) AS TotalProducts
FROM Products
JOIN Categories on Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName
ORDER BY TotalProducts DESC

-- 21. Total customers per country/city
SELECT Country, City, COUNT(City) AS TotalCustomers
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomers DESC

-- 22. Products that need reordering
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ProductID;