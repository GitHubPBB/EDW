USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[PBB_ManualSalesStats]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[PBB_ManualSalesStats](
	[row] [int] NOT NULL,
	[market] [varchar](20) NULL,
	[c1] [varchar](20) NULL,
	[c2] [varchar](20) NULL,
	[c3] [varchar](20) NULL,
	[c4] [varchar](20) NULL,
	[c5] [varchar](20) NULL,
	[c6] [varchar](20) NULL,
	[c7] [varchar](20) NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
