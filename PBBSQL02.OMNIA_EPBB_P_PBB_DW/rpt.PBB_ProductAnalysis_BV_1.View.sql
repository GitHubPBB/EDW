USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_ProductAnalysis_BV_1]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [rpt].[PBB_ProductAnalysis_BV_1] as
--Month End Snapshot
select *
from [rpt].[PBB_ProductAnalysis_BT] bt
WHERE bt.asofdate = EOMONTH(bt.asofdate)   

UNION
--Current Month latest date
select *
from [rpt].[PBB_ProductAnalysis_BT] bt
WHERE bt.asofdate = (SELECT MAX(asofdate) from [rpt].[PBB_ProductAnalysis_BT]) 

GO
