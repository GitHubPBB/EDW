USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_DimLeadHyperlink]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[PBB_DimLeadHyperlink]
as
	SELECT [DimLeadId]
		 ,[LeadId]
		 ,'https://pbb-p.chrsaas.com/main.aspx?etn=lead&id=' + convert(nvarchar(50),[LeadId]) + '&pagetype=entityrecord' as [LeadURL]
		 ,'javascript:void(window.open(''https://pbb-p.chrsaas.com/main.aspx?etn=lead&id=' + convert(nvarchar(50),[LeadId]) + '&pagetype=entityrecord'',''_blank''))' as [JavaScriptLeadURL]
		 ,'=iif(Globals!RenderFormat.IsInteractive = TRUE, Fields!JavaScriptLeadURL.Value, Fields!LeadURL.value)' as [SSRSReportLeadExprAction]
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimLead]
GO
