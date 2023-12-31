USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCustomerPrice]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCustomerPrice](
	[DimCustomerPriceId] [int] IDENTITY(1,1) NOT NULL,
	[ItemPriceID] [nvarchar](400) NOT NULL,
	[CustomerPriceWaiveFractional] [nvarchar](50) NOT NULL,
	[CustomerPriceChargeDescription] [varchar](60) NOT NULL,
	[CustomerPriceBilledThruDate] [smalldatetime] NULL,
	[CustomerPriceNumberOfPeriodsBilled] [decimal](15, 7) NOT NULL,
	[CustomerPriceWaiveCharge] [nvarchar](50) NOT NULL,
	[CustomerPriceBillingMethod] [nvarchar](50) NOT NULL,
	[CustomerPriceAPR] [decimal](15, 4) NOT NULL,
	[CustomerPriceList] [nvarchar](80) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCustomerPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ItemPriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
