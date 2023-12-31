USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_ServiceClassifyTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_ServiceClassifyTemp](
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[accountcode] [nvarchar](20) NOT NULL,
	[IntGrpSvcItemPrice] [money] NULL,
	[IntGrpSvcnet] [decimal](38, 7) NULL,
	[CabGrpSvcItemPrice] [money] NULL,
	[CabGrpSvcnet] [decimal](38, 7) NULL,
	[HBOItemPrice] [money] NULL,
	[HBOnet] [decimal](38, 7) NULL,
	[CinemaxItemPrice] [money] NULL,
	[Cinemaxnet] [decimal](38, 7) NULL,
	[ShowtimeItemPrice] [money] NULL,
	[Showtimenet] [decimal](38, 7) NULL,
	[StarzItemPrice] [money] NULL,
	[Starznet] [decimal](38, 7) NULL,
	[CabGrpAddOnItemPrice] [money] NULL,
	[CabGrpAddOnnet] [decimal](38, 7) NULL,
	[SmartHomeItemPrice] [money] NULL,
	[SmartHomenet] [decimal](38, 7) NULL,
	[SmartHomePodItemPrice] [money] NULL,
	[SmartHomePodnet] [decimal](38, 7) NULL,
	[PointGuardItemPrice] [money] NULL,
	[PointGuardnet] [decimal](38, 7) NULL,
	[IntGrpAddOnItemPrice] [money] NULL,
	[IntGrpAddOnnet] [decimal](38, 7) NULL,
	[PhnGrpSvcItemPrice] [money] NULL,
	[PhnGrpSvcnet] [decimal](38, 7) NULL,
	[PhnGrpAddOnItemPrice] [money] NULL,
	[PhnGrpAddOnnet] [decimal](38, 7) NULL,
	[PromoPrice] [money] NULL,
	[Promonet] [decimal](38, 7) NULL,
	[TaxOrFeePrice] [money] NULL,
	[TaxFeeNet] [decimal](38, 7) NULL,
	[OtherPrice] [money] NULL,
	[OtherNet] [decimal](38, 7) NULL,
	[IsPromo] [int] NULL,
	[IsData] [int] NULL,
	[IsDataSvc] [int] NULL,
	[IsSmartHome] [int] NULL,
	[IsSmartHomePod] [int] NULL,
	[IsPointGuard] [int] NULL,
	[DataCategory] [varchar](12) NULL,
	[IsCable] [int] NULL,
	[IsCableSvc] [int] NULL,
	[IsHBO] [int] NULL,
	[IsCinemax] [int] NULL,
	[IsShowtime] [int] NULL,
	[IsStarz] [int] NULL,
	[CableCategory] [varchar](10) NULL,
	[IsPhone] [int] NULL,
	[IsPhoneSvc] [int] NULL,
	[IsComplexSvc] [int] NULL,
	[IsTaxOrFee] [int] NULL,
	[IsOther] [int] NULL,
	[IsEmployee] [int] NULL
) ON [PRIMARY]
GO
