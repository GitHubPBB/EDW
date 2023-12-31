USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_DimSalesOrderHyperLink]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Script for SelectTopNRows command from SSMS  ******/
/*
select * from [dbo].[FactSalesOrder] so
inner join [dbo].DimAccount a on a.DimAccountId = so.DimAccountId
inner join [dbo].PBB_DimSalesOrderHyperLink soh on soh.DimSalesOrderId = so.DimSalesOrderId
*/
CREATE view [dbo].[PBB_DimSalesOrderHyperLink] as
SELECT [DimSalesOrderId]
      ,[SalesOrderId]
	 ,'https://pbb-p.chrsaas.com/main.aspx?etc=1088&extraqs=%3fetc%3d1088%26id%3d' + replace(convert(nvarchar(50),[SalesOrderId]),'-','') + N'&histKey=957556776&newWindow=true&pagetype=entityrecord#870042821' as [ServiceOrderHyperlink]
	 ,'javascript:void(window.open(''https://pbb-p.chrsaas.com/main.aspx?etc=1088&extraqs=%3fetc%3d1088%26id%3d' + replace(convert(nvarchar(50),[SalesOrderId]),'-','') + N'&histKey=957556776&newWindow=true&pagetype=entityrecord#870042821'',''_blank''))' as JavaScriptServiceOrderURL
	 ,'=iif(Globals!RenderFormat.IsInteractive = TRUE, Fields!JavaScriptServiceOrderURL.Value, Fields!ServiceOrderURL.value)' as [SSRSReportServiceOrderExprAction]
FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimSalesOrder]
GO
