USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_BundleSort]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_BundleSort](
	[BundleType] [varchar](50) NOT NULL,
	[SortValue] [int] NULL,
	[isVideo] [bit] NULL,
	[isData] [bit] NULL,
	[isPhone] [bit] NULL,
 CONSTRAINT [PK_PBB_BundleSort] PRIMARY KEY CLUSTERED 
(
	[BundleType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
