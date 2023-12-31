USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DimProjectT1]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProjectT1](
	[DimProjectKey] [smallint] NOT NULL,
	[DimProjectNaturalKey] [varchar](100) NOT NULL,
	[DimProjectNaturalKeyFields] [varchar](100) NOT NULL,
	[ProjectCode] [varchar](100) NOT NULL,
	[ProjectName] [varchar](100) NOT NULL,
	[CalcProjectName] [varchar](100) NOT NULL,
	[AddressType] [varchar](20) NOT NULL,
	[LocationServiceableDate] [date] NOT NULL,
	[ProjectServiceableDate] [date] NOT NULL,
	[HasFiberActiveE] [char](1) NOT NULL,
	[HasFiberGPON] [char](1) NOT NULL,
	[CompetitiveType] [varchar](20) NULL,
	[DimMarketKey] [smallint] NOT NULL,
	[DimMarketNaturalKey] [varchar](50) NOT NULL,
	[MetaSourceSystemCode] [varchar](20) NOT NULL,
	[MetaInsertDatetime] [date] NOT NULL,
	[MetaUpdateDatetime] [date] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
