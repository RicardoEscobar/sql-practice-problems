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

-- 23. Products that need reordering, continued
SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
  AND Discontinued = 0
ORDER BY ProductID;

-- 24. Customer list by region
SELECT
       CustomerID,
       CompanyName,
       Region,
       CASE WHEN Region IS NULL THEN 1 ELSE 0 END AS isNull
FROM Customers
ORDER BY isNull, Region