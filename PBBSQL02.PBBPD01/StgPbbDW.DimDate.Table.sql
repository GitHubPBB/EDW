USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimDate]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimDate](
	[DimDateId] [date] NOT NULL,
	[Name] [nvarchar](29) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [nvarchar](9) NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[DayOfMonth] [int] NOT NULL,
	[MonthOfYear] [int] NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
