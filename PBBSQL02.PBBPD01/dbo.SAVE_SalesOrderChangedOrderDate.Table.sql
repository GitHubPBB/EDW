USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[SAVE_SalesOrderChangedOrderDate]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAVE_SalesOrderChangedOrderDate](
	[AccountMarket] [nvarchar](99) NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[SalesOrderReviewDate] [datetime] NULL,
	[ActualOrderDate] [date] NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderOwner] [nvarchar](200) NOT NULL,
	[OrderClosedDate] [date] NOT NULL,
	[DimServiceLocationId] [int] NULL
) ON [PRIMARY]
GO
