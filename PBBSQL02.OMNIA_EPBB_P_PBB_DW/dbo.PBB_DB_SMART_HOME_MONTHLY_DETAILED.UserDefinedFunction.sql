USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SMART_HOME_MONTHLY_DETAILED]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE FUNCTION [dbo].[PBB_DB_SMART_HOME_MONTHLY_DETAILED](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
(Select Distinct 
	  DimSalesOrder.SalesorderID
	 ,SUBSTRING(_ac.pbb_AccountMarket,4,255) AS pbb_AccountMarket
	 ,pbb_MarketSummary
	 ,DimSalesOrder.SalesOrderNumber As 'SalesOrderNumber'
	 ,DimSalesOrder.SalesOrderName As 'SalesOrderName'
	 ,DimSalesOrder.SalesOrderFulfillmentStatus As 'SalesOrderFulfillmentStatus'
	 ,DimSalesOrder.SalesOrderChannel As 'SalesOrderChannel'
	 ,DimSalesOrder.SalesOrderSegment As 'SalesOrderSegment'
	 ,DimSalesOrder.SalesOrderProvisioningDate As 'SalesOrderProvisioningDate'
	 ,DimSalesOrder.SalesOrderCommitmentDate As 'SalesOrderCommitmentDate'
	 ,DimOpportunity.OpportunityBillingDate As 'BillingDate'
	 ,DimSalesOrder.SalesOrderType As 'SalesOrderType'
	 ,DimSalesOrder.SalesOrderProject As 'SalesOrderProject'
	 ,DimSalesOrder.SalesOrderProjectManager As 'SalesOrderProjectManager'
	 ,DimSalesOrder.SalesOrderOwner As 'SalesOrderOwner'
	 ,DimSalesOrder.SalesOrderStatusReason As 'SalesOrderStatusReason'
	 ,DimSalesOrder.SalesOrderStatus As 'SalesOrderStatus'
	 ,DimSalesOrder.SalesOrderPriorityCode As 'SalesOrderPriorityCode'
	 ,DimAccount.AccountCode As 'AccountCode'
	 ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
	 ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
	 ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
	 ,replace(DimAccount.BillingAddressCity,' ','') As 'City'
	 ,DimAccount.BillingAddressState As 'State'
	 ,DimAccount.BillingAddressCountry As 'Country'
	 ,DimAccount.BillingAddressPostalCode As 'ZIP'
	 ,DimAccountCategory.AccountClassCode As 'AccountClassCode'
	 ,DimAccountCategory.AccountClass As 'AccountClass'
	 ,DimAccountCategory.AccountGroupCode As 'AccountGroupCode'
	 ,DimAccountCategory.AccountGroup As 'AccountGroup'
	 ,DimAccountCategory.AccountType As 'AccountType'
	 ,f.OrderClosed_DimDateId As 'Completion Date'
	 ,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) as OrderReviewDate
	 ,p.CatalogPriceIsRecurring
	 ,f.SalesOrderLineItemPrice
	 ,SalesOrderLineItemActivity
	 ,ci.ComponentName
From FactSalesOrderLineItem f
	Join DimSalesOrderLineItem On F.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
	Join DimSalesOrder ON f.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
	Join DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
	Join DimAccountCategory ON f.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
	Join DimAccountCategory_pbb _ac ON DimAccountCategory.SourceId = _ac.SourceId
	Join DimCatalogItem ci ON f.DimCatalogItemId = ci.DimCatalogItemId
	--Join DimCatalogItem_pbb _ci ON f.DimCatalogItemId = _ci.DimCatalogItemId
	--						 And _ci.CatalogItemIsSmartHome = 'Yes'
	join PrdComponentMap cm on ci.ComponentCode = cm.ComponentCode and IsSmartHome = 1
	Join DimAccount ON f.DimAccountId = DimAccount.DimAccountId
	JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
	JOIN DimOpportunity ON f.dimopportunityid = DimOpportunity.dimopportunityid
	--Left Join DimServiceLocationItem_pbb On DimAccount.AccountId = DimServiceLocationItem_pbb.pbb_dimAccountid
	--Left join DimServiceLocation On DimServiceLocationItem_pbb.pbb_DimServiceLocationid = DimServiceLocation.DimServiceLocationid
	join DimCatalogPrice p on f.DimCatalogPriceId = p.DimCatalogPriceId
Where DimSalesOrder.SalesOrderType in
							  (
							   'Install'
							  ,'Change'
							  )
	 And DimSalesOrder.SalesOrderStatus <> 'Canceled'
	 And DimSalesOrderLineItem.SalesOrderLineItemActivity In('Install','Reconnect')
	And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
	And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
	And DimSalesOrder_pbb.pbb_SalesOrderReviewDate < @ReportDate
	And Year(DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = Year(case when datepart(weekday, @ReportDate)=2 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate) end)
	And Month(DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = Month(case when datepart(weekday, @ReportDate)=2 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate) end)
--	And (DimSalesOrder.SalesOrderType IN(@OrderType))
--AND (SUBSTRING(_ac.pbb_AccountMarket,4,255) IN(@AccountGroup))
--AND (DimAccountCategory.AccountType IN(@AccountType))
)
GO
