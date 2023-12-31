USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_ManualSalesStats]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_ManualSalesStats](
	[row] [int] NOT NULL,
	[market] [varchar](20) NULL,
	[c1] [varchar](20) NULL,
	[c2] [varchar](20) NULL,
	[c3] [varchar](20) NULL,
	[c4] [varchar](20) NULL,
	[c5] [varchar](20) NULL,
	[c6] [varchar](20) NULL,
	[c7] [varchar](20) NULL,
 CONSTRAINT [PK_PBB_ManualSalesStats] PRIMARY KEY CLUSTERED 
(
	[row] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
