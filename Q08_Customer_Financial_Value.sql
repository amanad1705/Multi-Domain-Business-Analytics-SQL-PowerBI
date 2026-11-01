-- Q08 Customer Financial Value
-- Standalone SELECT query (converted from the supplied VIEW definition).
USE BUSINESS_ANALYTICS_FINAL;
GO

WITH TransactionValue AS
(
    SELECT
        CustomerID,
        SUM(Amount) AS TotalTransactionValue,
        COUNT(*) AS TransactionCount
    FROM dbo.FactTransactions
    WHERE TransactionStatus = 'Completed'
    GROUP BY CustomerID
),
LoanValue AS
(
    SELECT
        CustomerID,
        SUM(
            CASE
                WHEN LoanStatus = 'Approved'
                THEN LoanAmount
                ELSE 0
            END
        ) AS ApprovedLoanValue,
        SUM(
            CASE
                WHEN LoanStatus = 'Approved'
                THEN 1
                ELSE 0
            END
        ) AS ApprovedLoanCount,
        SUM(CAST(DefaultFlag AS INT)) AS DefaultCount
    FROM dbo.FactLoans
    GROUP BY CustomerID
)
SELECT
    c.CustomerID,
    c.CustomerName,
    c.Region,
    c.IncomeBand,
    ISNULL(t.TotalTransactionValue,0) AS TotalTransactionValue,
    ISNULL(t.TransactionCount,0) AS TransactionCount,
    ISNULL(l.ApprovedLoanValue,0) AS ApprovedLoanValue,
    ISNULL(l.ApprovedLoanCount,0) AS ApprovedLoanCount,
    ISNULL(l.DefaultCount,0) AS DefaultCount,
    ISNULL(t.TotalTransactionValue,0)
        + ISNULL(l.ApprovedLoanValue,0) AS FinancialValue
FROM dbo.DimCustomer c
LEFT JOIN TransactionValue t
    ON c.CustomerID = t.CustomerID
LEFT JOIN LoanValue l
    ON c.CustomerID = l.CustomerID
WHERE t.CustomerID IS NOT NULL
   OR l.CustomerID IS NOT NULL;
GO
