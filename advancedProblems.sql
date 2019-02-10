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

-- 34. High-value customers with discount
SELECT
  C.CustomerID,
  C.CompanyName,
  TotalsWithoutDiscount = SUM(OD.UnitPrice * OD.Quantity),
  TotalsWithDiscount =
    SUM((OD.UnitPrice * OD.Quantity) - ((OD.UnitPrice * OD.Quantity) * OD.Discount))-- 0.15 = 15% discount
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE
  OrderDate BETWEEN '20160101' AND '20170101'
GROUP BY
  C.CompanyName,
  C.CustomerID
HAVING SUM(OD.UnitPrice * OD.Quantity) >= 15000
ORDER BY TotalsWithDiscount DESC

-- 35. Month-end orders
SELECT EmployeeID, OrderID, OrderDate
FROM Orders
WHERE CONVERT(DATE,OrderDate) = EOMONTH ( OrderDate )
ORDER BY EmployeeID, OrderID

-- 36. Orders with many line items
SELECT TOP(10) OrderID, COUNT(*) AS TotalOrderDetails
FROM OrderDetails
GROUP BY OrderID
ORDER BY TotalOrderDetails DESC