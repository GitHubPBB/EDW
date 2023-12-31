USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCatalogLineItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCatalogLineItem](
	[DimCatalogLineItemId] [int] IDENTITY(1,1) NOT NULL,
	[ProductComponentID] [int] NOT NULL,
	[LineItemComponentName] [varchar](80) NOT NULL,
	[LineItemPrintDescription] [varchar](80) NOT NULL,
	[LineItemOfferBeginDate] [smalldatetime] NULL,
	[LineItemOfferEndDate] [smalldatetime] NULL,
	[LineItemMinQuantity] [int] NOT NULL,
	[LineItemMaxQuantity] [int] NOT NULL,
	[LineItemMinChildren] [int] NOT NULL,
	[LineItemMaxChildren] [int] NOT NULL,
	[LineItemSelectionWeight] [int] NOT NULL,
	[LineItemDisperseWeight] [int] NOT NULL,
	[LineItemDisperseCharges] [bit] NOT NULL,
	[LineItemBillWhenNonPay] [bit] NOT NULL,
	[LineItemBillWhenSuspended] [bit] NOT NULL,
	[LineItemAllowDualServiceBilling] [bit] NOT NULL,
	[LineItemPricingIsRequired] [bit] NOT NULL,
	[LineItemRemarks] [varchar](8000) NOT NULL,
	[LineItemIsValid] [bit] NOT NULL,
	[LineItemChurnWeight] [int] NOT NULL,
	[LineItemDefaultQuantity] [int] NOT NULL,
	[LineItemAutoSubscribe] [bit] NOT NULL,
	[LineItemAllowSplitServiceBilling] [bit] NOT NULL,
	[LineItemOrderVisible] [bit] NOT NULL,
	[LineItemIsMultInstance] [bit] NOT NULL,
	[LineItemMarketingDescription] [varchar](80) NOT NULL,
	[LineItemDescriptionAssignmentMethod] [char](1) NOT NULL,
	[LineItemIsMultipleOfParent] [bit] NOT NULL,
	[LineItemSelectTriggersPrequal] [bit] NOT NULL,
	[LineItemBusResIndicator] [char](1) NOT NULL,
	[LineItemPrintMethod] [char](1) NOT NULL,
	[LineItemCollectionMethod] [char](1) NOT NULL,
	[LineItemPrepayFrequencyMask] [varchar](8) NOT NULL,
	[LineItemPrepayFrequencyDefault] [char](1) NOT NULL,
	[LineItemPrepayAutoRenew] [char](1) NOT NULL,
	[LineItemComponentCode] [char](7) NOT NULL,
	[LineItemComponentClass] [varchar](40) NOT NULL,
	[LineItemComponentTypeCode] [char](4) NOT NULL,
	[LineItemComponentType] [varchar](40) NOT NULL,
	[LineItemUnitOfMeasure] [varchar](20) NOT NULL,
	[LineItemUnitOfMeasureAbbreviation] [char](6) NOT NULL,
	[LineItemUnitOfMeasureQuantity] [int] NOT NULL,
	[LineItemProviderCode] [char](7) NOT NULL,
	[LineItemProvider] [varchar](40) NOT NULL,
	[LineItemPrintProvider] [varchar](60) NOT NULL,
	[LineItemPrintProviderAbbreviation] [char](6) NOT NULL,
	[LineItemProviderClass] [varchar](40) NOT NULL,
	[LineItemSegmentCode] [varchar](10) NOT NULL,
	[LineItemSegment] [varchar](60) NOT NULL,
	[LineItemChannelCode] [varchar](10) NOT NULL,
	[LineItemChannel] [varchar](60) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCatalogLineItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProductComponentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
