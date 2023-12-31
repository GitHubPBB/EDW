USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbCM].[SrvLocationX]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbCM].[SrvLocationX](
	[TransactionType] [char](1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[TaxAreaID] [int] NOT NULL,
	[MSAGID] [int] NULL,
	[CountyJurisdictionID] [int] NULL,
	[DistrictJurisdictionID] [int] NULL,
	[LocationComment] [varchar](30) NULL,
	[LocationZoneID] [int] NULL,
	[WireCenterID] [int] NULL,
	[LocationDescription] [varchar](80) NULL,
	[Latitude] [varchar](11) NULL,
	[Longitude] [varchar](11) NULL,
	[CensusTract] [varchar](7) NULL,
	[CensusBlock] [varchar](4) NULL,
	[CensusStateCode] [varchar](2) NULL,
	[CensusCountyCode] [varchar](3) NULL,
	[SalesRegionID] [int] NULL,
	[TimeZoneId] [nvarchar](250) NULL,
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
