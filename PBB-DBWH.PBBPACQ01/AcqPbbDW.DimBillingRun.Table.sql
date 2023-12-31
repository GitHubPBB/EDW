USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimBillingRun]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimBillingRun](
	[DimBillingRunId] [int] NOT NULL,
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
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingMode]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingYearYYYY]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingMonthMMM]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingCycleCC]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ((0)) FOR [BillingYearMonth]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ((0)) FOR [BillingCycleID]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingCycle]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ('') FOR [BillingCompanyCode]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ((0)) FOR [ArrearsDaysInPeriod]
GO
ALTER TABLE [AcqPbbDW].[DimBillingRun] ADD  DEFAULT ((0)) FOR [PreBillDaysInPeriod]
GO
