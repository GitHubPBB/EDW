USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimCase]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimCase](
	[DimCaseId] [int] NOT NULL,
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [TicketNumber]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [TicketTitle]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [TicketStatus]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [TroubleTicketType]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CasePriorityStatus]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseOrigin]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [TroubleType]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [ReportedTrouble]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseCreatedBy]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseOwner]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseClearBy]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseCauseCode]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseClearTroubleComment]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseFoundCodeName]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseCloseCodeComment]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseCloseBy]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseCloseCode]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ((0)) FOR [CasePlantChanges]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseClearCode]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseQueueName]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseQueueItem]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseWorkedBy]
GO
ALTER TABLE [AcqPbbDW].[DimCase] ADD  DEFAULT ('') FOR [CaseDispatchedBy]
GO
