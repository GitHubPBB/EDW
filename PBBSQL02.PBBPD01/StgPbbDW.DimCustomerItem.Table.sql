USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimCustomerItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimCustomerItem](
	[DimCustomerItemId] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemActivationDate] [date] NULL,
	[ItemDeactivationDate] [date] NULL,
	[ItemStatus] [varchar](1) NOT NULL,
	[ItemServiceIdentifier] [varchar](85) NOT NULL,
	[ItemProviderCode] [char](7) NOT NULL,
	[ItemProvider] [varchar](40) NOT NULL,
	[ItemPrintProvider] [varchar](60) NOT NULL,
	[ItemPrintProviderAbbreviation] [char](6) NOT NULL,
	[ItemProviderClass] [varchar](40) NOT NULL,
	[ItemNumberOfPeriodsBilled] [decimal](15, 7) NOT NULL,
	[ItemInitialBillingId] [int] NOT NULL,
	[ItemFinalBillingId] [int] NOT NULL,
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
