-- Q15 Customer Acquisition
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

WITH AcquisitionTouch AS
(
    SELECT
        m.CustomerID,
        m.ChannelID,
        m.CampaignID,
        d.FullDate AS TouchDate,
        ROW_NUMBER() OVER
        (
            PARTITION BY m.CustomerID
            ORDER BY d.FullDate DESC, m.MarketingID DESC
        ) AS rn
    FROM dbo.FactMarketing m
    JOIN dbo.DimDate d
        ON m.DateID = d.DateID
    JOIN dbo.DimCustomer c
        ON m.CustomerID = c.CustomerID
    WHERE d.FullDate <= c.SignupDate
      AND d.FullDate >= DATEADD(DAY,-30,c.SignupDate)
),
Acquisition AS
(
    SELECT
        c.CustomerID,
        c.SignupDate,
        CASE
            WHEN a.CustomerID IS NULL
                THEN 'Organic'
            ELSE ch.ChannelName
        END AS AcquisitionChannel,
        CASE
            WHEN a.CustomerID IS NULL
                THEN NULL
            ELSE cp.CampaignName
        END AS AcquisitionCampaign
    FROM dbo.DimCustomer c
    LEFT JOIN AcquisitionTouch a
        ON c.CustomerID = a.CustomerID
       AND a.rn = 1
    LEFT JOIN dbo.DimChannel ch
        ON a.ChannelID = ch.ChannelID
    LEFT JOIN dbo.DimCampaign cp
        ON a.CampaignID = cp.CampaignID
)
SELECT
    AcquisitionChannel,
    YEAR(SignupDate) AS SignupYear,
    MONTH(SignupDate) AS SignupMonth,
    COUNT(*) AS AcquiredCustomers
FROM Acquisition
GROUP BY
    AcquisitionChannel,
    YEAR(SignupDate),
    MONTH(SignupDate);
GO
