USE [PBBPDW01]
GO
/****** Object:  Table [transient].[FactCustomerItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[FactCustomerItem](
	[FactCustomerItemId] [int] NULL,
	[SourceId] [varchar](72) NOT NULL,
	[ItemID] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemPrice] [numeric](15, 7) NULL,
	[DimCustomerActivityId] [int] NULL,
	[DimCustomerItemId] [int] NULL,
	[Parent_DimCustomerItemId] [int] NULL,
	[DimCustomerProductId] [varchar](148) NOT NULL,
	[DimAccountId] [uniqueidentifier] NULL,
	[DimAccountCategoryId] [varchar](107) NOT NULL,
	[DimMembershipId] [int] NULL,
	[DimServiceLocationId] [int] NULL,
	[DimFMAddressId] [int] NULL,
	[DimCatalogItemId] [int] NULL,
	[Parent_DimCatalogItemId] [int] NULL,
	[DimPhoneId] [int] NULL,
	[DimInternetId] [int] NULL,
	[Activation_DimDateId] [smalldatetime] NULL,
	[Deactivation_DimDateId] [smalldatetime] NULL,
	[EffectiveStartDate] [smalldatetime] NOT NULL,
	[EffectiveEndDate] [datetime] NULL,
	[DimCatalogPriceId] [int] NULL,
	[Nonpay_DimDateId] [smalldatetime] NULL,
	[PWBParent_DimCatalogItemId] [int] NULL,
	[DimAgentId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
