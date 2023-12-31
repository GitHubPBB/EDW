USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_SDMPROTO]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

-- =============================================
-- Author:		Todd Boyer
-- Create date: 2022
-- Description:	The primary purpose of this procedure is to create a DataSet ready for Tableau
-- =============================================
--drop procedure dbo.[PBB_Populate_SDMPROTO]
CREATE PROCEDURE [dbo].[PBB_Populate_SDMPROTO]
	(@CycleDate date)
AS


BEGIN
 


	-- Declare @CycleDate date='20231013';
	 drop table if exists dbo.SDM_PROTO_stage_tb;


	 Declare @RangeStartDt date = @CycleDate, @RangeEndDt date = @CycleDate; 

	 WITH
	 bulk_ac AS ( 
       	   SELECT *
      	  FROM (
            	SELECT *
            	FROM (
                  	  SELECT ma.*
                        	,fsla.DimAccountid
                        	,da.AccountCode
                        	,row_number() OVER ( PARTITION BY ma.DimServiceLocationId ORDER BY da.DimAccountId DESC ) acct_cnt
                  	  FROM (
                        	SELECT DISTINCT dsl.DimServiceLocationId
                              	  ,dsl.LocationId
                              	  ,dc.cus_DistributionCenterName AS DistributionCenter
								  ,cast(dc.CreatedOn as date) DCcreatedOnDt
                              	  ,ab.AccountNumber AS MDUAccountCode
                              	  ,csl.chr_name
                              	  ,csl.chr_apartment
							-- select *
                        	FROM PBBPDW01.Transient.cus_DistributionCenterBase dc
                        	JOIN PBBPDW01.Transient.chr_servicelocation        csl ON dc.cus_distributioncenterId = csl.cus_ServiceLocationsId
                        	JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation    dsl ON dsl.locationid = csl.chr_masterlocationid
                        	JOIN PBBPDW01.Transient.AccountBase                ab  ON ab.AccountId = dc.cus_BulkBillingAccount /*-- Get the BULK master account */
                        	) ma
                  	  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.PBB_ServiceLocationAccountALL fsla ON fsla.DimServiceLocationId = ma.DimServiceLocationId
                        	AND fsla.LocationAccountDeactivationDate > GETDATE()
                  	  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccount             da  ON da.DimAccountId = fsla.dimAccountId
                      	  --  AND coalesce(da.AccountStatus, '') <> 'Inactive'
                  	  WHERE 1 = 1 /* --(MDUAccountCode is not null or fsla.DimAccountId <> 0) */
                  	  ) z
            	WHERE NOT ( acct_cnt > 1 AND DimAccountId = 0 ) ) MDUAddTenant
      	  WHERE MDUAccountCode <> AccountCode COLLATE DATABASE_DEFAULT
            	AND coalesce(AccountCode, '') <> '' 

	)
	 SELECT   dt.DimDateId AsOfDate,x.DimAccountId, dc.AccountCode, dsl.DimServiceLocationId, dsl.LocationId, dac.AccountTypeCode
				   , SUBSTRING(dacp.pbb_AccountMarket,4,255) AccountMarket
			   
				  ,CASE
					  WHEN SUM(pcm.IsCableSvc) = 0
						 -- AND SUM(pcm.IsDataSvc) = 0
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) =0
						  AND (SUM(pcm.IsLocalPhn) >= 1
							  or SUM(pcm.IsComplexPhn) >= 1)
					  THEN 'Phone Only'
					  WHEN SUM(pcm.IsCableSvc) = 0
						--  AND SUM(pcm.IsDataSvc) >= 1
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) > 0
						  AND SUM(pcm.IsLocalPhn) = 0
						  AND SUM(pcm.IsComplexPhn) = 0
					  THEN 'Internet Only'
					  WHEN SUM(pcm.IsCableSvc) >= 1
						 -- AND SUM(pcm.IsDataSvc) = 0
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) =0
						  AND SUM(pcm.IsLocalPhn) = 0
						  AND SUM(pcm.IsComplexPhn) = 0
					  THEN 'Cable Only'
					  WHEN SUM(pcm.IsCableSvc) >= 1
						--  AND SUM(pcm.IsDataSvc) = 0
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) =0
						  AND (SUM(pcm.IsLocalPhn) >= 1
							  or SUM(pcm.IsComplexPhn) >= 1)
					  THEN 'Double Play-Phone/Cable'
					  WHEN SUM(pcm.IsCableSvc) = 0
						--  AND SUM(pcm.IsDataSvc) >= 1
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) > 0
						  AND (SUM(pcm.IsLocalPhn) >= 1
							  or SUM(pcm.IsComplexPhn) >= 1)
					  THEN 'Double Play-Internet/Phone'
					  WHEN SUM(pcm.IsCableSvc) >= 1
						 -- AND SUM(pcm.IsDataSvc) >= 1
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) > 0
						  AND SUM(pcm.IsLocalPhn) = 0
						  AND SUM(pcm.IsComplexPhn) = 0
					  THEN 'Double Play-Internet/Cable'
					  WHEN SUM(pcm.IsCableSvc) >= 1
						--  AND SUM(pcm.IsDataSvc) >= 1
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) > 0
						  AND (SUM(pcm.IsLocalPhn) >= 1
							  or SUM(pcm.IsComplexPhn) >= 1)
					  THEN 'Triple Play-Internet/Phone/Cable'
					  WHEN SUM(pcm.IsCableSvc) = 0
						 -- AND SUM(pcm.IsDataSvc) = 0
						  AND SUM(pcm.IsDataSvc + case when Component in ( 'Performance Plus Promo','Gig Special') then 1 else 0 end) =0
						  AND SUM(pcm.IsLocalPhn) = 0
						  AND SUM(pcm.IsComplexPhn) = 0
					  THEN 'None' ELSE 'Other'
				   END AS PBB_BundleType
				   , case when blk.DimAccountId is not null then 'Y' else 'N' end BulkTenantFlag
				   , max(coalesce(Courtesy_Internal.Courtesy,'N')) Courtesy
				   , max(coalesce(Courtesy_Internal.InternalUse,'N')) InternalUse
				   , min(dcp.ProductStatusCode) MaxProductStatus
				   , sum( x.ItemPrice )  MRC 
				   , sum( case when  ( pcm.IsDataSvc + pcm.IsLocalPhn + pcm.IsComplexPhn + pcm.IsCableSvc  > 0  
				                       or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') 
									 )  then 1 else 0 end ) ServiceItem

								  INTO dbo.SDM_PROTO_stage_tb
								  FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation      dsl  on x.DimServiceLocationId = dsl.DimServiceLocationId							 
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount              dc   ON x.DimAccountId         = dc.DimAccountId 
																							  AND coalesce(AccountCode,'')  <> ''
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCustomerProduct      dcp  ON dcp.DimCustomerProductId = x.DimCustomerProductId
																						--	  AND dcp.ProductStatusCode <> 'I'
								  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory dac  on dac.DimAccountCategoryId = x.DimAccountCategoryId
								  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount_pbb     dap  on dap.AccountId = dc.AccountId
								  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory_pbb dacp ON dacp.SourceId = dac.SourceId
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimDate                 dt   on 1=1
																							  and dt.DimDateId  between @RangeStartDt and @RangeEndDt
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
								  JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
								  LEFT JOIN Bulk_AC                                      blk  ON blk.DimAccountId      = x.DimAccountId
								  LEFT JOIN ( SELECT DISTINCT DimAccountId ,  cast(EffectiveStartdate as date) EffectiveStartDt
													, cast(EffectiveEndDate as date) EffectiveEndDt
													, Deactivation_DimDateId, case when component like '%Courtesy%' then 'Y' else 'N' end Courtesy
													, case when Component like '%Internal use only%' then 'Y' else 'N' end InternalUse
                                                            	FROM [OMNIA_EPBB_P_PBB_DW].dbo.factcustomeritem
                                                            	LEFT JOIN  [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem ON  factcustomeritem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
                                                            	LEFT JOIN  [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap cm ON  DimCatalogItem.ComponentCode = cm.ComponentCode
                                                            	WHERE  (component like '%Courtesy%' or component like '%Internal use only%')
											)                                Courtesy_Internal ON  Courtesy_Internal.DimAccountId =  x.DimAccountId  
																							   AND Courtesy_Internal.EffectiveStartDt <=dt.DimDateId
																							   AND Courtesy_Internal.EffectiveEndDt   > dt.DimDateId
		                    						  
	                              LEFT JOIN	TempAcctItems ih on  ih.ItemId = x.itemId
								 WHERE 1=1
								   AND cast(x.EffectiveStartDate as date) <= cast(dt.DimDateId as date)
								   AND cast(x.EffectiveEndDate   as date) >  cast(dt.DimDateId as date)
								   AND right(x.SourceId,2) <> '.N' 
							       AND x.Deactivation_DimDateId > cast(x.EffectiveStartDate as date) 
								   AND x.Deactivation_DimDateId > @CycleDate
								   -- and x.dimaccountid= 751780

		GROUP BY  dt.DimDateId, x.DimAccountId, dc.AccountCode, dsl.DimServiceLocationId, dsl.LocationId, dac.AccountTypeCode, SUBSTRING(dacp.pbb_AccountMarket,4,255)  
				   , case when blk.DimAccountId is not null then 'Y' else 'N' end 
				--   , Courtesy_Internal.Courtesy, Courtesy_Internal.InternalUse 
		;


	/*
	select * from SDM_PROTO_stage_tb order by DimAccountId, AsOfDate
	select * from SDM_PROTO_Daily_tb  
	select * from SDM_PROTO_stage_tb where AccountCode = '100000126'
	*/

	-------------------------------------------------------------------


	-- INCREMENTAL LOAD

	-- Declare @CycleDate date='20231013';

	-- Identify Gain (no match) (could be Move)
			DROP TABLE if exists #TempGainSubsT;

			SELECT distinct s.DimAccountId, s.DimServiceLocationId,  @CycleDate AsOfDate, SalesOrderNumber, SalesOrderType, s.ServiceItem
			  INTO #TempGainSubsT
			  FROM SDM_PROTO_stage_tb                              s
			  LEFT JOIN OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily t on  s.DimAccountId         = t.DimAccountId
																	 and s.DimServiceLocationId = t.DimServiceLocationId
																	 and t.MetaEffectiveEndDate = '20500101'
			  LEFT JOIN (
					     select DimAccountId, DimServiceLocationId, SalesOrderNumber, SalesOrderType, SalesOrderDisconnectReason 
			               from  pbbpdw01.transient.PBB_OrderInfo   
						  where ActualOrderDate = @CycleDate
						    and pbb_OrderActivityType = 'Install'    
						)  so on  so.DimAccountId          = s.DimAccountId
						      and so.DimServiceLocationId  = s.DimServiceLocationId 
			  WHERE t.DimAccountId is null
			;



		-- Identify matching but with differences
			DROP TABLE if exists #TempMatchDiffs;

			SELECT t.DimAccountId, t.DimServiceLocationId, s.AsOfDate
				 , case when s.PBB_BundleType <> t.BundleType                then 'BUNDLE CHANGE'            else null end PkgChange
				 , case when s.BulkTenantFlag ='Y' and t.BulkTenantFlag ='N' then 'BULK CHANGE-ADD'          else null end BulkAdd
				 , case when s.BulkTenantFlag ='N' and t.BulkTenantFlag ='Y' then 'BULK CHANGE-REMOVE'       else null end BulkRemove
				 , case when s.Courtesy       ='Y' and t.CourtesyFlag   ='N' then 'COURTESY DISCOUNT-ADD'    else null end CourtesyAdd
				 , case when s.Courtesy       ='N' and t.CourtesyFlag   ='Y' then 'COURTESY DISCOUNT-REMOVE' else null end CourtesyRemove
				 , case when s.MRC <> t.MRC then 'Y' else 'N' end MRCdiff
				 , t.MRC pMRC
				 , s.MRC nMRC
				 , s.PBB_BundleType BundleType
				 , t.BundleType   PreviousBundleType
				 , case when  s.PBB_BundleType <> t.BundleType  then bt.TransitionType else null end BundleTransition
				 , t.ProductState           PreviousProductState
				 , t.SubscriberLossCount    PreviousSubscriberLoss
				 , t.SubscriberMoveOutCount PreviousSubscriberMoveOut
				 , t.SubscriberEndCount     PreviousSubscriberEndCount
				 , t.ExcludeReason          PrevExcludeReason
				 , case when t.ExcludeReason is     null and (s.BulkTenantFlag='Y' or  s.Courtesy='Y' or  s.InternalUse='Y' or  s.PBB_BundleType= 'None' ) then 'Y' else 'N' end ExclusionAdded
				 , case when t.ExcludeReason is not null and (s.BulkTenantFlag='N' and s.Courtesy='N' and s.InternalUse='N' and s.PBB_BundleType<>'None' ) then 'Y' else 'N' end ExclusionDropped
				 , case when so1.SalesOrderType ='Location Change' and s.MRC =0 and tg.DimAccountId is not null then 'Y'
				        when so1.SalesOrderType ='Disconnect'                   then 'N'
				        when so1.SalesOrderType is null and so2.SalesOrderType = 'Disconnect' then 'N'
				        when s.PBB_BundleType <> t.BundleType  and tg.DimAccountId is not null and bt.TransitionType ='Lost' then 'Y' 
				        else 'N' end PossibleMove
				 , t.ExcludeReason
				 , case when s.BulkTenantFlag='Y'    then 'BULK TENANT'
			            when s.Courtesy='Y'          then 'COURTESY'
			            when s.InternalUse ='Y'      then 'INTERNAL USE'
			            when s.PBB_BundleType='None' then 'NO ACTIVE SERVICE'
			            else null end NewExcludeReason
				  , so1.SalesOrderNumber, so1.SalesOrderType
				  , so2.SalesOrderNumber D2SalesOrderNumber, so2.SalesOrderType D2SalesOrderType
				  , so1.SalesOrderDisconnectReason
			  INTO #TempMatchDiffs
			  FROM SDM_PROTO_stage_tb s
			  JOIN OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily t on  s.DimAccountId         = t.DimAccountId
										and s.DimServiceLocationId = t.DimServiceLocationId
										and t.MetaEffectiveEndDate = '20500101' 
			  LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PBB_BundleTransition  bt ON  t.BundleType     = bt.BundleType
																		   AND s.PBB_BundleType = bt.ToBundleType
			  LEFT JOIN (select DimAccountId, DimServiceLocationId from #TempGainSubsT) tg on tg.DimAccountId = t.DimAccountId and tg.DimServiceLocationId <> t.DimServiceLocationId
			  LEFT JOIN (			      
				SELECT dso.DimSalesOrderId                                        AS DimSalesOrderId
		           ,dso.SalesOrderId                                                AS SalesOrderId
				   ,dso.SalesOrderNumber
				   ,dso.SalesOrderType   
				   ,dso.SalesOrderStatus
				   ,dso.SalesOrderDisconnectReason
				   ,coalesce(fsoli.DimAccountId,da.DimAccountId)                    AS DimAccountId
				   ,coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId)   AS DimServiceLocationId
				   ,MIN(case when fsoli.DimAccountid is null then 'OC' else 'FSO' end)   AS Source
				   ,MIN(DATEADD(HOUR,-4,dsop.pbb_SalesOrderReviewDate))                  AS pbb_SalesOrderReviewDate
				   ,MIN(coalesce(fsoli.OrderClosed_DimDateId,fso.OrderClosed_DimDateId)) AS OrderClosed_DimDateId
				   , row_number() over (partition by coalesce(fsoli.DimAccountId,da.DimAccountId)   order by SalesOrderNumber desc) row_cnt
				FROM OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder                  dso 
			      JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrder               fso   ON fso.DimSalesOrderId                    = dso.DimSalesOrderId
				  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder_pbb            dsop  ON dso.SalesOrderId                       = dsop.SalesOrderId 
						                                                        and cast(dsop.pbb_SalesOrderReviewDate as date) = @CycleDate
			      LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrderLineItem  fsoli ON fsoli.DimSalesOrderId                  = dso.DimSalesOrderId
                  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.PBB_OCComponent_View    oc    on oc.SalesOrderId                        = dso.SalesOrderId 
				  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccount              da    on da.dimAccountId                        = fso.DimAccountId
				  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation      dsl   on dsl.LocationId                         = oc.LocationId 
				group by dso.DimSalesOrderId     ,dso.SalesOrderId,dso.SalesOrderNumber, dso.SalesOrderType 
				   ,dso.SalesOrderStatus   ,dso.SalesOrderDisconnectReason
				   ,dso.SalesOrderStatus  , coalesce(fsoli.DimAccountId,da.DimAccountId) , coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId)  	  
			   
						)  so1 on so1.DimAccountId         = s.DimAccountId
						      and so1.DimServiceLocationId = s.DimServiceLocationId
						      and row_cnt=1

			  LEFT JOIN (select fso.DimAccountId, dso.SalesOrderNumber, dso.SalesOrderType, dso.SalesOrderDisconnectReason, pbb_SalesOrderReviewDate 
			                  , row_number() over (partition by DimAccountId order by SalesOrderNumber desc) row_cnt
			              from [OMNIA_EPBB_P_PBB_DW].dbo.DimSalesOrder     dso 
						  join [OMNIA_EPBB_P_PBB_DW].dbo.FactSalesOrder    fso  on fso.DimSalesOrderId = dso.DimSalesOrderId 
			              join [OMNIA_EPBB_P_PBB_DW].dbo.DimSalesOrder_pbb dsop on  dso.SalesOrderId = dsop.SalesOrderId 
						                                                        and cast(dsop.pbb_SalesOrderReviewDate as date) = dateadd(d,1,@CycleDate)  -- Order on AsOfDate+1
						)  so2 on so2.DimAccountId = t.DimAccountId  
						      and so2.row_cnt=1
			WHERE s.AccountMarket   <> t.AccountMarket
			   OR s.AccountTypeCode <> t.AccountTypeCode
			   OR s.PBB_BundleType  <> t.BundleType
			   OR s.BulkTenantFlag  <> t.BulkTenantFlag
			   OR s.Courtesy        <> t.CourtesyFlag
			   OR s.InternalUse     <> t.InternalUseFlag
			   OR s.MRC             <> t.MRC
			;

			-- select * from #TempMatchDiffs

		
		
	    -- Declare @CycleDate date='20230407';
		-- Identify Loss ( no match )
			DROP TABLE if exists #TempLossSubs;

			SELECT distinct t.DimAccountId, t.DimServiceLocationId, @CycleDate AsOfDate, t.BundleType PreviousBundleType, t.ProductState PreviousProductState
				, case when tg.DimAccountId is not null then 'Y' 
				       when md.DimAccountId is not null and md.PossibleMove='Y' then 'Y' else 'N' 
					   end MoveXaction
				, so.SalesOrderNumber, so.SalesOrderType, so.SalesOrderDisconnectReason
				, (SubscriberBeginCount+SubscriberGainCount+SubscriberMoveInCount) ActiveCount
				, t.SubscriberLossCount    PreviousSubscriberLoss
				, t.SubscriberMoveOutCount PreviousSubscriberMoveOut
				, t.SubscriberEndcount     PrevEndCount
				, t.ExcludeReason          PrevExcludeReason
			  INTO #TempLossSubs
			  FROM OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily      t 
			  LEFT JOIN SDM_PROTO_Stage_tb s on  s.DimAccountId         = t.DimAccountId
											 and s.DimServiceLocationId = t.DimServiceLocationId
			  LEFT JOIN (select DimAccountId, DimServiceLocationId from #TempGainSubsT)  tg on tg.DimAccountId = t.DimAccountId and tg.DimServiceLocationId <> t.DimServiceLocationId		
			  LEFT JOIN (select DimAccountId, DimServiceLocationId, PossibleMove from #TempMatchDiffs) md on md.DimAccountId = t.DimAccountId and md.DimServiceLocationId <> t.DimServiceLocationId		 
			  LEFT JOIN (select DimAccountId, DimServiceLocationId, SalesOrderNumber, SalesOrderType, SalesOrderDisconnectReason 
			              from  pbbpdw01.transient.PBB_OrderInfo   
						  where ActualOrderDate = @CycleDate
						    and SalesOrderType = 'Disconnect'
						)  so on so.DimAccountId = t.DimAccountId  and so.DimServiceLocationId = t.DimServiceLocationId
			 WHERE t.MetaEffectiveEndDate = '20500101'
			   AND coalesce(t.BundleTransitionType,'') <> 'Lost'
			   AND s.DimAccountId is null
			;


			DROP TABLE if exists #TempGainSubs;

			select st.* 
			     , case when l.DimAccountId is not null then 'Y' 
				        when m.DimAccountId is not null then 'Y'
						else 'N' end MoveXaction
			  into #TempGainSubs 
			  -- select st.*,m.*
			  from #TempGainSubsT       st
			  left join #TempLossSubs   l on l.DimAccountId = st.DimAccountId and l.DimServiceLocationId <> st.DimServiceLocationId
			  left join #TempMatchDiffs m on m.DimAccountId = st.DimAccountId and m.DimServiceLocationId <> st.DimServiceLocationId and m.PossibleMove='Y'
			;

		/*
		select count(*) from #TempMatchDiffs;
		select count(*) from #TempGainSubs where serviceitem > 0;
		select count(*) from #TempLossSubs;

		select * from #TempMatchDiffs  where dimaccountId =711707 order by 1;
		select * from #TempGainSubs  tg join SDM_PROTO_Stage_tb s on tg.DimAccountId = s.DimAccountId and tg.DimServiceLocationId  = s.DimServiceLocationId  where tg.ServiceItem > 0 order by 1;
		select * from #TempLossSubs    where dimaccountId =711707 order by 1;


		select t.*
			  FROM SDM_PROTO_Daily_tb      t 
			  LEFT JOIN SDM_PROTO_Stage_tb s on  s.DimAccountId         = t.DimAccountId
											 and s.DimServiceLocationId = t.DimServiceLocationId
			  where t.DimAccountId = 711707 and MetaEffectiveEndDAte = '20500101'
			   AND s.DimAccountId is null

		select * from SDM_PROTO_Stage_tb
		*/


	-------------------------------------------------------------------


		-- INSERT GAIN
		--  
		INSERT INTO OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily (
		 MetaEffectiveStartDate  
		,MetaEffectiveEndDate 
		,DimAccountId 
		,DimServiceLocationId
		,AccountCode 
		,LocationId 
		,AccountMarket
		,AccountTypeCode 
		,BundleType 
		,PreviousBundleType 
		,BundleTransitionType 
		,BulkTenantFlag 
		,CourtesyFlag 
		,InternalUseFlag 
		,ProductState 
		,PreviousProductState 
		,SubscriberBeginCount 
		,SubscriberGainCount  
		,SubscriberLossCount  
		,SubscriberMoveInCount
		,SubscriberMoveOutCount
		,SubscriberConvertedInCount
		,SubscriberEndcount   
		,StartStatusReason 
		,EndStatusReason
		,StartOrderNumber  
		,EndOrderNumber
		,ConnectReason
		,DisconnectReason  
		,ExcludeReason    
		,MRC
		)
		SELECT distinct
		 s.AsOfDate  
		,'20500101' 
		,s.DimAccountId  
		,s.DimServiceLocationId
		,s.AccountCode 
		,s.LocationId  
		,AccountMarket  
		,AccountTypeCode  
		,PBB_BundleType BundleType
		,NULL PreviousBundleType
		,case when coalesce(g.SalesOrderType,'') = 'Location Change' or g.MoveXaction='Y' then 'LOCATION CHANGE' ELSE 'GAIN' end BundleTransitionType
		,BulkTenantFlag
		,Courtesy
		,InternalUse
		,MaxProductStatus
		,NULL PreviousProductState	
		,0  SubscriberBeginCount
		,case when coalesce(g.SalesOrderType,'') = 'Location Change'  
		        or g.MoveXaction='Y'
				or (PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y')       
			    or CIaccts.AccountCode is not null then 0 
			  else 1 
			   end SubscriberGainCount  
		,0 SubscriberLossCount  
		,case when (coalesce(g.SalesOrderType,'') = 'Location Change'  or g.MoveXaction='Y') 
		       and not (PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y') 
			  then 1 
			  else 0 
			   end MoveInCount
		,0 MoveOutCount
		,case when CIaccts.AccountCode is not null then 1 else 0 end SubscriberConvertedInCount 
		,case when PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y'  then 0 else 1 end  SubscriberEndCount
		,case when coalesce(g.SalesOrderType,'') = 'Location Change'  or g.MoveXaction='Y' then 'MOVE IN' 
		      ELSE 'NEW SUBSCRIBER' 
			   end StartStatusReason
		,null EndStatusReason
		,g.SalesOrderNumber StartOrderNumber
		,null EndOrderNumber
		,case when coalesce(g.SalesOrderType,'') = 'Location Change'  then 'LOCATION CHANGE' else  g.SalesOrderType end ConnectReason
		,NULL DisconnectReason
		,case when BulkTenantFlag='Y'    then 'BULK TENANT'
			  when Courtesy='Y'          then 'COURTESY'
			  when InternalUse ='Y'      then 'INTERNAL USE'
			  when PBB_BundleType='None' then 'NO ACTIVE SERVICE'
			  else null
			   end ExcludeReason  
		,MRC  
	
		FROM SDM_PROTO_stage_tb s
		JOIN #TempGainSubs      g on  s.DimAccountId         = g.DimAccountId
								  and s.DimServiceLocationId = g.DimServiceLocationId
								  and g.ServiceItem > 0
		LEFT JOIN  pbbpdw01.dbo.SAVE_SalesOrderConvertedInAccts CIaccts  on CIaccts.AccountCode = s.AccountCode and CIaccts.IsExpired = 0

		WHERE 1=1
		;


		-------------------------------------------------------------------------------

		
		-- LOSS
		UPDATE OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily 
		--   SET MetaEffectiveEndDate   = case when l.AsOfDate> MetaEffectiveStartDate then dateadd(d,-1,l.AsOfDate) else l.AsOfDate end
		   SET MetaEffectiveEndDate   = l.AsOfDate    -- tb 6/12/23
		     , SubscriberLosscount    = case when l.MoveXaction='Y'              and l.ActiveCount > 0 then 0 
			                                 when l.SalesOrderType ='Disconnect' and l.ActiveCount > 0 then 1
			                                 when l.MoveXaction='N'              and l.ActiveCount > 0 then 1 else 0 end 
		   	 , SubscriberMoveOutCount = case when l.MoveXaction='Y'              and l.ActiveCount > 0 then 1 else 0 end 
		     , SubscriberEndCount     = 0    
			 , EndOrderNumber         = case when l.ActiveCount > 0 then l.SalesOrderNumber end
			 , EndStatusReason        = case when l.ActiveCount = 0                    then 'CLEANUP'
			                                 when l.SalesOrdertype = 'Disconnect'      then 'DISCONNECT'
			                                 when l.SalesOrderType = 'Location Change' and l.MoveXaction='Y' then 'MOVE OUT'
			                                 when l.SalesOrderType is not null then upper(l.SalesOrderType)
			                                 when l.MoveXaction = 'Y' then 'MOVE OUT' 
											 else 'LOSS' end
		     , DisconnectReason       = case when l.SalesOrdertype = 'Disconnect'       and l.ActiveCount > 0      then 'DISCONNECT'
			                                 when l.SalesOrderType = 'Location Change'  and l.ActiveCount > 0      then 'LOCATION CHANGE'
											 when l.ActiveCount > 0                                                then l.SalesOrderDisconnectReason
			                                 else null end
		FROM  #TempLossSubs           l 
		-- select * from SDM_PROTO_Daily_tb join #TempLossSubs l 
		WHERE PBB_SubMetricDaily.DimAccountId         = l.DimAccountId
		  and PBB_SubMetricDaily.DimServiceLocationid = l.DimServiceLocationId
		  and PBB_SubMetricDaily.MetaEffectiveEndDate =  '20500101'
		  and PBB_SubMetricDaily.MetaEffectiveStartDate <> l.AsOfDate
		; 
		
		-------------------------------------------------------------------------------

		 

		-- CHANGE - Close Out old side
		UPDATE OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily 
		   SET MetaEffectiveEndDate = case when l.AsOfDate> MetaEffectiveStartDate then dateadd(d,-1,l.AsOfDate) else l.AsOfDate end
		     , EndStatusReason      = case when l.SalesOrderType = 'Disconnect' then 'DISCONNECT'
			                               when l.ExcludeReason is null and l.NewExcludeReason is not null then 'NEW EXCLUSION'
			                               when l.BundleTransition='Lost' and l.PossibleMove = 'Y' then 'MOVE OUT' 
										   when l.BundleTransition='Downgrade'  then 'DOWNGRADE'
										   when l.BundleTransition='Upgrade'    then 'UPGRADE'
			                               when l.MRCdiff = 'Y'                 then 'CHANGE MRC' 
			                               when l.PkgChange is not null         then l.PkgChange
										   when l.BulkAdd is not null           then l.BulkAdd
										   when l.BulkRemove is not null        then l.BulkRemove
										   when l.CourtesyAdd is not null       then l.CourtesyAdd
										   when l.CourtesyRemove is not null    then l.CourtesyRemove
										   else 'CHANGE' end
			 , DisconnectReason       = case when l.SalesOrderType = 'Disconnect' then l.SalesOrderDisconnectReason end
			 , EndOrderNumber         = l.SalesOrderNumber  
			 , SubscriberLosscount    = case when l.SalesOrderType = 'Disconnect'       and   l.PreviousSubscriberEndCount=1 then 1 
			                                 when l.ExcludeReason is null and l.NewExcludeReason is not null                 then 1
			                                 else 0 end
			 , SubscriberMoveOutCount = case when l.ExcludeReason is null and l.NewExcludeReason is not null           then 0
			                                 when l.SalesOrderType = 'Location Change' and l.PossibleMove = 'Y' and   l.PreviousSubscriberEndCount=1 then 1
			                                 when l.SalesOrderType = 'Disconnect'      then 0
			                                 when l.BundleTransition='Lost' and l.PossibleMove = 'Y'  and      (SubscriberBeginCount+SubscriberGainCount+SubscriberMoveIncount=1) then 1 
			                                 else 0 end
			 , SubscriberEndCount     = case when l.ExcludeReason is null and l.NewExcludeReason is not null           then 0
			                                 when l.SalesOrderType = 'Location Change'  and  l.PossibleMove='Y' and  (SubscriberBeginCount+SubscriberGainCount+SubscriberMoveIncount=1) then 0
			                                 when l.SalesOrderType = 'Disconnect' and                          (SubscriberBeginCount+SubscriberGainCount+SubscriberMoveIncount=1) then 0
			                                 when not (l.BundleTransition='Lost' and l.PossibleMove = 'Y') and (SubscriberBeginCount+SubscriberGainCount+SubscriberMoveIncount=1) then 1 
			                                 else 0 end
		FROM  #TempMatchDiffs            l 
		WHERE PBB_SubMetricDaily.DimAccountId         = l.DimAccountId
		  and PBB_SubMetricDaily.DimServiceLocationid = l.DimServiceLocationId
		  and PBB_SubMetricDaily.MetaEffectiveEndDate = '20500101'
		; 


		INSERT INTO OMNIA_EPBB_P_PBB_DW.rpt.PBB_SubMetricDaily (
		 MetaEffectiveStartDate  
		,MetaEffectiveEndDate 
		,DimAccountId 
		,DimServiceLocationId
		,AccountCode 
		,LocationId 
		,AccountMarket
		,AccountTypeCode 
		,BundleType 
		,PreviousBundleType 
		,BundleTransitionType 
		,BulkTenantFlag 
		,CourtesyFlag 
		,InternalUseFlag 
		,ProductState 
		,PreviousProductState 
		,SubscriberBeginCount 
		,SubscriberGainCount  
		,SubscriberLossCount  
		,SubscriberMoveInCount
		,SubscriberMoveOutCount
		,SubscriberConvertedInCount
		,SubscriberEndcount   
		,StartStatusReason 
		,EndStatusReason
		,StartOrderNumber  
		,EndOrderNumber
		,ConnectReason
		,DisconnectReason  
		,ExcludeReason    
		,MRC
		)
		SELECT distinct
		 s.AsOfDate  MetaEffectiveStartDate
		,'20500101'  MetaEffectiveEndDate
		,s.DimAccountId  
		,s.DimServiceLocationId
		,s.AccountCode 
		,LocationId  
		,AccountMarket  
		,AccountTypeCode  
		,PBB_BundleType BundleType
		,l.PreviousBundleType PreviousBundleType
		,case when l.BundleTransition = 'Lost' and l.PossibleMove = 'Y' then 'LOCATION CHANGE' else l.BundleTransition end BundleTransition
		,BulkTenantFlag
		,Courtesy
		,InternalUse
		,MaxProductStatus ProductState
		,l.PreviousProductState 
		,case when l.PreviousSubscriberEndCount = 1                                                                             then 1
		      when l.ExclusionDropped ='Y'                                                                                      then 0
		      when l.PossibleMove = 'Y' or (PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y')  then 0 
		      else 1 end                                      SubscriberBeginCount
		,case when l.ExclusionDropped ='Y' then 1 else 0 end  SubscriberGainCount  
		,0 SubscriberLossCount  
		,0 MoveInCount
		,case when l.PossibleMove = 'Y' and not  (PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y') then 1 else 0 end MoveOutCount
		,0 SubscriberConvertedInCount
		,case when l.PossibleMove = 'Y' or (PBB_BundleType = 'None' or BulkTenantFlag='Y' or Courtesy='Y' or InternalUse ='Y')  then 0 else 1 end  SubscriberEndCount
		,case when l.BundleTransition='Lost' and l.PossibleMove = 'Y' then 'MOVE OUT' 
		      when l.BundleTransition='Downgrade' then 'DOWNGRADE'   
		      when l.BundleTransition='Upgrade'   then 'UPGRADE'                           
			  when l.MRCdiff = 'Y'                then 'CHANGE MRC' 
			  when l.PkgChange is not null        then l.PkgChange
			  when l.BulkAdd is not null          then l.BulkAdd
			  when l.BulkRemove is not null       then l.BulkRemove
			  when l.CourtesyAdd is not null      then l.CourtesyAdd
			  when l.CourtesyRemove is not null   then l.CourtesyRemove
		      else 'CHANGE' END StartStatusReason
		,NULL EndStatusReason
		,NULL StartOrderNumber
		,NULL EndOrderNumber
		,NULL ConnectReason
		,NULL DisconnectReason
		,case when BulkTenantFlag='Y'    then 'BULK TENANT'
			  when Courtesy='Y'          then 'COURTESY'
			  when InternalUse ='Y'      then 'INTERNAL USE'
			  when PBB_BundleType='None' then 'NO ACTIVE SERVICE'
			  else null end ExcludeReason  
		,MRC  
		-- select *
		FROM SDM_PROTO_stage_tb s
		JOIN #TempMatchDiffs    l on  s.DimAccountId         = l.DimAccountId
								  and s.DimServiceLocationId = l.DimServiceLocationId
		WHERE NOT (coalesce(l.BundleTransition,'')='Lost' and l.PossibleMove = 'Y' )
		 AND coalesce(l.SalesOrderType,'') <> 'Disconnect'
		 AND NOT ( l.ExcludeReason is null and l.NewExcludeReason is not null )    

	--	 and l.DimAccountId = 757521
		;

	--	select * from SDM_PROTO_stage_tb where DimAccountId = 757521 
	--  select * from #TempMatchDiffs where DimAccountId = 757521


END
GO
