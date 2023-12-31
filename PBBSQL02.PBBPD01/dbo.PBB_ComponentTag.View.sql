USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ComponentTag]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create view [dbo].[PBB_ComponentTag] as
	select ComponentID, ComponentCode, Component, Tag, TagDescription, AllowedValues
	from pbbsql01.omnia_epbb_p_pbb_cm.dbo.prdcomponent c
		JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.[PrdTableTag] ON c.[ComponentID] = [PrdTableTag].[RowID]
					AND [PrdTableTag].[TableName] = 'PrdComponent'
		JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.[PrdTag] T on [PrdTableTag].[TagID] = T.TagID and tagclassid = 99
GO
