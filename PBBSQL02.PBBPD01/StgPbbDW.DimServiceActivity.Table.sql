USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimServiceActivity]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimServiceActivity](
	[DimServiceActivityId] [int] NOT NULL,
	[ActivityId] [uniqueidentifier] NOT NULL,
	[ServiceActivityActualStart] [datetime] NULL,
	[ServiceActivityActualEnd] [datetime] NULL,
	[ServiceActivityActualDurationMinutes] [int] NOT NULL,
	[ServiceActivityDescription] [nvarchar](max) NOT NULL,
	[ServiceActivityName] [nvarchar](160) NOT NULL,
	[ServiceActivitySubject] [nvarchar](200) NOT NULL,
	[ServiceActivityStatus] [nvarchar](9) NOT NULL,
	[ServiceActivityScheduledStart] [datetime] NULL,
	[ServiceActivityScheduledEnd] [datetime] NULL,
	[ServiceActivityScheduledDurationMinutes] [int] NOT NULL,
	[ServiceActivityCreatedOn] [datetime] NULL,
	[ServiceActivityCreatedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityModifiedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityRegardingObjectName] [nvarchar](4000) NOT NULL,
	[ServiceActivityRegardingObjectType] [varchar](19) NOT NULL,
	[ServiceActivityOwner] [nvarchar](200) NOT NULL,
	[ServiceActivitySiteName] [nvarchar](160) NOT NULL,
	[ServiceActivityResourceNames] [nvarchar](4000) NOT NULL,
	[ServiceActivityDispatchedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityDispatchedOn] [datetime] NULL,
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
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ((0)) FOR [ServiceActivityActualDurationMinutes]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityDescription]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityName]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivitySubject]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityStatus]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ((0)) FOR [ServiceActivityScheduledDurationMinutes]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityCreatedBy]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityModifiedBy]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityRegardingObjectName]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityRegardingObjectType]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityOwner]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivitySiteName]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityResourceNames]
GO
ALTER TABLE [StgPbbDW].[DimServiceActivity] ADD  DEFAULT ('') FOR [ServiceActivityDispatchedBy]
GO
