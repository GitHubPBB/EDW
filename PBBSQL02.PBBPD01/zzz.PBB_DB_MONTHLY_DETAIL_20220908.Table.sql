USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_DB_MONTHLY_DETAIL_20220908]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_DB_MONTHLY_DETAIL_20220908](
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
	[DisconnectReason] [nvarchar](256) NULL,
	[DisconnectType] [varchar](22) NOT NULL,
	[SalesOrderName] [nvarchar](300) NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NULL,
	[SalesOrderChannel] [nvarchar](256) NULL,
	[SalesOrderSegment] [nvarchar](1000) NULL,
	[SalesOrderProvisioningDate] [datetime] NULL,
	[SalesOrderCommitmentDate] [datetime] NULL,
	[BillingDate] [datetime] NULL,
	[SalesOrderType] [nvarchar](256) NULL,
	[pbb_OrderActivityType] [varchar](10) NULL,
	[SalesOrderProject] [nvarchar](80) NULL,
	[SalesOrderProjectManager] [nvarchar](200) NULL,
	[SalesOrderOwner] [nvarchar](200) NULL,
	[SalesOrderStatusReason] [nvarchar](256) NULL,
	[SalesOrderStatus] [nvarchar](256) NULL,
	[SalesOrderPriorityCode] [nvarchar](256) NULL,
	[AccountCode] [nvarchar](20) NULL,
	[CustomerName] [nvarchar](4000) NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[BillingAddressLine1] [nvarchar](4000) NULL,
	[BillingAddressLine2] [nvarchar](4000) NULL,
	[City] [nvarchar](4000) NULL,
	[State] [nvarchar](4000) NULL,
	[Country] [nvarchar](4000) NULL,
	[ZIP] [nvarchar](4000) NULL,
	[AccountClassCode] [nvarchar](20) NULL,
	[AccountClass] [nvarchar](256) NULL,
	[AccountGroupCode] [nvarchar](20) NULL,
	[AccountGroup] [nvarchar](256) NULL,
	[AccountType] [nvarchar](100) NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[Completion Date] [date] NULL,
	[Order Review Date] [date] NULL,
	[SalesOrderTotalMRC] [decimal](38, 6) NULL,
	[SalesOrderTotalNRC] [money] NOT NULL,
	[SalesOrderTotalTax] [money] NOT NULL,
	[SalesOrderTotalAmount] [money] NOT NULL,
	[pbb_AccountMarket] [nvarchar](100) NULL,
	[pbb_marketsummary] [nvarchar](100) NULL,
	[pbb_ReportingMarket] [nvarchar](100) NULL,
	[dimaccountid] [int] NULL,
	[dimservicelocationid] [int] NULL,
	[SalesOrderClassification] [varchar](11) NULL
) ON [PRIMARY]
GO
