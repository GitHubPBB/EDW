USE [PBBPDW01]
GO
/****** Object:  Table [transient].[priPricePlan]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[priPricePlan](
	[PricePlanID] [int] NOT NULL,
	[Version] [timestamp] NOT NULL,
	[PricePlan] [varchar](80) NOT NULL,
	[OfferBeginDate] [smalldatetime] NOT NULL,
	[OfferEndDate] [smalldatetime] NULL,
	[OfferRemarks] [varchar](8000) NULL,
	[QualifyingExpressionID] [int] NULL,
	[PlanPeriods] [int] NOT NULL,
	[DeferredPeriods] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[PlanType] [char](1) NULL,
 CONSTRAINT [XPKPriPricePlan] PRIMARY KEY NONCLUSTERED 
(
	[PricePlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
