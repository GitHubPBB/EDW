USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCustomerProduct]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCustomerProduct](
	[DimCustomerProductId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](200) NOT NULL,
	[ProductStatusCode] [varchar](1) NOT NULL,
	[ProductStatus] [varchar](20) NOT NULL,
	[ProductName] [varchar](40) NOT NULL,
	[ProductClass] [varchar](40) NOT NULL,
	[ProductBundle] [varchar](40) NOT NULL,
	[ProductConfiguration] [varchar](40) NOT NULL,
	[ProductProviderCode] [varchar](7) NOT NULL,
	[ProductProvider] [varchar](40) NOT NULL,
	[ProductServiceArea] [varchar](40) NOT NULL,
	[ProductExemptionType] [varchar](40) NOT NULL,
	[ProductBusResIndicatorCode] [varchar](1) NOT NULL,
	[ProductBusResIndicator] [varchar](40) NOT NULL,
	[ProductAdditionalInformation] [varchar](40) NOT NULL,
	[ProductDivisionCode] [varchar](7) NOT NULL,
	[ProductDivision] [varchar](40) NOT NULL,
	[ProductReportAreaCode] [varchar](10) NOT NULL,
	[ProductReportArea] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCustomerProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
