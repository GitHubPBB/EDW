USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_MONTHLY_DETAIL]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--  2022-09-12 Todd Boyer		Change for speed, FactCustomerItem does not contain uncompleted order detail
--
--

/*
select * from [dbo].[PBB_DB_MONTHLY_DETAIL_V2]('1/1/2022')
*/

CREATE FUNCTION [dbo].[PBB_DB_MONTHLY_DETAIL](
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
		    group by DimSalesOrder.DimSalesOrderId
		) 

		,Speeds AS (
		   select * from (
			select DimAccountId, DimServiceLocationId, Speed, row_number() over (partition by DimAccountId, DimServiceLocationId order by EffectiveStartDate desc) row_num
			  from (
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
				)    s   
 				JOIN dbo.FactCustomerItem fci on s.DimCatalogItemId = fci.DimCatalogItemId
			) y 
			where y.row_num = 1
			  and DimAccountId <> 0
		),

		SpeedsInstall AS (
		   select * from (
			select DimAccountId, DimServiceLocationId, Speed, row_number() over (partition by DimAccountId, DimServiceLocationId order by fci.DimCatalogitemId ) row_num
			  from (
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
				)    s   
 				JOIN dbo.FactSalesOrderLineItem fci on s.DimCatalogItemId = fci.DimCatalogItemId
			) y 
			where y.row_num = 1
			  and DimAccountId <> 0
		),

		Cabinet AS (
			SELECT chr_masterlocationid AS LocationId
				 , cus_Cabinet
				 , cus_ProjectCode 
				 , cus_CabinetName
				 , c.cus_name AS Cabinet
				 , cast(ps.ServiceableDate as date) ServiceableDate
			  FROM      PBBSQL01.[PBB_P_MSCRM].[dbo].[chr_servicelocationBase] slb with(NOLOCK) 
			  left join PBBSQL01.[PBB_P_MSCRM].[dbo].[cus_cabinetBase]         c with(NOLOCK) on c.cus_cabinetId = slb.cus_CabinetName
			  left join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrjServiceability]        ps on ps.ProjectName collate Latin1_General_CI_AI= cus_ProjectCode collate Latin1_General_CI_AI
			  where cus_cabinet is not null
				and cus_cabinet <>'Unknown'
		)

		--Internal Install/Disconnect 
		Select Distinct 
			  FactSalesOrder.SalesorderID              As 'SalesOrderId'
			 ,DimSalesOrder.SalesOrderNumber           As 'SalesOrderNumber'
			 ,FactSalesOrder.CreatedOn_DimDateId       As 'CreatedOn_DimDateId'
			 ,DimSalesOrder.SalesOrderDisconnectReason As DisconnectReason
			 ,Case
				 when DimSalesOrder.SalesOrderType in('Install')
				 then ''
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason = 'Total Disconnect for Non Pay'
				 then 'Disconnect for Non Pay'
				 when DimSalesOrder.SalesOrderType in('Disconnect')
					 and DimSalesOrder.SalesOrderDisconnectReason <> 'Total Disconnect for Non Pay'
				 then 'Voluntary Disconnect' else ''
			  end                                       As 'DisconnectType'
			 ,DimSalesOrder.SalesOrderName              As 'SalesOrderName'
			 ,DimSalesOrder.SalesOrderFulfillmentStatus As 'SalesOrderFulfillmentStatus'
			 ,DimSalesOrder.SalesOrderChannel           As 'SalesOrderChannel'
			 ,DimSalesOrder.SalesOrderSegment           As 'SalesOrderSegment'
			 ,DimSalesOrder.SalesOrderProvisioningDate  As 'SalesOrderProvisioningDate'
			 ,DimSalesOrder.SalesOrderCommitmentDate    As 'SalesOrderCommitmentDate'
			 ,DimOpportunity.OpportunityBillingDate     As 'BillingDate'
			 ,DimSalesOrder.SalesOrderType              As 'SalesOrderType'
			 ,DimSalesOrderView_pbb.pbb_OrderActivityType
			 ,DimSalesOrder.SalesOrderProject           As 'SalesOrderProject'
			 ,DimSalesOrder.SalesOrderProjectManager    As 'SalesOrderProjectManager'
			 ,upper(DimSalesOrder.SalesOrderOwner)      As 'SalesOrderOwner'
			 ,DimSalesOrder.SalesOrderStatusReason      As 'SalesOrderStatusReason'
			 ,DimSalesOrder.SalesOrderStatus            As 'SalesOrderStatus'
			 ,DimSalesOrder.SalesOrderPriorityCode      As 'SalesOrderPriorityCode'
			 ,DimAccount.AccountCode                    As 'AccountCode'
			 ,DimOpportunity.OpportunityCustomerName    As 'CustomerName'
			 ,DimAccount.AccountActivationDate
			 ,DimAccount.AccountDeactivationDate
			 ,case when DimSalesOrder.SalesOrderType = 'Install' then InstBundle.PBB_BundleType
			       else coalesce(coalesce(dslbt.PBB_BundleType,dslbt2.PBB_BundleType),dslbt3.PBB_BundleType) end BundleType
			 ,case when DimSalesOrder.SalesOrderType = 'Disconnect' 
			            and coalesce(coalesce(dslbt.PBB_BundleType,dslbt2.PBB_BundleType),dslbt3.PBB_BundleType) in ('Phone Only')
			       then ''
				   when DimSalesOrder.SalesOrdertype = 'Install' and InstBundle.PBB_BundleType = 'Phone Only' then ''
				   else coalesce(Speeds.Speed, SpeedsInstall.Speed)
			   end Speed
	--		 ,coalesce(proj.pbb_LocationProjectCode,Cabinet.Cus_projectcode)           As ProjectCode
 	 --        ,proj.pbb_LocationProjectCode           As ProjectCode
 	         ,case when DimServiceLocation.ProjectName  like 'PC%' then substring(DimServiceLocation.ProjectName,4,99) 
			       else DimServiceLocation.ProjectName 
				   end     ProjectCode
 	--         ,case when Cabinet.cus_projectcode  like 'PC%' then substring(Cabinet.cus_projectcode,4,99) else cabinet.cus_projectcode end              As ProjectCode
			 ,coalesce(proj.ServiceableDate , Cabinet.ServiceableDate)                 As ProjectServiceableDate
	--		 ,Cabinet.Cabinet
			 ,DimServiceLocation.Cabinet
			 ,Disco.Orig_InstallOrderChannel
			 ,Disco.Orig_InstallSalesAgent
			 ,Disco.Orig_InstallOrderOwner

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
			 ,DimServiceLocation.FullAddress ServiceLocationFullAddress
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
			 ,SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			 ,pbb_marketsummary
			 ,pbb_ReportingMarket
			 ,dimaccount.dimaccountid
			 ,dimservicelocation.dimservicelocationid
			 ,sc.SalesOrderClassification
		from FactSalesOrder
			LEFT JOIN DimAccountCategory     ON FactSalesOrder.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			LEFT JOIN DimAccountCategory_pbb on DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			LEFT join DimSalesOrder          on FactSalesOrder.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			LEFT JOIN DimSalesOrder_pbb      ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			Left Join DimSalesOrderView_pbb  on DimSalesOrder.SalesOrderId = DimSalesOrderView_pbb.SalesOrderId
			LEFT JOIN DimAccount             ON FactSalesOrder.DimAccountId = DimAccount.DimAccountId
			JOIN DimAccount_pbb              ON DimAccount.AccountId = DimAccount_pbb.AccountId
			LEFT JOIN DimDate                on FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimOpportunity         ON FactSalesOrder.dimopportunityid = DimOpportunity.dimopportunityid
	--		Left join DimServiceLocation     On DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationid
			LEFT JOIN rpt.DimAddress DimServiceLocation     ON DimSalesOrderView_pbb.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			Left Join DisconnectMRC          ON FactSalesOrder.DimSalesOrderId = DisconnectMRC.DimSalesOrderId
			left join PBB_SalesOrder_Classification sc on sc.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
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

			left join Speeds                 ON Speeds.DimAccountId = DimAccount.DimAccountId and Speeds.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			left join SpeedsInstall          ON SpeedsInstall.DimAccountId = DimAccount.DimAccountId and SpeedsInstall.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			left join [rpt].[PBB_ServiceOrderDisconnects] disco on disco.SalesOrderNumber = DimSalesOrder.SalesOrderNumber
			left join (SELECT distinct
							   [pbb_DimServiceLocationId]
							  ,[LocationId]
							  ,[pbb_LocationProjectCode]
							  ,prjs.ServiceableDate
						  FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation_pbb] dsl
						  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PrjServiceability]      prjs on prjs.ProjectName = dsl.pbb_LocationProjectCode
			          ) Proj on Proj.pbb_DimServiceLocationId = DimServiceLocation.DimServiceLocationId
			left join Cabinet on Cabinet.LocationId   =  DimServiceLocation.LocationId
			left join [dbo].[PBB_SalesOrderBundleType_UseForInstallsOnly] InstBundle on InstBundle.SalesOrderNumber = DimSalesOrder.SalesOrderNumber
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
