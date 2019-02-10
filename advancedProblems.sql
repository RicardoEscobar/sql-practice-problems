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

-- 37. Orders random assortment
SELECT TOP(2)PERCENT  -- GET THE 2% OF 830
  OrderID
FROM Orders
ORDER BY NEWID()

-- 38. Orders accidental double entry
SELECT OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY ORDERID, QUANTITY
HAVING COUNT(*) > 1
ORDER BY OrderID

-- 39. Orders—accidental double-entry details
;WITH DUPLICATES_CTE AS (
  SELECT OrderID
  FROM OrderDetails
  WHERE Quantity >= 60
  GROUP BY OrderID, Quantity
  HAVING COUNT(*) > 1
)
SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
FROM OrderDetails
WHERE OrderID IN (SELECT OrderID FROM DUPLICATES_CTE)
ORDER BY OrderID, Quantity

-- 40. Orders—accidental double-entry details, derived table
Select OrderDetails.OrderID, ProductID, UnitPrice, Quantity, Discount
From OrderDetails
       Join (Select DISTINCT OrderID
             From OrderDetails
             Where Quantity >= 60
             Group By OrderID, Quantity
             Having Count(*) > 1) PotentialProblemOrders on PotentialProblemOrders.OrderID = OrderDetails.OrderID
Order by OrderID, ProductID

-- 41. Late orders
SELECT OrderID, OrderDate, RequiredDate, ShippedDate
FROM Orders
WHERE ShippedDate >= RequiredDate
ORDER BY OrderID

-- 42. Late orders—which employees?
SELECT
  E.EmployeeID,
  E.LastName,
  COUNT(O.OrderID) AS LateOrders
FROM Orders AS O
JOIN Employees AS E on O.EmployeeID = E.EmployeeID
WHERE ShippedDate >= RequiredDate
GROUP BY E.EmployeeID, LastName
ORDER BY E.EmployeeID

-- 43. Late orders vs. total orders
;WITH LateOrders_CTE AS (Select EmployeeID, LateOrders = Count(*)
                        From Orders
                        Where RequiredDate <= ShippedDate
                        Group By EmployeeID
),
 TotalOrders_CTE AS (SELECT EmployeeID,
                         TotalOrders = Count(*)
                         From Orders
                         Group By EmployeeID
)
SELECT
  E.EmployeeID,
  E.LastName,
  TotalOrders_CTE.TotalOrders,
  LateOrders_CTE.LateOrders
FROM Orders AS O
JOIN Employees AS E on O.EmployeeID = E.EmployeeID
JOIN TotalOrders_CTE ON E.EmployeeID = TotalOrders_CTE.EmployeeID
JOIN LateOrders_CTE ON E.EmployeeID = LateOrders_CTE.EmployeeID
WHERE ShippedDate >= RequiredDate
GROUP BY E.EmployeeID, LastName, TotalOrders_CTE.TotalOrders, LateOrders_CTE.LateOrders
ORDER BY E.EmployeeID

-- 44. Late orders vs. total orders—missing employee
;WITH LateOrders_CTE AS (Select EmployeeID, LateOrders = Count(*)
                        From Orders
                        Where RequiredDate <= ShippedDate
                        Group By EmployeeID
),
 TotalOrders_CTE AS (SELECT EmployeeID,
                         TotalOrders = Count(*)
                         From Orders
                         Group By EmployeeID
)
SELECT
  E.EmployeeID,
  E.LastName,
  TotalOrders_CTE.TotalOrders,
  LateOrders_CTE.LateOrders
FROM Employees AS E
--JOIN Employees AS E on O.EmployeeID = E.EmployeeID
JOIN TotalOrders_CTE ON E.EmployeeID = TotalOrders_CTE.EmployeeID
LEFT JOIN LateOrders_CTE ON E.EmployeeID = LateOrders_CTE.EmployeeID
--WHERE ShippedDate >= RequiredDate
GROUP BY E.EmployeeID, LastName, TotalOrders_CTE.TotalOrders, LateOrders_CTE.LateOrders
ORDER BY E.EmployeeID

-- 45. Late orders vs. total orders—fix null
;WITH LateOrders_CTE AS (Select EmployeeID, LateOrders = Count(*)
                        From Orders
                        Where RequiredDate <= ShippedDate
                        Group By EmployeeID
),
 TotalOrders_CTE AS (SELECT EmployeeID,
                         TotalOrders = Count(*)
                         From Orders
                         Group By EmployeeID
)
SELECT
  E.EmployeeID,
  E.LastName,
  TotalOrders_CTE.TotalOrders,
  ISNULL(LateOrders_CTE.LateOrders, 0) AS LateOrders
FROM Employees AS E
--JOIN Employees AS E on O.EmployeeID = E.EmployeeID
JOIN TotalOrders_CTE ON E.EmployeeID = TotalOrders_CTE.EmployeeID
LEFT JOIN LateOrders_CTE ON E.EmployeeID = LateOrders_CTE.EmployeeID
--WHERE ShippedDate >= RequiredDate
GROUP BY E.EmployeeID, LastName, TotalOrders_CTE.TotalOrders, LateOrders_CTE.LateOrders
ORDER BY E.EmployeeID

-- 46. Late orders vs. total orders—percentage
;WITH LateOrders_CTE AS (Select EmployeeID, LateOrders = Count(*)
                        From Orders
                        Where RequiredDate <= ShippedDate
                        Group By EmployeeID
),
 TotalOrders_CTE AS (SELECT EmployeeID,
                         TotalOrders = Count(*)
                         From Orders
                         Group By EmployeeID
)
SELECT
  E.EmployeeID,
  E.LastName,
  TotalOrders_CTE.TotalOrders,
  ISNULL(LateOrders_CTE.LateOrders, 0) AS LateOrders,
  LateOrdersPercent =
    ISNULL(LateOrders_CTE.LateOrders, 0) * 1.0 / TotalOrders_CTE.TotalOrders
FROM Employees AS E
JOIN TotalOrders_CTE ON E.EmployeeID = TotalOrders_CTE.EmployeeID
LEFT JOIN LateOrders_CTE ON E.EmployeeID = LateOrders_CTE.EmployeeID
GROUP BY E.EmployeeID, LastName, TotalOrders_CTE.TotalOrders, LateOrders_CTE.LateOrders
ORDER BY E.EmployeeID

-- 47. Late orders vs. total orders—fix decimal
;WITH LateOrders_CTE AS (Select EmployeeID, LateOrders = Count(*)
                        From Orders
                        Where RequiredDate <= ShippedDate
                        Group By EmployeeID
),
 TotalOrders_CTE AS (SELECT EmployeeID,
                         TotalOrders = Count(*)
                         From Orders
                         Group By EmployeeID
)
SELECT
  E.EmployeeID,
  E.LastName,
  TotalOrders_CTE.TotalOrders,
  ISNULL(LateOrders_CTE.LateOrders, 0) AS LateOrders,
  LateOrdersPercent =CONVERT(DECIMAL(3, 2),
                           ISNULL(LateOrders_CTE.LateOrders, 0) * 1.0 / TotalOrders_CTE.TotalOrders
                       )
FROM Employees AS E
JOIN TotalOrders_CTE ON E.EmployeeID = TotalOrders_CTE.EmployeeID
LEFT JOIN LateOrders_CTE ON E.EmployeeID = LateOrders_CTE.EmployeeID
GROUP BY E.EmployeeID, LastName, TotalOrders_CTE.TotalOrders, LateOrders_CTE.LateOrders
ORDER BY E.EmployeeID