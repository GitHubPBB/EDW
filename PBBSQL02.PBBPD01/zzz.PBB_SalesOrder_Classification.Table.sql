USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_SalesOrder_Classification]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_SalesOrder_Classification](
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NULL,
	[SalesOrderName] [nvarchar](300) NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[DimServiceLocationId] [int] NULL,
	[LocationId] [int] NULL,
	[AccountId] [nvarchar](400) NULL,
	[CreatedOn] [date] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[Order Review Date] [date] NULL,
	[SLADimServiceLocationID] [int] NOT NULL,
	[SLADimAccountID] [int] NULL,
	[LocationAccountActivationDate] [smalldatetime] NULL,
	[LocationAccountDeactivationDate] [smalldatetime] NULL,
	[rownumber] [bigint] NULL,
	[SalesOrderClassification] [varchar](11) NOT NULL
) ON [PRIMARY]
GO
