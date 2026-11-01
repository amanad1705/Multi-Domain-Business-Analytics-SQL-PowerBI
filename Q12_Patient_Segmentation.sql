-- Q12 Patient Segmentation
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

WITH PatientVisits AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.Gender,
        c.Region,
        COUNT(v.VisitID) AS VisitFrequency,
        SUM(v.TreatmentCost) AS TotalTreatmentCost,
        AVG(
            CAST(v.PatientAge AS DECIMAL(10,2))
        ) AS AvgPatientAge
    FROM dbo.DimCustomer c
    JOIN dbo.FactHealthcareVisits v
        ON c.CustomerID = v.CustomerID
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        c.Gender,
        c.Region
)
SELECT
    CustomerID,
    CustomerName,
    Gender,
    Region,
    AvgPatientAge,
    VisitFrequency,
    TotalTreatmentCost,
    CASE
        WHEN VisitFrequency >= 5
            THEN 'Frequent Patient'
        WHEN VisitFrequency >= 3
            THEN 'Regular Patient'
        WHEN VisitFrequency = 2
            THEN 'Occasional Patient'
        ELSE 'Single Visit'
    END AS PatientSegment
FROM PatientVisits;
GO
