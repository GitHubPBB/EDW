USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactFMEquipment]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactFMEquipment](
	[FactFMEquipmentId] [int] IDENTITY(1,1) NOT NULL,
	[EQUIPMENT_Id] [int] NOT NULL,
	[DimFMEquipmentId] [int] NOT NULL,
	[DimFMCircuitId] [int] NOT NULL,
	[DimFMJunctionId] [int] NOT NULL,
	[DimFMFacilityId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactFMEquipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
