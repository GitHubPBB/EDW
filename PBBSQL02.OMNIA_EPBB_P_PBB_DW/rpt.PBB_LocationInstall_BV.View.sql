USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_LocationInstall_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



 create view [rpt].[PBB_LocationInstall_BV] as
 select concat(year(ActualOrderDate),right(concat('0',month(ActualOrderDate)),2) ) YearMonth
      , accountmarket, LocationInstallType, count(*) CountOf 
   from OMNIA_EPBB_P_PBB_DW.rpt.PBB_LocationInstall 
  where 1=1
    -- and ActualOrderDate between @RptStart and eomonth(@RptStart)
	and ActualOrderDate >= '20230101'
    and not ( (left(AccountCode,1) ='3' and row_seq=1 and AccountMarket in  ('E Michigan - FTTH', 'North AL - FTTH') ) 
	       or (left(AccountCode,1) ='3' and row_seq>1 and OrderWorkflowName in ('Billing Correction','Provisioning Only') and AccountMarket in  ('E Michigan - FTTH', 'North AL - FTTH')   )
		    )
  group by concat(year(ActualOrderDate),right(concat('0',month(ActualOrderDate)),2) ) , accountmarket, LocationInstallType
 
GO
