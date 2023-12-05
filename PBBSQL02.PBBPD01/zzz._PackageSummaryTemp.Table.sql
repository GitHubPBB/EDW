USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PackageSummaryTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PackageSummaryTemp](
	[dimaccountid] [int] NOT NULL,
	[accountcode] [nvarchar](20) NOT NULL,
	[accountname] [nvarchar](168) NOT NULL,
	[DimServiceLocationid] [int] NOT NULL,
	[Package] [nvarchar](max) NULL,
	[TotalPackageCharge] [money] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
