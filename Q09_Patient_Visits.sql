-- Q09 Patient Visits
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    COUNT(*) AS TotalVisits,
    SUM(
        CASE WHEN v.VisitStatus = 'Completed'
             THEN 1 ELSE 0 END
    ) AS CompletedVisits,
    SUM(
        CASE WHEN v.VisitStatus = 'Cancelled'
             THEN 1 ELSE 0 END
    ) AS CancelledVisits,
    SUM(
        CASE WHEN v.VisitStatus = 'No Show'
             THEN 1 ELSE 0 END
    ) AS NoShowVisits,
    SUM(v.TreatmentCost) AS TotalTreatmentCost
FROM dbo.FactHealthcareVisits v
JOIN dbo.DimDate d
    ON v.DateID = d.DateID
GROUP BY
    d.Year,
    d.Month,
    d.MonthName;
GO
