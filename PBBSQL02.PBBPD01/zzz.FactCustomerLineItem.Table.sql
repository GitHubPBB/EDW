USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerLineItem]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerLineItem](
	[FactCustomerLineItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[DimCustomerLineItemId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[CustomerLineItemQuantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerLineItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
