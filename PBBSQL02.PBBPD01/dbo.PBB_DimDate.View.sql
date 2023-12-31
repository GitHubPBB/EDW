USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_DimDate]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[PBB_DimDate]
as
	SELECT [DimDateId]
		 ,[Name]
		 ,[Year]
		 ,[Month]
		 ,[MonthName]
		 ,[DayOfYear]
		 ,[DayOfMonth]
		 ,[MonthOfYear]
		 ,case
			 when DimDateID = '1900-01-01'
				 or DimDateID = '12-31-2050'
			 then '' else right('0000' + convert(varchar(4),Year),4) + '-' + right('00' + convert(varchar(4),MonthOfYear),2) + '-' + right('00' + convert(varchar(4),DayOfMonth),2)
		  end as [FormatYearFirst]
		 ,case
			 when DimDateID = '1900-01-01'
				 or DimDateID = '12-31-2050'
			 then '' else right('00' + convert(varchar(4),MonthOfYear),2) + '-' + right('00' + convert(varchar(4),DayOfMonth),2) + '-' + right('0000' + convert(varchar(4),Year),4)
		  end as [FormatMonthFirst]
		 ,case
			 when DimDateID = '1900-01-01'
				 or DimDateID = '12-31-2050'
			 then '' else right('00' + convert(varchar(4),MonthOfYear),2) + '/' + right('00' + convert(varchar(4),DayOfMonth),2) + '/' + right('0000' + convert(varchar(4),Year),4)
		  end as [FormatMonthFirstWithSlashes]
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimDate];
GO
