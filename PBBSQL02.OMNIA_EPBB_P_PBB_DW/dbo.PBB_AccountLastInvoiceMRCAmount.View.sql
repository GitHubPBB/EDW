USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_AccountLastInvoiceMRCAmount]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[PBB_AccountLastInvoiceMRCAmount]
as
	select AccountCode
		 ,[Last Billed Amount]
	from
		(
		    select AccountCode
		    ,case when MRCBase<MRC then MRC else MRCBase end as [Last Billed Amount]
		    ,Year,month
		    ,row_number() over (partition by AccountCode order by year desc, month desc) as rn
		    from [OMNIA_ELEG_P_LEG_DW].[dbo].[FactBilledAccountPeriodSummary_pbb]
		) d
	where rn = 1
GO
