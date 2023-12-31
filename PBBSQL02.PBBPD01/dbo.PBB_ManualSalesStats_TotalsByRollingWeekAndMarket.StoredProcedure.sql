USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ManualSalesStats_TotalsByRollingWeekAndMarket]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[PBB_ManualSalesStats_TotalsByRollingWeekAndMarket]
AS
    begin

	   select top (7) [Date]
				  ,[AlaGa]
				  ,[N AL - S TN]
				  ,[Island]
				  ,[HAG]
				  ,[Michigan]
				  ,[NY]
				  ,[Ohio]
				  ,[VA/TN]
				  ,[AlaGa] + [N AL - S TN] + [Island] + [HAG] + [Michigan] + [NY] + [Ohio] + [VA/TN] as [Total]
	   from
		   (
			  select convert(date,[date]) as [Date]
				   ,[market] as [Market]
				   ,convert(int,isnull([value],0)) as [Value]
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_ManualSalesStats_History]
		   ) as [SourceTable] PIVOT(SUM([Value]) for [Market] in([AlaGa]
													 ,[N AL - S TN]
													 ,[Island]
													 ,[HAG]
													 ,[Michigan]
													 ,[NY]
													 ,[Ohio]
													 ,[VA/TN])) as [PivotTable]
	   order by [Date] desc
    end
GO
