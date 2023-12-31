USE [PBBPDW01]
GO
/****** Object:  Table [info].[ExecutionLog]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[ExecutionLog](
	[LogID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[LogParentID] [numeric](18, 0) NULL,
	[EtlGroup] [varchar](50) NOT NULL,
	[EtlName] [varchar](50) NOT NULL,
	[LoadDttm] [datetime] NOT NULL,
	[StartDttm] [datetime] NOT NULL,
	[StopDttm] [datetime] NULL,
	[ElapsedSec] [int] NULL,
	[EtlGUID] [varchar](50) NULL,
	[ExecutionGUID] [varchar](50) NULL,
	[MachineName] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[ExecutionStatus] [numeric](1, 0) NOT NULL,
	[ExecutionMsg] [varchar](2000) NOT NULL,
 CONSTRAINT [pk_ExecutionLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
