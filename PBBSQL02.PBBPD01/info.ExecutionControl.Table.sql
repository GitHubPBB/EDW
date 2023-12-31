USE [PBBPDW01]
GO
/****** Object:  Table [info].[ExecutionControl]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [info].[ExecutionControl](
	[CPRID] [int] IDENTITY(1,1) NOT NULL,
	[EtlGroup] [varchar](50) NOT NULL,
	[EtlSeqGroup] [varchar](25) NOT NULL,
	[EtlName] [varchar](100) NOT NULL,
	[EtlSeqGroupSort] [smallint] NOT NULL,
	[ReadyFlag] [bit] NOT NULL,
	[EtlStatus] [varchar](15) NOT NULL,
	[EtlStatusDttm] [datetime] NOT NULL,
	[EtlErrorMsg] [varchar](max) NULL,
	[Parm1] [varchar](200) NULL,
	[SQLExpression] [varchar](max) NULL,
 CONSTRAINT [pk_ExecutionControl] PRIMARY KEY CLUSTERED 
(
	[CPRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
