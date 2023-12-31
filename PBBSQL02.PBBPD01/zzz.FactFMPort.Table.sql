USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactFMPort]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactFMPort](
	[FactFMPortId] [int] IDENTITY(1,1) NOT NULL,
	[PORT_Id] [int] NOT NULL,
	[DimFMPortId] [int] NOT NULL,
	[DimFacilityId] [int] NOT NULL,
	[DimEquipmentId] [int] NOT NULL,
	[DimCircuitId] [int] NOT NULL,
	[Z_DimFacilityId] [int] NOT NULL,
	[Next_DimPortId] [int] NOT NULL,
	[DimJunctionId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactFMPortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
