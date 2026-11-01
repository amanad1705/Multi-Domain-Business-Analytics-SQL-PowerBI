-- Q03 Customer Segmentation
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

WITH CustomerRFM AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.Region,
        MAX(d.FullDate) AS LastPurchaseDate,
        DATEDIFF(
            DAY,
            MAX(d.FullDate),
            (SELECT MAX(FullDate) FROM dbo.DimDate)
        ) AS RecencyDays,
        COUNT(DISTINCT f.SaleID) AS Frequency,
        SUM(f.SalesAmount) AS MonetaryValue
    FROM dbo.DimCustomer c
    JOIN dbo.FactSales f
        ON c.CustomerID = f.CustomerID
    JOIN dbo.DimDate d
        ON f.DateID = d.DateID
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        c.Region
),
Scored AS
(
    SELECT *,
        NTILE(4) OVER (ORDER BY RecencyDays DESC) AS RecencyScore,
        NTILE(4) OVER (ORDER BY Frequency) AS FrequencyScore,
        NTILE(4) OVER (ORDER BY MonetaryValue) AS MonetaryScore
    FROM CustomerRFM
)
SELECT
    CustomerID,
    CustomerName,
    Region,
    RecencyDays,
    Frequency,
    MonetaryValue,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    CASE
        WHEN RecencyScore >= 3
         AND FrequencyScore >= 3
         AND MonetaryScore >= 3
            THEN 'VIP / High Value'
        WHEN MonetaryScore >= 3
         AND FrequencyScore >= 2
            THEN 'Loyal'
        WHEN RecencyScore <= 2
         AND FrequencyScore >= 2
            THEN 'At Risk'
        WHEN RecencyScore <= 2
         AND FrequencyScore <= 2
            THEN 'Lost / Inactive'
        ELSE 'Regular'
    END AS CustomerSegment
FROM Scored;
GO
