USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactCustomerItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactCustomerItem](
	[FactCustomerItemId] [int] NOT NULL,
	[SourceId] [varchar](65) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemQuantity] [int] NOT NULL,
	[ItemPrice] [money] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
	[DimPhoneId] [int] NOT NULL,
	[DimInternetId] [int] NOT NULL,
	[Activation_DimDateId] [date] NOT NULL,
	[Deactivation_DimDateId] [date] NOT NULL,
	[EffectiveStartDate] [datetime] NOT NULL,
	[EffectiveEndDate] [datetime] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
	[Nonpay_DimDateId] [date] NOT NULL,
	[PWBParent_DimCatalogItemId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
