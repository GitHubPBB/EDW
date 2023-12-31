USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactBilledCharge]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactBilledCharge](
	[FactBilledChargeId] [int] NOT NULL,
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
) ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimBillingRunId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimCustomerProductId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [Parent_DimCustomerItemId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimCustomerPriceId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimGLMapId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimCatalogItemId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimCatalogPriceId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ('1900-01-01') FOR [BeginDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ('1900-01-01') FOR [EndDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ('1900-01-01') FOR [ChargeBeginDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ('1900-01-01') FOR [ChargeEndDate_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeDiscountAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeNetAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeQuantity]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeStandardRate]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeSuspendRate]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [BilledChargeNonPayRate]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [DimBilledChargeId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledCharge] ADD  DEFAULT ((0)) FOR [Parent_DimCatalogItemId]
GO
