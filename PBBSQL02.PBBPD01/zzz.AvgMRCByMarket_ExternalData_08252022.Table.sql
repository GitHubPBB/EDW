USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[AvgMRCByMarket_ExternalData_08252022]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[AvgMRCByMarket_ExternalData_08252022](
	[InstallMonth] [date] NOT NULL,
	[AccountCode] [varchar](20) NULL,
	[AccountType] [nvarchar](50) NULL,
	[GrossMRC] [money] NULL,
	[pbb_AccountMarket] [nvarchar](50) NULL,
	[pbb_ReportingMarket] [nvarchar](50) NULL,
	[BundleType] [nvarchar](max) NULL,
	[Speed] [varchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
