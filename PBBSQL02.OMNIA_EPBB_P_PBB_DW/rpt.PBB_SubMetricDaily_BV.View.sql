USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SubMetricDaily_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE   VIEW [rpt].[PBB_SubMetricDaily_BV] 
as select 

	 case when b.[DimAccountId] is not null then '20230531' 
	      when  left(a.AccountCode,3) in ('310','320','330','340') 
		   and len(a.AccountCode)=9 and cast(a.MetaEffectiveStartDate as date) ='20230729' 
		   and  cast(a.MetaEffectiveStartDate as date)  > cast(da2.AccountActivationDate as date) then cast(da2.AccountActivationDate as date)
	      else a.MetaEffectiveStartDate end MetaEffectiveStartDate 
	,[MetaEffectiveEndDate] 
	,a.[DimAccountId] 
	,[DimServiceLocationId] 
	,a.[AccountCode] 
	,[LocationId]
	,a.[AccountMarket] 
	,[AccountTypeCode] 
	,[BundleType] 
	,[PreviousBundleType] 
	,[BundleTransitionType] 
	,[BulkTenantFlag]
	,[CourtesyFlag] 
	,[InternalUseFlag] 
	,[ProductState] 
	,[PreviousProductState] 
	,[SubscriberBeginCount] 
	,[SubscriberGainCount] 
	,[SubscriberLossCount] 
	,[SubscriberMoveInCount] 
	,[SubscriberMoveOutCount]
	,[SubscriberEndcount] 
	,[StartStatusReason] 
	,[EndStatusReason] 
	,[StartOrderNumber] 
	,[EndOrderNumber]
	,[ConnectReason] 
	,[DisconnectReason]
	,[ExcludeReason] 
	,[MRC] 
from omnia_epbb_p_pbb_dw.rpt.PBB_SubMetricDaily  a
--from omnia_epbb_p_pbb_dw.rpt.PBB_SubMetricDaily_bk20230927  a
left join OMNIA_EPBB_P_PBB_DW..DimAccount da2 on da2.DimAccountId = a.DimAccountId
left join (
select distinct da.DimAccountId, min(MetaEffectiveStartDate) MetaEffectiveStartDate --so.ServiceOrderCode,sdm.dimAccountId, sdm.AccountMarket, da.AccountActivationDate, min(sdm.MetaEffectiveStartDate) MetaEffectiveStartDate
  from pbbpdw01.dbo.sdm_conv_so so
 join OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder  dso on so.ServiceOrderCode = dso.SalesOrderNumber
 join OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrder fso on fso.DimSalesOrderId = dso.DimSalesOrderId  
 join omnia_epbb_p_pbb_dw.rpt.PBB_SubMetricDaily                      sdm on sdm.DimAccountId    = fso.DimAccountId
 join OMNIA_EPBB_P_PBB_DW.dbo.DimAccount     da  on da.DimAccountId     = sdm.DimAccountId 
 where SubscriberGainCount=1
 group by da.DimAccountId
 --group by so.ServiceOrderCode, sdm.dimAccountId, sdm.AccountMarket, da.AccountActivationDate

) b on a.DimAccountId = b.DimAccountId and a.MetaEffectiveStartDate = b.MetaEffectiveStartDate 
GO
