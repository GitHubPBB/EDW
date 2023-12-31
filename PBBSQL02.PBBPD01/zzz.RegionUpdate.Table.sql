USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[RegionUpdate]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[RegionUpdate](
	[Wirecenter_Region1] [nvarchar](255) NULL,
	[FullStreetAddress_Original] [nvarchar](255) NULL,
	[PostalCodePlus4] [nvarchar](255) NULL,
	[Cabinet] [float] NULL,
	[CensusStateCode] [nvarchar](255) NULL,
	[CensusCountyCode] [nvarchar](255) NULL,
	[Zone] [nvarchar](255) NULL,
	[WireCenter] [nvarchar](255) NULL,
	[countyjurisdictionid] [nvarchar](255) NULL,
	[districtjurisdictionid] [nvarchar](255) NULL,
	[VetroCircuitId] [nvarchar](255) NULL,
	[FundType] [nvarchar](255) NULL,
	[FundTypeId] [nvarchar](255) NULL,
	[Fiber] [nvarchar](255) NULL,
	[NetworkDeliveryMethod] [nvarchar](255) NULL,
	[Serviceable] [nvarchar](255) NULL,
	[Data] [nvarchar](255) NULL,
	[CATV] [nvarchar](255) NULL,
	[CATVDigital] [nvarchar](255) NULL,
	[Phone] [nvarchar](255) NULL,
	[FixedWireless] [nvarchar](255) NULL,
	[ID] [nvarchar](255) NULL,
	[Project_Name] [nvarchar](255) NULL,
	[MarketType2] [nvarchar](255) NULL,
	[Omnia_SrvItemLocationID] [int] NULL,
	[AccountCode1] [nvarchar](255) NULL,
	[Serviceability2] [nvarchar](255) NULL,
	[Serviceable_Date1] [datetime] NULL,
	[CreatedOn1] [datetime] NULL,
	[Account_Service_Activation_Date1] [datetime] NULL,
	[Account_Service_Deactivation_Date1] [datetime] NULL,
	[AccountType] [nvarchar](255) NULL,
	[AccountName1] [nvarchar](255) NULL,
	[ChargeAmount] [nvarchar](255) NULL,
	[Net] [nvarchar](255) NULL,
	[AccountLocationStatus1] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[OriginalProjectName] [nvarchar](255) NULL,
	[OriginalServiceable] [nvarchar](255) NULL
) ON [PRIMARY]
GO
