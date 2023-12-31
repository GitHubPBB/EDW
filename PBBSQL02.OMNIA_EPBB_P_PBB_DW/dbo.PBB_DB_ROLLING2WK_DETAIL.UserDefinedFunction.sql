USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_ROLLING2WK_DETAIL]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from [dbo].[PBB_DB_DAILY_DETAIL_V2]('7/28/2022')
*/
CREATE FUNCTION [dbo].[PBB_DB_ROLLING2WK_DETAIL](
			 @ReportDate date
									 )
RETURNS TABLE
AS
	RETURN(--Disconnect MRC
	--declare @ReportDate date = '10/22/2021';
	/*
	WITH DisconnectMRC
		AS (select DimSalesOrder.DimSalesOrderId
				 , SUM(FactSalesOrderLineItem.SalesOrderLineItemOldPrice) * -1 AS DisconnectPrice
		      from FactSalesOrderLineItem
			  join DimSalesOrder on FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
		     where DimSalesOrder.SalesOrderType = 'Disconnect'
		     group by DimSalesOrder.DimSalesOrderId
		)
     */
		-- Internal Install/Disconnect
		-- DECLARE @ReportDate date = cast(getdate() as date);

		WITH DateList AS ( 
				SELECT @ReportDate AsOfDate       , 14 DayNum, DATEPART(WEEKDAY, @ReportDate )                 DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-1  ,@ReportDate), 13 DayNum, DATEPART(WEEKDAY, DATEADD(d,-1  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-2  ,@ReportDate), 12 DayNum, DATEPART(WEEKDAY, DATEADD(d,-2  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-3  ,@ReportDate), 11 DayNum, DATEPART(WEEKDAY, DATEADD(d,-3  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-4  ,@ReportDate), 10 DayNum, DATEPART(WEEKDAY, DATEADD(d,-4  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-5  ,@ReportDate), 9  DayNum, DATEPART(WEEKDAY, DATEADD(d,-5  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-6  ,@ReportDate), 8  DayNum, DATEPART(WEEKDAY, DATEADD(d,-6  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-7  ,@ReportDate), 7  DayNum, DATEPART(WEEKDAY, DATEADD(d,-7  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-8  ,@ReportDate), 6  DayNum, DATEPART(WEEKDAY, DATEADD(d,-8  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-9  ,@ReportDate), 5  DayNum, DATEPART(WEEKDAY, DATEADD(d,-9  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-10 ,@ReportDate), 4  DayNum, DATEPART(WEEKDAY, DATEADD(d,-10 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-11 ,@ReportDate), 3  DayNum, DATEPART(WEEKDAY, DATEADD(d,-11 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-12 ,@ReportDate), 2  DayNum, DATEPART(WEEKDAY, DATEADD(d,-12 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-13 ,@ReportDate), 1  DayNum, DATEPART(WEEKDAY, DATEADD(d,-13 ,@ReportDate) ) DOW, 2 WeekNum   
		)
		-- SELECT * from DateList

		SELECT DimAccount.AccountCode                As 'AccountCode'
		     ,dl.AsOfDate
			 ,dl.DayNum
			 ,dl.DOW
			 ,dl.WeekNum
			 ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
			 ,DimAccountCategory.AccountGroup      As 'AccountGroup'
			 ,DimAccountCategory.AccountType       As 'AccountType'
			 ,DimAccountCategory.AccountClass      As 'AccountClass'
			 ,AccountActivationdate
			 ,AccountDeactivationDate
			 ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
			 ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
			 ,DimAccount.BillingAddressStreetLine3 As 'BillingAddressLine3'
			 ,DimAccount.BillingAddressStreetLine4 As 'BillingAddressLine4'
			 ,DimAccount.BillingAddressCity        As 'City'
			 ,DimAccount.BillingAddressStateAbbreviation As 'State'
			 ,DimAccount.BillingAddressPostalCode  As 'Zip'
			 ,DimAccount.AccountPhoneNumber        As 'Phone'
			 ,DimAccount.AccountEMailAddress       as 'Email'
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,DimSalesOrder.SalesOrderNumber       As 'SalesOrderNumber'
			 ,FactSalesOrder.CreatedOn_DimDateId   As 'CreatedOn_DimDateId'
			--,Case
			--	 When DimSalesOrder.SalesOrderType = 'Disconnect'
			--	 Then DisconnectMRC.DisconnectPrice Else FactSalesOrder.SalesOrderTotalMRC
			-- End As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC         As 'SalesOrderTotalNRC'
			 ,FactSalesOrder.SalesOrderTotalTax         As 'SalesOrderTotalTax'
			 ,FactSalesOrder.SalesOrderTotalAmount      As 'SalesOrderTotalAmount'
			 ,DimSalesOrder.SalesOrderProjectManager    As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner)      As 'SalesOrderOwner'
			 ,DimSalesOrder.SalesOrderStatus            As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderStatusReason      As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderDisconnectReason  as 'DisconnectReason'
			 ,Case
				 when DimSalesOrder.SalesOrderType in('Install')
				 then ''
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
				 then 'Disconnect for Non Pay'
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
				 then 'Voluntary Disconnect' else ''
			  end                                        as 'DisconnectType'
			 ,DimSalesOrderView_pbb.pbb_OrderActivityType
			 ,DimSalesOrder.SalesOrderFulfillmentStatus  As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderProvisioningDate   As 'SalesOrderProvisioningDate'
			 ,case
				 when FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
				 then null else FactSalesOrder.OrderClosed_DimDateId
			  end                                        As 'Completion Date'
			 ,DimSalesOrder_pbb.pbb_SalesOrderReviewDate as 'Order Review Date'
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			 ,DimSalesOrder.SalesOrderName               As 'SalesOrderName'
			 ,DimAccountCategory_pbb.pbb_MarketSummary   As 'VATNGroup'
			 ,DimSalesOrder.SalesOrderType
			 ,DimSalesOrder.DimSalesOrderId
			 ,sc.SalesOrderClassification
		from FactSalesOrder
			JOIN DimAccount                  ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
			JOIN DimAccount_pbb              ON DimAccount.AccountId        = DimAccount_pbb.AccountId
			LEFT JOIN DimAccountCategory     ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			JOIN DimSalesOrder               ON FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb      ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			Left Join DimSalesOrderView_pbb  ON DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
			LEFT JOIN DimServiceLocation     ON DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			LEFT JOIN DimDate                ON FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimOpportunity         ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
		--	Left Join DisconnectMRC ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
			left join PBB_SalesOrder_Classification sc on sc.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			JOIN DateList dl                 ON dl.AsOfDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
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
	)

GO
