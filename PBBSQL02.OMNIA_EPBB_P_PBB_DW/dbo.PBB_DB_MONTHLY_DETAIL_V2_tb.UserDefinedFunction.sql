USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_MONTHLY_DETAIL_V2_tb]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from [dbo].[PBB_DB_MONTHLY_DETAIL_V2]('1/1/2022')
*/

CREATE FUNCTION [dbo].[PBB_DB_MONTHLY_DETAIL_V2_tb](
			@ReportDate date)
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

    , MDUAddresses AS (

  		SELECT Distinct dsl.DimServiceLocationId
			 , dsl.LocationId
			 , dsl.ServiceLocationFullAddress
			 , dc.cus_DistributionCenterName
			 , ab.AccountNumber  as MDUAccountCode
			 , case when csl.cus_Serviceable = '972050000' then 'Y' else 'N' end ServiceableAddress
			 , case when ab.AccountNumber is not null then 'Bulk' else 'MDU' end BulkMduCode 
		  FROM pbbpdw01.Transient.cus_DistributionCenterBase         dc   
		  JOIN pbbpdw01.Transient.chr_servicelocation                csl  ON dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
		  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation          dsl  ON dsl.locationid                = csl.chr_masterlocationid
		  LEFT JOIN pbbpdw01.Transient.AccountBase                   ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount    -- Get the BULK master account
	  )
	

		--Internal Install/Disconnect 
		Select Distinct 
			  FactSalesOrder.SalesorderID              As 'SalesOrderId'
			 ,DimSalesOrder.SalesOrderNumber           As 'SalesOrderNumber'
			 ,FactSalesOrder.CreatedOn_DimDateId       As 'CreatedOn_DimDateId'
			 ,DimSalesOrder.SalesOrderDisconnectReason as DisconnectReason
			 ,Case
				 when DimSalesOrder.SalesOrderType in('Install','Change')
				 then ''
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
				 then 'Disconnect for Non Pay'
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
				 then 'Voluntary Disconnect' else ''
			  end                                       as 'DisconnectType'
			 ,DimSalesOrder.SalesOrderName              As 'SalesOrderName'
			 ,DimSalesOrder.SalesOrderFulfillmentStatus As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderChannel           As 'SalesOrderChannel'
			 ,DimSalesOrder.SalesOrderSegment           As 'SalesOrderSegment'
			 ,DimSalesOrder.SalesOrderProvisioningDate  As 'SalesOrderProvisioningDate'
			 ,DimSalesOrder.SalesOrderCommitmentDate    As 'SalesOrderCommitmentDate'
			 ,DimOpportunity.OpportunityBillingDate     As 'BillingDate'
			 ,DimSalesOrder.SalesOrderType              As 'SalesOrderType'
			 ,poi.pbb_OrderActivityType
			 ,DimSalesOrder.SalesOrderProject           As 'SalesOrderProject'
			 ,DimSalesOrder.SalesOrderProjectManager    As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner)      As 'SalesOrderOwner'
			 ,DimSalesOrder.SalesOrderStatusReason      As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderStatus            As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderPriorityCode      As 'SalesOrderPriorityCode'
			 ,DimAccount.AccountCode                    As 'AccountCode'
			 ,DimOpportunity.OpportunityCustomerName    As 'CustomerName'
			 ,AccountActivationDate
			 ,AccountDeactivationDate
			 ,DimAccount.BillingAddressStreetLine1      As 'BillingAddressLine1'
			 ,DimAccount.BillingAddressStreetLine2      As 'BillingAddressLine2'
			 ,DimAccount.BillingAddressCity             As 'City'
			 ,DimAccount.BillingAddressState            As 'State'
			 ,DimAccount.BillingAddressCountry          As 'Country'
			 ,DimAccount.BillingAddressPostalCode       As 'ZIP'
			 ,DimAccountCategory.AccountClassCode       As 'AccountClassCode'
			 ,DimAccountCategory.AccountClass           As 'AccountClass'
			 ,DimAccountCategory.AccountGroupCode       As 'AccountGroupCode'
			 ,DimAccountCategory.AccountGroup           As 'AccountGroup'
			 ,DimAccountCategory.AccountType            As 'AccountType'
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,case
				 when FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
				 then null else FactSalesOrder.OrderClosed_DimDateId
			  end As 'Completion Date'
			 ,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) as 'Order Review Date'
			 ,poi.ActualOrderDate  -- New tb 2023/08/23
			 ,Case
				 When DimSalesOrder.SalesOrderType = 'Disconnect'
				 Then DisconnectMRC.DisconnectPrice Else FactSalesOrder.SalesOrderTotalMRC
			  End As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC
			 ,FactSalesOrder.SalesOrderTotalTax
			 ,FactSalesOrder.SalesOrderTotalAmount
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			 ,pbb_marketsummary
			 ,pbb_ReportingMarket
			 ,dimaccount.dimaccountid
			 ,dimservicelocation.dimservicelocationid
			 ,sc.SalesOrderClassification
		from FactSalesOrder
			LEFT JOIN DimAccountCategory                             ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb                         on DimAccountCategory.SourceId         = DimAccountCategory_pbb.SourceId
			LEFT join DimSalesOrder                                  on FactSalesOrder.DimSalesOrderId      = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb                              ON DimSalesOrder.SalesOrderId          = DimSalesOrder_pbb.SalesOrderId
			--Left Join DimSalesOrderView_pbb_tb DimSalesOrderView_pbb on DimSalesOrder.SalesOrderId          = DimSalesOrderView_pbb.SalesOrderId
		    JOIN pbbpdw01.transient.PBB_OrderInfo                poi ON poi.SalesOrderId                    = FactSalesOrder.SalesOrderId 
			                                                           -- and poi.DimServiceLocationId = FactSalesOrder.DimServiceLocationId
			LEFT JOIN DimAccount                                     ON FactSalesOrder.DimAccountId         = DimAccount.DimAccountId
			JOIN DimAccount_pbb                                      ON DimAccount.AccountId = DimAccount_pbb.AccountId
			LEFT JOIN DimDate                                        on FactSalesOrder.CreatedOn_DimDateId  = DimDate.DimDateID
			LEFT JOIN DimOpportunity                                 ON FactSalesOrder.dimopportunityid     = DimOpportunity.dimopportunityid
			Left join DimServiceLocation                             On poi.DimServiceLocationId            = DimServiceLocation.DimServiceLocationid
			Left Join DisconnectMRC                                  ON FactSalesOrder.DimSalesOrderId      = DisconnectMRC.DimSalesOrderId
			left join PBB_SalesOrder_Classification sc               on sc.SalesOrderId                     = DimSalesOrder_pbb.SalesOrderId
			left join MDUAddresses                              mdu  on mdu.DimServiceLocationId            = poi.DimServiceLocationId
		Where 1=1
		     and mdu.MDUAccountCode is null  -- Bulk Account
		     and DimSalesOrder.SalesOrderType in
									  (
									   'Install'
									  ,'Change'
									  ,'Disconnect'
									  ) 
			 and DimSalesOrder.SalesOrderNumber not in
											   (
												  select [SalesOrderNumber]
												  from [dbo].[PBB_ExcludeSalesFromDailyDashboardMonthlyDetail]
											   ) 
			And poi.pbb_OrderActivityType  In ('Install','Disconnect')
			and poi.CourtesyInternalFlag = 'N' 
			and DimSalesOrder.SalesOrderStatusReason <> 'Canceled'

			And cast(poi.ActualOrderDate as date) < @ReportDate
			And (Year(poi.ActualOrderDate) = Year(case
																when datepart(weekday,@ReportDate) = 2
																then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
															 end)
			And Month(poi.ActualOrderDate) = Month(case
																	 when datepart(weekday,@ReportDate) = 2
																	 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
																  end)))

	 
GO
