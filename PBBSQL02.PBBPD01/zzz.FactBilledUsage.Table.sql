USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledUsage]    Script Date: 12/5/2023 4:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledUsage](
	[FactBilledUsageId] [int] IDENTITY(1,1) NOT NULL,
	[BRCDRSummaryID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimGLMapId] [int] NOT NULL,
	[DimBilledUsageId] [int] NOT NULL,
	[RatedMessages] [int] NOT NULL,
	[BillableMessages] [int] NOT NULL,
	[BillableMinutes] [float] NOT NULL,
	[BillableBytes] [bigint] NOT NULL,
	[RatedAmount] [decimal](19, 7) NOT NULL,
	[BlockPlanDiscount] [decimal](19, 7) NOT NULL,
	[VolumePlanDiscount] [decimal](19, 7) NOT NULL,
	[CrossProductDiscount] [decimal](19, 7) NOT NULL,
	[BillableAmount] [decimal](19, 7) NOT NULL,
	[ForeignStateTax] [decimal](19, 7) NOT NULL,
	[ForeignLocalTax] [decimal](19, 7) NOT NULL,
	[BlockPlan_DimGLMapId] [int] NOT NULL,
	[VolumePlan_DimGLMapId] [int] NOT NULL,
	[DiscountPlan_DimGLMapId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledUsageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
