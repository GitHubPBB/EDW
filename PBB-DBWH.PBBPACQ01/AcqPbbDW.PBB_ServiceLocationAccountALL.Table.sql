USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[PBB_ServiceLocationAccountALL]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[PBB_ServiceLocationAccountALL](
	[DimServiceLocationId] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountID] [int] NULL,
	[CRMAccountID] [nvarchar](100) NULL,
	[AccountStatus] [nvarchar](40) NULL,
	[LocationAccountActivationDate] [smalldatetime] NULL,
	[LocationAccountDeactivationDate] [smalldatetime] NULL,
	[LocationAccountAmount] [numeric](38, 7) NULL,
	[LocationAccountItemStatuses] [nvarchar](max) NULL,
	[OpenInstallOrder] [varchar](1) NULL,
	[NonInstallOrder] [varchar](1) NULL,
	[OpenInstallOpportunity] [varchar](1) NULL,
	[NonInstallOpportunity] [varchar](1) NULL,
	[OpenInstallLead] [varchar](1) NULL,
	[NonInstallLead] [varchar](1) NULL,
	[LeadType] [nvarchar](4000) NULL,
	[pbb_ServiceLocationAccountStatus] [nvarchar](4000) NULL,
	[pbb_ServiceLocationAccountRank] [int] NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [char](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
