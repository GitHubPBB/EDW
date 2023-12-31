USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceLocationBundleType_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceLocationBundleType_pbb](
	[DimServiceLocationID] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[AsOfDimDateID] [date] NOT NULL,
	[PBB_BundleType] [varchar](32) NOT NULL,
	[DoesCustomerHaveOtherServices] [varchar](1) NOT NULL,
 CONSTRAINT [PK_DimServiceLocationBundleType_pbb] PRIMARY KEY CLUSTERED 
(
	[DimServiceLocationID] ASC,
	[DimAccountId] ASC,
	[AsOfDimDateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
