USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PackagePartsTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PackagePartsTemp](
	[AccountCode] [char](13) NOT NULL,
	[LocationId] [int] NOT NULL,
	[PhoneServiceCharge] [decimal](38, 6) NULL,
	[PhoneAddOnCharge] [decimal](38, 6) NULL,
	[DataServiceCharge] [decimal](38, 6) NULL,
	[SmartHomeCharge] [decimal](38, 6) NULL,
	[PromoCharge] [decimal](38, 6) NULL,
	[Allocateable] [varchar](1) NULL,
	[AllocateFlag] [int] NULL,
	[DisperseAmount] [decimal](38, 6) NULL,
	[UnallocatedPkgAmount] [decimal](38, 6) NULL
) ON [PRIMARY]
GO
