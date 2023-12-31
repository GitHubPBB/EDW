USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_AddressSubsidySourceAggregate]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[PBB_AddressSubsidySourceAggregate] AS
select sl.[cus_ServiceLocationId]
	 ,string_agg(convert(varchar(max), sb.[cus_SubsidySource]), ' | ') within group (order by sb.[cus_SubsidySource],sl.[cus_servicelocationsubsidysourceId]) as FundType
	 ,string_agg(convert(varchar(max), isnull(sl.[cus_SubsidyID],'N/A')),' | ') within group (order by sb.[cus_SubsidySource],sl.[cus_servicelocationsubsidysourceId]) as FundTypeId
from [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_addresssubsidysourceBase] sb with(NOLOCK)
	inner join [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_servicelocationsubsidysourceBase] sl with(NOLOCK) on sl.[cus_AddressSubsidySourceId] = sb.[cus_addresssubsidysourceId]
group by sl.[cus_ServiceLocationId]
GO
