-- Q05 Loan Approval
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

SELECT
    LoanType,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN LoanStatus = 'Approved' THEN 1 ELSE 0 END)
        AS ApprovedLoans,
    SUM(CASE WHEN LoanStatus = 'Rejected' THEN 1 ELSE 0 END)
        AS RejectedLoans,
    CAST(
        100.0 *
        SUM(CASE WHEN LoanStatus = 'Approved' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*),0)
        AS DECIMAL(10,2)
    ) AS ApprovalRatePct,
    SUM(
        CASE WHEN LoanStatus = 'Approved'
             THEN LoanAmount ELSE 0 END
    ) AS ApprovedLoanValue,
    AVG(
        CASE WHEN LoanStatus = 'Approved'
             THEN LoanAmount END
    ) AS AvgApprovedLoanAmount
FROM dbo.FactLoans
GROUP BY LoanType;
GO
