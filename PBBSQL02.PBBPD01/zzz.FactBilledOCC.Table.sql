USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledOCC]    Script Date: 12/5/2023 4:43:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledOCC](
	[FactBilledOCCId] [int] IDENTITY(1,1) NOT NULL,
	[BROCCSKID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerOCCId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimCatalogOCCId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[DimDateId] [date] NOT NULL,
	[OCCBilledAmount] [money] NOT NULL,
	[OCCBilledQuantity] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledOCCId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
