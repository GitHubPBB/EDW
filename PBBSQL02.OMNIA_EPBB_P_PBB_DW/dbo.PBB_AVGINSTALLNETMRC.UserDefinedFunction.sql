USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_AVGINSTALLNETMRC]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from [dbo].[PBB_AVGINSTALLNETMRC]('1/1/2022')
*/

CREATE FUNCTION [dbo].[PBB_AVGINSTALLNETMRC](
			@ReportDate date)
RETURNS TABLE
AS
	RETURN(--Disconnect MRC
	--declare @ReportDate date = '2/1/2022';
	WITH DisconnectMRC
		AS (select DimSalesOrder.DimSalesOrderId
				,SUM(FactSalesOrderLineItem.SalesOrderLineItemOldPrice) * -1 AS DisconnectPrice
		    from FactSalesOrderLineItem
			    join DimSalesOrder on FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
		    where DimSalesOrder.SalesOrderType = 'Disconnect'
		    group by DimSalesOrder.DimSalesOrderId),
		GrossMRC
		as (select DimSalesOrderId
				,sum(salesorderlineitemprice) NetMRC
		    from FactSalesOrderLineItem f with(NOLOCK)
			    join DimSalesOrderLineItem d with(NOLOCK) on f.DimSalesOrderLineItemId = d.DimSalesOrderLineItemId
			    join DimCatalogItem ci with(NOLOCK) on f.DimCatalogItemId = ci.DimCatalogItemId
			    join PrdComponentMap cm with(NOLOCK) on ci.ComponentCode = cm.ComponentCode
		    where IsNRC_Scheduling = 0
		    group by DimSalesOrderId)

		--Internal Install/Disconnect 
		Select Distinct 
			  FactSalesOrder.SalesorderID As 'SalesOrderId'
			 ,DimSalesOrder.DimSalesOrderId
			 ,DimSalesOrder.SalesOrderNumber As 'SalesOrderNumber'
			 ,FactSalesOrder.CreatedOn_DimDateId As 'CreatedOn_DimDateId'
			 ,DimSalesOrder.SalesOrderDisconnectReason as DisconnectReason
			 ,Case
				 when DimSalesOrder.SalesOrderType in('Install')
				 then ''
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
				 then 'Disconnect for Non Pay'
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
				 then 'Voluntary Disconnect' else ''
			  end as 'DisconnectType'
			 ,DimSalesOrder.SalesOrderName As 'SalesOrderName'
			 ,DimSalesOrder.SalesOrderFulfillmentStatus As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderChannel As 'SalesOrderChannel'
			 ,DimSalesOrder.SalesOrderSegment As 'SalesOrderSegment'
			 ,DimSalesOrder.SalesOrderProvisioningDate As 'SalesOrderProvisioningDate'
			 ,DimSalesOrder.SalesOrderCommitmentDate As 'SalesOrderCommitmentDate'
			 ,DimOpportunity.OpportunityBillingDate As 'BillingDate'
			 ,DimSalesOrder.SalesOrderType As 'SalesOrderType'
			 ,DimSalesOrderView_pbb.pbb_OrderActivityType
			 ,DimSalesOrder.SalesOrderProject As 'SalesOrderProject'
			 ,DimSalesOrder.SalesOrderProjectManager As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner) As 'SalesOrderOwner'
			 ,DimSalesOrder.SalesOrderStatusReason As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderStatus As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderPriorityCode As 'SalesOrderPriorityCode'
			 ,DimAccount.AccountCode As 'AccountCode'
			 ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
			 ,AccountActivationDate
			 ,AccountDeactivationDate
			 ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
			 ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
			 ,DimAccount.BillingAddressCity As 'City'
			 ,DimAccount.BillingAddressState As 'State'
			 ,DimAccount.BillingAddressCountry As 'Country'
			 ,DimAccount.BillingAddressPostalCode As 'ZIP'
			 ,DimAccountCategory.AccountClassCode As 'AccountClassCode'
			 ,DimAccountCategory.AccountClass As 'AccountClass'
			 ,DimAccountCategory.AccountGroupCode As 'AccountGroupCode'
			 ,DimAccountCategory.AccountGroup As 'AccountGroup'
			 ,DimAccountCategory.AccountType As 'AccountType'
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,case
				 when FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
				 then null else FactSalesOrder.OrderClosed_DimDateId
			  end As 'Completion Date'
			 ,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) as 'Order Review Date'
			 ,Case
				 When DimSalesOrder.SalesOrderType = 'Disconnect'
				 Then DisconnectMRC.DisconnectPrice Else FactSalesOrder.SalesOrderTotalMRC
			  End As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC
			 ,FactSalesOrder.SalesOrderTotalTax
			 ,FactSalesOrder.SalesOrderTotalAmount
			 ,GrossMRC.NetMRC
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			 ,pbb_marketsummary
			 ,pbb_ReportingMarket
			 ,dimaccount.dimaccountid
			 ,dimservicelocation.dimservicelocationid
			 ,dimservicelocation.LocationId
			 ,ds.Speed as [Speed]
			 ,case
				 when pbb_LocationProjectCode like 'PC-%Project%'
				 then substring(pbb_LocationProjectCode,4,100) else 'Legacy'
			  end as Project
		from FactSalesOrder with(NOLOCK)
			LEFT JOIN DimAccountCategory with(NOLOCK) ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb with(NOLOCK) on DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			LEFT join DimSalesOrder with(NOLOCK) on FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb with(NOLOCK) ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			Left Join DimSalesOrderView_pbb with(NOLOCK) on DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
			LEFT JOIN DimAccount with(NOLOCK) ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
			JOIN DimAccount_pbb with(NOLOCK) ON DimAccount.AccountId = DimAccount_pbb.AccountId
			LEFT JOIN DimDate with(NOLOCK) on FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimOpportunity with(NOLOCK) ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
			Left join DimServiceLocation with(NOLOCK) On DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationid
			left join DimServiceLocation_pbb with(NOLOCK) on DimServiceLocation_pbb.LocationId = DimServiceLocation.LocationId
			Left Join DisconnectMRC with(NOLOCK) ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
			LEFT JOIN GrossMRC with(NOLOCK) on FactSalesOrder.DimSalesOrderId = GrossMRC.DimSalesOrderId
			left join [dbo].[PBB_AccountLocation_DataServices_Aggregation](dateadd(day,-1,@ReportDate),',') ds on ds.DimAccountID = DimAccount.DimAccountId
																							  and ds.DimServiceLocationID = DimServiceLocation.DimServiceLocationId
		Where DimSalesOrder.SalesOrderType in
									  ('Install'
			 --		  ,'Disconnect'
									  )
			 And DimSalesOrder.SalesOrderStatus <> 'Canceled'
			 And DimSalesOrder.OrderWorkflowName <> 'Billing Correction'
			 And DimSalesOrderView_pbb.pbb_OrderActivityType In('Install','Disconnect')
		And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
		And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
		And cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) < @ReportDate
		And (Year(DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = Year(case
															when datepart(weekday,@ReportDate) = 2
															then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
														 end)
			And Month(DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = Month(case
																 when datepart(weekday,@ReportDate) = 2
																 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
															  end)))
GO
