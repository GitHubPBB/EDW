USE [PBBPDW01]
GO
/****** Object:  Table [info].[SourceTable]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[SourceTable](
	[ServerName] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[SchemaName] [varchar](100) NULL,
	[TableName] [varchar](100) NULL,
	[MetaRowKeyFields] [nvarchar](max) NULL,
	[ACQSchema] [varchar](50) NULL,
	[STGSchema] [varchar](50) NULL,
	[ExpandedBusKeyFlag] [char](1) NULL,
	[ColumnList] [nvarchar](max) NULL,
	[ColumnRowHashExp] [nvarchar](max) NULL,
	[LastFromDate] [date] NULL,
	[LastThruDate] [date] NULL,
	[ExecutionGroup] [varchar](25) NULL,
	[ExecutionGroupSeq] [smallint] NULL,
	[ExecutionReadyFlag] [bit] NULL,
	[ExecutionExp] [nvarchar](max) NULL,
	[ExecutionStatus] [varchar](15) NULL,
	[ExecutionDttm] [datetime] NULL,
	[ExecutionError] [varchar](8000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [info].[SourceTable] ADD  DEFAULT ('N') FOR [ExpandedBusKeyFlag]
GO
