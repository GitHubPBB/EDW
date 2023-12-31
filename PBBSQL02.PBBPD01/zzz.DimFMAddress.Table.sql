USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMAddress]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMAddress](
	[DimFMAddressId] [int] IDENTITY(1,1) NOT NULL,
	[ADDRESS_Id] [int] NOT NULL,
	[AddressComment] [nvarchar](255) NOT NULL,
	[AddressDrawName] [nvarchar](100) NOT NULL,
	[AddressHandle] [nvarchar](50) NOT NULL,
	[AddressXLoc] [float] NOT NULL,
	[AddressYLoc] [float] NOT NULL,
	[AddressCounty] [nvarchar](50) NOT NULL,
	[AddressCompany] [nvarchar](5) NOT NULL,
	[AddressBuildingName] [nvarchar](40) NOT NULL,
	[AddressServiceableDate] [date] NULL,
	[AddressType] [nvarchar](25) NOT NULL,
	[AddressWireCenterCode] [nvarchar](50) NOT NULL,
	[AddressWireCenterName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimFMAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ADDRESS_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
