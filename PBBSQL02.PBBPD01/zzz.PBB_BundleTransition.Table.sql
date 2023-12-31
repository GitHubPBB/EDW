USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_BundleTransition]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_BundleTransition](
	[BundleType] [varchar](50) NOT NULL,
	[ToBundleType] [varchar](50) NOT NULL,
	[TransitionType] [varchar](50) NULL,
 CONSTRAINT [PK_PBB_BundleTransition] PRIMARY KEY CLUSTERED 
(
	[BundleType] ASC,
	[ToBundleType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
