USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[PrdComponentMap]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[PrdComponentMap](
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
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [char](1) NOT NULL
) ON [PRIMARY]
GO
