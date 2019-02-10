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

-- 25. High freight charges
SELECT TOP(3) ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- 26. High freight charges - 2015
SELECT TOP(3) ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE YEAR(OrderDate) = 2015
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

-- 27. High freight charges with between
Select Top 3 ShipCountry, AverageFreight = avg(freight)
From Orders
Where OrderDate between '20150101' and '20160101'
Group By ShipCountry
ORDER BY AverageFreight

-- 28. High freight charges with between - last year
DECLARE @END_DATE AS DATETIME = (SELECT MAX(OrderDate) FROM Orders);
DECLARE @START_DATE AS DATETIME = (Select Dateadd(yy, -1, @END_DATE));

SELECT TOP(3) ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate BETWEEN @START_DATE AND @END_DATE
GROUP BY ShipCountry
ORDER BY AverageFreight DESC