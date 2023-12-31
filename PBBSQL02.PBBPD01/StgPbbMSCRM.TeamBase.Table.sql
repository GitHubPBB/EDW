USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[TeamBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[TeamBase](
	[TeamId] [uniqueidentifier] NOT NULL,
	[OrganizationId] [uniqueidentifier] NOT NULL,
	[BusinessUnitId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](160) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[EMailAddress] [nvarchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[IsDefault] [bit] NOT NULL,
	[AdministratorId] [uniqueidentifier] NOT NULL,
	[QueueId] [uniqueidentifier] NULL,
	[ExchangeRate] [decimal](18, 0) NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[YomiName] [nvarchar](160) NULL,
	[RegardingObjectId] [uniqueidentifier] NULL,
	[TeamType] [int] NOT NULL,
	[ProcessId] [uniqueidentifier] NULL,
	[SystemManaged] [bit] NOT NULL,
	[StageId] [uniqueidentifier] NULL,
	[TeamTemplateId] [uniqueidentifier] NULL,
	[RegardingObjectTypeCode] [int] NULL,
	[TraversedPath] [nvarchar](1250) NULL,
	[chr_AssignedDate] [datetime] NULL,
	[chr_Estimatedtime] [nvarchar](100) NULL,
	[chr_Incident_Team] [nvarchar](100) NULL,
	[chr_Status] [int] NULL,
	[chr_SubmittedDate] [datetime] NULL,
	[chr_TimeOfCompletion] [decimal](18, 0) NULL,
	[new_date1] [datetime] NULL,
	[new_date2] [datetime] NULL,
	[new_TaskTeamId] [uniqueidentifier] NULL,
	[chr_teamtype] [int] NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [StgPbbMSCRM].[TeamBase] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [StgPbbMSCRM].[TeamBase] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AdministratorId]
GO
ALTER TABLE [StgPbbMSCRM].[TeamBase] ADD  DEFAULT ((0)) FOR [TeamType]
GO
ALTER TABLE [StgPbbMSCRM].[TeamBase] ADD  DEFAULT ((0)) FOR [SystemManaged]
GO
