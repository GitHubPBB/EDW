USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PWB_PackageWeights2]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PWB_PackageWeights2]  as
select * from pbbsql01.omnia_epbb_p_pbb_cm.dbo.PWB_Packageweights2
GO
