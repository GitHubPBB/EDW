USE [PBBPDW01]
GO
/****** Object:  Table [transient].[chr_BillingCycleBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[chr_BillingCycleBase](
	[chr_BillingCycleId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OrganizationId] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [timestamp] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[chr_Name] [nvarchar](256) NULL,
	[chr_CardDebitDays] [nvarchar](100) NULL,
	[chr_Code] [nvarchar](20) NULL,
	[chr_ExternalId] [nvarchar](100) NULL,
	[chr_Version] [int] NULL
) ON [PRIMARY]
GO
