-- Q10 Department Performance
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    dp.DepartmentID,
    dp.DepartmentName,
    dp.DepartmentType,
    COUNT(*) AS TotalVisits,
    SUM(
        CASE WHEN v.VisitStatus = 'Completed'
             THEN 1 ELSE 0 END
    ) AS CompletedVisits,
    SUM(v.TreatmentCost) AS TotalTreatmentCost,
    AVG(v.TreatmentCost) AS AvgTreatmentCost,
    CAST(
        100.0 *
        SUM(
            CASE WHEN v.VisitStatus = 'Completed'
                 THEN 1 ELSE 0 END
        )
        / NULLIF(COUNT(*),0)
        AS DECIMAL(10,2)
    ) AS CompletionRatePct
FROM dbo.FactHealthcareVisits v
JOIN dbo.DimDepartment dp
    ON v.DepartmentID = dp.DepartmentID
GROUP BY
    dp.DepartmentID,
    dp.DepartmentName,
    dp.DepartmentType;
GO
