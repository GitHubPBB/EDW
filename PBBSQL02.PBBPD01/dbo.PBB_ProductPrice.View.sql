USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ProductPrice]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[PBB_ProductPrice] AS
	SELECT	* 
	FROM	pbbsql01.omnia_epbb_p_pbb_cm.dbo.PWB_ProductPrice

GO
