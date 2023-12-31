USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_ServiceOrderDisconnects_old]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--drop procedure dbo.[PBB_Populate_ServiceOrderConnects]
CREATE PROCEDURE [dbo].[PBB_Populate_ServiceOrderDisconnects_old]
AS


BEGIN
 
	DROP TABLE if exists rpt.PBB_ServiceOrderDisconnects;

	DROP TABLE if exists #PaymentLast6;
	DROP TABLE if exists #NonPayLast6;
	DROP TABLE if exists #PTPCountLast6;
	DROP TABLE if exists #DelinquentLast6;
	DROP TABLE if exists #TempAccountOrderDate ;
	DROP TABLE if exists #TempSpeeds;
	


WITH Speeds AS (
select * 
     , case when gb_mult > 1 and len(DownLoadRate) < 4 then concat(DownloadRate*gb_mult,'/',UploadRate*gb_mult) else Speed_dci end Speed
  from (
		select DimCatalogItemId
			  ,ProductComponentId
			  ,dci.ComponentCode
			  ,ComponentName
			  ,case when ComponentName like '%GB%' then 1000 else 1 end gb_mult
			  ,DownloadRate
			  ,UploadRate
			  ,concat(DownloadRate,'/',UploadRate) Speed_dci 
			  ,concat(DownloadMB,'/',UploadMB) Speed_pcm
		  FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] dci
		  join dbo.PrdComponentMap                          pcm on pcm.ComponentCode = dci.ComponentCode
		  where DownloadRate is not null and trim(DownloadRate)<> ''
		) x
)
select * into #TempSpeeds 
  from 
	(
	select DimAccountId, Speed, row_number() over (partition by DimAccountId order by EffectiveStartDate desc) row_num
	FROM dbo.FactCustomerItem fci
	JOIN Speeds               s    on s.DimCatalogItemId = fci.DimCatalogItemId
	) y 
where y.row_num = 1
; 


