USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[chr_WorkflowAutomatedActivityBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[chr_WorkflowAutomatedActivityBase](
	[chr_WorkflowAutomatedActivityId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OrganizationId] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[chr_name] [nvarchar](100) NULL,
	[chr_ActivityStatus] [int] NULL,
	[chr_CommonActivityTypeID] [uniqueidentifier] NULL,
	[chr_CompletedDateTime] [datetime] NULL,
	[chr_SalesOrderID] [uniqueidentifier] NULL,
	[chr_ServiceOrderID] [uniqueidentifier] NULL,
	[chr_StartedDateTime] [datetime] NULL,
	[chr_WorkflowEventID] [nvarchar](100) NULL,
	[chr_WorkflowInstanceID] [nvarchar](50) NULL,
	[chr_RetriedBy] [uniqueidentifier] NULL,
	[chr_RetryDate] [datetime] NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
