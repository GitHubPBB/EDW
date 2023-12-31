USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SalesOrderDisconnect]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE   VIEW [rpt].[PBB_SalesOrderDisconnect] as 

SELECT x.* , cast(y.SortOrder as smallint) MarketSort FROM ( 
 
SELECT  
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
      ,DisconnectReasonCategory
      ,[DisconnectReason]
      ,[SalesOrderStatus]
      ,[SalesOrderStatusReason]
      ,[SalesOrderFulfillmentStatus]
      ,[SalesOrderPriorityCode]
      ,[SalesOrderOwner]
      ,d.AccountCode
      ,[AccountClassCode]
      ,[AccountClass]
      ,d.AccountGroupCode
      ,[AccountGroup]
      ,[AccountType]
	  ,WriteOffStatus
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
	  ,TenureRange
	  ,TenureSort	  
      ,[PaidInvoicesLast6Months]
      ,[PartialPaidInvoicesLast6Months]
      ,[NonPayCountLast6Months]
      ,[PTPCountLast6Months]
      ,[DelinquentInvoicesLast6Months]
	  ,TroubleTicketsLast3Months
	     , TotalDue,       PreviousBalanceAmount,       InvoiceAmount,       RecurringAmount,       DiscountAmount,       NonRecurringAmount,       PaymentAmount
	     , TotalDueMinus1, PreviousBalanceAmountMinus1, InvoiceAmountMinus1, RecurringAmountMinus1, DiscountAmountMinus1, NonRecurringAmountMinus1, PaymentAmountMinus1
	     , TotalDueMinus2, PreviousBalanceAmountMinus2, InvoiceAmountMinus2, RecurringAmountMinus2, DiscountAmountMinus2, NonRecurringAmountMinus2, PaymentAmountMinus2
	     , TotalDueMinus3, PreviousBalanceAmountMinus3, InvoiceAmountMinus3, RecurringAmountMinus3, DiscountAmountMinus3, NonRecurringAmountMinus3, PaymentAmountMinus3
	     , TotalDueMinus4, PreviousBalanceAmountMinus4, InvoiceAmountMinus4, RecurringAmountMinus4, DiscountAmountMinus4, NonRecurringAmountMinus4, PaymentAmountMinus4
	     , TotalDueMinus5, PreviousBalanceAmountMinus5, InvoiceAmountMinus5, RecurringAmountMinus5, DiscountAmountMinus5, NonRecurringAmountMinus5, PaymentAmountMinus5
      ,d.LocationId
      ,[Latitude]
      ,[Longitude]
      ,[ServiceLocationStateAbbrev]
      ,[ServiceLocationCity]
      ,[ServiceLocationZip]
      ,[ServiceLocationFullAddress]
	  ,Cabinet
	  ,LocationProjectCode
	  ,ProjectName
	  ,coalesce(calcProjectName , 'Unknown') CalcProjectName
	  ,AddressType

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
	  , LastInvYearMonth
	  , LastInvYearMonthMinus1
	  , LastInvYearMonthMinus2
	  , cast(b.BilledAmount as decimal(12,2))   LastInvoiceBilledMRC
	  ,AccountName
	  ,DimAccountId
      ,[AccountCount] 
  FROM rpt.PBB_ServiceOrderDisconnects           d
      LEFT JOIN  [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_LastBilledFullAmountByAccountAndLocation] b 
	                                               on     d.AccountCode = b.AccountCode 
												      and d.LocationId  = b.LocationId
												      and b.BillingRunId in (d.LastInvYearMonth , d.LastInvYearMonthMinus1, d.LastInvYearMonthMinus2)
													--  (d.LastInvYearMonth  = b.BillingRunId or d.LastInvYearMonthMinus1= b.BillingRunId or d.LastInvYearMonthMinus2= b.BillingRunId) 

 

UNION

 -- RES DISCO
  select concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES') SalesOrderId
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES') SalesOrderNumber
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES','-',replace(pbb_ExternalMarketName,' ','') ) SalesOrderName
       , 'CSR'            SalesOrderChannel
       , 'RES'            SalesOrderSegment
       , cast(null as date)                SalesOrderProvisioningDate
	   , cast(null as date)                SalesOrderCommitmentDate
       , cast(pbb_DimDateId as date) OrderReviewDate
       , cast(pbb_DimDateId as date) CompletionDate
       , cast(null as date)                AccountActivationDate
	   , cast(null as date)                AccountDeactivationDate
       , 'Disconnect'     SalesOrderType
       , 'Disconnect'     OrderActivityType
       , 'Disconnect'     SalesOrderClassification
	   , 'Unknown'        DisconnectType
	   , 'Unknown'        DisconnectReasonCategory
	   , 'Unknown'        DisconnectReason
       , 'Fulfilled'      SalesOrderStatus
       , 'Complete'       SalesOrderStatusReason
       , 'Completed'      SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , 'Unknown'        SalesOrderOwner
       , '000000000'      AccountCode
       , 'S'              AccountClassCode
       , 'Subscriber'     AccountClass
       , upper(concat('EXT','RES'))             AccountGroupCode
       , upper(concat('EXT',' ','Residential')) AccountGroup
       , 'Residential'    AccountType
	   , NULL WriteOffStatus
       , cast(NULL as money)      SalesOrderTotalMRC
       , cast(NULL as money)      SalesOrderTotalNRC
       , cast(NULL as money)      SalesOrderTotalTax
       , cast(NULL as money)      SalesOrderTotalAmount 
       , case when pbb_ExternalMarketName ='Clarity NY'    then 'New York' 
	          when pbb_ExternalMarketName ='AlaGa - Fixed' then 'Central AL' 
	          when pbb_ExternalMarketName ='Opelika'       then 'Central AL' 
	          when pbb_ExternalMarketName ='N AL - Fixed'  then 'North AL - Fixed' 
	          when pbb_ExternalMarketName ='N AL - FTTH'   then 'North AL - FTTH' 
	          when pbb_ExternalMarketName ='Island'        then 'South AL' 
	          else pbb_ExternalMarketName end AccountMarket
       , case when pbb_ExternalMarketName = 'Island'        then 'Island Fiber' 
	          when pbb_ExternalMarketName = 'Opelika'       then 'Opelika' 
	          when pbb_ExternalMarketName = 'AlaGa - Fixed' then 'AlaGa - Fixed' 
	          else pbb_ExternalMarketAccountGroupMarket end ReportingMarket
       , NULL             MarketSummary
	   , NULL             PrintGroup
	   , NULL             RecurringPaymentMethod
	   , NULL             PortalUserExists
       , 'Unknown'             BundleType
	   , NULL             Speed
       , cast(NULL as int)               Tenure

	   , NULL                            TenureRange
	   , cast(NULL as int)               TenureSort
       , cast(NULL as int)               PaidInvoicesLast6Months
       , cast(NULL as int)               PartialInvoicesLast6Months
       , cast(NULL as int)               NonPayCountLast6Months
	   , cast(NULL as int)               PTPCountLast6Months
	   , cast(NULL as int)               DelinquentInvoicesLast6Months
	   , cast(NULL as int)               TroubleTicketsLast3Months
	   , cast(NULL as decimal(12,2))              TotalDue
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmount
	   , cast(NULL as decimal(12,2))              InvoiceAmount
	   , cast(NULL as decimal(12,2))              RecurringAmount
	   , cast(NULL as decimal(12,2))              DiscountAmount
	   , cast(NULL as decimal(12,2))              NonRecurringAmount
	   , cast(NULL as decimal(12,2))              PaymentAmount	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus1
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus1
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus1
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus1
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus1
	   , cast(NULL as decimal(12,2))              TotalDueMinus2
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus2
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus2
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus2
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus2	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus3
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus3
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus3
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus3
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus3
	   , cast(NULL as decimal(12,2))              TotalDueMinus4
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus4
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus4
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus4
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus4
	   , cast(NULL as decimal(12,2))              TotalDueMinus5
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus5
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus5
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus5
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus5
       , 0                LocationId
       , '00.0000000'      Latitude
       , '00.0000000'      Longitude
       , case when x.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48)      then 'OH'
			  when x.pbb_DimExternalMarketId in (41)          then 'NY'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             Cabinet
	   , NULL             LocationProjectCode
	   , 'Unknown'        ProjectName
	   , 'Unknown'        CalcProjectName
	   , NULL             AddressType
	   , NULL             Orig_InstallOrderNumber
	   , NULL             Orig_InstallOrderName
	   , NULL             Orig_InstallType
	   , NULL             Orig_InstallStatus
	   , NULL             Orig_SalesOrderProvisioningDate
	   , NULL             Orig_InstallOrderBillReviewDate
	   , NULL             Orig_InstallOrderChannel
	   , NULL             Orig_InstallOrderSegment
	   , NULL             Orig_InstallOrderOwner
	   , NULL             Orig_InstallSalesAgent

	   , NULL             LastInvYearMonth
	   , NULL             LastInvYearMonthMinus1
	   , NULL             LastInvYearMonthMinus2
	   
	   , cast(NULL as decimal(12,2))                             LastInvoiceBilledMRC 
	   , NULL             AccountName
	   , NULL             DimAccountId
       , pbb_DailyStatisticsResidentialDisconnects               AccountCount    
       -- , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where pbb_DailyStatisticsResidentialDisconnects <> 0

    and cast(x.pbb_DimDateId as date) < '20221101'  -- Comment out to revert back to summary


