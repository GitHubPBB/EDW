USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMJunction]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMJunction](
	[DimFMJunctionId] [int] IDENTITY(1,1) NOT NULL,
	[JUNCTION_Id] [int] NOT NULL,
	[JunctionName] [nvarchar](75) NOT NULL,
	[JunctionRoute] [nvarchar](50) NOT NULL,
	[JunctionType] [nvarchar](20) NOT NULL,
	[JunctionComment] [nvarchar](255) NOT NULL,
	[JunctionStatus] [nvarchar](50) NOT NULL,
	[JunctionDrawname] [nvarchar](100) NOT NULL,
	[JunctionHandle] [nvarchar](50) NOT NULL,
	[JunctionXLoc] [float] NOT NULL,
	[JunctionYLoc] [float] NOT NULL,
	[JunctionTemplate] [nvarchar](50) NOT NULL,
	[JunctionStartRackPosition] [int] NOT NULL,
	[JunctionEndRackPosition] [int] NOT NULL,
	[JunctionDistanceFromCO] [nvarchar](50) NOT NULL,
	[JunctionOwnership] [nvarchar](50) NOT NULL,
	[JunctionJunctionType] [nvarchar](32) NOT NULL,
	[JunctionWireCenterName] [nvarchar](50) NOT NULL,
	[JunctionWireCenterCode] [nvarchar](50) NOT NULL,
	[JunctionDeviceGroup] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimFMJunctionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[JUNCTION_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
