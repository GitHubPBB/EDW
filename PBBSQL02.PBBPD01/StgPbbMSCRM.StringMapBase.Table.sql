USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[StringMapBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[StringMapBase](
	[ObjectTypeCode] [int] NOT NULL,
	[AttributeName] [nvarchar](100) NOT NULL,
	[AttributeValue] [int] NOT NULL,
	[LangId] [int] NOT NULL,
	[OrganizationId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](4000) NULL,
	[DisplayOrder] [int] NULL,
	[VersionNumber] [int] NULL,
	[StringMapId] [uniqueidentifier] NOT NULL,
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
ALTER TABLE [StgPbbMSCRM].[StringMapBase] ADD  DEFAULT (newid()) FOR [StringMapId]
GO
