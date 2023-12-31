USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactFMAddress]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactFMAddress](
	[FactFMAddressId] [int] IDENTITY(1,1) NOT NULL,
	[ADDRESS_Id] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimFMWorkOrderId] [int] NOT NULL,
	[DimFMJunctionId] [int] NOT NULL,
	[CATV_DimFMJunctionId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[Parent_DimFMAddressId] [int] NOT NULL,
	[Distribution_DimFMJunctionId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactFMAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
