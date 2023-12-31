USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceActivityResource]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceActivityResource](
	[DimServiceActivityResourceId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityPartyId] [uniqueidentifier] NOT NULL,
	[ServiceActivityResourceName] [nvarchar](4000) NOT NULL,
	[ServiceActivityResourceType] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimServiceActivityResourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ActivityPartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
