USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PandLAdHocReport]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PandLAdHocReport](
	[RevenueGLAccount] [nvarchar](255) NULL,
	[RevenueGLAccountNumber] [nvarchar](255) NULL,
	[RevenueGLSubAccountNumber] [nvarchar](255) NULL,
	[RevenueGLCompanyCode] [nvarchar](255) NULL,
	[RevenueGLCompany] [nvarchar](255) NULL,
	[OtherRevenues-Customer] [nvarchar](255) NULL,
	[Other Revenues-Non Customer] [nvarchar](255) NULL,
	[Credits&Allowances] [nvarchar](255) NULL
) ON [PRIMARY]
GO
