USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimFMEquipment]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimFMEquipment](
	[DimFMEquipmentId] [int] NOT NULL,
	[EQUIPMENT_Id] [int] NOT NULL,
	[EquipmentLCE] [nvarchar](100) NOT NULL,
	[EquipmentType] [nvarchar](50) NOT NULL,
	[EquipmentStatus] [nvarchar](50) NOT NULL,
	[EquipmentComment] [nvarchar](255) NOT NULL,
	[EquipmentCutStatus] [nvarchar](50) NOT NULL,
	[EquipmentAssignNum] [nvarchar](10) NOT NULL,
	[EquipmentOldAssignNum] [nvarchar](10) NOT NULL,
	[EquipmentCardAssignment] [nvarchar](50) NOT NULL,
	[EquipmentFormattedAssignNum] [nvarchar](8) NOT NULL,
	[EquipmentMfgId] [nvarchar](50) NOT NULL,
	[EquipmentTerminalAddress] [nvarchar](100) NOT NULL,
	[EquipmentCustomerOwned] [nvarchar](1) NOT NULL,
	[EquipmentCreditLimit] [nvarchar](40) NOT NULL,
	[EquipmentLocation] [nvarchar](100) NOT NULL,
	[EquipmentIP] [nvarchar](60) NOT NULL,
	[EquipmentHostIdentifier] [nvarchar](100) NOT NULL,
	[EquipmentCableCardId] [nvarchar](100) NOT NULL,
	[EquipmentMTAMAC] [nvarchar](60) NOT NULL,
	[EquipmentInstallDate] [datetime] NULL,
	[EquipmentSecurityData] [nvarchar](100) NOT NULL,
	[EquipmentBatteryInstallDate] [datetime] NULL,
	[EquipmentPurchaseDate] [datetime] NULL,
	[EquipmentItemProtected] [bit] NOT NULL,
	[EquipmentWireCenterCode] [nvarchar](50) NOT NULL,
	[EquipmentWireCenterName] [nvarchar](50) NOT NULL,
	[EquipmentEquipmentType] [nvarchar](50) NOT NULL,
	[EquipmentDeviceGroup] [nvarchar](50) NOT NULL,
	[EquipmentHeadend] [varchar](40) NOT NULL,
	[EquipmentHeadendCode] [int] NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentLCE]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentType]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentStatus]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentComment]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentCutStatus]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentAssignNum]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentOldAssignNum]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentCardAssignment]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentFormattedAssignNum]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentMfgId]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentTerminalAddress]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentCustomerOwned]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentCreditLimit]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentLocation]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentIP]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentHostIdentifier]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentCableCardId]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentMTAMAC]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentSecurityData]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ((0)) FOR [EquipmentItemProtected]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentWireCenterCode]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentWireCenterName]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentEquipmentType]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentDeviceGroup]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ('') FOR [EquipmentHeadend]
GO
ALTER TABLE [StgPbbDW].[DimFMEquipment] ADD  DEFAULT ((0)) FOR [EquipmentHeadendCode]
GO
