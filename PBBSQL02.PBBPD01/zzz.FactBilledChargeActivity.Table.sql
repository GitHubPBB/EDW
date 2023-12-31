USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledChargeActivity]    Script Date: 12/5/2023 4:43:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledChargeActivity](
	[FactBilledChargeActivityId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[ChargeActivityAmount] [money] NOT NULL,
	[ChargeActivityDiscountAmount] [money] NOT NULL,
	[ChargeActivityNetAmount] [money] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimBilledChargeId] [int] NOT NULL,
	[DimCustomerPriceId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[DimBillingActivityId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledChargeActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
