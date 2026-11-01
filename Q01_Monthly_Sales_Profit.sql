-- Q01 Monthly Sales Profit
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.CostAmount) AS TotalCost,
    SUM(f.ProfitAmount) AS TotalProfit,
    CAST(
        100.0 * SUM(f.ProfitAmount)
        / NULLIF(SUM(f.SalesAmount), 0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPct
FROM dbo.FactSales f
JOIN dbo.DimDate d
    ON f.DateID = d.DateID
GROUP BY
    d.Year,
    d.Month,
    d.MonthName;
GO
