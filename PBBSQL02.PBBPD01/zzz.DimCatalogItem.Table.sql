USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCatalogItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCatalogItem](
	[DimCatalogItemId] [int] IDENTITY(1,1) NOT NULL,
	[ProductComponentID] [nvarchar](400) NOT NULL,
	[ComponentName] [varchar](80) NOT NULL,
	[ItemPrintDescription] [varchar](80) NOT NULL,
	[ItemOfferBeginDate] [smalldatetime] NULL,
	[ItemOfferEndDate] [smalldatetime] NULL,
	[ItemMinQuantity] [int] NOT NULL,
	[ItemMaxQuantity] [int] NOT NULL,
	[ItemMinChildren] [int] NOT NULL,
	[ItemMaxChildren] [int] NOT NULL,
	[SelectionWeight] [int] NOT NULL,
	[DisperseWeight] [int] NOT NULL,
	[DisperseCharges] [nvarchar](50) NOT NULL,
	[BillWhenNonPay] [nvarchar](50) NOT NULL,
	[BillWhenSuspended] [nvarchar](50) NOT NULL,
	[AllowDualServiceBilling] [nvarchar](50) NOT NULL,
	[ItemPricingIsRequired] [nvarchar](50) NOT NULL,
	[ItemIsValid] [nvarchar](50) NOT NULL,
	[ChurnWeight] [int] NOT NULL,
	[ItemDefaultQuantity] [int] NOT NULL,
	[AutoSubscribe] [nvarchar](50) NOT NULL,
	[AllowSplitServiceBilling] [nvarchar](50) NOT NULL,
	[ItemOrderVisible] [nvarchar](50) NOT NULL,
	[ItemIsMultInstance] [nvarchar](50) NOT NULL,
	[ItemMarketingDescription] [varchar](80) NOT NULL,
	[DescriptionAssignmentMethod] [varchar](50) NOT NULL,
	[ItemIsMultipleOfParent] [nvarchar](50) NOT NULL,
	[ItemSelectTriggersPrequal] [nvarchar](50) NOT NULL,
	[ItemBusResIndicator] [nvarchar](50) NOT NULL,
	[ItemPrintMethod] [nvarchar](50) NOT NULL,
	[ItemCollectionMethod] [char](1) NOT NULL,
	[ComponentCode] [char](7) NOT NULL,
	[ComponentClass] [varchar](40) NOT NULL,
	[ComponentTypeCode] [char](4) NOT NULL,
	[ComponentType] [varchar](40) NOT NULL,
	[ItemUnitOfMeasure] [varchar](20) NOT NULL,
	[ItemUnitOfMeasureAbbreviation] [char](6) NOT NULL,
	[ItemUnitOfMeasureQuantity] [int] NOT NULL,
	[Product] [varchar](40) NOT NULL,
	[ProductClass] [varchar](40) NOT NULL,
	[ItemSegmentCode] [varchar](10) NOT NULL,
	[ItemSegment] [varchar](60) NOT NULL,
	[ItemChannelCode] [varchar](10) NOT NULL,
	[ItemChannel] [varchar](60) NOT NULL,
	[Technology] [varchar](60) NOT NULL,
	[ProvidedOver] [varchar](60) NOT NULL,
	[BilledTo] [varchar](60) NOT NULL,
	[UploadRate] [varchar](60) NOT NULL,
	[DownloadRate] [varchar](60) NOT NULL,
	[OtherTechnology] [varchar](60) NOT NULL,
	[ItemIsService] [nvarchar](50) NOT NULL,
	[OfferingName] [varchar](80) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCatalogItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProductComponentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
