-- 20. Categories and the total products in each category
SELECT CategoryName, COUNT(CategoryName) AS TotalProducts
FROM Products
JOIN Categories on Products.CategoryID = Categories.CategoryID
GROUP BY CategoryName
ORDER BY TotalProducts DESC