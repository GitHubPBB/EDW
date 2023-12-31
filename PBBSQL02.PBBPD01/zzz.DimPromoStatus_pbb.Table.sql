USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimPromoStatus_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimPromoStatus_pbb](
	[AccountCode] [char](13) NOT NULL,
	[ProductOffering] [varchar](80) NOT NULL,
	[Priceplan] [varchar](80) NOT NULL,
	[ComponentCode] [char](7) NOT NULL,
	[component] [varchar](40) NOT NULL,
	[Begindate] [smalldatetime] NOT NULL,
	[NumberofRecurrences] [int] NULL,
	[EndDate] [smalldatetime] NULL,
	[Status] [varchar](7) NULL,
	[Itemid] [int] NOT NULL,
	[Locationid] [int] NOT NULL
) ON [PRIMARY]
GO
