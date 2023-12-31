USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimAccountCategory]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimAccountCategory](
	[DimAccountCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](200) NOT NULL,
	[AccountClassCode] [nvarchar](20) NOT NULL,
	[AccountClass] [nvarchar](256) NOT NULL,
	[AccountGroupCode] [nvarchar](20) NOT NULL,
	[AccountGroup] [nvarchar](256) NOT NULL,
	[AccountTypeCode] [varchar](4) NOT NULL,
	[AccountType] [nvarchar](100) NOT NULL,
	[CustomerServiceRegionCode] [nvarchar](20) NOT NULL,
	[CustomerServiceRegion] [nvarchar](256) NOT NULL,
	[CycleNumber] [int] NOT NULL,
	[CycleDescription] [varchar](40) NOT NULL,
	[CycleDay] [char](2) NOT NULL,
	[AccountSegment] [nvarchar](1000) NOT NULL,
	[AccountTaxExemption] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimAccountCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
