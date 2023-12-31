USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactFMCircuit]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactFMCircuit](
	[FactFMCircuitId] [int] IDENTITY(1,1) NOT NULL,
	[CIRCUIT_Id] [int] NOT NULL,
	[DimFMCircuitId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimWorkOrderId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Parent_DimFMCircuitId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Z_DimFMAddressId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMJunctionId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactFMCircuitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
