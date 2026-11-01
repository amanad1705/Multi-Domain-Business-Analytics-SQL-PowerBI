-- Q13 Campaign Performance
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    c.CampaignID,
    c.CampaignName,
    c.CampaignType,
    c.Objective,
    SUM(m.Impressions) AS Impressions,
    SUM(m.Clicks) AS Clicks,
    SUM(m.Conversions) AS Conversions,
    SUM(m.Spend) AS Spend,
    SUM(m.Revenue) AS Revenue,
    CAST(
        100.0 * SUM(m.Clicks)
        / NULLIF(SUM(m.Impressions),0)
        AS DECIMAL(10,2)
    ) AS CTRPct,
    CAST(
        100.0 * SUM(m.Conversions)
        / NULLIF(SUM(m.Clicks),0)
        AS DECIMAL(10,2)
    ) AS ConversionRatePct,
    CAST(
        SUM(m.Revenue)
        / NULLIF(SUM(m.Spend),0)
        AS DECIMAL(10,2)
    ) AS ROAS,
    CAST(
        (SUM(m.Revenue) - SUM(m.Spend))
        / NULLIF(SUM(m.Spend),0) * 100.0
        AS DECIMAL(10,2)
    ) AS ROIPct
FROM dbo.FactMarketing m
JOIN dbo.DimCampaign c
    ON m.CampaignID = c.CampaignID
GROUP BY
    c.CampaignID,
    c.CampaignName,
    c.CampaignType,
    c.Objective;
GO
