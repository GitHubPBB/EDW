USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PBB_AccountRecurringPaymentMethodTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PBB_AccountRecurringPaymentMethodTemp](
	[AccountCode] [nvarchar](50) NULL,
	[Method] [varchar](14) NOT NULL
) ON [PRIMARY]
GO
