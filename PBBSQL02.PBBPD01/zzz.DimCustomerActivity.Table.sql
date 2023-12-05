USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCustomerActivity]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCustomerActivity](
	[DimCustomerActivityId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](200) NOT NULL,
	[CustomerActivity] [nvarchar](50) NOT NULL,
	[CustomerActivityAbbreviation] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCustomerActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
