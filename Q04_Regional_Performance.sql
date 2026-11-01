-- Q04 Regional Performance
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    c.Region,
    COUNT(DISTINCT f.CustomerID) AS ActiveCustomers,
    COUNT(DISTINCT f.SaleID) AS Orders,
    SUM(f.Quantity) AS UnitsSold,
    SUM(f.SalesAmount) AS Revenue,
    SUM(f.ProfitAmount) AS Profit,
    CAST(
        100.0 * SUM(f.ProfitAmount)
        / NULLIF(SUM(f.SalesAmount),0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPct
FROM dbo.FactSales f
JOIN dbo.DimCustomer c
    ON f.CustomerID = c.CustomerID
GROUP BY c.Region;
GO
