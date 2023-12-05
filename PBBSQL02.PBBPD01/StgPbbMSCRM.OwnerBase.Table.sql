USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[OwnerBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[OwnerBase](
	[OwnerIdType] [int] NOT NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](160) NULL,
	[VersionNumber] [int] NULL,
	[YomiName] [nvarchar](160) NULL,
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
ALTER TABLE [StgPbbMSCRM].[OwnerBase] ADD  DEFAULT ((8)) FOR [OwnerIdType]
GO
