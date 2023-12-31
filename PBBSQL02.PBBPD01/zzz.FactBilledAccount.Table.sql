USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactBilledAccount]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactBilledAccount](
	[FactBilledAccountId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[DimBillingRunId] ASC,
	[FactBilledAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [BillingRunPS]([DimBillingRunId])
) ON [BillingRunPS]([DimBillingRunId])
GO
