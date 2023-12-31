USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCatalogOCC]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCatalogOCC](
	[DimCatalogOCCId] [int] IDENTITY(1,1) NOT NULL,
	[OCCID] [int] NOT NULL,
	[OCCCode] [varchar](10) NOT NULL,
	[OCCName] [varchar](200) NOT NULL,
	[OCCTypeCode] [char](1) NOT NULL,
	[OCCApplicationMethodCode] [char](1) NOT NULL,
	[OCCApplicationMethod] [varchar](10) NOT NULL,
	[OCCActivationDate] [smalldatetime] NULL,
	[OCCDeactivationDate] [smalldatetime] NULL,
	[OCCProvider] [varchar](40) NOT NULL,
	[OCCType] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCatalogOCCId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[OCCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
