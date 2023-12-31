USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetPaymentDetailPrior6Months]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[PBB_GetPaymentDetailPrior6Months](
             @AccountCode varchar(10)
			,@AsOfDate date
			)
RETURNS @AccountDetails TABLE 
(AccountCode varchar(10)
,InvoiceId int
,TranDate date
,InvoiceDate date
,InvoiceBilledAmount decimal(8,2)
,PaymentAmount decimal(8,2)
)
AS
BEGIN

     WITH PaymentMonth
          AS (SELECT AccountCode, 
                     InvoiceID, 
					 @AsOfDate TranDate,
                     InvoiceDate, 
                     InvoiceBilledAmount,
                     Payment, 
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
                         InvoiceID, 
                         InvoiceDate, 
                         MIN(invoicebilledamount) invoiceBilledAmount,
                         SUM(InvoiceAdjustment) Payment
                  FROM pbbsql01.[OMNIA_EPBB_P_PBB_AR].[dbo].[CV_ARInvoiceAdjustmentAndTransactions_V100]
                  WHERE(AdjustmentClass = 'Payment')
                       AND InvoiceDate BETWEEN(DATEADD(month, -6, @AsOfDate)) AND @AsOfDate                     
					   AND accountcode = @AccountCode
                  GROUP BY accountcode
                          ,InvoiceID
						  ,InvoiceDate
              ) x
		  )
		  INSERT INTO @AccountDetails
          SELECT AccountCode, InvoiceId, TranDate, InvoiceDate,
                 InvoiceBilledAmount,
                 SUM(Payment) PaymentAmount
		   FROM  PaymentMonth
		   GROUP BY AccountCode, InvoiceId, TranDate, InvoiceDate, InvoiceBilledAmount
		  
    RETURN 
END;

GO
