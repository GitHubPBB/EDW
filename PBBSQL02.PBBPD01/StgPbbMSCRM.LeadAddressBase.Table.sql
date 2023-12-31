USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[LeadAddressBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[LeadAddressBase](
	[ParentId] [uniqueidentifier] NOT NULL,
	[LeadAddressId] [uniqueidentifier] NOT NULL,
	[AddressNumber] [int] NULL,
	[AddressTypeCode] [int] NULL,
	[Name] [nvarchar](200) NULL,
	[Line1] [nvarchar](4000) NULL,
	[Line2] [nvarchar](4000) NULL,
	[Line3] [nvarchar](4000) NULL,
	[City] [nvarchar](4000) NULL,
	[StateOrProvince] [nvarchar](4000) NULL,
	[County] [nvarchar](4000) NULL,
	[Country] [nvarchar](4000) NULL,
	[PostOfficeBox] [nvarchar](4000) NULL,
	[PostalCode] [nvarchar](4000) NULL,
	[UTCOffset] [int] NULL,
	[UPSZone] [nvarchar](4) NULL,
	[Latitude] [float] NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Longitude] [float] NULL,
	[ShippingMethodCode] [int] NULL,
	[Telephone2] [nvarchar](50) NULL,
	[Telephone3] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[VersionNumber] [int] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[ExchangeRate] [decimal](18, 0) NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[Composite] [nvarchar](max) NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
