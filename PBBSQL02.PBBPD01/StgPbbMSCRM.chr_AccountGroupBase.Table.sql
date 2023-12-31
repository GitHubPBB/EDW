USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[chr_AccountGroupBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[chr_AccountGroupBase](
	[chr_AccountGroupId] [uniqueidentifier] NOT NULL,
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
	[chr_Name] [nvarchar](256) NULL,
	[chr_AccountClassId] [uniqueidentifier] NULL,
	[chr_AccountGroupCode] [nvarchar](20) NULL,
	[chr_AccountTypeId] [uniqueidentifier] NULL,
	[chr_BillingAccountGroupId] [nvarchar](100) NULL,
	[chr_BillingCycleId] [uniqueidentifier] NULL,
	[chr_CustomerServiceRegionId] [uniqueidentifier] NULL,
	[chr_ExemptClassId] [uniqueidentifier] NULL,
	[chr_InvoiceFormatId] [uniqueidentifier] NULL,
	[chr_PrintGroupId] [uniqueidentifier] NULL,
	[chr_SACCode] [uniqueidentifier] NULL,
	[chr_SegmentId] [uniqueidentifier] NULL,
	[cus_Market] [nvarchar](100) NULL,
	[cus_MarketSummary] [nvarchar](100) NULL,
	[cus_ReportingMarket] [nvarchar](100) NULL,
	[cus_DefaultInternationalPIC] [int] NULL,
	[cus_DefaultInterlataPIC] [int] NULL,
	[cus_DefaultIntralataPIC] [int] NULL,
	[cus_SwitchCutOverDate] [datetime] NULL,
	[cus_EngineeringFiberDesignNeeded] [bit] NULL,
	[cus_MarketCode] [int] NULL,
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
