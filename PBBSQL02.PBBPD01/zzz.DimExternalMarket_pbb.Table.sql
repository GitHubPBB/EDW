USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimExternalMarket_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimExternalMarket_pbb](
	[pbb_DimExternalMarketId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [uniqueidentifier] NOT NULL,
	[pbb_ExternalMarketName] [nvarchar](200) NOT NULL,
	[pbb_ExternalMarketDescription] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketAccountGroupMarket] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketAccountGroupMarketSummary] [nvarchar](100) NOT NULL,
	[pbb_ExternalMarketSort] [int] NOT NULL,
	[pbb_ExternalMarketCallStats] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pbb_DimExternalMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
