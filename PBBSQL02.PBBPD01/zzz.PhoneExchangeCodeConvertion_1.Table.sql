USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PhoneExchangeCodeConvertion_1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PhoneExchangeCodeConvertion_1](
	[Market] [varchar](3) NULL,
	[PhoneExchangeCode] [varchar](7) NULL,
	[ResultMarket] [varchar](7) NULL,
	[IsCorrection] [bit] NULL
) ON [PRIMARY]
GO
