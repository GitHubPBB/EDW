USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PAndLAdHocMapping]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PAndLAdHocMapping](
	[DimGLMapId] [int] IDENTITY(1,1) NOT NULL,
	[RevenueGLAccount] [varchar](40) NOT NULL,
	[RevenueGLAccountNumber] [varchar](30) NOT NULL,
	[RevenueGLSubAccountNumber] [varchar](15) NOT NULL,
	[RevenueGLCompanyCode] [char](10) NOT NULL,
	[RevenueGLCompany] [varchar](40) NOT NULL,
	[Category] [varchar](50) NULL
) ON [PRIMARY]
GO
