USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ManualSalesStats_TotalsByMonthAndMarket]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[PBB_ManualSalesStats_TotalsByMonthAndMarket]
AS
    begin

	   select top (12) [Month]
				   ,[Year]
				   ,case
					   when [Month] = datepart(month,getdate())
						   and [Year] = datepart(year,getdate())
					   then 'Current Month'
					   when [Month] = 8
						   and [Year] = 2021
					   then 'Partial Month' else 'Complete Month'
				    end as [Status]
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
			  select datepart(month,convert(date,[date])) as [Month]
				   ,datepart(year,convert(date,[date])) as [Year]
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
	   order by [Year] desc
			 ,[Month] desc;
    end
GO
