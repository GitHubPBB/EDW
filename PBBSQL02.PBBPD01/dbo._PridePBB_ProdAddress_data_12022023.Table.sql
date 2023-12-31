USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[_PridePBB_ProdAddress_data_12022023]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_PridePBB_ProdAddress_data_12022023](
	[LocationId] [nvarchar](50) NULL,
	[FullAddress] [nvarchar](256) NULL,
	[SalesRegion] [nvarchar](100) NULL,
	[chr_stateorprovince] [nvarchar](7) NULL,
	[Serviceable] [nvarchar](4000) NULL,
	[PremiseType] [nvarchar](4000) NULL,
	[cus_ProjectName] [nvarchar](100) NULL,
	[cus_ProjectCode] [nvarchar](100) NULL,
	[cus_CabinetNameName] [nvarchar](100) NULL,
	[MDUType] [nvarchar](4000) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
	[Modified_YEAR] [int] NULL,
	[chr_latitude] [nvarchar](11) NULL,
	[chr_longitude] [nvarchar](11) NULL,
	[cus_VetroCircuitID] [nvarchar](100) NULL,
	[chr_taxareaidName] [nvarchar](256) NULL,
	[fiber] [nvarchar](4000) NULL
) ON [PRIMARY]
GO
