USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimBundleType_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimBundleType_pbb](
	[DimBundleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[BundleType] [varchar](50) NOT NULL,
	[SortValue] [int] NULL,
	[isVideo] [bit] NULL,
	[isData] [bit] NULL,
	[isPhone] [bit] NULL,
 CONSTRAINT [PK_DimBundle_pbb] PRIMARY KEY CLUSTERED 
(
	[DimBundleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
