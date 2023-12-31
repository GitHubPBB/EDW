USE [PBBPDW01]
GO
/****** Object:  Table [rpt].[PBB_ServiceOrderConnects]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[PBB_ServiceOrderConnects](
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NULL,
	[SalesOrderName] [nvarchar](300) NULL,
	[SalesOrderChannel] [nvarchar](256) NULL,
	[SalesOrderSegment] [nvarchar](1000) NULL,
	[SalesOrderProvisioningDate] [date] NULL,
	[SalesOrderCommitmentDate] [date] NULL,
	[OrderReviewDate] [date] NULL,
	[CompletionDate] [date] NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[SalesOrderType] [nvarchar](256) NULL,
	[OrderActivityType] [varchar](10) NULL,
	[SalesOrderClassification] [varchar](11) NULL,
	[SalesOrderStatus] [nvarchar](256) NULL,
	[SalesOrderStatusReason] [nvarchar](256) NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NULL,
	[SalesOrderPriorityCode] [nvarchar](256) NULL,
	[SalesOrderOwner] [nvarchar](200) NULL,
	[AccountCode] [nvarchar](20) NULL,
	[AccountClassCode] [nvarchar](20) NULL,
	[AccountClass] [nvarchar](256) NULL,
	[AccountGroupCode] [nvarchar](20) NULL,
	[AccountGroup] [nvarchar](256) NULL,
	[AccountType] [nvarchar](100) NULL,
	[SalesOrderTotalMRC] [money] NOT NULL,
	[SalesOrderTotalNRC] [money] NOT NULL,
	[SalesOrderTotalTax] [money] NOT NULL,
	[SalesOrderTotalAmount] [money] NOT NULL,
	[AccountMarket] [nvarchar](100) NULL,
	[ReportingMarket] [nvarchar](100) NULL,
	[MarketSummary] [nvarchar](100) NULL,
	[BundleType] [varchar](32) NULL,
	[Tenure] [int] NULL,
	[PaidInvoicesLast6Months] [int] NULL,
	[PartialPaidInvoicesLast6Months] [int] NULL,
	[NonPayCountLast6Months] [int] NULL,
	[LocationId] [int] NULL,
	[Latitude] [varchar](11) NULL,
	[Longitude] [varchar](11) NULL,
	[ServiceLocationStateAbbrev] [char](6) NULL,
	[ServiceLocationCity] [varchar](28) NULL,
	[ServiceLocationZip] [char](11) NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[AccountCount] [int] NOT NULL
) ON [PRIMARY]
GO
