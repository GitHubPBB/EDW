USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimFMFacility]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimFMFacility](
	[DimFMFacilityId] [int] NOT NULL,
	[FACILITY_Id] [int] NOT NULL,
	[FacilityCount] [int] NOT NULL,
	[FacilityRouteName] [nvarchar](500) NOT NULL,
	[FacilityName] [nvarchar](50) NOT NULL,
	[FacilityStatus] [nvarchar](50) NOT NULL,
	[FacilityType] [nvarchar](50) NOT NULL,
	[FacilityComment] [nvarchar](255) NOT NULL,
	[FacilityDrawname] [nvarchar](100) NOT NULL,
	[FacilityHandle] [nvarchar](50) NOT NULL,
	[FacilityXLoc] [float] NOT NULL,
	[FacilityYLoc] [float] NOT NULL,
	[FacilityCutStatus] [nvarchar](50) NOT NULL,
	[FacilityMACAddress] [nvarchar](50) NOT NULL,
	[FacilityItemProtected] [bit] NOT NULL,
	[FacilityWireCenterCode] [nvarchar](50) NOT NULL,
	[FacilityWireCenterName] [nvarchar](50) NOT NULL,
	[FacilityBandwidthName] [nvarchar](50) NOT NULL,
	[FacilityBandwidthKbps] [decimal](18, 0) NOT NULL,
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
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ((0)) FOR [FacilityCount]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityRouteName]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityName]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityStatus]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityType]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityComment]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityDrawname]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityHandle]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ((0)) FOR [FacilityXLoc]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ((0)) FOR [FacilityYLoc]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityCutStatus]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityMACAddress]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ((0)) FOR [FacilityItemProtected]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityWireCenterCode]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityWireCenterName]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ('') FOR [FacilityBandwidthName]
GO
ALTER TABLE [StgPbbDW].[DimFMFacility] ADD  DEFAULT ((0)) FOR [FacilityBandwidthKbps]
GO
