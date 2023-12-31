USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimServiceLocation_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimServiceLocation_pbb](
	[pbb_DimServiceLocationId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[pbb_LocationProjectCode] [nvarchar](100) NOT NULL,
	[pbb_LocationVetroCircuitID] [nvarchar](100) NOT NULL,
	[pbb_LocationMadeServiceableBy] [nvarchar](100) NOT NULL,
	[pbb_LocationIsServiceable] [nvarchar](50) NOT NULL,
	[pbb_LocationServiceableDate] [nvarchar](50) NOT NULL,
	[pbb_NonServiceableReason] [nvarchar](50) NOT NULL,
	[pbb_CATV] [nvarchar](50) NOT NULL,
	[pbb_CATVDigital] [nvarchar](50) NOT NULL,
	[pbb_Data] [nvarchar](50) NOT NULL,
	[pbb_Phone] [nvarchar](50) NOT NULL,
	[pbb_Fiber] [nvarchar](50) NOT NULL,
	[pbb_FixedWireless] [nvarchar](50) NOT NULL,
	[pbb_DefaultNetworkDelivery] [nvarchar](50) NULL,
	[pbb_FundType] [nvarchar](50) NOT NULL,
	[pbb_FundTypeID] [nvarchar](50) NOT NULL,
	[pbb_LoadDate] [datetime] NULL,
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
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_LocationProjectCode]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_LocationVetroCircuitID]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_LocationMadeServiceableBy]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_LocationIsServiceable]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_LocationServiceableDate]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_NonServiceableReason]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_CATV]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_CATVDigital]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_Data]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_Phone]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_Fiber]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_FixedWireless]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_DefaultNetworkDelivery]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_FundType]
GO
ALTER TABLE [StgPbbDW].[DimServiceLocation_pbb] ADD  DEFAULT ('') FOR [pbb_FundTypeID]
GO
