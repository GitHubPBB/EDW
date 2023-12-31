USE [PBBPDW01]
GO
/****** Object:  Table [transient].[TempOrders]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[TempOrders](
	[AccountCode] [nvarchar](20) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NULL,
	[AccountMarket] [nvarchar](99) NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[SalesOrderDisconnectReason] [nvarchar](256) NOT NULL,
	[OrderWorkflowName] [nvarchar](256) NOT NULL,
	[ProvisioningDate_DimDateId] [date] NOT NULL,
	[OrderClosed_DimDateId] [date] NOT NULL,
	[pbb_SalesOrderReviewDate] [datetime] NULL,
	[OrderDate] [date] NULL,
	[ActiveItemsYminus1] [varchar](20) NULL,
	[ActiveItemsYesterday] [varchar](20) NULL,
	[ActiveItemsToday] [varchar](20) NULL,
	[ActiveItemsTomorrow] [varchar](20) NULL,
	[ActiveItemsTplus1] [varchar](20) NULL,
	[ActiveItemsTplus2] [varchar](20) NULL,
	[ActiveItemsTplus3] [varchar](20) NULL,
	[ActiveItemsTplus4] [varchar](20) NULL,
	[ActiveItemsTplus5] [varchar](20) NULL,
	[ActiveItemsTplus6] [varchar](20) NULL,
	[ActiveItemsAtOrderClose] [varchar](20) NULL,
	[row_Seq] [bigint] NULL,
	[row_DailySeq] [bigint] NULL,
	[PrevSalesOrderType] [nvarchar](256) NULL,
	[PrevOrderDate] [date] NULL,
	[NextSalesOrderType] [nvarchar](256) NULL,
	[NextOrderDate] [date] NULL,
	[row_DailyNextSeq] [bigint] NULL
) ON [PRIMARY]
GO
