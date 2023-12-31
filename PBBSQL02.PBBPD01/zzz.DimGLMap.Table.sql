USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimGLMap]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimGLMap](
	[DimGLMapId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](20) NOT NULL,
	[GLMapType] [varchar](20) NOT NULL,
	[ReceivableGLAccount] [varchar](40) NOT NULL,
	[ReceivableGLAccountNumber] [varchar](30) NOT NULL,
	[ReceivableGLSubAccountNumber] [varchar](15) NOT NULL,
	[ReceivableGLCompanyCode] [char](10) NOT NULL,
	[ReceivableGLCompany] [varchar](40) NOT NULL,
	[RevenueGLAccount] [varchar](40) NOT NULL,
	[RevenueGLAccountNumber] [varchar](30) NOT NULL,
	[RevenueGLSubAccountNumber] [varchar](15) NOT NULL,
	[RevenueGLCompanyCode] [char](10) NOT NULL,
	[RevenueGLCompany] [varchar](40) NOT NULL,
	[SCD_EffectiveDate] [datetime] NULL,
	[SCD_ExpirationDate] [datetime] NULL,
	[SCD_IsCurrentRow] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimGLMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
