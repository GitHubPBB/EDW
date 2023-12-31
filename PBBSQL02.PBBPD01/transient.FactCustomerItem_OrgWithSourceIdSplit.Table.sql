USE [PBBPDW01]
GO
/****** Object:  Table [transient].[FactCustomerItem_OrgWithSourceIdSplit]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[FactCustomerItem_OrgWithSourceIdSplit](
	[row_num] [bigint] NULL,
	[SrvItemX_ItemID] [int] NULL,
	[SrvItemX_Version] [int] NULL,
	[SrvServiceX_ServiceID] [int] NULL,
	[SrvServiceX_Version] [int] NULL,
	[CusAccountX_AccountID] [int] NULL,
	[CusAccountX_Version] [int] NULL,
	[SrvItemPrice_ItemPriceID] [int] NULL,
	[FactCustomerItemId] [int] IDENTITY(1,1) NOT NULL,
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
	[DimAgentId] [int] NOT NULL
) ON [PRIMARY]
GO
