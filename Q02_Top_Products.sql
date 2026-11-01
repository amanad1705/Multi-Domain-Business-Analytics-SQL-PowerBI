-- Q02 Top Products
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT TOP 10
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SubCategory,
    SUM(f.Quantity) AS UnitsSold,
    SUM(f.SalesAmount) AS Revenue,
    SUM(f.ProfitAmount) AS Profit,
    CAST(
        100.0 * SUM(f.ProfitAmount)
        / NULLIF(SUM(f.SalesAmount),0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPct
FROM dbo.FactSales f
JOIN dbo.DimProduct p
    ON f.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SubCategory
ORDER BY Revenue DESC;
GO
