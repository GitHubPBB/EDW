USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactServiceLocation]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactServiceLocation](
	[FactServiceLocationId] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimMsagId] [int] NOT NULL,
	[EffectiveStartDate] [datetime] NOT NULL,
	[EffectiveEndDate] [datetime] NOT NULL,
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
ALTER TABLE [StgPbbDW].[FactServiceLocation] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [StgPbbDW].[FactServiceLocation] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [StgPbbDW].[FactServiceLocation] ADD  DEFAULT ((0)) FOR [DimMsagId]
GO
ALTER TABLE [StgPbbDW].[FactServiceLocation] ADD  DEFAULT ('1900-01-01') FOR [EffectiveStartDate]
GO
ALTER TABLE [StgPbbDW].[FactServiceLocation] ADD  DEFAULT ('2050-01-01') FOR [EffectiveEndDate]
GO
