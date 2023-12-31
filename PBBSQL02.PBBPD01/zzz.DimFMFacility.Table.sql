USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMFacility]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMFacility](
	[DimFMFacilityId] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[DimFMFacilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FACILITY_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
