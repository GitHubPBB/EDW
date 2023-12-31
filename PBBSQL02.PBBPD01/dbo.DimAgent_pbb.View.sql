USE [PBBPDW01]
GO
/****** Object:  View [dbo].[DimAgent_pbb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE View [dbo].[DimAgent_pbb] as
select a.[DimAgentId]
	 ,a.[chr_AgentId]
	 ,[agentstatus].[Value] as [AgentStatus]
	 ,a.[AgentName]
	 ,a.[AgentParentName]
from [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAgent] a
	inner join [PBBSQL01].[PBB_P_MSCRM].[dbo].[chr_AgentBase] ab on ab.chr_AgentId = convert(uniqueidentifier,a.chr_AgentId)
	left join [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_StringMapBaseJoin]('chr_agent','statuscode') agentstatus on agentstatus.JoinOnValue = ab.statuscode
where a.chr_AgentId like '%-%-%-%-%'
GO
