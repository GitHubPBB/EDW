USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_DAILY_DETAIL_V2_20221121]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [dbo].[PBB_DB_DAILY_DETAIL_V2]('7/28/2022')
*/
create FUNCTION [dbo].[PBB_DB_DAILY_DETAIL_V2_20221121](
			 @ReportDate date
									 )
RETURNS TABLE
AS
	RETURN(--Disconnect MRC
	--declare @ReportDate date = '10/22/2021';
	WITH DisconnectMRC
		AS (select DimSalesOrder.DimSalesOrderId
				,SUM(FactSalesOrderLineItem.SalesOrderLineItemOldPrice) * -1 AS DisconnectPrice
		    from FactSalesOrderLineItem
			    join DimSalesOrder on FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
		    where DimSalesOrder.SalesOrderType = 'Disconnect'
		    group by DimSalesOrder.DimSalesOrderId)

		-- Internal Install/Disconnect
		Select DimAccount.AccountCode As 'AccountCode'
			 ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
			 ,DimAccountCategory.AccountGroup As 'AccountGroup'
			 ,DimAccountCategory.AccountType As 'AccountType'
			 ,DimAccountCategory.AccountClass As 'AccountClass'
			 ,AccountActivationdate
			 ,AccountDeactivationDate
			 ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
			 ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
			 ,DimAccount.BillingAddressStreetLine3 As 'BillingAddressLine3'
			 ,DimAccount.BillingAddressStreetLine4 As 'BillingAddressLine4'
			 ,DimAccount.BillingAddressCity As 'City'
			 ,DimAccount.BillingAddressStateAbbreviation As 'State'
			 ,DimAccount.BillingAddressPostalCode As 'Zip'
			 ,DimAccount.AccountPhoneNumber As 'Phone'
			 ,DimAccount.AccountEMailAddress as 'Email'
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,DimSalesOrder.SalesOrderNumber As 'SalesOrderNumber'
			 ,FactSalesOrder.CreatedOn_DimDateId As 'CreatedOn_DimDateId'
			 ,Case
				 When DimSalesOrder.SalesOrderType = 'Disconnect'
				 Then DisconnectMRC.DisconnectPrice Else FactSalesOrder.SalesOrderTotalMRC
			  End As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC As 'SalesOrderTotalNRC'
			 ,FactSalesOrder.SalesOrderTotalTax As 'SalesOrderTotalTax'
			 ,FactSalesOrder.SalesOrderTotalAmount As 'SalesOrderTotalAmount'
			 ,DimSalesOrder.SalesOrderProjectManager As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner) As 'SalesOrderOwner'
			 ,DimSalesOrder.SalesOrderStatus As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderStatusReason As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderDisconnectReason as 'DisconnectReason'
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
			 ,DimSalesOrderView_pbb.pbb_OrderActivityType
			 ,DimSalesOrder.SalesOrderFulfillmentStatus As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderProvisioningDate As 'SalesOrderProvisioningDate'
			 ,case
				 when FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
				 then null else FactSalesOrder.OrderClosed_DimDateId
			  end As 'Completion Date'
			 ,DimSalesOrder_pbb.pbb_SalesOrderReviewDate as 'Order Review Date'
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			 ,DimSalesOrder.SalesOrderName As 'SalesOrderName'
			 ,DimAccountCategory_pbb.pbb_MarketSummary As 'VATNGroup'
			 ,DimSalesOrder.SalesOrderType
			 ,DimSalesOrder.DimSalesOrderId
			 ,sc.SalesOrderClassification
		from FactSalesOrder
			LEFT JOIN DimAccountCategory ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb on DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			LEFT join DimSalesOrder on FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			Left Join DimSalesOrderView_pbb on DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
			LEFT JOIN DimServiceLocation ON DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			LEFT JOIN DimAccount ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
			JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
			LEFT JOIN DimDate on FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimOpportunity ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
			Left Join DisconnectMRC ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
			left join PBB_SalesOrder_Classification sc on sc.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
		Where DimSalesOrder.SalesOrderType in
									  (
									   'Install'
									  ,'Disconnect'
									  )
			 And DimSalesOrder.SalesOrderStatus <> 'Canceled'
			 And DimSalesOrder.OrderWorkflowName <> 'Billing Correction'
			 And DimSalesOrderView_pbb.pbb_OrderActivityType In('Install','Disconnect')
			And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
			And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
			And ((Convert(Date,DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = COnvert(Date,
																	   Case
																		  When Datepart(weekday,@ReportDate) = 2
																		  Then DATEadd(day,-3,@ReportDate) Else DATEadd(day,-1,@ReportDate)
																	   End))
				Or Convert(Date,DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = COnvert(Date,
																		Case
																		    When Datepart(weekday,@ReportDate) = 2
																		    Then DATEadd(day,-2,@ReportDate) Else DATEadd(day,-1,@ReportDate)
																		End)
				Or Convert(Date,DimSalesOrder_pbb.pbb_SalesOrderReviewDate) = COnvert(Date,
																		Case
																		    When Datepart(weekday,@ReportDate) = 2
																		    Then DATEadd(day,-1,@ReportDate) Else DATEadd(day,-1,@ReportDate)
																		End)))

GO
