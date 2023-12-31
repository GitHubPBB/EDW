USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_AccountLastInvoiceDate]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[PBB_AccountLastInvoiceDate]
as
	select AccountCode
		 ,AccountName
		 ,BillingRunID
		 ,Max(BillingInvoiceDate) as LastInvoiceDate
	from
		(
		    select a.AccountCode
				,a.AccountName
				,br.BillingInvoiceDate
				,br.BillingRunID
		    from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactBilledCharge] fbc
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a on a.DimAccountId = fbc.DimAccountId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac on ac.DimAccountCategoryID = fbc.DimAccountCategoryID
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimBillingRun] br on br.DimBillingRunID = fbc.DimBillingRunID
		    union all
		    select a.AccountCode
				,a.AccountName
				,br.BillingInvoiceDate
				,br.BillingRunID
		    from [OMNIA_ELEG_P_LEG_DW].[dbo].[FactBilledCharge] fbc
			    inner join [OMNIA_ELEG_P_LEG_DW].[dbo].[DimAccount] a on a.DimAccountId = fbc.DimAccountId
			    inner join [OMNIA_ELEG_P_LEG_DW].[dbo].[DimAccountCategory] ac on ac.DimAccountCategoryID = fbc.DimAccountCategoryID
			    inner join [OMNIA_ELEG_P_LEG_DW].[dbo].[DimBillingRun] br on br.DimBillingRunID = fbc.DimBillingRunID
		) d
	group by AccountCode
		   ,AccountName
		   ,BillingRunID
GO
