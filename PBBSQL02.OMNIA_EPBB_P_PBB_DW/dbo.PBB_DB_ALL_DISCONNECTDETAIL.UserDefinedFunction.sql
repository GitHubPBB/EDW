USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_ALL_DISCONNECTDETAIL]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from [dbo].[PBB_DB_ALL_DISCONNECTDETAIL]('11/21/2022')
*/

CREATE FUNCTION [dbo].[PBB_DB_ALL_DISCONNECTDETAIL](
			@ReportDate DATE)
RETURNS TABLE
AS
	RETURN(
	--Disconnect MRC
	--declare @ReportDate date = '10/22/2021';
	WITH 
	--DisconnectMRC
	--AS (SELECT DimSalesOrder.DimSalesOrderId
	--		,SUM(FactSalesOrderLineItem.SalesOrderLineItemOldPrice) * -1 AS DisconnectPrice
	--    FROM FactSalesOrderLineItem
	--	    JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
	--    WHERE DimSalesOrder.SalesOrderType = 'Disconnect'
	--    GROUP BY DimSalesOrder.DimSalesOrderId),
	LastFullBilledMRC
	AS (select BillingRunId
			,AccountGroupCode
			,AccountCode
			,LocationId
			,BilledAmount
	    from PBB_LastBilledFullAmountByAccountAndLocation),
	DisconnectReason
	AS (SELECT 'Billing Correction' AS SalesOrderDisconnectReason
			,'Billing Correction' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competition - Charter' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competition - Comcast' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competition - Dish' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competition - Other' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competition - Verizon' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Competitor' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade - Financial Issues' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade - Streaming TV' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Cell Phone' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition - Charter' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition - Other' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition - Verizon' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition- Century Link' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Business Closure' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'Financial Issues' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'House Fire' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'Price' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'Rate Increase' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'Temporary - Financial' AS SalesOrderDisconnectReason
			,'Financial' AS DisconnectReason
	    UNION ALL
	    SELECT 'Moving' AS SalesOrderDisconnectReason
			,'Moving' AS DisconnectReason
	    UNION ALL
	    SELECT 'Moving in with Family Member' AS SalesOrderDisconnectReason
			,'Moving' AS DisconnectReason
	    UNION ALL
	    SELECT 'Moving out of Service Area' AS SalesOrderDisconnectReason
			,'Moving' AS DisconnectReason
	    UNION ALL
	    SELECT 'Moving out of Service Area - No Service' AS SalesOrderDisconnectReason
			,'Moving' AS DisconnectReason
	    UNION ALL
	    SELECT 'NonPay' AS SalesOrderDisconnectReason
			,'NonPay' AS DisconnectReason
	    UNION ALL
	    SELECT 'Total Disconnect for Non Pay' AS SalesOrderDisconnectReason
			,'NonPay' AS DisconnectReason
	    UNION ALL
	    SELECT 'Cell Phone' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Cell Phone Only' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Convert to OptiPro' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Deceased' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Doesn''t Use' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Other' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Test Account' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Seasonal' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Temporary - Snowbird' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Customer/Technical Support' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason
	    UNION ALL
	    SELECT 'Service related issues - All services' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason
	    UNION ALL
	    SELECT 'Service related issues - Cable' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason
	    UNION ALL
	    SELECT 'Service related issues - Data' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason
	    UNION ALL
	    SELECT 'Service related issues - Voice' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason
	    UNION ALL
	    SELECT 'Unhappy with Service' AS SalesOrderDisconnectReason
			,'Service' AS DisconnectReason     
	    -- [SUNIL] added more DisconnectReason on 07/18
	    UNION ALL
	    SELECT 'Competition - Direct TV' AS SalesOrderDisconnectReason
			,'Competition' AS DisconnectReason
	    UNION ALL
	    SELECT 'Streaming TV' AS SalesOrderDisconnectReason
			,'Other' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade - Verizon' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition - Comcast' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Competition - Direct TV' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason
	    UNION ALL
	    SELECT 'Downgrade Streaming TV' AS SalesOrderDisconnectReason
			,'Downgrade' AS DisconnectReason)
	--Internal Install/Disconnect 
	SELECT DISTINCT 
		  FactSalesOrder.SalesorderID AS 'SalesOrderId'
		 ,DimSalesOrder.SalesOrderNumber AS 'SalesOrderNumber'
		 ,FactSalesOrder.CreatedOn_DimDateId AS 'CreatedOn_DimDateId'
		 ,DimSalesOrder.SalesOrderDisconnectReason AS DisconnectReason
		 ,DisconnectReason.DisconnectReason AS ReportDisconnectReason
		 ,CASE
			 WHEN DimSalesOrder.SalesOrderType IN('Install')
			 THEN ''
			 WHEN DimSalesOrder.SalesOrderType IN('Disconnect')
				 AND DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
			 THEN 'Disconnect for Non Pay'
			 WHEN DimSalesOrder.SalesOrderType IN('Disconnect')
				 AND DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
			 THEN 'Voluntary Disconnect' ELSE ''
		  END AS 'DisconnectType'
		 ,DimSalesOrder.SalesOrderName AS 'SalesOrderName'
		 ,DimSalesOrder.SalesOrderFulfillmentStatus AS 'SalesOrderFulfillmentStatus'
		 ,DimSalesOrder.SalesOrderChannel AS 'SalesOrderChannel'
		 ,DimSalesOrder.SalesOrderSegment AS 'SalesOrderSegment'
		 ,DimSalesOrder.SalesOrderProvisioningDate AS 'SalesOrderProvisioningDate'
		 ,DimSalesOrder.SalesOrderCommitmentDate AS 'SalesOrderCommitmentDate'
		 ,DimOpportunity.OpportunityBillingDate AS 'BillingDate'
		 ,DimSalesOrder.SalesOrderType AS 'SalesOrderType'
		 ,DimSalesOrderView_pbb.pbb_OrderActivityType
		 ,DimSalesOrder.SalesOrderProject AS 'SalesOrderProject'
		 ,DimSalesOrder.SalesOrderProjectManager AS 'SalesOrderProjectManager'
		 ,upper(DimSalesOrder.SalesOrderOwner) AS 'SalesOrderOwner'
		 ,DimSalesOrder.SalesOrderStatusReason AS 'SalesOrderStatusReason'
		 ,DimSalesOrder.SalesOrderStatus AS 'SalesOrderStatus'
		 ,DimSalesOrder.SalesOrderPriorityCode AS 'SalesOrderPriorityCode'
		 ,DimAccount.AccountCode AS 'AccountCode'
		 ,DimOpportunity.OpportunityCustomerName AS 'CustomerName'
		 ,AccountActivationDate
		 ,AccountDeactivationDate
		 ,DimAccount.BillingAddressStreetLine1 AS 'BillingAddressLine1'
		 ,DimAccount.BillingAddressStreetLine2 AS 'BillingAddressLine2'
		 ,DimAccount.BillingAddressCity AS 'City'
		 ,DimAccount.BillingAddressState AS 'State'
		 ,DimAccount.BillingAddressCountry AS 'Country'
		 ,DimAccount.BillingAddressPostalCode AS 'ZIP'
		 ,DimAccountCategory.AccountClassCode AS 'AccountClassCode'
		 ,DimAccountCategory.AccountClass AS 'AccountClass'
		 ,DimAccountCategory.AccountGroupCode AS 'AccountGroupCode'
		 ,DimAccountCategory.AccountGroup AS 'AccountGroup'
		 ,DimAccountCategory.AccountType AS 'AccountType'
		 ,DimServiceLocation.ServiceLocationFullAddress
		 ,DimServiceLocation_pbb.pbb_LocationProjectCode 'Project'
		 ,CASE
			 WHEN FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
			 THEN NULL ELSE FactSalesOrder.OrderClosed_DimDateId
		  END AS 'Completion Date'
		 ,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate AS DATE) AS 'Order Review Date'
		  --,CASE
		  -- WHEN DimSalesOrder.SalesOrderType = 'Disconnect'
		  -- THEN DisconnectMRC.DisconnectPrice ELSE FactSalesOrder.SalesOrderTotalMRC
		  -- END AS 'SalesOrderTotalMRC'
		 ,CASE
			 WHEN DimSalesOrder.SalesOrderType = 'Disconnect'
			 THEN LastFullBilledMRC.BilledAmount ELSE FactSalesOrder.SalesOrderTotalMRC
		  END AS 'SalesOrderTotalMRC'
		 ,FactSalesOrder.SalesOrderTotalNRC
		 ,FactSalesOrder.SalesOrderTotalTax
		 ,FactSalesOrder.SalesOrderTotalAmount
		 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
		 ,pbb_marketsummary
		 ,pbb_ReportingMarket
		 ,dimaccount.dimaccountid
		 ,dimservicelocation.dimservicelocationid
	FROM FactSalesOrder
		LEFT JOIN DimAccountCategory ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
		LEFT JOIN DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
		LEFT JOIN DimSalesOrder ON FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
		LEFT JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
		LEFT JOIN DimSalesOrderView_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
		LEFT JOIN DimAccount ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
		JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
		LEFT JOIN DimDate ON FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
		LEFT JOIN DimOpportunity ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
		LEFT JOIN DimServiceLocation ON DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationid
		LEFT JOIN DimServiceLocation_pbb on DimServiceLocation.LocationID = DimServiceLocation_pbb.LocationId
		--LEFT JOIN DisconnectMRC ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
		LEFT JOIN LastFullBilledMRC on LastFullBilledMRC.LocationID = DimServiceLocation.LocationID
								 and LastFullBilledMRC.AccountCode = DimAccount.AccountCode
		LEFT JOIN DisconnectReason ON coalesce(DimSalesOrder.SalesOrderDisconnectReason,'Other') = DisconnectReason.SalesOrderDisconnectReason
	WHERE DimSalesOrder.SalesOrderType IN('Disconnect')
		AND DimSalesOrder.SalesOrderStatus <> 'Canceled'
		AND DimSalesOrder.OrderWorkflowName <> 'Billing Correction'
		AND DimSalesOrderView_pbb.pbb_OrderActivityType IN('Disconnect')
	AND DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
	AND DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%Courtesy%'
	AND cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate AS DATE) < @ReportDate)
GO
