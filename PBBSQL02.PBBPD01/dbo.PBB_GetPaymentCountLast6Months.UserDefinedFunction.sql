USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetPaymentCountLast6Months]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[PBB_GetPaymentCountLast6Months](
             @AccountCode varchar(10)
			,@AsOfDate date
			)
RETURNS @AccountDetails TABLE 
(AccountCode varchar(10)
,TranDate date
,PaidInvoicesLast6Months Int
,PartialPaidInvoicesLast6Months Int
)
AS
BEGIN

     WITH PaymentMonth
          AS (SELECT AccountCode, 
					 @AsOfDate TranDate,
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
                       AND InvoiceDate BETWEEN(DATEADD(month, -6, @AsOfDate)) AND @AsOfDate                     
					   AND accountcode = @AccountCode
                  GROUP BY accountcode,  
                           FORMAT(InvoiceDate, 'yyyy-MM'), 
                           InvoiceID, 
                           invoicebilledamount
              ) x
		  )
		  INSERT INTO @AccountDetails
          SELECT AccountCode, TranDate,
                 SUM(PaidInvoicesLast6Months) PaidInvoicesLast6Months, 
                 SUM(PartialPaidInvoicesLast6Months) PartialPaidInvoicesLast6Months
          FROM
          (
              SELECT AccountCode, TranDate,
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
              GROUP BY accountcode, TranDate, 
                       paid
          ) p
          GROUP BY accountcode, TranDate



		  
    RETURN 
END;

GO
