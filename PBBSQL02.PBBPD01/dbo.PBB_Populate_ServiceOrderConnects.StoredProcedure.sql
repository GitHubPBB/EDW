USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_ServiceOrderConnects]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--drop procedure dbo.[PBB_Populate_ServiceOrderConnects]
CREATE PROCEDURE [dbo].[PBB_Populate_ServiceOrderConnects]
AS


BEGIN
 
	DROP TABLE if exists rpt.PBB_ServiceOrderConnects;

	DROP TABLE if exists #PaymentLast6;
	DROP TABLE if exists #NonPayLast6;
	DROP TABLE if exists #TempAccountOrderDate ;


WITH AccountOrderDate AS (
          SELECT da.AccountCode, cast(dsop.pbb_SalesOrderReviewDate as date) ReviewDate
		    FROM FactSalesOrder     fso
			join DimSalesOrder      dso     ON fso.DimSalesOrderId = dso.DimSalesOrderId
			                                AND dso.SalesOrderType <> 'Disconnect'
			JOIN DimSalesOrder_pbb  dsop    ON dsop.SalesOrderId   = dso.SalesOrderId 
			JOIN DimAccount         da      ON fso.DimAccountId    = da.DimAccountId
		   GROUP BY da.AccountCode, cast(dsop.pbb_SalesOrderReviewDate as date)
 )
SELECT * INTO #TempAccountOrderDate FROM AccountOrderDate
;

CREATE unique index pk_t_AccountOrderDate on #TempAccountOrderDate(AccountCode, ReviewDate);

