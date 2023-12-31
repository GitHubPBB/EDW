USE [PBBPDW01]
GO
/****** Object:  Table [transient].[cus_externalprojectpenetration]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[cus_externalprojectpenetration](
	[CreatedByName] [nvarchar](200) NULL,
	[CreatedByYomiName] [nvarchar](200) NULL,
	[ModifiedByName] [nvarchar](200) NULL,
	[ModifiedByYomiName] [nvarchar](200) NULL,
	[CreatedOnBehalfByName] [nvarchar](200) NULL,
	[CreatedOnBehalfByYomiName] [nvarchar](200) NULL,
	[cus_ProjectNameName] [nvarchar](100) NULL,
	[ModifiedOnBehalfByName] [nvarchar](200) NULL,
	[ModifiedOnBehalfByYomiName] [nvarchar](200) NULL,
	[TransactionCurrencyIdName] [nvarchar](100) NULL,
	[cus_MarketName] [nvarchar](200) NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[OwnerIdName] [nvarchar](160) NULL,
	[OwnerIdYomiName] [nvarchar](160) NULL,
	[OwnerIdDsc] [int] NOT NULL,
	[OwnerIdType] [int] NULL,
	[OwningUser] [uniqueidentifier] NULL,
	[OwningTeam] [uniqueidentifier] NULL,
	[cus_externalprojectpenetrationId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [timestamp] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[cus_ExternalProjectPenetrationName] [nvarchar](100) NULL,
	[cus_ReportDate] [datetime] NULL,
	[cus_ProjectName] [uniqueidentifier] NULL,
	[cus_Market] [uniqueidentifier] NULL,
	[cus_CRMAddresses] [int] NULL,
	[cus_CompetitiveAddresses] [int] NULL,
	[cus_UnderservedAddresses] [int] NULL,
	[cus_TotalServiceableAddresses] [int] NULL,
	[cus_CurrentMonthBilledMRC] [money] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[ExchangeRate] [numeric](23, 10) NULL,
	[cus_currentmonthbilledmrc_Base] [money] NULL,
	[cus_ActiveCompetitiveCustomers] [int] NULL,
	[cus_ActiveUnderservedCustomers] [int] NULL,
	[cus_TotalActiveCustomers] [int] NULL
) ON [PRIMARY]
GO
