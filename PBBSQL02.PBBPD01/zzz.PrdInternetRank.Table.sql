USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PrdInternetRank]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PrdInternetRank](
	[Category] [varchar](12) NOT NULL,
	[Rnk] [int] NOT NULL,
 CONSTRAINT [PK_PrdInternetRank] PRIMARY KEY CLUSTERED 
(
	[Category] ASC,
	[Rnk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
