USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_IntCatTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_IntCatTemp](
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[rnk] [int] NULL
) ON [PRIMARY]
GO
