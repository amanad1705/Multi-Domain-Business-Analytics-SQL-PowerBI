-- Q07 Transaction Analysis
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    t.TransactionType,
    t.TransactionStatus,
    COUNT(*) AS TransactionCount,
    SUM(t.Amount) AS TransactionValue,
    AVG(t.Amount) AS AvgTransactionValue
FROM dbo.FactTransactions t
JOIN dbo.DimDate d
    ON t.DateID = d.DateID
GROUP BY
    d.Year,
    d.Month,
    d.MonthName,
    t.TransactionType,
    t.TransactionStatus;
GO
