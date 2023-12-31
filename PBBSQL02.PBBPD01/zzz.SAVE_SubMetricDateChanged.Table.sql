USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[SAVE_SubMetricDateChanged]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[SAVE_SubMetricDateChanged](
	[ActualOrderDate] [date] NULL,
	[SalesOrderReviewDate] [datetime] NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[PrevMetaEffectiveEndDate] [date] NULL,
	[MetaEffectiveStartDate] [date] NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL
) ON [PRIMARY]
GO
