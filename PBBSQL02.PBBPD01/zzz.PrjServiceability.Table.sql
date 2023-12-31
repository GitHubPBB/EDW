USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PrjServiceability]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PrjServiceability](
	[ProjectName] [nvarchar](200) NOT NULL,
	[ServiceableDate] [date] NULL,
 CONSTRAINT [PK_PrjServiceability] PRIMARY KEY CLUSTERED 
(
	[ProjectName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
