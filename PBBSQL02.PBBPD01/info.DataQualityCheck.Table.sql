USE [PBBPDW01]
GO
/****** Object:  Table [info].[DataQualityCheck]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[DataQualityCheck](
	[CycleNumber] [numeric](5, 0) NULL,
	[RunDate] [date] NULL,
	[TargetSystem] [varchar](250) NULL,
	[TableName] [varchar](250) NULL,
	[TestCase] [varchar](500) NULL,
	[Script] [varchar](max) NULL,
	[RecordCount] [numeric](16, 0) NULL,
	[IssueType] [varchar](200) NULL,
	[ExecutionStatus] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
