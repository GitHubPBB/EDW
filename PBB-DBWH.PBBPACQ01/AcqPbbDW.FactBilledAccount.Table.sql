USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactBilledAccount]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactBilledAccount](
	[FactBilledAccountId] [int] NOT NULL,
	[BRAccountID] [nvarchar](400) NOT NULL,
	[DimBillingRunId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[WriteOffAmount] [money] NOT NULL,
	[TransferAmount] [money] NOT NULL,
	[PreviousBillAmount] [money] NOT NULL,
	[PreviousBalanceAmount] [money] NOT NULL,
	[PreviousBalanceDelinquentAmount] [money] NOT NULL,
	[DepositOnFileAmount] [money] NOT NULL,
	[ARChargeAmount] [money] NOT NULL,
	[ProductChargeAmount] [money] NOT NULL,
	[OCCAmount] [money] NOT NULL,
	[CDRAmount] [money] NOT NULL,
	[CABAccessAmount] [money] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[UsageAmount] [money] NOT NULL,
	[Usage360Amount] [money] NOT NULL,
	[InvoiceAmount] [money] NOT NULL,
	[TotalDue] [money] NOT NULL,
	[BilledAmount] [money] NOT NULL,
	[DiscountAmount] [money] NOT NULL,
	[NetAmount] [money] NOT NULL,
	[RecurringAmount] [money] NOT NULL,
	[NonRecurringAmount] [money] NOT NULL,
	[DerateAmount] [money] NOT NULL,
	[ProrateAmount] [money] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DimBillingRunId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [WriteOffAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [TransferAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [PreviousBillAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [PreviousBalanceAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [PreviousBalanceDelinquentAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DepositOnFileAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [ARChargeAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [ProductChargeAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [OCCAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [CDRAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [CABAccessAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [TaxAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [UsageAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [Usage360Amount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [InvoiceAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [TotalDue]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [BilledAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [NetAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [RecurringAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [NonRecurringAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [DerateAmount]
GO
ALTER TABLE [AcqPbbDW].[FactBilledAccount] ADD  DEFAULT ((0)) FOR [ProrateAmount]
GO