--------------------------------- ,PaymentLast6 AS (

 WITH PaidInvoices AS (
 SELECT AccountCode, 
                     ReviewDate, 
                     InvoiceID, 
                     Payment, 
                     InvoiceBilledAmount,
                     CASE
                         WHEN invoicebilledamount - Payment = 0
                         THEN 'Paid In Full'
                         WHEN invoicebilledamount - Payment > 0
                         THEN 'Partial'
                         ELSE 'None'
                     END AS Paid
              FROM 
				(
				 SELECT v.accountcode, ReviewDate,
						FORMAT(InvoiceDate, 'yyyy-MM') InvoiceDate, 
						InvoiceID, 
						SUM(InvoiceAdjustment) Payment, 
						invoicebilledamount
				   FROM pbbsql01.[OMNIA_EPBB_P_PBB_AR].[dbo].[CV_ARInvoiceAdjustmentAndTransactions_V100] v
				   JOIN #TempAccountOrderDate ta on ta.AccountCode = v.AccountCode 
				   WHERE(AdjustmentClass = 'Payment')
					 AND InvoiceDate BETWEEN(DATEADD(month, -6, ta.REviewDate)) AND ta.ReviewDate                    
								--	   AND accountcode = @AccountCode
				   GROUP BY v.accountcode,  ReviewDate,
							FORMAT(InvoiceDate, 'yyyy-MM'), 
							InvoiceID, 
							invoicebilledamount
				) x
		)
          SELECT AccountCode, ReviewDate,
                 SUM(PaidInvoicesLast6Months) PaidInvoicesLast6Months, 
                 SUM(PartialPaidInvoicesLast6Months) PartialPaidInvoicesLast6Months
		    INTO  #PaymentLast6
          FROM
          (
              SELECT AccountCode, ReviewDate,
                     CASE
                         WHEN Paid = 'Paid in Full'
                         THEN COUNT(DISTINCT InvoiceID)
                         ELSE 0
                     END AS PaidInvoicesLast6Months,
                     CASE
                         WHEN Paid = 'Partial'
                         THEN COUNT(DISTINCT InvoiceID)
                         ELSE 0
                     END AS PartialPaidInvoicesLast6Months
              FROM PaidInvoices
              GROUP BY accountcode, 
                       ReviewDate,
					   Paid
          ) p
          GROUP BY accountcode, ReviewDate
;

--------------------------------- NonPayLast6

With NonPaid AS ( 
		select nd.Accountcode, ReviewDate, count(distinct d.disconnectrun) NonPayCount 
		  from pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[CV_NoticeDisconnect_V100] nd
		  join pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[ArDisconnectRun]          d  on nd.DisconnectRun = d.DisconnectRun
		  JOIN #TempAccountOrderDate                                         ta on ta.AccountCode = nd.AccountCode 
		 where cast(d.DisconnectRunDate as date) between (dateadd(month,-6,ReviewDate)) and ReviewDate 
		 group by nd.accountcode, ReviewDate
)
 		  select *
		    INTO #NonPayLast6
		  	FROM NonPaid aod

 ;


 		Select Distinct 
			  FactSalesOrder.SalesorderID                              As 'SalesOrderId'
			 ,DimSalesOrder.SalesOrderNumber                           As 'SalesOrderNumber'
			-- ,FactSalesOrder.CreatedOn_DimDateId                       As 'CreatedOn_DimDateId'
			 ,DimSalesOrder.SalesOrderName                             As 'SalesOrderName'
			 ,DimSalesOrder.SalesOrderChannel                          As 'SalesOrderChannel'
			 ,DimSalesOrder.SalesOrderSegment                          As 'SalesOrderSegment'
			 ,cast(DimSalesOrder.SalesOrderProvisioningDate as date)   As 'SalesOrderProvisioningDate'
			 ,cast(DimSalesOrder.SalesOrderCommitmentDate as date)     As 'SalesOrderCommitmentDate'
			 ,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) as 'OrderReviewDate'
			 ,case
				 when FactSalesOrder.OrderClosed_DimDateId = '1900-01-01'
				 then null else FactSalesOrder.OrderClosed_DimDateId
			  end                                                      As 'CompletionDate'
			 ,AccountActivationDate
			 ,AccountDeactivationDate
			 ,DimSalesOrder.SalesOrderType                             As 'SalesOrderType'
			 ,DimSalesOrderView_pbb.pbb_OrderActivityType              AS 'OrderActivityType'
			 ,sc.SalesOrderClassification
			 /*
			 ,Case
				 when DimSalesOrder.SalesOrderType in('Install')
				 then ''
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
				 then 'Disconnect for Non Pay'
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
				 then 'Voluntary Disconnect' else ''
			  end                                                      as 'DisconnectType'
			 ,DR.DisconnectReason                                      as DisconnectReasonCategory
			 ,DimSalesOrder.SalesOrderDisconnectReason                 as DisconnectReason
			 */
			 ,DimSalesOrder.SalesOrderStatus                           As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderStatusReason                     As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderFulfillmentStatus        As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderPriorityCode      As 'SalesOrderPriorityCode'
			-- ,DimSalesOrder.SalesOrderProject           As 'SalesOrderProject'
			-- ,DimSalesOrder.SalesOrderProjectManager    As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner)      As 'SalesOrderOwner'
			 ,DimAccount.AccountCode As 'AccountCode'
			-- ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
			-- ,DimOpportunity.OpportunityBillingDate  As 'BillingDate'
			-- ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
			-- ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
			-- ,DimAccount.BillingAddressCity       As 'City'
			-- ,DimAccount.BillingAddressState      As 'State'
			-- ,DimAccount.BillingAddressCountry    As 'Country'
			-- ,DimAccount.BillingAddressPostalCode As 'ZIP'
			 ,DimAccountCategory.AccountClassCode As 'AccountClassCode'
			 ,DimAccountCategory.AccountClass     As 'AccountClass'
			 ,DimAccountCategory.AccountGroupCode As 'AccountGroupCode'
			 ,DimAccountCategory.AccountGroup     As 'AccountGroup'
			 ,DimAccountCategory.AccountType      As 'AccountType'
			 ,FactSalesOrder.SalesOrderTotalMRC   As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC
			 ,FactSalesOrder.SalesOrderTotalTax
			 ,FactSalesOrder.SalesOrderTotalAmount
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS AccountMarket
			 ,pbb_ReportingMarket AS ReportingMarket
			 ,pbb_marketsummary   AS MarketSummary
			 ,coalesce(coalesce(dslbt.PBB_BundleType,dslbt2.PBB_BundleType),dslbt3.PBB_BundleType) BundleType
			 ,DATEDIFF(month, accountactivationdate, ISNULL(AccountDeactivationDate, GETDATE())) Tenure
			 ,coalesce(PaidInvoicesLast6Months,0)        PaidInvoicesLast6Months
			 ,coalesce(PartialPaidInvoicesLast6Months,0) PartialPaidInvoicesLast6Months
			 ,coalesce(NonPayCount,0) AS NonPayCountLast6Months
			 ,DimServiceLocation.LocationId
			 ,DimServiceLocation.Latitude
			 ,DimServiceLocation.Longitude
			 ,DimServiceLocation.ServiceLocationStateAbbreviation ServiceLocationStateAbbrev
			 ,DimServiceLocation.ServiceLocationCity              ServiceLocationCity
			 ,DimServiceLocation.ServiceLocationPostalCode        ServiceLocationZip
			 ,DimServiceLocation.ServiceLocationFullAddress
			 ,1 AccountCount
			-- ,dimaccount.dimaccountid
			-- ,dimservicelocation.dimservicelocationid
		INTO rpt.PBB_ServiceOrderConnects
		FROM FactSalesOrder
			LEFT JOIN DimAccountCategory     ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			LEFT join DimSalesOrder          ON FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb      ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			Left Join DimSalesOrderView_pbb  ON DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
			LEFT JOIN DimAccount             ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
			JOIN DimAccount_pbb              ON DimAccount.AccountId = DimAccount_pbb.AccountId
			LEFT JOIN DimDate                ON FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimOpportunity         ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
			Left join DimServiceLocation     ON DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationid
			left join DimServiceLocationBundleType_pbb dslbt on  dslbt.DimAccountId = DimAccount.DimAccountId 
			                                                 and dslbt.DimServiceLocationID = DimServiceLocation.DimServiceLocationId
			                                                 and (  (DimSalesOrder.SalesOrderType = 'Disconnect' and dslbt.AsOfDimDateID = dateadd(d,-1,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)) )
															     or (DimSalesOrder.SalesOrderType <>'Disconnect' and dslbt.AsOfDimDateID = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) )
																 )
			left join DimServiceLocationBundleType_pbb dslbt2 on  dslbt2.DimAccountId = DimAccount.DimAccountId 
			                                                 and  dslbt2.DimServiceLocationID = DimServiceLocation.DimServiceLocationId
			                                                 and  DimSalesOrder.SalesOrderType = 'Disconnect' and dslbt2.AsOfDimDateID = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) 
			left join DimServiceLocationBundleType_pbb dslbt3 on  dslbt3.DimAccountId = DimAccount.DimAccountId 
			                                                 and  dslbt3.DimServiceLocationID = DimServiceLocation.DimServiceLocationId
			                                                 and  DimSalesOrder.SalesOrderType <> 'Disconnect' and dslbt3.AsOfDimDateID = dateadd(d,1,cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) )
			--Join DisconnectMRC                               ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
			left join PBB_SalesOrder_Classification sc       on sc.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
     		left join #PaymentLast6     pcl6m                 on pcl6m.AccountCode = 	DimAccount.AccountCode
			                                                 AND pcl6m.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
			left join #NonPayLast6      npl6m                 on npl6m.AccountCode = 	DimAccount.AccountCode
			                                                 AND npl6m.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
		Where DimSalesOrder.SalesOrderType in
									  (
									   'Install'
									 -- ,'Disconnect'
									  )
			 And DimSalesOrder.SalesOrderStatus <> 'Canceled'
			 And DimSalesOrder.OrderWorkflowName <> 'Billing Correction'
			 And DimSalesOrderView_pbb.pbb_OrderActivityType In('Install','Disconnect')
			 And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
			 And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
			 And cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) < CAST(getdate() as date) 
			;
	

  CREATE UNIQUE INDEX pk_PBB_ServiceOrderConnects ON rpt.PBB_ServiceOrderConnects (SalesorderID);

END
GO
