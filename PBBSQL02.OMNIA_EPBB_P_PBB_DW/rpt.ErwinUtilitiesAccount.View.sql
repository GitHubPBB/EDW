USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[ErwinUtilitiesAccount]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [rpt].[ErwinUtilitiesAccount] As

select ed.AccountCode, ed.DimServiceLocationId, dsl.ServiceLocationFullAddress, ed.SalesOrderNumber, ed.ActualOrderDate, dbo.[PBB_GetSubscriberMRC] (ed.DimAccountId, ed.DimServiceLocationId, ed.ActualOrderDate) MRC
  from (
		 select toi.*,  sov2.pbb_OrderActivityType newPbb_OrderActivityType, oc.BillingEffectiveDate, cast(oc.ModifiedDatetime as date) ModifiedDate
			  , row_number() over (partition by toi.DimServiceLocationId, ActualOrderDate order by SalesOrderNumber) row_cnt
			from  pbbpdw01.transient.PBB_OrderInfo                   toi
			left join   omnia_epbb_p_pbb_dw..DimSalesOrderView_pbb_tb sov2 on sov2.SalesOrderId=toi.SalesOrderId and sov2.DimServiceLocationId = toi.DimServiceLocationId
      		  left join   (select SalesOrderId,min(ModifiedDatetime) ModifiedDatetime, min(BillingEffectiveDate) BillingEffectiveDate
      						 from OMNIA_EPBB_P_PBB_DW.dbo.PBB_OCComponent_View  where BillingEffectiveDate is not null group by SalesOrderId
                        		) oc on oc.SalesOrderId = toi.SalesOrderId
		  where AccountCode = '100206935'
			and ActualOrderDate >='20230101'
      		  and sov2.pbb_OrderActivityType ='Disconnect'
		 -- order by ActualOrderDate,DimServiceLOcationId, row_Seq, row_dailyseq
		) ed
  join OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation dsl on dsl.DimServiceLocationId = ed.DimServiceLocationId
  where row_cnt=1 
GO
