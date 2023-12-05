USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[PriPrice]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[PriPrice](
	[PriceID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[PriceListID] [int] NOT NULL,
	[ProductComponentID] [int] NOT NULL,
	[AccountID] [int] NULL,
	[ElementClassID] [int] NOT NULL,
	[Description] [varchar](80) NOT NULL,
	[PrintDescription] [varchar](80) NOT NULL,
	[OfferBeginDate] [smalldatetime] NOT NULL,
	[OfferEndDate] [smalldatetime] NULL,
	[OfferRemarks] [varchar](8000) NULL,
	[QualifyingExpressionID] [int] NULL,
	[PriceClass] [tinyint] NOT NULL,
	[RoundingMethod] [char](1) NOT NULL,
	[BillingMethod] [char](1) NOT NULL,
	[FractionalizationMethod] [char](1) NOT NULL,
	[WaiverMethod] [char](1) NOT NULL,
	[BillingFrequency] [char](1) NOT NULL,
	[BillingFrequencyMask] [int] NULL,
	[PriceScheduleBehavior] [char](1) NOT NULL,
	[PriceScheduleAlignment] [char](1) NOT NULL,
	[RealCost] [numeric](15, 7) NOT NULL,
	[BookedCost] [numeric](15, 7) NOT NULL,
	[Weight] [int] NOT NULL,
	[ExcludeFromDisperse] [bit] NOT NULL,
	[PrintMethod] [char](1) NOT NULL,
	[PricePlanID] [int] NULL,
	[IsDeniable] [bit] NOT NULL,
	[CustomPricingStoredProc] [varchar](128) NULL,
	[AdjustableSchedule] [bit] NOT NULL,
	[ExtendableSchedule] [bit] NOT NULL,
	[MinPeriodDeviation] [numeric](15, 2) NULL,
	[MaxPeriodDeviation] [numeric](15, 2) NULL,
	[MinAmountDeviation] [numeric](15, 2) NULL,
	[MaxAmountDeviation] [numeric](15, 2) NULL,
	[RevertToPricePlanID] [int] NULL,
	[IsCommissionable] [bit] NOT NULL,
	[AgentCost] [numeric](15, 2) NOT NULL,
	[SPIFFCost] [numeric](15, 2) NOT NULL,
	[ETLCost] [numeric](15, 2) NOT NULL,
	[OtherCost] [numeric](15, 2) NOT NULL,
	[IsContracted] [bit] NOT NULL,
	[MinDownPaymentDeviation] [numeric](15, 2) NULL,
	[MaxDownPaymentDeviation] [numeric](15, 2) NULL,
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
