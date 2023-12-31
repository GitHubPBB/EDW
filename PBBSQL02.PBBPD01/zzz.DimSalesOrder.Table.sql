USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimSalesOrder]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimSalesOrder](
	[DimSalesOrderId] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderName] [nvarchar](300) NOT NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[SalesOrderChannel] [nvarchar](256) NOT NULL,
	[SalesOrderSegment] [nvarchar](1000) NOT NULL,
	[SalesOrderProvisioningDate] [datetime] NULL,
	[SalesOrderCommitmentDate] [datetime] NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[SalesOrderProject] [nvarchar](80) NOT NULL,
	[SalesOrderProjectManager] [nvarchar](200) NOT NULL,
	[SalesOrderOwner] [nvarchar](200) NOT NULL,
	[SalesOrderStatusReason] [nvarchar](256) NOT NULL,
	[SalesOrderStatus] [nvarchar](256) NOT NULL,
	[SalesOrderPriorityCode] [nvarchar](256) NOT NULL,
	[SalesOrderDisconnectReason] [nvarchar](256) NOT NULL,
	[OrderHasServiceActivity] [nvarchar](50) NOT NULL,
	[OrderWorkflowName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimSalesOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SalesOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
