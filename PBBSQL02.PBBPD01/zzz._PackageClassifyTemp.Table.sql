USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PackageClassifyTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PackageClassifyTemp](
	[DimAccountId] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountName] [nvarchar](168) NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[Package] [nvarchar](183) NULL,
	[TotalPackageCharge] [money] NULL
) ON [PRIMARY]
GO
