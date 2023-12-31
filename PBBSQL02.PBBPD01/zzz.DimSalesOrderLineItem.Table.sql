USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimSalesOrderLineItem]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimSalesOrderLineItem](
	[DimSalesOrderLineItemId] [int] IDENTITY(1,1) NOT NULL,
	[OCComponent_ID] [int] NOT NULL,
	[SalesOrderLineItemName] [nvarchar](max) NOT NULL,
	[SalesOrderLineItemIsFractionalWaived] [bit] NOT NULL,
	[SalesOrderLineItemIsChargeWaived] [bit] NOT NULL,
	[SalesOrderLineItemIsCommisionable] [bit] NOT NULL,
	[SalesOrderLineItemIsService] [bit] NOT NULL,
	[SalesOrderLineItemServiceIdentifier] [nvarchar](max) NOT NULL,
	[SalesOrderLineItemInstallDate] [datetime] NULL,
	[SalesOrderLineItemProvisioningDate] [datetime] NULL,
	[SalesOrderLineItemBillingEffectiveDate] [datetime] NULL,
	[SalesOrderLineItemActivity] [varchar](max) NOT NULL,
	[SalesOrderLineItemMinQty] [int] NOT NULL,
	[SalesOrderLineItemMaxQty] [int] NOT NULL,
	[SalesOrderLineItemPaymentStatus] [tinyint] NOT NULL,
	[SalesOrderLineItemPaidThruDate] [datetime] NULL,
	[SalesOrderLineItemAPR] [decimal](15, 2) NOT NULL,
	[SalesOrderLineItemBillingMethod] [char](1) NOT NULL,
	[SalesOrderLineItemPrepaidPeriods] [int] NOT NULL,
	[SalesOrderLineItemCollectionMethod] [char](1) NOT NULL,
	[SalesOrderLineItemAgents] [nvarchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimSalesOrderLineItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[OCComponent_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
