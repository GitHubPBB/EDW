USE [PBBPDW01]
GO
/****** Object:  Table [AcqPbbDW].[DimCustomerProduct]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimCustomerProduct](
	[DimCustomerProductId] [int] NOT NULL,
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
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [char](1) NOT NULL
) ON [PRIMARY]
GO
