USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_DimServiceLocation_pbbbu]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_DimServiceLocation_pbbbu](
	[pbb_DimServiceLocationId] [int] IDENTITY(1,1) NOT NULL,
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
	[pbb_LoadDate] [datetime] NULL
) ON [PRIMARY]
GO
