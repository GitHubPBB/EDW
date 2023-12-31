USE [PBBPDW01]
GO
/****** Object:  Table [info].[ExecutionControlDetail]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[ExecutionControlDetail](
	[ServerName] [varchar](100) NULL,
	[LoadType] [nvarchar](100) NULL,
	[TargetDatabaseName] [varchar](100) NULL,
	[TargetSchemaName] [varchar](100) NULL,
	[TargetTableName] [varchar](100) NULL,
	[SourceDatabaseName] [varchar](100) NULL,
	[SourceSchemaName] [varchar](100) NULL,
	[SourceTableName] [varchar](100) NULL,
	[ExecutionGroup] [varchar](100) NULL,
	[ExecutionGroupSeq] [smallint] NULL,
	[ExecutionReadyFlag] [bit] NULL,
	[LastLoadDttm] [datetime] NULL,
	[ExecutionExp] [nvarchar](max) NULL,
	[ExecutionStatus] [varchar](100) NULL,
	[ExecutionLogID] [numeric](18, 0) NULL,
	[ExecutionDttm] [datetime] NULL,
	[ExecutionError] [varchar](8000) NULL,
	[MetaRowKeyFields] [varchar](8000) NULL,
	[ColumnList] [nvarchar](max) NULL,
	[ColumnRowHashExp] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
