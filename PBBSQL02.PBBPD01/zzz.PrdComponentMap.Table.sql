USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PrdComponentMap]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PrdComponentMap](
	[ComponentID] [int] NOT NULL,
	[ComponentCode] [nvarchar](50) NOT NULL,
	[Component] [nvarchar](50) NOT NULL,
	[ComponentClassID] [int] NOT NULL,
	[ComponentClass] [nvarchar](50) NOT NULL,
	[IsData] [int] NOT NULL,
	[IsDataSvc] [int] NOT NULL,
	[SpeedTier] [nvarchar](50) NULL,
	[IsSmartHome] [int] NOT NULL,
	[IsSmartHomePod] [int] NOT NULL,
	[IsSmartHomePromo] [int] NOT NULL,
	[IsPointGuard] [int] NOT NULL,
	[DownloadMB] [nvarchar](50) NOT NULL,
	[UploadMB] [nvarchar](50) NOT NULL,
	[IsPhone] [int] NOT NULL,
	[IsLocalPhn] [int] NOT NULL,
	[IsUnlimitedLD] [int] NOT NULL,
	[IsCallPlan] [int] NOT NULL,
	[NonPub] [int] NOT NULL,
	[NonList] [int] NOT NULL,
	[ForeignList] [int] NOT NULL,
	[TollFree] [int] NOT NULL,
	[ISDID] [int] NOT NULL,
	[IsCable] [int] NOT NULL,
	[IsCableSvc] [int] NOT NULL,
	[HBOBulk] [int] NOT NULL,
	[HBOSA] [int] NOT NULL,
	[HBOQV] [int] NOT NULL,
	[Cinemax_Standalone_SA] [int] NOT NULL,
	[Cinemax_Standalone_QV] [int] NOT NULL,
	[Cinemax_Pkg_SA] [int] NOT NULL,
	[Cinemax_pkg_qv] [int] NOT NULL,
	[Showtime_SA] [int] NOT NULL,
	[Showtime_QV] [int] NOT NULL,
	[Starz_SA] [int] NOT NULL,
	[Starz_QV] [int] NOT NULL,
	[IsHispanic] [int] NULL,
	[IsFreeHD] [int] NULL,
	[IsRF] [int] NOT NULL,
	[IsIPTV] [int] NOT NULL,
	[IsCableManual] [int] NOT NULL,
	[IsPromo] [int] NOT NULL,
	[IsNRC_Scheduling] [int] NOT NULL,
	[IsOther] [int] NOT NULL,
	[Category] [nvarchar](50) NULL,
	[IsIgnored] [int] NOT NULL,
	[IsUsed] [int] NOT NULL,
	[IsSportsTier] [int] NULL,
	[IsComplexPhn] [int] NULL,
	[IsTaxOrFee] [int] NULL,
	[IsEmployee] [int] NULL,
 CONSTRAINT [PK_PrdComponentMap] PRIMARY KEY CLUSTERED 
(
	[ComponentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsData]  DEFAULT ((0)) FOR [IsData]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsDataSvc]  DEFAULT ((0)) FOR [IsDataSvc]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_SpeedTier]  DEFAULT ('') FOR [SpeedTier]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsSmartHome]  DEFAULT ((0)) FOR [IsSmartHome]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsSmartHomePod]  DEFAULT ((0)) FOR [IsSmartHomePod]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsSmartHomePromo]  DEFAULT ((0)) FOR [IsSmartHomePromo]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsPointGuard]  DEFAULT ((0)) FOR [IsPointGuard]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_DownloadMB]  DEFAULT ('') FOR [DownloadMB]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_UploadMB]  DEFAULT ('') FOR [UploadMB]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsPhone]  DEFAULT ((0)) FOR [IsPhone]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsLocalPhn]  DEFAULT ((0)) FOR [IsLocalPhn]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsUnlimitedLD]  DEFAULT ((0)) FOR [IsUnlimitedLD]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsCallPlan]  DEFAULT ((0)) FOR [IsCallPlan]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_NonPub]  DEFAULT ((0)) FOR [NonPub]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_NonList]  DEFAULT ((0)) FOR [NonList]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_ForeignList]  DEFAULT ((0)) FOR [ForeignList]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_TollFree]  DEFAULT ((0)) FOR [TollFree]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_ISDID]  DEFAULT ((0)) FOR [ISDID]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsCable]  DEFAULT ((0)) FOR [IsCable]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsCableSvc]  DEFAULT ((0)) FOR [IsCableSvc]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_HBOBulk]  DEFAULT ((0)) FOR [HBOBulk]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_HBOSA]  DEFAULT ((0)) FOR [HBOSA]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_HBOQV]  DEFAULT ((0)) FOR [HBOQV]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Cinemax_Standalone_SA]  DEFAULT ((0)) FOR [Cinemax_Standalone_SA]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Cinemax_Standalone_QV]  DEFAULT ((0)) FOR [Cinemax_Standalone_QV]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Cinemax_Pkg_SA]  DEFAULT ((0)) FOR [Cinemax_Pkg_SA]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Cinemax_pkg_qv]  DEFAULT ((0)) FOR [Cinemax_pkg_qv]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Showtime_SA]  DEFAULT ((0)) FOR [Showtime_SA]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Showtime_QV]  DEFAULT ((0)) FOR [Showtime_QV]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Starz_SA]  DEFAULT ((0)) FOR [Starz_SA]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_Starz_QV]  DEFAULT ((0)) FOR [Starz_QV]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsHispanic]  DEFAULT ((0)) FOR [IsHispanic]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsFreeHD]  DEFAULT ((0)) FOR [IsFreeHD]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsRF]  DEFAULT ((0)) FOR [IsRF]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsIPTV]  DEFAULT ((0)) FOR [IsIPTV]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsCableManual]  DEFAULT ((0)) FOR [IsCableManual]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsPromo]  DEFAULT ((0)) FOR [IsPromo]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsNRC_Scheduling]  DEFAULT ((0)) FOR [IsNRC_Scheduling]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsOther]  DEFAULT ((0)) FOR [IsOther]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsIgnored]  DEFAULT ((0)) FOR [IsIgnored]
GO
ALTER TABLE [zzz].[PrdComponentMap] ADD  CONSTRAINT [DF_PrdComponentMap_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
GO
