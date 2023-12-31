USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[AvgMRCByMarket_ExternalData]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[AvgMRCByMarket_ExternalData](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InstallMonth] [date] NOT NULL,
	[AccountCode] [varchar](20) NOT NULL,
	[AccountType] [nvarchar](50) NOT NULL,
	[GrossMRC] [money] NULL,
	[pbb_AccountMarket] [nvarchar](50) NOT NULL,
	[pbb_ReportingMarket] [nvarchar](50) NOT NULL,
	[BundleType] [nvarchar](max) NULL,
	[Speed] [varchar](20) NULL,
 CONSTRAINT [PK_AvgMRCByMarket_ExternalData] PRIMARY KEY CLUSTERED 
(
	[InstallMonth] ASC,
	[AccountCode] ASC,
	[AccountType] ASC,
	[pbb_AccountMarket] ASC,
	[pbb_ReportingMarket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
