USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimMsag]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimMsag](
	[DimMsagId] [int] IDENTITY(1,1) NOT NULL,
	[MsagId] [int] NOT NULL,
	[MSAG_OMNIAStreet] [varchar](66) NOT NULL,
	[MSAG_OMNIAPreDirectional] [varchar](2) NOT NULL,
	[MSAG_OMNIAStreetSuffix] [varchar](4) NOT NULL,
	[MSAG_OMNIAPostDirectional] [varchar](2) NOT NULL,
	[MSAGLowHouse] [varchar](10) NOT NULL,
	[MSAGHighHouse] [varchar](10) NOT NULL,
	[MSAGNumberingMethod] [varchar](1) NOT NULL,
	[MSAGPreDirectional] [varchar](3) NOT NULL,
	[MSAGStreet] [varchar](66) NOT NULL,
	[MSAGStreetSuffix] [varchar](14) NOT NULL,
	[MSAGPostDirectional] [varchar](3) NOT NULL,
	[MSAGExchange] [varchar](4) NOT NULL,
	[MSAGCountyID] [varchar](28) NOT NULL,
	[MSAGTarCode] [varchar](6) NOT NULL,
	[MSAGPSAP] [varchar](5) NOT NULL,
	[MSAGESN] [varchar](5) NOT NULL,
	[MSAGCommunity] [varchar](32) NOT NULL,
	[MSAGState] [varchar](2) NOT NULL,
	[MSAGTransferID] [int] NOT NULL,
	[MSAGTransferDate] [datetime] NULL,
	[MSAGDistribution] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimMsagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MsagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
