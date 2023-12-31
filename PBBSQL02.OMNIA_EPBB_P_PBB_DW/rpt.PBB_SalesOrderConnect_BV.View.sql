USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SalesOrderConnect_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [rpt].[PBB_SalesOrderConnect_BV] as
SELECT 
  AccountActivationDate  	[Acct-ActivationDate]
, BundleType	            [Acct-BundleType]
, AccountClass	            [Acct-Class]
--, AccountClassCode	    [Acct-ClassCode]
, AccountCode	            [Acct-Code]
, AccountCount	            [Acct-Count]
, AccountDeactivationDate	[Acct-DeactivationDate]
, AccountDiscountNames  [Acct-Discounts]
, AccountGroup	    [Acct-Group]
, AccountGroupCode	[Acct-GroupCode]
, AccountName       [Acct-Name]
, case when AccountType = 'COMMERCIAL' then 'Business'
       else AccountType end [Acct-Type]
, PortalUserExists	[Acct-PortalUserExists]
, PrintGroup	    [Acct-PrintGroup]
, Speed	            [Acct-Speed]
--, Tenure	        [Acct-Tenure]
--, TenureRange    	[Acct-TenureRange]
--, TenureSort	    [Acct-TenureSort]
, CalcProjectName	[Addr-CalcProjectName]
, ServiceLocationCity	        [Addr-City]
, ServiceLocationFullAddress	[Addr-Full Address]
, Cabinet                       [Addr-Cabinet]
, Latitude	                    [Addr-Latitude]
, Longitude      	            [Addr-Longitude]
, ProjectName	                [Addr-ProjectName]
, ProjectServiceableDate        [Addr-ProjectServiceableDate]
--, LocationProjectCode	        [Addr-ProjectCode]
, ServiceLocationStateAbbrev	[Addr-StateAbbrev]
--, AddressType	                [Addr-Type]
, ServiceLocationZip	        [Addr-Zip]
, NonPayCountLast6Months	    [AR-NonPayCountLast6Months]
, PaidInvoicesLast6Months	    [AR-PaidInvoicesLast6Months]
, DimAccountId	        [Dim-AccountId]
, AccountMarket	[Mkt-AccountMarket]
, MarketSummary	[Mkt-MarketSummary]
--, MarketSort    [Mkt-Sort]
, ReportingMarket	[Mkt-ReportingMarket]
, OrderActivityType	[Order-ActivityType]
, SalesOrderChannel	[Order-Channel]
--, SalesOrderClassification	[Order-Classification]
 ,case
		 when SalesOrderClassification = 'New Install' then 'Install (New Customer, New Location)'
		 when SalesOrderClassification = 'New Connect' then 'Install (New Customer, Existing Location)'
         when SalesOrderClassification = 'Reconnect' then 'Install (Existing Customer, Existing Location)'
		 when SalesOrderType = 'Disconnect' then 'Disconnect'
		 else 'Other'
	  End as [Order-Classification]
, SalesOrderCommitmentDate	[Order-CommitmentDate]
, CompletionDate	[Order-CompletionDate]
, SalesOrderFulfillmentStatus	[Order-FulfillmentStatus]
, SalesOrderId	    [Order-Id]
, SalesOrderName	[Order-Name]
, SalesOrderNumber	[Order-Number]
, SalesOrderOwner	[Order-Owner]
, SalesOrderPriorityCode	[Order-PriorityCode]
, SalesOrderProvisioningDate	[Order-ProvisioningDate]
, OrderReviewDate	[Order-ReviewDate]
, SalesOrderSegment	[Order-Segment]
, SalesOrderStatus	[Order-Status]
, SalesOrderStatusReason	[Order-StatusReason]
, SalesOrderTotalAmount	[Order-TotalAmount]
, SalesOrderTotalMRC	[Order-TotalMRC]
, SalesOrderTotalNRC	[Order-TotalNRC]
, SalesOrderTotalTax	[Order-TotalTax]
, SalesOrderType	    [Order-Type]

  FROM rpt.PBB_SalesOrderConnect
GO
