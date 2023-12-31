USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimBilledAccount_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimBilledAccount_pbb](
	[DimAccountId] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NULL,
	[BillingYearMonth] [int] NOT NULL,
	[AccountPreviousBundleType] [varchar](50) NULL,
	[AccountCurrentBundleType] [varchar](50) NULL,
	[AccountTransitionType] [varchar](50) NULL,
 CONSTRAINT [PK_FactBilledAccount_pbb] PRIMARY KEY CLUSTERED 
(
	[DimAccountId] ASC,
	[BillingYearMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
