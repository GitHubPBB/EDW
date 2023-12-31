USE [PBBPDW01]
GO
/****** Object:  Table [info].[ExecutionLogDetail]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[ExecutionLogDetail](
	[LogDetailID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[LogID] [numeric](18, 0) NULL,
	[LogDttm] [datetime] NOT NULL,
	[ExecutionStep] [varchar](2000) NOT NULL,
	[ExecutionMsg] [varchar](8000) NULL,
 CONSTRAINT [pk_ExecutionLogDetail] PRIMARY KEY CLUSTERED 
(
	[LogDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [info].[ExecutionLogDetail] ADD  DEFAULT (getdate()) FOR [LogDttm]
GO
