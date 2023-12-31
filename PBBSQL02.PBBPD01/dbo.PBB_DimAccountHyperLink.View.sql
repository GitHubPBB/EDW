USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_DimAccountHyperLink]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/****** Script for SelectTopNRows command from SSMS  ******/
/*
select * from DimAccount a
inner join [dbo].[PBB_DimAccountHyperLink] ahl on ahl.DimAccountId = a.DimAccountId
*/
CREATE view [dbo].[PBB_DimAccountHyperLink] as
SELECT [DimAccountId]
	 ,[AccountId]
	 ,'https://pbb-p.chrsaas.com/main.aspx?etn=account&id=' + convert(nvarchar(50),[AccountId]) + '&pagetype=entityrecord' as AccountURL
	 ,'javascript:void(window.open(''https://pbb-p.chrsaas.com/main.aspx?etn=account&id=' + convert(nvarchar(50),[AccountId]) + '&pagetype=entityrecord'',''_blank''))' as JavaScriptAccountURL
	 ,'=iif(Globals!RenderFormat.IsInteractive = TRUE, Fields!JavaScriptAccountURL.Value, Fields!AccountURL.value)' as [SSRSReportAccountExprAction]
FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount]
GO
