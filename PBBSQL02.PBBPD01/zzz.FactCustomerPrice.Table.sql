USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerPrice]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerPrice](
	[FactCustomerPriceId] [int] IDENTITY(1,1) NOT NULL,
	[ItemPriceID] [int] NOT NULL,
	[DimCustomerPriceId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
	[DimPhoneId] [int] NOT NULL,
	[DimInternetId] [int] NOT NULL,
	[BeginDate_DimDateId] [date] NOT NULL,
	[EndDate_DimDateId] [date] NOT NULL,
	[CustomerPriceQuantity] [int] NOT NULL,
	[CustomerPriceAmount] [decimal](15, 7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
