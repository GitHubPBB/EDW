USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DimSalesOrderDetailT1]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesOrderDetailT1](
	[AccountCode] [nvarchar](20) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NULL,
	[DimMarketKey] [smallint] NULL,
	[AccountMarket] [nvarchar](99) NULL,
	[ReportingMarket] [nvarchar](100) NOT NULL,
	[BulkMduCode] [varchar](4) NULL,
	[IsCourtesyInternal] [char](1) NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[OrderActivityType] [varchar](20) NULL,
	[SalesOrderStatus] [nvarchar](256) NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderName] [nvarchar](300) NOT NULL,
	[SalesOrderChannel] [nvarchar](256) NOT NULL,
	[SalesOrderSegment] [nvarchar](1000) NOT NULL,
	[SalesOrderClassification] [varchar](17) NULL,
	[SalesOrderPriorityCode] [nvarchar](256) NOT NULL,
	[SalesOrderOwner] [nvarchar](200) NOT NULL,
	[OrderWorkflowName] [nvarchar](256) NOT NULL,
	[ProvisioningDate] [date] NOT NULL,
	[SalesOrderReviewDateUTC] [datetime] NULL,
	[SalesOrderReviewDate] [datetime] NULL,
	[OrderDate] [date] NULL,
	[OrderClosedDate] [date] NOT NULL,
	[ActualOrderDate] [date] NULL,
	[row_Seq] [bigint] NULL,
	[row_DailySeq] [bigint] NULL,
	[row_DailyNextSeq] [bigint] NULL,
	[PrevSalesOrderType] [nvarchar](256) NULL,
	[PrevOrderDate] [date] NULL,
	[Prev2SalesOrderType] [nvarchar](256) NULL,
	[Prev2OrderDate] [date] NULL,
	[NextSalesOrderType] [nvarchar](256) NULL,
	[NextorderDate] [date] NULL,
	[ActiveItemsYminus1Start] [varchar](1) NULL,
	[ActiveItemsYminus1End] [varchar](1) NULL,
	[ActiveItemsYminus1DiscoDate] [varchar](20) NULL,
	[ActiveItemsYesterdayStart] [varchar](1) NULL,
	[ActiveItemsYesterdayEnd] [varchar](1) NULL,
	[ActiveItemsYesterdayDiscoDate] [varchar](20) NULL,
	[ActiveItemsTodayStart] [varchar](1) NULL,
	[ActiveItemsTodayEnd] [varchar](1) NULL,
	[ActiveItemsTodayDiscoDate] [varchar](20) NULL,
	[ActiveItemsTomorrowStart] [varchar](1) NULL,
	[ActiveItemsTomorrowEnd] [varchar](1) NULL,
	[ActiveItemsTomorrowDiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus1Start] [varchar](1) NULL,
	[ActiveItemsTplus1End] [varchar](1) NULL,
	[ActiveItemsTplus1DiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus2Start] [varchar](1) NULL,
	[ActiveItemsTplus2End] [varchar](1) NULL,
	[ActiveItemsTplus2DiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus3Start] [varchar](1) NULL,
	[ActiveItemsTplus3End] [varchar](1) NULL,
	[ActiveItemsTplus3DiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus4Start] [varchar](1) NULL,
	[ActiveItemsTplus4End] [varchar](1) NULL,
	[ActiveItemsTplus4DiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus5Start] [varchar](1) NULL,
	[ActiveItemsTplus5End] [varchar](1) NULL,
	[ActiveItemsTplus5DiscoDate] [varchar](20) NULL,
	[ActiveItemsTplus6Start] [varchar](1) NULL,
	[ActiveItemsTplus6End] [varchar](1) NULL,
	[ActiveItemsTplus6DiscoDate] [varchar](20) NULL,
	[ActiveItemsAtOrderCloseStart] [varchar](1) NULL,
	[ActiveItemsAtOrderCloseEnd] [varchar](1) NULL,
	[ActiveItemsAtOrderCloseDiscoDate] [varchar](20) NULL
) ON [PRIMARY]
GO
