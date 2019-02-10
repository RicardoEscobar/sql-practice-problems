-- 32. High-value customers
SELECT
  C.CustomerID,
  C.CompanyName,
  O.OrderID,
  TotalOrderAmount = SUM(OD.UnitPrice * OD.Quantity)
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE
  OrderDate BETWEEN '20160101' AND '20170101'
GROUP BY
  C.CompanyName,
  O.OrderID,
  C.CustomerID,
  OD.UnitPrice,
  OD.Quantity
HAVING SUM(OD.UnitPrice * OD.Quantity) >= 10000

-- 33. High-value customers - total orders
SELECT
  C.CustomerID,
  C.CompanyName,
--  O.OrderID,
  TotalOrderAmount = SUM(OD.UnitPrice * OD.Quantity)
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE
  OrderDate BETWEEN '20160101' AND '20170101'
GROUP BY
  C.CompanyName,
--  O.OrderID,
  C.CustomerID
--  OD.UnitPrice,
--  OD.Quantity
HAVING SUM(OD.UnitPrice * OD.Quantity) >= 15000
ORDER BY TotalOrderAmount DESC