USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimBillingRun]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimBillingRun](
	[DimBillingRunId] [int] IDENTITY(1,1) NOT NULL,
	[BillingRunID] [int] NOT NULL,
	[BillingMode] [char](1) NOT NULL,
	[BillingYearYYYY] [char](4) NOT NULL,
	[BillingMonthMMM] [char](3) NOT NULL,
	[BillingCycleCC] [char](2) NOT NULL,
	[BillingYearMonth] [int] NOT NULL,
	[BillingCycleID] [int] NOT NULL,
	[BillingCycle] [varchar](max) NOT NULL,
	[BillingCompanyCode] [char](7) NOT NULL,
	[ArrearsBillFromDate] [date] NULL,
	[ArrearsBillThruDate] [date] NULL,
	[ArrearsDaysInPeriod] [int] NOT NULL,
	[PreBillFromDate] [date] NULL,
	[PreBillThruDate] [date] NULL,
	[PreBillDaysInPeriod] [int] NOT NULL,
	[BillingInvoiceDate] [date] NULL,
	[BillingDueDate] [date] NULL,
	[AdjustmentsThruDate] [smalldatetime] NULL,
	[OrdersThruDate] [smalldatetime] NULL,
	[UsageThruDate] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[BillingRunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
