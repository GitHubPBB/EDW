USE [PBBPDW01]
GO
/****** Object:  View [rpt].[cust_network_data]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [rpt].[cust_network_data]
AS 
SELECT  * FROM  [PBBSQL01.PBBO360.INT].[PBB_ClientWorkspace].[dbo].[cust_network_data]
GO
