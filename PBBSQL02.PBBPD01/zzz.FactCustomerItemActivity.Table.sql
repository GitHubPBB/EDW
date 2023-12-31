USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerItemActivity]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerItemActivity](
	[FactCustomerItemActivityId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](200) NOT NULL,
	[DimDateId] [date] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Account_DimAgentId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[ItemAddQuantity] [int] NOT NULL,
	[ItemRemoveQuantity] [int] NOT NULL,
	[ItemNetQuantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerItemActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
