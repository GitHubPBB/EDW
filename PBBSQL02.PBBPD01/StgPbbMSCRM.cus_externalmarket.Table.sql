USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[cus_externalmarket]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[cus_externalmarket](
	[CreatedOnBehalfByName] [nvarchar](200) NULL,
	[CreatedOnBehalfByYomiName] [nvarchar](200) NULL,
	[ModifiedByName] [nvarchar](200) NULL,
	[ModifiedByYomiName] [nvarchar](200) NULL,
	[CreatedByName] [nvarchar](200) NULL,
	[CreatedByYomiName] [nvarchar](200) NULL,
	[ModifiedOnBehalfByName] [nvarchar](200) NULL,
	[ModifiedOnBehalfByYomiName] [nvarchar](200) NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[OwnerIdName] [nvarchar](160) NULL,
	[OwnerIdYomiName] [nvarchar](160) NULL,
	[OwnerIdDsc] [int] NOT NULL,
	[OwnerIdType] [int] NULL,
	[OwningUser] [uniqueidentifier] NULL,
	[OwningTeam] [uniqueidentifier] NULL,
	[cus_externalmarketId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[cus_name] [nvarchar](200) NULL,
	[cus_Description] [nvarchar](100) NULL,
	[cus_AccountGroupMarket] [nvarchar](100) NULL,
	[cus_AccountGroupMarketSummary] [nvarchar](100) NULL,
	[cus_CallStats] [bit] NULL,
	[MetaRowKey] [varbinary](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
