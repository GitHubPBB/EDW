USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerItem]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerItem](
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
	[DimAgentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