WITH AccountOrderDate AS (
          SELECT da.AccountCode, cast(dsop.pbb_SalesOrderReviewDate as date) ReviewDate
		    FROM FactSalesOrder     fso
			join DimSalesOrder      dso     ON fso.DimSalesOrderId = dso.DimSalesOrderId
			                                AND dso.SalesOrderType = 'Disconnect'
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
WITH PTPMonth
          AS (	SELECT aa.AccountCode
		             , ReviewDate 
				     , COUNT(PromiseDate) PTPCount
				  FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount      AS AA  WITH(NOLOCK)
				  JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP WITH(NOLOCK) ON AA.AccountID = PTP.AccountID
		          JOIN #TempAccountOrderDate                              ta on ta.AccountCode = aa.AccountCode 
		         WHERE cast(ptp.PromiseDate as date) between (dateadd(month,-6,ReviewDate)) and ReviewDate 
				 GROUP BY aa.AccountCode,ReviewDate
		  )
          SELECT AccountCode, ReviewDate, PTPCount
		   INTO #PTPCountLast6
          FROM PTPMonth
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

--------------------------------- DelinquentInvoiceLast6
WITH DelinquentLast6 AS  (
		  select d.accountcode, d.accountid, ReviewDate, count(br.BillingInvoiceDate) DelinquentInvoiceCount --, 
			from FactBilledAccount      f
			join DimBillingRun          br on f.DimBillingRunId = br.DimBillingRunId
			join dimaccount             d  on f.DimAccountId    = d.DimAccountId
		    JOIN #TempAccountOrderDate  ta on ta.AccountCode    = d.AccountCode   
		   where f.dimaccountid <> 0
			 and billinginvoicedate between (dateadd(month,-6,ReviewDate)) and ReviewDate
			 and PreviousBalanceAmount > 20
		   group by d.accountcode, d.accountid, ReviewDate
)
 		  select *
		    INTO #DelinquentLast6
		  	FROM DelinquentLast6 aod
 ;

 WITH DisconnectReason AS ( 
		 SELECT 'Billing Correction' AS SalesOrderDisconnectReason  , 'Billing Correction' AS DisconnectReason  UNION ALL 
		 SELECT 'Competition - Charter' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Competition - Comcast' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Competition - Dish' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Competition - Other' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Competition - Verizon' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Competitor' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade - Financial Issues' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade - Streaming TV' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade Cell Phone' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade Competition - Charter' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade Competition - Other' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade Competition - Verizon' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Downgrade Competition- Century Link' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  UNION ALL 
		 SELECT 'Business Closure' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'Financial Issues' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'House Fire' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'Price' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'Rate Increase' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'Temporary - Financial' AS SalesOrderDisconnectReason  , 'Financial' AS DisconnectReason  UNION ALL 
		 SELECT 'Moving' AS SalesOrderDisconnectReason  , 'Moving' AS DisconnectReason  UNION ALL 
		 SELECT 'Moving in with Family Member' AS SalesOrderDisconnectReason  , 'Moving' AS DisconnectReason  UNION ALL 
		 SELECT 'Moving out of Service Area' AS SalesOrderDisconnectReason  , 'Moving' AS DisconnectReason  UNION ALL 
		 SELECT 'Moving out of Service Area - No Service' AS SalesOrderDisconnectReason  , 'Moving' AS DisconnectReason  UNION ALL 
		 SELECT 'NonPay' AS SalesOrderDisconnectReason  , 'NonPay' AS DisconnectReason  UNION ALL 
		 SELECT 'Total Disconnect for Non Pay' AS SalesOrderDisconnectReason  , 'NonPay' AS DisconnectReason  UNION ALL 
		 SELECT 'Cell Phone' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Cell Phone Only' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Convert to OptiPro' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Deceased' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Doesn''t Use' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Other' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Test Account' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Seasonal' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Temporary - Snowbird' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason  UNION ALL 
		 SELECT 'Customer/Technical Support' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason  UNION ALL 
		 SELECT 'Service related issues - All services' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason  UNION ALL 
		 SELECT 'Service related issues - Cable' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason  UNION ALL 
		 SELECT 'Service related issues - Data' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason  UNION ALL 
		 SELECT 'Service related issues - Voice' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason  UNION ALL 
		 SELECT 'Unhappy with Service' AS SalesOrderDisconnectReason  , 'Service' AS DisconnectReason     
		 -- [SUNIL] added more DisconnectReason on 07/18
		UNION ALL 
		 SELECT 'Competition - Direct TV' AS SalesOrderDisconnectReason  , 'Competition' AS DisconnectReason  		 UNION ALL 
		 SELECT 'Streaming TV' AS SalesOrderDisconnectReason  , 'Other' AS DisconnectReason     	 UNION ALL 
		 SELECT 'Downgrade - Verizon' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason     		 UNION ALL 
		 SELECT 'Downgrade Competition - Comcast' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason     		 UNION ALL  
		 SELECT 'Downgrade Competition - Direct TV' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason     		 UNION ALL  
		 SELECT 'Downgrade Streaming TV' AS SalesOrderDisconnectReason  , 'Downgrade' AS DisconnectReason  
 )
 ,

 FirstInstall AS (
	select * from (
	      select AccountCode
		       , SalesOrderNumber Orig_InstallOrderNumber
		       , SalesOrderName   Orig_InstallOrderName
			   , SalesOrderType   Orig_InstallType
			   , SalesOrderStatus Orig_InstallStatus
			   , da.DimAccountId
			   , cast(SalesOrderProvisioningDate as date) Orig_SalesOrderProvisioningDate
			   , OrderClosed_DimDateId
			   ,cast(dsop.pbb_SalesOrderReviewDate as date)    as Orig_InstallOrderBillReviewDate
			   ,dso.SalesOrderChannel                          As Orig_InstallOrderChannel
			   ,dso.SalesOrderSegment                          As Orig_InstallOrderSegment
			   ,upper(dso.SalesOrderOwner)                     As Orig_InstallOrderOwner
			   ,son.AgentName Orig_InstallSalesAgent
               ,row_number() over (partition by AccountCode order by SalesOrderProvisioningDate) SortOrder
		    FROM FactSalesOrder     fso
			join DimSalesOrder      dso     ON fso.DimSalesOrderId = dso.DimSalesOrderId
			                                AND SalesOrderStatus <> 'Canceled'
			JOIN DimSalesOrder_pbb  dsop    ON dsop.SalesOrderId   = dso.SalesOrderId 
			JOIN DimAccount         da      ON fso.DimAccountId    = da.DimAccountId
			LEFT JOIN              (
						select x.*, y.AgentName 
						  from (
								select DimSalesOrderId, max(DimAgentId) DimAgentId 
								  from dbo.FactSalesOrderItemAgent 
								 group by DimSalesOrderId
							   ) x
						  join dbo.DimAgent y on x.DimAgentId = y.DimAgentId
						) son on son.DimSalesOrderId = fso.DimSalesOrderId


	) x
	where SortOrder =1
	  and Orig_InstallType = 'Install'
 )
 ,

 PortalCustomer AS (
            SELECT *
              FROM
              (
                  SELECT BillingAccountID, 
                         ROW_NUMBER() OVER(PARTITION BY BillingAccountID
                         ORDER BY CAST(CB.CreatedDateTime AS DATE) DESC) AS [Row],
                         CASE
                             WHEN cw.UserName IS NOT NULL
                             THEN 'Y'
                             ELSE 'N'
                         END AS PortalUserExists, 
                         Email AS PortalEmail
                  FROM pbbsql01.CHRWEB.dbo.CHRWebUser_BillingAccount CB
                       JOIN pbbsql01.CHRWEB.dbo.chrwebuser cw ON cb.chrwebuserid = cw.CHRWebUserID
                  WHERE ishomebillingaccountid = 1
                        AND isenabled = 1
                        AND recordstatusid = 1
              ) inr
              WHERE row = 1
)

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

			 ,DimSalesOrder.SalesOrderStatus                           As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderStatusReason                     As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderFulfillmentStatus                As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderPriorityCode                     As 'SalesOrderPriorityCode'
			-- ,DimSalesOrder.SalesOrderProject           As 'SalesOrderProject'
			-- ,DimSalesOrder.SalesOrderProjectManager    As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner)                     As 'SalesOrderOwner'
			 ,DimAccount.AccountCode                                   As 'AccountCode'
			-- ,DimOpportunity.OpportunityCustomerName As 'CustomerName'
			-- ,DimOpportunity.OpportunityBillingDate  As 'BillingDate'
			-- ,DimAccount.BillingAddressStreetLine1 As 'BillingAddressLine1'
			-- ,DimAccount.BillingAddressStreetLine2 As 'BillingAddressLine2'
			-- ,DimAccount.BillingAddressCity       As 'City'
			-- ,DimAccount.BillingAddressState      As 'State'
			-- ,DimAccount.BillingAddressCountry    As 'Country'
			-- ,DimAccount.BillingAddressPostalCode As 'ZIP'
			 ,DimAccountCategory.AccountClassCode                      As 'AccountClassCode'
			 ,DimAccountCategory.AccountClass                          As 'AccountClass'
			 ,DimAccountCategory.AccountGroupCode                      As 'AccountGroupCode'
			 ,DimAccountCategory.AccountGroup                          As 'AccountGroup'
			 ,DimAccountCategory.AccountType                           As 'AccountType'
			 ,FactSalesOrder.SalesOrderTotalMRC                        As 'SalesOrderTotalMRC'
			 ,FactSalesOrder.SalesOrderTotalNRC
			 ,FactSalesOrder.SalesOrderTotalTax
			 ,FactSalesOrder.SalesOrderTotalAmount
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS AccountMarket
			 ,pbb_ReportingMarket AS ReportingMarket
			 ,pbb_marketsummary   AS MarketSummary
			 ,coalesce(coalesce(dslbt.PBB_BundleType,dslbt2.PBB_BundleType),dslbt3.PBB_BundleType) BundleType
			 ,Speed.Speed
			 ,DATEDIFF(month, accountactivationdate, ISNULL(AccountDeactivationDate, GETDATE()))   Tenure
			 ,coalesce(PaidInvoicesLast6Months,0)        PaidInvoicesLast6Months
			 ,coalesce(PartialPaidInvoicesLast6Months,0) PartialPaidInvoicesLast6Months
			 ,coalesce(NonPayCount,0) AS                 NonPayCountLast6Months
			 ,coalesce(PTPCount,0)                       PTPCountLast6Months
			 ,coalesce(DelinquentInvoiceCount,0)         DelinquentInvoicesLast6Months
			 ,DimServiceLocation.LocationId
			 ,DimServiceLocation.Latitude
			 ,DimServiceLocation.Longitude
			 ,DimServiceLocation.ServiceLocationStateAbbreviation ServiceLocationStateAbbrev
			 ,DimServiceLocation.ServiceLocationCity              ServiceLocationCity
			 ,DimServiceLocation.ServiceLocationPostalCode        ServiceLocationZip
			 ,DimServiceLocation.ServiceLocationFullAddress
			 , case when DimAccount.PrintGroup ='Electronic Invoice' then 'EBill' else 'Paper' end PrintGroup
			 , case when DimAccount.AccountAchStatus = 'Live' then 'ACH' 
			        when coalesce(rpm.Method,'') = 'Recurring Card' then rpm.Method else null end RecurringPaymentMethod
			 , case when coalesce(Portal.PortalUserExists,'') = 'Y' then 'Y' else 'N' end PortalUserExists
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

			 ,DimAccount.DimAccountId
			 ,1 AccountCount
			-- ,dimaccount.dimaccountid
			-- ,dimservicelocation.dimservicelocationid
		INTO rpt.PBB_ServiceOrderDisconnects
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
			left join DisconnectReason DR                    ON trim(DR.SalesOrderDisconnectReason) =  trim(coalesce ( DimSalesOrder.SalesOrderDisconnectReason , 'Other' ))
			left join PBB_SalesOrder_Classification sc       on sc.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
     		left join #PaymentLast6     pcl6m                 on pcl6m.AccountCode = 	DimAccount.AccountCode
			                                                 AND pcl6m.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
			left join #NonPayLast6      npl6m                 on npl6m.AccountCode = 	DimAccount.AccountCode
			                                                 AND npl6m.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
			left join #PTPCountLast6    ptpc                 on ptpc.AccountCode = 	DimAccount.AccountCode
			                                                 AND ptpc.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
			left join #DelinquentLast6  Del6                 on Del6.AccountCode = 	DimAccount.AccountCode
			                                                 AND Del6.ReviewDate = cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date)
			left join FirstInstall      fi                   on  fi.DimAccountId = DimAccount.DimAccountId
			left join [dbo].[PBB_AccountRecurringPaymentMethod]  rpm on rpm.AccountCode = DimAccount.AccountCode 
			                                                 and rpm.Method = 'Recurring Card'
			left join PortalCustomer      portal             on  portal.BillingAccountID = DimAccount.AccountCode
			left join #TempSpeeds       Speed                on  Speed.DimAccountId = DimAccount.DimAccountId
		Where DimSalesOrder.SalesOrderType in
									  (
									 --  'Install'
									   'Disconnect'
									  )
			 And DimSalesOrder.SalesOrderStatus <> 'Canceled'
			 And DimSalesOrder.OrderWorkflowName <> 'Billing Correction'
			 And DimSalesOrderView_pbb.pbb_OrderActivityType In('Install','Disconnect')
			 And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
			 And DimAccount_pbb.pbb_AccountDiscountNames not like '%Courtesy%'
			 And cast(DimSalesOrder_pbb.pbb_SalesOrderReviewDate as date) < CAST(getdate() as date) 
			;
	

  CREATE UNIQUE INDEX pk_PBB_ServiceOrderDisconnects ON rpt.PBB_ServiceOrderDisconnects (SalesorderID);

END
GO
