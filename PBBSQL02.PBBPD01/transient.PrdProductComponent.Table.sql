USE [PBBPDW01]
GO
/****** Object:  Table [transient].[PrdProductComponent]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[PrdProductComponent](
	[ProductComponentID] [int] NOT NULL,
	[Version] [timestamp] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[RootProductComponentID] [int] NULL,
	[ProductComponent] [varchar](80) NOT NULL,
	[PrintDescription] [varchar](80) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[ProviderID] [int] NOT NULL,
	[ParentProductComponentID] [int] NULL,
	[OfferBeginDate] [smalldatetime] NOT NULL,
	[OfferEndDate] [smalldatetime] NULL,
	[MinQuantity] [int] NOT NULL,
	[MaxQuantity] [int] NOT NULL,
	[MinChildren] [int] NOT NULL,
	[MaxChildren] [int] NOT NULL,
	[SelectionWeight] [int] NOT NULL,
	[DisperseWeight] [int] NOT NULL,
	[DisperseCharges] [bit] NOT NULL,
	[DefaultPrice] [numeric](15, 7) NOT NULL,
	[BillWhenNonPay] [bit] NOT NULL,
	[BillWhenSuspended] [bit] NOT NULL,
	[AllowDualServiceBilling] [bit] NOT NULL,
	[PricingIsRequired] [bit] NOT NULL,
	[Remarks] [varchar](8000) NULL,
	[IsValid] [bit] NOT NULL,
	[ChurnWeight] [int] NOT NULL,
	[DefaultCost] [numeric](15, 7) NOT NULL,
	[DefaultQuantity] [int] NOT NULL,
	[AutoSubscribe] [bit] NOT NULL,
	[AllowSplitServiceBilling] [bit] NOT NULL,
	[OrderVisible] [bit] NOT NULL,
	[BasisListID] [int] NULL,
	[ProrateListID] [int] NULL,
	[QualifyingStoredProc] [varchar](128) NULL,
	[DisperseAmount] [numeric](15, 7) NULL,
	[IsMultInstance] [bit] NOT NULL,
	[MarketingDescription] [varchar](80) NULL,
	[DescriptionAssignmentMethod] [char](1) NOT NULL,
	[IsMultipleOfParent] [bit] NOT NULL,
	[SelectTriggersPrequal] [bit] NOT NULL,
	[BusResIndicator] [char](1) NULL,
	[PrintMethod] [char](1) NOT NULL,
	[CollectionMethod] [char](1) NULL,
	[PrepayFrequencyMask] [varchar](512) NULL,
	[PrepayFrequencyDefault] [char](1) NULL,
	[PrepayAutoRenew] [char](1) NULL,
	[PackageAliasComponentID] [int] NULL,
	[DisableProviderOverride] [bit] NULL
) ON [PRIMARY]
GO
