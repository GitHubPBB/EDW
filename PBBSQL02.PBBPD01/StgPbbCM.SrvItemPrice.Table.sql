USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[SrvItemPrice]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[SrvItemPrice](
	[ItemPriceID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[PriceID] [int] NULL,
	[BeginDate] [smalldatetime] NOT NULL,
	[BeginOrderNumber] [varchar](40) NULL,
	[EndDate] [smalldatetime] NULL,
	[EndOrderNumber] [varchar](40) NULL,
	[WaiveFractional] [char](1) NOT NULL,
	[ChargeDescription] [varchar](60) NOT NULL,
	[ItemStatus] [char](1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Multiplier] [int] NOT NULL,
	[Amount] [numeric](15, 7) NOT NULL,
	[Factor] [numeric](15, 7) NOT NULL,
	[AgentID] [int] NULL,
	[BilledThruDate] [smalldatetime] NULL,
	[NumberOfPeriodsBilled] [numeric](15, 7) NOT NULL,
	[InitialCycleScheduleID] [int] NULL,
	[FinalCycleScheduleID] [int] NULL,
	[BillToAccountID] [int] NULL,
	[WaiveCharge] [char](1) NULL,
	[BillingMethod] [char](1) NULL,
	[PurchaseAmount] [numeric](15, 2) NOT NULL,
	[DownPaymentAmount] [numeric](15, 2) NOT NULL,
	[LoanAmount] [numeric](15, 2) NOT NULL,
	[PrepaidTaxAmount] [numeric](15, 2) NOT NULL,
	[AdvancedPayments] [int] NULL,
	[APR] [numeric](15, 4) NULL,
	[ElementClassID] [int] NULL,
	[OrderDate] [smalldatetime] NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