UNION

 -- BUS DISCO
  select concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS') SalesOrderId
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS') SalesOrderNumber
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS','-',replace(pbb_ExternalMarketName,' ','') ) SalesOrderName
       , 'CSR'            SalesOrderChannel
       , 'BUS'            SalesOrderSegment
       , cast(null as date)             SalesOrderProvisioningDate
	   , cast(null as date)                SalesOrderCommitmentDate
       , cast(pbb_DimDateId as date) OrderReviewDate
       , cast(pbb_DimDateId as date) CompletionDate
       , cast(null as date)                AccountActivationDate
	   , cast(null as date)                AccountDeactivationDate
       , 'Disconnect'     SalesOrderType
       , 'Disconnect'     OrderActivityType
       , 'Disconnect'     SalesOrderClassification
	   , 'Unknown'        DisconnectType
	   , 'Unknown'        DisconnectReasonCategory
	   , 'Unknown'        DisconnectReason
       , 'Fulfilled'      SalesOrderStatus
       , 'Complete'       SalesOrderStatusReason
       , 'Completed'      SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , 'Unknown'        SalesOrderOwner
       , '000000000'      AccountCode
       , 'S'              AccountClassCode
       , 'Subscriber'     AccountClass
       , upper(concat('EXT','BUS'))             AccountGroupCode
       , upper(concat('EXT',' ','Business'))    AccountGroup
       , 'Business'       AccountType
	   , NULL WriteOffStatus
       , cast(NULL as money)              SalesOrderTotalMRC
       , cast(NULL as money)              SalesOrderTotalNRC
       , cast(NULL as money)              SalesOrderTotalTax
       , cast(NULL as money)              SalesOrderTotalAmount
       , case when pbb_ExternalMarketName ='Clarity NY'    then 'New York' 
	          when pbb_ExternalMarketName ='AlaGa - Fixed' then 'Central AL' 
	          when pbb_ExternalMarketName ='Opelika'       then 'Central AL' 
	          when pbb_ExternalMarketName ='N AL - Fixed'  then 'North AL - Fixed' 
	          when pbb_ExternalMarketName ='N AL - FTTH'   then 'North AL - FTTH' 
	          when pbb_ExternalMarketName ='Island'        then 'South AL' 
	          else pbb_ExternalMarketName end AccountMarket
       , case when pbb_ExternalMarketName = 'Island'        then 'Island Fiber' 
	          when pbb_ExternalMarketName = 'Opelika'       then 'Opelika' 
	          when pbb_ExternalMarketName = 'AlaGa - Fixed' then 'AlaGa - Fixed' 
	          else pbb_ExternalMarketAccountGroupMarket end ReportingMarket
       , NULL             MarketSummary
	   , NULL             PrintGroup
	   , NULL             RecurringPaymentMethod
	   , NULL             PortalUserExists
       , 'Unknown'             BundleType
	   , NULL             Speed
       , cast(NULL as int)                   Tenure
	   , NULL             TenureRange
	   , cast(NULL as int)               TenureSort
       , cast(NULL as int)               PaidInvoicesLast6Months
       , cast(NULL as int)               PartialInvoicesLast6Months
       , cast(NULL as int)               NonPayCountLast6Months
	   , cast(NULL as int)               PTPCountLast6Months
	   , cast(NULL as int)               DelinquentInvoicesLast6Months
	   , cast(NULL as int)             TroubleTicketsLast3Months
	   , cast(NULL as decimal(12,2))              TotalDue
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmount
	   , cast(NULL as decimal(12,2))              InvoiceAmount
	   , cast(NULL as decimal(12,2))              RecurringAmount
	   , cast(NULL as decimal(12,2))              DiscountAmount
	   , cast(NULL as decimal(12,2))              NonRecurringAmount
	   , cast(NULL as decimal(12,2))              PaymentAmount	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus1
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus1
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus1
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus1
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus1
	   , cast(NULL as decimal(12,2))              TotalDueMinus2
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus2
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus2
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus2
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus2	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus3
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus3
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus3
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus3
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus3
	   , cast(NULL as decimal(12,2))              TotalDueMinus4
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus4
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus4
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus4
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus4
	   , cast(NULL as decimal(12,2))              TotalDueMinus5
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus5
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus5
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus5
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus5
       , 0                LocationId
       , '00.0000000'       Latitude
       , '00.0000000'       Longitude
       , case when x.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48)      then 'OH'
			  when x.pbb_DimExternalMarketId in (41)          then 'NY'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             Cabinet
	   , NULL             LocationProjectCode
	   , 'Unknown'        ProjectName
	   , 'Unknown'        CalcProjectName
	   , NULL             AddressType
	   , NULL             Orig_InstallOrderNumber
	   , NULL             Orig_InstallOrderName
	   , NULL             Orig_InstallType
	   , NULL             Orig_InstallStatus
	   , NULL             Orig_SalesOrderProvisioningDate
	   , NULL             Orig_InstallOrderBillReviewDate
	   , NULL             Orig_InstallOrderChannel
	   , NULL             Orig_InstallOrderSegment
	   , NULL             Orig_InstallOrderOwner
	   , NULL             Orig_InstallSalesAgent
	   
	   , NULL             LastInvYearMonth
	   , NULL             LastInvYearMonthMinus1
	   , NULL             LastInvYearMonthMinus2
	   
	   , cast(NULL as decimal(12,2))                             LastInvoiceBilledMRC   
	   , NULL             AccountName
	   , NULL             DimAccountId

       , pbb_DailyStatisticsCommercialDisconnects               AccountCount    
       -- , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where pbb_DailyStatisticsCommercialDisconnects <> 0

   and cast(x.pbb_DimDateId as date) < '20221101'

 --  /*    uncomment to filter details
 /*  tb 2023/10/30  remove upon request from Bob H

UNION


 -- RES DISCO
  select concat('EXT-',OrderNo)			SalesOrderId
       , OrderNo            SalesOrderNumber
       , concat('EXT-',OrderNo,'-',AccountName ) SalesOrderName
       , 'CSR'              SalesOrderChannel
       , case when AccountType ='Residential' then 'RES' else 'BUS' end  SalesOrderSegment
       , cast(null as date)                SalesOrderProvisioningDate
	   , cast(null as date)                SalesOrderCommitmentDate
       , cast(OrderDate as date)           OrderReviewDate
       , cast(OrderDate as date)           CompletionDate
       , cast(x.AccountActivationDate as date)                AccountActivationDate
	   , cast(x.AccountDeactivationDate as date)              AccountDeactivationDate
       , 'Disconnect'     SalesOrderType
       , 'Disconnect'     OrderActivityType
       , 'Disconnect'     SalesOrderClassification
	   , case when x.DisconnectReason like 'Non%Pay' then 'Disconnect for Non Pay' 
	          when x.DisconnectType   like 'Non%Pay' then 'Disconnect for Non Pay'
			  when x.DisconnectType   = 'Voluntary'  then 'Voluntary Disconnect'
	          else coalesce(x.DisconnectType,'Unknown')     end     DisconnectType
	   , case when x.DisconnectReason like 'Non%Pay' then 'NonPay' 
	          when x.DisconnectType   like 'Non%Pay' then 'NonPay'
			  when x.DisconnectReason like '%moving%' then 'Moving'
			  when x.DisconnectReason like '%moved%'  then 'Moving'
			  when x.DisconnectReason like '%service%'  then 'Service'
			  when x.DisconnectReason like '%speed%'    then 'Service'
			  when x.DisconnectReason like '%outages%'  then 'Service'
			  when x.DisconnectReason like '%price%'    then 'Financial'
			  when x.DisconnectReason like 'downgrade%' then 'Downgrade'
			  when x.DisconnectReason like 'went with%' then 'Competition'
			  when x.DisconnectReason like 'went to%a%' then 'Competition'
			  when x.DisconnectReason like '%competition%' then 'Competition'
			  when x.DisconnectReason like '%tri%county%'  then 'Competition'
			  when x.DisconnectReason like 'tru%stream%'   then 'Competition'
	          else 'Unknown'                                end     DisconnectReasonCategory
	   , case when x.DisconnectReason like 'Non%Pay' then 'NonPay' 
	          when x.DisconnectType   like 'Non%Pay' then 'NonPay'
	          else coalesce(x.DisconnectReason,'Unknown')   end     DisconnectReason
       , 'Fulfilled'      SalesOrderStatus
       , 'Complete'       SalesOrderStatusReason
       , 'Completed'      SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , 'Unknown'        SalesOrderOwner
       , cast(AccountCode as nvarchar(20))     AccountCode
       , 'S'              AccountClassCode
       , 'Subscriber'     AccountClass
       , upper(concat(case when y.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
						  when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
						  when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
						  when y.pbb_DimExternalMarketId in (41)          then 'NY'
              end   
	                 ,case when x.AccountType='Residential' then 'RES' else 'BUS' end))             AccountGroupCode

       , upper(concat(case when y.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
					  when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
					  when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
					  when y.pbb_DimExternalMarketId in (41)          then 'NY'
					  end   
	                 ,' ',AccountType)) AccountGroup

       , upper(x.AccountType)     AccountType
	   , NULL WriteOffStatus
       , cast(x.GrossMRC*-1 as money) SalesOrderTotalMRC
       , cast(NULL as money)      SalesOrderTotalNRC
       , cast(NULL as money)      SalesOrderTotalTax
       , cast(NULL as money)      SalesOrderTotalAmount 
       , case when pbb_AccountMarket = 'NY'      then 'New York' 
	          else pbb_AccountMarket   end AccountMarket
       , case when pbb_ReportingMarket = 'NY'    then 'New York' 
	          else pbb_ReportingMarket end ReportingMarket
       , NULL             MarketSummary
	   , NULL             PrintGroup
	   , x.RecurringPaymentMethod        RecurringPaymentMethod
	   , x.PortalUserExists              PortalUserExists
       , x.BundleType                    BundleType
	   , x.Speed                         Speed
       , cast(NULL as int)               Tenure

	   , NULL                            TenureRange
	   , cast(NULL as int)               TenureSort
       , cast(x.PaidInvoicesLast6Months as int)              PaidInvoicesLast6Months
       , cast(x.PartialPaidInvoicesLast6Months as int)       PartialInvoicesLast6Months
       , cast(x.NonPayCountLast6Months as int)               NonPayCountLast6Months
	   , cast(x.PTPLast6Months as int)                       PTPCountLast6Months
	   , cast(x.DelinquentInvoiceCount as int)               DelinquentInvoicesLast6Months
	   , cast(NULL as int)               TroubleTicketsLast3Months
	   , cast(NULL as decimal(12,2))              TotalDue
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmount
	   , cast(NULL as decimal(12,2))              InvoiceAmount
	   , cast(NULL as decimal(12,2))              RecurringAmount
	   , cast(NULL as decimal(12,2))              DiscountAmount
	   , cast(NULL as decimal(12,2))              NonRecurringAmount
	   , cast(NULL as decimal(12,2))              PaymentAmount	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus1
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus1
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus1
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus1
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus1
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus1
	   , cast(NULL as decimal(12,2))              TotalDueMinus2
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus2
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus2
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus2
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus2
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus2	   
	   , cast(NULL as decimal(12,2))              TotalDueMinus3
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus3
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus3
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus3
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus3
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus3
	   , cast(NULL as decimal(12,2))              TotalDueMinus4
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus4
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus4
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus4
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus4
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus4
	   , cast(NULL as decimal(12,2))              TotalDueMinus5
	   , cast(NULL as decimal(12,2))              PreviousBalanceAmountMinus5
	   , cast(NULL as decimal(12,2))              InvoiceAmountMinus5
	   , cast(NULL as decimal(12,2))              RecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              DiscountAmountMinus5
	   , cast(NULL as decimal(12,2))              NonRecurringAmountMinus5
	   , cast(NULL as decimal(12,2))              PaymentAmountMinus5
       , 0                LocationId
       , coalesce(x.Latitude,'00.0000000')      Latitude
       , coalesce(x.Longitude,'00.0000000')      Longitude
       , case when y.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
              when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
			  when y.pbb_DimExternalMarketId in (41)          then 'NY'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             Cabinet
	   , NULL             LocationProjectCode
	   , 'Unknown'        ProjectName
	   , 'Unknown'        CalcProjectName
	   , NULL             AddressType
	   , NULL             Orig_InstallOrderNumber
	   , NULL             Orig_InstallOrderName
	   , NULL             Orig_InstallType
	   , NULL             Orig_InstallStatus
	   , NULL             Orig_SalesOrderProvisioningDate
	   , NULL             Orig_InstallOrderBillReviewDate
	   , x.InstallSalesChannel             Orig_InstallOrderChannel
	   , NULL             Orig_InstallOrderSegment
	   , NULL             Orig_InstallOrderOwner
	   , x.InstallSalesAgent               Orig_InstallSalesAgent

	   , NULL             LastInvYearMonth
	   , NULL             LastInvYearMonthMinus1
	   , NULL             LastInvYearMonthMinus2
	   
	   , cast(NULL as decimal(12,2))                             LastInvoiceBilledMRC 
	   , x.AccountName             AccountName
	   , NULL             DimAccountId
       , 1                AccountCount    
       -- , *

  from [OMNIA_EPBB_P_PBB_DW].dbo.PBB_ExternalMarket_InstallsAndDisconnects x
  join dbo.DimExternalMarket_pbb           y on 
       case when x.pbb_AccountMarket='NY' then 'New York' else x.pbb_ReportingMarket end = y.pbb_ExternalMarketAccountGroupMarket 

  
  where upper(x.OrderType) = 'DISCONNECT'

    and x.OrderDate > '20221031'  

   */

) x
LEFT JOIN (
 SELECT pbb_MarketSummary
				 , SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarkety
				 , SUBSTRING(pbb_AccountMarket,1,2) AS SortOrder
		      FROM DimAccountCategory_pbb
		     WHERE pbb_AccountMarket NOT LIKE ''
		    UNION
		    SELECT pbb_ExternalMarketAccountGroupMarketSummary
				 , pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				 , pbb_ExternalMarketSort AS SortOrder
		      FROM DimExternalMarket_pbb
		     WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''
) y on x.AccountMarket = y.AccountMarkety

;


GO
