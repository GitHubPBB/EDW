USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_PaymentCountLast6Months]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_PaymentCountLast6Months]
AS
     WITH PaymentMonth
          AS (SELECT AccountCode, 
                     InvoiceDate, 
                     InvoiceID, 
                     Payment, 
                     InvoiceBilledAmount,
                     CASE
                         WHEN invoicebilledamount - Payment = 0
                         THEN 'Paid In Full'
                         WHEN invoicebilledamount - Payment > 0
                         THEN 'Partial'
                         ELSE 'None'
                     END AS Paid
              FROM
              (
                  SELECT accountcode, 
                         FORMAT(InvoiceDate, 'yyyy-MM') InvoiceDate, 
                         InvoiceID, 
                         SUM(InvoiceAdjustment) Payment, 
                         invoicebilledamount
                  FROM pbbsql01.[OMNIA_EPBB_P_PBB_AR].[dbo].[CV_ARInvoiceAdjustmentAndTransactions_V100]
                  WHERE(AdjustmentClass = 'Payment')
                       AND InvoiceDate BETWEEN(DATEADD(month, -6, GETDATE())) AND GETDATE()
                      -- AND accountcode = 100502758
                  GROUP BY accountcode, 
                           FORMAT(InvoiceDate, 'yyyy-MM'), 
                           InvoiceID, 
                           invoicebilledamount
              ) x)
          SELECT AccountCode, 
                 SUM(PaidInvoicesLast6Months) PaidInvoicesLast6Months, 
                 SUM(PartialPaidInvoicesLast6Months) PartialPaidInvoicesLast6Months
          FROM
          (
              SELECT AccountCode,
                     CASE
                         WHEN Paid = 'Paid in Full'
                         THEN COUNT(DISTINCT InvoiceID)
                         ELSE 0
                     END AS PaidInvoicesLast6Months,
                     CASE
                         WHEN Paid = 'Partial'
                         THEN COUNT(DISTINCT InvoiceID)
                         ELSE 0
                     END AS PartialPaidInvoicesLast6Months
              FROM PaymentMonth
              GROUP BY accountcode, 
                       paid
          ) p
          GROUP BY accountcode;
GO
