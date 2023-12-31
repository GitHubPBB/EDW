USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimDistribution]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimDistribution](
	[DimDistributionId] [int] IDENTITY(1,1) NOT NULL,
	[DistributionId] [int] NOT NULL,
	[Distribution] [varchar](40) NOT NULL,
	[DistributionDirection] [char](1) NOT NULL,
	[DistributionInterval] [char](1) NOT NULL,
	[HostComputer] [varchar](40) NOT NULL,
	[FilePath] [varchar](255) NOT NULL,
	[MaximumFileRecordCount] [int] NOT NULL,
	[DistributionClass] [varchar](40) NOT NULL,
	[DistributionClassStat] [char](1) NOT NULL,
	[DistributionMedia] [varchar](40) NOT NULL,
	[DistributionMechanism] [varchar](40) NOT NULL,
	[LIDBOTCNumber] [char](6) NOT NULL,
	[LIDBCurrentOCN] [char](4) NOT NULL,
	[LIDBCurrentRAO] [char](3) NOT NULL,
	[LIDBFileFormatProgID] [varchar](40) NOT NULL,
	[LIDBIncludeCallingCards] [tinyint] NOT NULL,
	[LIDBThresholdCode] [char](1) NOT NULL,
	[LIDBICONumber] [char](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimDistributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DistributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
