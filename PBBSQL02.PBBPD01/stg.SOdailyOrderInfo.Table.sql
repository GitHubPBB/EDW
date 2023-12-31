USE [PBBPDW01]
GO
/****** Object:  Table [stg].[SOdailyOrderInfo]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [stg].[SOdailyOrderInfo](
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountId] [int] NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NULL,
	[AccountMarket] [nvarchar](99) NULL,
	[ReportingMarket] [nvarchar](100) NOT NULL,
	[BulkMduCode] [varchar](4) NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[SalesOrderStatus] [nvarchar](256) NOT NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[SalesOrderDisconnectReason] [nvarchar](256) NOT NULL,
	[OrderWorkflowName] [nvarchar](256) NOT NULL,
	[ProvisioningDate_DimDateId] [date] NOT NULL,
	[OrderClosed_DimDateId] [date] NOT NULL,
	[pbb_SalesOrderReviewDateUTC] [datetime] NULL,
	[pbb_SalesOrderReviewDate] [datetime] NULL,
	[OrderDate] [date] NULL
) ON [PRIMARY]
GO
