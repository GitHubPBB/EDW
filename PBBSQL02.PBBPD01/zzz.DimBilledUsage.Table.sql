USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimBilledUsage]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimBilledUsage](
	[DimBilledUsageId] [int] IDENTITY(1,1) NOT NULL,
	[BilledUsageID] [varchar](200) NOT NULL,
	[UsageCallClassCode] [char](5) NOT NULL,
	[RatePeriodClassCode] [char](1) NOT NULL,
	[UsageDiscountPlan] [char](40) NOT NULL,
	[UsageClass] [varchar](40) NOT NULL,
	[UsageProvider] [varchar](40) NOT NULL,
	[UsageCIC] [char](5) NOT NULL,
	[UsageOCN] [char](5) NOT NULL,
	[UsageJurisdiction] [varchar](40) NOT NULL,
	[UsageRecordClass] [varchar](40) NOT NULL,
	[UsageTaxChargeType] [varchar](40) NOT NULL,
	[UsageRatePlan] [varchar](40) NOT NULL,
	[UsageBlockPlan] [varchar](40) NOT NULL,
	[UsageVolumePlan] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBilledUsageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[BilledUsageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
