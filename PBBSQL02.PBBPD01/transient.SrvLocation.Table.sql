USE [PBBPDW01]
GO
/****** Object:  Table [transient].[SrvLocation]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[SrvLocation](
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
	[TimeZoneId] [nvarchar](250) NULL
) ON [PRIMARY]
GO
