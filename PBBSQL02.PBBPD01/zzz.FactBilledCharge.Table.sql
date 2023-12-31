USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledCharge]    Script Date: 12/5/2023 4:43:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledCharge](
	[FactBilledChargeId] [int] IDENTITY(1,1) NOT NULL,
	[BRChargeID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Parent_DimCustomerItemId] [int] NOT NULL,
	[DimCustomerPriceId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[DimCatalogPriceId] [int] NOT NULL,
	[BeginDate_DimDateId] [date] NOT NULL,
	[EndDate_DimDateId] [date] NOT NULL,
	[ChargeBeginDate_DimDateId] [date] NOT NULL,
	[ChargeEndDate_DimDateId] [date] NOT NULL,
	[BilledChargeAmount] [money] NOT NULL,
	[BilledChargeDiscountAmount] [money] NOT NULL,
	[BilledChargeNetAmount] [money] NOT NULL,
	[BilledChargeQuantity] [int] NOT NULL,
	[BilledChargeStandardRate] [money] NOT NULL,
	[BilledChargeSuspendRate] [money] NOT NULL,
	[BilledChargeNonPayRate] [money] NOT NULL,
	[DimBilledChargeId] [int] NOT NULL,
	[Parent_DimCatalogItemId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledChargeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
