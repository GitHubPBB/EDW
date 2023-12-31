USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimAccount_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimAccount_pbb](
	[pbb_DimAccountId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [nvarchar](400) NOT NULL,
	[pbb_AccountRecurringPaymentExpirationDate] [date] NULL,
	[pbb_AccountRecurringPaymentLastFour] [varchar](20) NOT NULL,
	[pbb_AccountRecurringPaymentStartDate] [date] NULL,
	[pbb_AccountRecurringPaymentEndDate] [date] NULL,
	[pbb_AccountRecurringPaymentType] [varchar](10) NOT NULL,
	[pbb_AccountRecurringPaymentCardType] [varchar](50) NOT NULL,
	[pbb_AccountDiscountPercentage] [decimal](15, 2) NOT NULL,
	[pbb_AccountDiscountNames] [nvarchar](1000) NOT NULL,
	[pbb_BundleType] [nvarchar](100) NOT NULL,
	[pbb_AccountDiscount_DimGLMapIds] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_DimAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
