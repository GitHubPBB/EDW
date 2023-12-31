USE [PBBPDW01]
GO
/****** Object:  Table [transient].[Cus_externalmarkets]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[Cus_externalmarkets](
	[cus_externalmarketId] [uniqueidentifier] NOT NULL,
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
	[VersionNumber] [timestamp] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[cus_name] [nvarchar](200) NULL,
	[cus_Description] [nvarchar](100) NULL,
	[cus_AccountGroupMarket] [nvarchar](100) NULL,
	[cus_AccountGroupMarketSummary] [nvarchar](100) NULL,
	[cus_CallStats] [bit] NULL
) ON [PRIMARY]
GO
