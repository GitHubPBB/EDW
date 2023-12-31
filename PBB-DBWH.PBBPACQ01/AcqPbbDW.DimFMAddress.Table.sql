USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimFMAddress]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimFMAddress](
	[DimFMAddressId] [int] NOT NULL,
	[ADDRESS_Id] [int] NOT NULL,
	[AddressComment] [nvarchar](255) NOT NULL,
	[AddressDrawName] [nvarchar](100) NOT NULL,
	[AddressHandle] [nvarchar](50) NOT NULL,
	[AddressXLoc] [float] NOT NULL,
	[AddressYLoc] [float] NOT NULL,
	[AddressCounty] [nvarchar](50) NOT NULL,
	[AddressCompany] [nvarchar](5) NOT NULL,
	[AddressBuildingName] [nvarchar](40) NOT NULL,
	[AddressServiceableDate] [date] NULL,
	[AddressType] [nvarchar](25) NOT NULL,
	[AddressWireCenterCode] [nvarchar](50) NOT NULL,
	[AddressWireCenterName] [nvarchar](50) NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressComment]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressDrawName]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressHandle]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ((0)) FOR [AddressXLoc]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ((0)) FOR [AddressYLoc]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressCounty]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressCompany]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressBuildingName]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressType]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressWireCenterCode]
GO
ALTER TABLE [AcqPbbDW].[DimFMAddress] ADD  DEFAULT ('') FOR [AddressWireCenterName]
GO
