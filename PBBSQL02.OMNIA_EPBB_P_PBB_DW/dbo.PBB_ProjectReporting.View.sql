USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ProjectReporting]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[PBB_ProjectReporting] as
select upper(replace(chr_name,'PC-','')) ProjectName, format(cus_serviceabledate, 'MM/dd/yyyy') ProjectServiceableDate, 
case when isnull(cus_serviceabledate,'1/1/2021') < '1/1/2021' or chr_name not like '%PROJECT%' then 'LEGACY' else upper(replace(chr_name,'PC-','')) end as CalcProjectName,
case when isnull(cus_serviceabledate,'1/1/2021') < '1/1/2021' or chr_name not like '%PROJECT%' then 'LEGACY' else 'PROJECT' end as AddressType
from pbbsql01.pbb_p_mscrm.dbo.chr_workorder
GO
