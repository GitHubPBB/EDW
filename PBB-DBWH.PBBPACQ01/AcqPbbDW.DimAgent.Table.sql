USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimAgent]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimAgent](
	[DimAgentId] [int] NOT NULL,
	[chr_AgentId] [nvarchar](400) NOT NULL,
	[AgentStatus] [nvarchar](256) NOT NULL,
	[AgentName] [nvarchar](100) NOT NULL,
	[AgentParentName] [nvarchar](100) NOT NULL,
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
ALTER TABLE [AcqPbbDW].[DimAgent] ADD  DEFAULT ('') FOR [AgentStatus]
GO
ALTER TABLE [AcqPbbDW].[DimAgent] ADD  DEFAULT ('') FOR [AgentName]
GO
ALTER TABLE [AcqPbbDW].[DimAgent] ADD  DEFAULT ('') FOR [AgentParentName]
GO
