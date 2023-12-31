USE [PBBPDW01]
GO
/****** Object:  Table [transient].[cus_externalprojectpenetrationBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[cus_externalprojectpenetrationBase](
	[cus_externalprojectpenetrationId] [uniqueidentifier] NOT NULL,
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
