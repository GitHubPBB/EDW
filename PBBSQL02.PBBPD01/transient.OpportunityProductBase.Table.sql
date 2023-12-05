USE [PBBPDW01]
GO
/****** Object:  Table [transient].[OpportunityProductBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[OpportunityProductBase](
	[ProductId] [uniqueidentifier] NULL,
	[OpportunityProductId] [uniqueidentifier] NOT NULL,
	[PricingErrorCode] [int] NULL,
	[IsProductOverridden] [bit] NULL,
	[IsPriceOverridden] [bit] NULL,
	[PricePerUnit] [money] NULL,
	[OpportunityId] [uniqueidentifier] NOT NULL,
	[BaseAmount] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UoMId] [uniqueidentifier] NULL,
	[ManualDiscountAmount] [money] NULL,
	[Quantity] [numeric](23, 10) NULL,
	[CreatedOn] [datetime] NULL,
	[VolumeDiscountAmount] [money] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[Tax] [money] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ProductDescription] [nvarchar](500) NULL,
	[ModifiedOn] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
	[VersionNumber] [timestamp] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[ExchangeRate] [numeric](23, 10) NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[BaseAmount_Base] [money] NULL,
	[ManualDiscountAmount_Base] [money] NULL,
	[VolumeDiscountAmount_Base] [money] NULL,
	[PricePerUnit_Base] [money] NULL,
	[Tax_Base] [money] NULL,
	[ExtendedAmount_Base] [money] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[LineItemNumber] [int] NULL,
	[EntityImageId] [uniqueidentifier] NULL,
	[SequenceNumber] [int] NULL,
	[ProductTypeCode] [int] NOT NULL,
	[ParentBundleId] [uniqueidentifier] NULL,
	[PropertyConfigurationStatus] [int] NOT NULL,
	[ProductAssociationId] [uniqueidentifier] NULL,
	[chr_LocalProductChargeType] [int] NULL,
	[chr_OCComponentID] [int] NULL,
	[chr_ProductType] [int] NULL,
	[chr_RevenueClassification] [uniqueidentifier] NULL,
	[chr_EffectiveDate] [datetime] NULL,
	[chr_ProvisioningDate] [datetime] NULL,
	[cus_Equipment] [nvarchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
