USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[cus_cabinetBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[cus_cabinetBase](
	[cus_cabinetId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[OwnerIdType] [int] NOT NULL,
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[cus_name] [nvarchar](100) NULL,
	[cus_CompetitiveType] [int] NULL,
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
ALTER TABLE [StgPbbMSCRM].[cus_cabinetBase] ADD  DEFAULT ((8)) FOR [OwnerIdType]
GO
