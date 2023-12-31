USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[ExternalData_Test]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[ExternalData_Test](
	[InstallMonth] [date] NOT NULL,
	[AccountCode] [varchar](20) NOT NULL,
	[AccountType] [nvarchar](50) NOT NULL,
	[GrossMRC] [money] NULL,
	[pbb_AccountMarket] [nvarchar](50) NOT NULL,
	[pbb_ReportingMarket] [nvarchar](50) NOT NULL,
	[BundleType] [nvarchar](max) NULL,
	[Speed] [varchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
