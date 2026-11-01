-- Q11 Visit Status
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    dp.DepartmentName,
    v.VisitType,
    v.VisitStatus,
    COUNT(*) AS VisitCount,
    SUM(v.TreatmentCost) AS TreatmentCost
FROM dbo.FactHealthcareVisits v
JOIN dbo.DimDepartment dp
    ON v.DepartmentID = dp.DepartmentID
GROUP BY
    dp.DepartmentName,
    v.VisitType,
    v.VisitStatus;
GO
