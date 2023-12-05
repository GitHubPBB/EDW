USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[priPricePlan]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[priPricePlan](
	[PricePlanID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[PricePlan] [varchar](80) NOT NULL,
	[OfferBeginDate] [smalldatetime] NOT NULL,
	[OfferEndDate] [smalldatetime] NULL,
	[OfferRemarks] [varchar](8000) NULL,
	[QualifyingExpressionID] [int] NULL,
	[PlanPeriods] [int] NOT NULL,
	[DeferredPeriods] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[PlanType] [char](1) NULL,
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
