USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimSalesOrderView_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimSalesOrderView_pbb](
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[pbb_OrderActivityType] [varchar](10) NOT NULL,
	[DimAccountId] [int] NULL,
	[DimServiceLocationId] [int] NULL
) ON [PRIMARY]
GO
