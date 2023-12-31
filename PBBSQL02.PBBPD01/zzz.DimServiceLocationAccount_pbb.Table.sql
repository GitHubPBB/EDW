USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceLocationAccount_pbb]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceLocationAccount_pbb](
	[pbb_DimServiceLocationAccountId] [int] IDENTITY(1,1) NOT NULL,
	[pbb_ServiceLocationAccountId] [nvarchar](415) NOT NULL,
	[pbb_ServiceLocationAccountStatus] [nvarchar](105) NULL,
	[pbb_ServiceLocationAccountStatusRank] [int] NOT NULL,
	[pbb_LocationAccountBundleType] [varchar](32) NOT NULL,
 CONSTRAINT [PK_DimServiceLocationAccount_pbb] PRIMARY KEY CLUSTERED 
(
	[pbb_DimServiceLocationAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
