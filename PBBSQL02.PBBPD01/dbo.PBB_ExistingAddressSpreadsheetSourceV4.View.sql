USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ExistingAddressSpreadsheetSourceV4]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
select * from dbo.[PBB_ExistingAddressSpreadsheetSourceV4] where LocationComment like '%DRILL%'
*/

CREATE VIEW [dbo].[PBB_ExistingAddressSpreadsheetSourceV4]
as
	SELECT * 
	FROM   [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[PBB_ExistingAddressSpreadsheetSourceV4]
GO
