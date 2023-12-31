USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ServiceLocationAccountMinRank]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



 CREATE view [dbo].[PBB_ServiceLocationAccountMinRank] as
 with MinRank
     AS (SELECT DISTINCT 
                DimServiceLocationID, 
                MIN(pbb_ServiceLocationAccountRank) pbb_ServiceLocationAccountRank
         FROM [PBB_ServiceLocationAccountALL] s
         GROUP BY DimServiceLocationID)
		 
		select AL.* 
		from [PBB_ServiceLocationAccountALL] AL
		join MinRank R on AL.DimServiceLocationId = R.DimServiceLocationId and AL.pbb_ServiceLocationAccountRank = R.pbb_ServiceLocationAccountRank

GO
