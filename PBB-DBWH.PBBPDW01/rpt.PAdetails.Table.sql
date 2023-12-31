USE [PBBPDW01]
GO
/****** Object:  Table [rpt].[PAdetails]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[PAdetails](
	[spid] [int] NOT NULL,
	[DimAccountId] [int] NULL,
	[DimServiceLocationId] [int] NULL,
	[AccountCode] [varchar](10) NULL,
	[AccountName] [varchar](100) NULL,
	[Package] [varchar](100) NULL,
	[TotalPackageCharge] [decimal](12, 2) NULL
) ON [PRIMARY]
GO
