USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactServiceLocationItem_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactServiceLocationItem_pbb](
	[pbb_FactServiceLocationItemId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[pbb_DimServiceLocationAccountId] [nvarchar](400) NOT NULL,
	[pbb_LocationItemAmount] [money] NOT NULL,
	[pbb_LocationItemActivation_DimDateId] [date] NOT NULL,
	[pbb_LocationItemDeactivation_DimDateId] [date] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Account_DimAgentId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_FactServiceLocationItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
