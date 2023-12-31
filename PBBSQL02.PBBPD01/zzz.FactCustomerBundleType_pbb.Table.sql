USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerBundleType_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerBundleType_pbb](
	[FactCustomerBundleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[BundleType] [varchar](100) NOT NULL,
	[EffectiveStartDate] [date] NOT NULL,
	[EffectiveEndDate] [date] NULL,
 CONSTRAINT [PK_FactCustomerBundleType_pbb] PRIMARY KEY CLUSTERED 
(
	[FactCustomerBundleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
