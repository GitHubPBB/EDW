USE [PBBPDW01]
GO
/****** Object:  Table [transient].[ADDRESS]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[ADDRESS](
	[Id] [int] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[DrawName] [nvarchar](100) NULL,
	[Handle] [nvarchar](50) NULL,
	[XLoc] [float] NULL,
	[YLoc] [float] NULL,
	[WO_Id] [int] NULL,
	[JUNCTION_Id] [int] NULL,
	[CATVJUNCTION_Id] [int] NULL,
	[WIRECENTER_Id] [int] NULL,
	[County] [nvarchar](50) NULL,
	[Company] [nvarchar](5) NULL,
	[MSAG_Id] [int] NULL,
	[BuildingName] [nvarchar](40) NULL,
	[SrvLocation_LocationID] [int] NULL,
	[STATUS] [nvarchar](50) NULL,
	[HISU] [varchar](50) NULL,
	[ServiceableDate] [datetime] NULL,
	[PADDRESS_Id] [int] NULL,
	[DistributionJUNCTION_Id] [int] NULL,
	[wfWORKGROUP_Id] [int] NULL,
	[Type] [nvarchar](25) NULL,
	[fmTROUBLESEVERITY_Id] [nvarchar](50) NULL,
	[Serviceable] [bit] NULL,
	[Phone] [bit] NULL,
	[Data] [bit] NULL,
	[CATV] [bit] NULL,
	[ThirdPartyAccount] [nvarchar](50) NULL,
	[DeliveryMethod] [nvarchar](50) NULL,
	[Voip] [nvarchar](50) NULL,
	[Mdu] [nvarchar](50) NULL,
	[LocationType] [nvarchar](50) NULL,
	[Rental] [nvarchar](50) NULL,
	[BusRes] [nvarchar](50) NULL,
	[CATVDigital] [bit] NULL,
	[Satellite] [bit] NULL,
	[CopperNIDBit] [bit] NULL,
	[FiberNIDBit] [bit] NULL,
	[DistanceFromCO] [nvarchar](25) NULL,
	[BandWidthTotal] [nvarchar](50) NULL,
	[FundType] [varchar](50) NULL,
	[FundTypeID] [varchar](50) NULL,
	[LoadDate] [int] NULL,
	[FMInitializeAllowed] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
