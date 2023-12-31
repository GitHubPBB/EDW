USE [PBBPDW01]
GO
/****** Object:  View [rpt].[SalesOrderDisconnect_PBBView]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [rpt].[SalesOrderDisconnect_PBBView] as 

WITH FactBilled AS (
		SELECT ba.*, br.BillingYearMonth, br.BillingCycle, br.PreBillFromDate, br.PreBillThruDate
		  FROM dbo.FactBilledAccount ba
		  JOIN dbo.DimBillingRun      br on br.Dimbillingrunid = ba.dimbillingrunid
	) 
SELECT DISTINCT
       [SalesOrderId]
      ,[SalesOrderNumber]
      ,[SalesOrderName]
      ,[SalesOrderChannel]
      ,[SalesOrderSegment]
      ,[SalesOrderProvisioningDate]
      ,[SalesOrderCommitmentDate]
      ,[OrderReviewDate]
      ,[CompletionDate]
      ,[AccountActivationDate]
      ,[AccountDeactivationDate]
      ,[SalesOrderType]
      ,[OrderActivityType]
      ,[SalesOrderClassification]
      ,[DisconnectType]
      ,[DisconnectReasonCategory]
      ,[DisconnectReason]
      ,[SalesOrderStatus]
      ,[SalesOrderStatusReason]
      ,[SalesOrderFulfillmentStatus]
      ,[SalesOrderPriorityCode]
      ,[SalesOrderOwner]
      ,[AccountCode]
      ,[AccountClassCode]
      ,[AccountClass]
      ,[AccountGroupCode]
      ,[AccountGroup]
      ,[AccountType]
      ,[SalesOrderTotalMRC]
      ,[SalesOrderTotalNRC]
      ,[SalesOrderTotalTax]
      ,[SalesOrderTotalAmount]
      ,[AccountMarket]
      ,[ReportingMarket]
      ,[MarketSummary]
	  ,PrintGroup
	  ,RecurringPaymentMethod
	  ,PortalUserExists
      ,[BundleType]
	  ,Speed
      ,[Tenure]
	  ,CASE WHEN Tenure < 4               THEN '0-3 M'
	        WHEN Tenure between 4 and 6   THEN '4-6 M'
			WHEN Tenure between 7 and 12  THEN '7-12 M'
			WHEN Tenure between 13 and 24 THEN '13-24 M'
			WHEN Tenure between 25 and 36 THEN '25-36 M'
			WHEN Tenure between 37 and 48 THEN '37-48 M'
			ELSE '> 48 M'
	    END TenureRange
	  ,CASE WHEN Tenure < 4               THEN 1
	        WHEN Tenure between 4 and 6   THEN 2
			WHEN Tenure between 7 and 12  THEN 3
			WHEN Tenure between 13 and 24 THEN 4
			WHEN Tenure between 25 and 36 THEN 5
			WHEN Tenure between 37 and 48 THEN 6
			ELSE 7
	    END TenureSort	  
      ,[PaidInvoicesLast6Months]
      ,[PartialPaidInvoicesLast6Months]
      ,[NonPayCountLast6Months]
      ,[PTPCountLast6Months]
      ,[DelinquentInvoicesLast6Months]
	     , cast(fb1.TotalDue as decimal(12,2)) TotalDue, cast(fb1.PreviousBalanceAmount as decimal(12,2)) PreviousBalanceAmount, cast(fb1.InvoiceAmount as decimal(12,2)) InvoiceAmount
		 , cast(fb1.RecurringAmount as decimal(12,2)) RecurringAmount, cast(fb1.DiscountAmount as decimal(12,2)) DiscountAmount, cast(fb1.NonRecurringAmount as decimal(12,2)) NonRecurringAmount
	     , cast(fb2.TotalDue as decimal(12,2)) TotalDueMinus1, cast(fb2.PreviousBalanceAmount as decimal(12,2))  PreviousBalanceAmountMinus1, cast(fb2.InvoiceAmount as decimal(12,2))  InvoiceAmountMinus1, cast(fb2.RecurringAmount as decimal(12,2)) RecurringAmountMinus1, cast(fb2.DiscountAmount as decimal(12,2)) DiscountAmountMinus1, cast(fb2.NonRecurringAmount as decimal(12,2)) NonRecurringAmountMinus1
	     , cast(fb3.TotalDue as decimal(12,2)) TotalDueMinus2, cast(fb3.PreviousBalanceAmount as decimal(12,2))  PreviousBalanceAmountMinus2, cast(fb3.InvoiceAmount as decimal(12,2))  InvoiceAmountMinus2, cast(fb3.RecurringAmount as decimal(12,2)) RecurringAmountMinus2, cast(fb3.DiscountAmount as decimal(12,2)) DiscountAmountMinus2, cast(fb3.NonRecurringAmount as decimal(12,2)) NonRecurringAmountMinus2
	     , cast(fb4.TotalDue as decimal(12,2)) TotalDueMinus3, cast(fb4.PreviousBalanceAmount as decimal(12,2))  PreviousBalanceAmountMinus3, cast(fb4.InvoiceAmount as decimal(12,2))  InvoiceAmountMinus3, cast(fb4.RecurringAmount as decimal(12,2)) RecurringAmountMinus3, cast(fb4.DiscountAmount as decimal(12,2)) DiscountAmountMinus3, cast(fb4.NonRecurringAmount as decimal(12,2)) NonRecurringAmountMinus3
	     , cast(fb5.TotalDue as decimal(12,2)) TotalDueMinus4, cast(fb5.PreviousBalanceAmount as decimal(12,2))  PreviousBalanceAmountMinus4, cast(fb5.InvoiceAmount as decimal(12,2))  InvoiceAmountMinus4, cast(fb5.RecurringAmount as decimal(12,2)) RecurringAmountMinus4, cast(fb5.DiscountAmount as decimal(12,2)) DiscountAmountMinus4, cast(fb5.NonRecurringAmount as decimal(12,2)) NonRecurringAmountMinus4
	     , cast(fb6.TotalDue as decimal(12,2)) TotalDueMinus5, cast(fb6.PreviousBalanceAmount as decimal(12,2))  PreviousBalanceAmountMinus5, cast(fb6.InvoiceAmount as decimal(12,2))  InvoiceAmountMinus5, cast(fb6.RecurringAmount as decimal(12,2)) RecurringAmountMinus5, cast(fb6.DiscountAmount as decimal(12,2)) DiscountAmountMinus5, cast(fb6.NonRecurringAmount as decimal(12,2)) NonRecurringAmountMinus5
      ,[LocationId]
      ,[Latitude]
      ,[Longitude]
      ,[ServiceLocationStateAbbrev]
      ,[ServiceLocationCity]
      ,[ServiceLocationZip]
      ,[ServiceLocationFullAddress]
	  , Orig_InstallOrderNumber
	  , Orig_InstallOrderName
	  , Orig_InstallType
	  , Orig_InstallStatus
	  , Orig_SalesOrderProvisioningDate
	  , Orig_InstallOrderBillReviewDate
	  , Orig_InstallOrderChannel
	  , Orig_InstallOrderSegment
	  , Orig_InstallOrderOwner
	  , Orig_InstallSalesAgent
	  ,d.DimAccountId
      ,[AccountCount] 
FROM rpt.PBB_ServiceOrderDisconnects d
	  LEFT JOIN FactBilled                     fb1 on d.DimAccountId  = fb1.DimAccountId and d.OrderReviewDate between fb1.PreBillFromDate and fb1.PreBillThruDate
	  LEFT JOIN FactBilled                     fb2 on d.DimAccountId  = fb2.DimAccountId and d.OrderReviewDate between dateadd(m,1,fb2.PreBillFromDate) and dateadd(m,1,fb2.PreBillThruDate)
	  LEFT JOIN FactBilled                     fb3 on d.DimAccountId  = fb3.DimAccountId and d.OrderReviewDate between dateadd(m,2,fb3.PreBillFromDate) and dateadd(m,2,fb3.PreBillThruDate)
	  LEFT JOIN FactBilled                     fb4 on d.DimAccountId  = fb4.DimAccountId and d.OrderReviewDate between dateadd(m,3,fb4.PreBillFromDate) and dateadd(m,3,fb4.PreBillThruDate)
	  LEFT JOIN FactBilled                     fb5 on d.DimAccountId  = fb5.DimAccountId and d.OrderReviewDate between dateadd(m,4,fb5.PreBillFromDate) and dateadd(m,4,fb5.PreBillThruDate)
	  LEFT JOIN FactBilled                     fb6 on d.DimAccountId  = fb6.DimAccountId and d.OrderReviewDate between dateadd(m,5,fb6.PreBillFromDate) and dateadd(m,5,fb6.PreBillThruDate) 
;


GO
