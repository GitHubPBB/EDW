USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimQuote]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimQuote](
	[DimQuoteId] [int] IDENTITY(1,1) NOT NULL,
	[QuoteId] [nvarchar](400) NOT NULL,
	[QuoteNumber] [nvarchar](100) NOT NULL,
	[QuoteRevisionNumber] [int] NOT NULL,
	[QuoteName] [nvarchar](300) NOT NULL,
	[QuoteEffectiveFrom] [datetime] NULL,
	[QuoteExpiresOn] [datetime] NULL,
	[QuoteStatus] [nvarchar](256) NOT NULL,
	[QuoteStatusReason] [nvarchar](256) NOT NULL,
	[QuoteRequestDeliveryBy] [datetime] NULL,
	[QuoteEffectiveTo] [datetime] NULL,
	[QuoteAddressLine1] [nvarchar](4000) NOT NULL,
	[QuoteAddressLine2] [nvarchar](4000) NOT NULL,
	[QuoteAddressLine3] [nvarchar](4000) NOT NULL,
	[QuoteAddressCity] [nvarchar](80) NOT NULL,
	[QuoteAddressState] [nvarchar](50) NOT NULL,
	[QuoteAddressPostalCode] [nvarchar](20) NOT NULL,
	[QuoteAddressCountry] [nvarchar](80) NOT NULL,
	[QuoteAddressTelephone] [nvarchar](50) NOT NULL,
	[QuoteAddressFax] [nvarchar](50) NOT NULL,
	[QuoteOwner] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimQuoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[QuoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
