USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCase](
	[DimCaseId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentId] [nvarchar](400) NOT NULL,
	[TicketNumber] [nvarchar](100) NOT NULL,
	[TicketTitle] [nvarchar](200) NOT NULL,
	[TicketStatus] [varchar](31) NOT NULL,
	[TroubleTicketType] [varchar](26) NOT NULL,
	[CasePriorityStatus] [varchar](11) NOT NULL,
	[CaseOrigin] [varchar](256) NOT NULL,
	[TroubleType] [nvarchar](100) NOT NULL,
	[ReportedTrouble] [nvarchar](100) NOT NULL,
	[CaseCreatedBy] [nvarchar](200) NOT NULL,
	[CaseOwner] [nvarchar](200) NOT NULL,
	[CaseDueDate] [datetime] NULL,
	[CaseModifiedOn] [datetime] NULL,
	[CaseCreatedOn] [datetime] NULL,
	[CaseFollowupBy] [datetime] NULL,
	[CaseStartClearDate] [datetime] NULL,
	[CaseEndClearDate] [datetime] NULL,
	[CaseClearBy] [nvarchar](200) NOT NULL,
	[CaseCauseCode] [nvarchar](100) NOT NULL,
	[CaseClearTroubleComment] [nvarchar](max) NOT NULL,
	[CaseFoundCodeName] [nvarchar](100) NOT NULL,
	[CaseCloseCodeComment] [nvarchar](max) NOT NULL,
	[CaseCloseBy] [nvarchar](200) NOT NULL,
	[CaseCloseCode] [nvarchar](100) NOT NULL,
	[CasePlantChanges] [bit] NOT NULL,
	[CaseClearCode] [nvarchar](100) NOT NULL,
	[CaseQueueName] [nvarchar](200) NOT NULL,
	[CaseQueueItem] [nvarchar](300) NOT NULL,
	[CaseWorkedBy] [nvarchar](4000) NOT NULL,
	[CaseQueueModifiedOn] [datetime] NULL,
	[CaseEnteredQueueOn] [datetime] NULL,
	[CaseWorkedOn] [datetime] NULL,
	[CaseDispatchedBy] [nvarchar](200) NOT NULL,
	[CaseDispatchedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IncidentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
