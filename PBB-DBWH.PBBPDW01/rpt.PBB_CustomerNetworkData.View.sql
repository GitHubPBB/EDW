USE [PBBPDW01]
GO
/****** Object:  View [rpt].[PBB_CustomerNetworkData]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [rpt].[PBB_CustomerNetworkData]
AS 
SELECT  * FROM [PBBSQL01.PBBO360.INT].[PBB_ClientWorkspace].[dbo].[PBB_CustomerNetworkData]
GO
