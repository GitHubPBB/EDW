USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimPhone]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimPhone](
	[DimPhoneId] [int] IDENTITY(1,1) NOT NULL,
	[PhoneId] [int] NOT NULL,
	[PhoneStatusIndicator] [tinyint] NOT NULL,
	[PhoneNumber] [char](10) NOT NULL,
	[PhoneStatus] [char](1) NOT NULL,
	[PhoneStatusDate] [smalldatetime] NULL,
	[PhoneESN] [varchar](21) NOT NULL,
	[PhoneExchangeCode] [char](7) NOT NULL,
	[PhoneSeries] [varchar](40) NOT NULL,
	[PhoneCountryCode] [varchar](5) NOT NULL,
	[PhoneSeriesStart] [varchar](10) NOT NULL,
	[PhoneSeriesEnd] [varchar](10) NOT NULL,
	[PhoneSeriesClassCode] [char](1) NOT NULL,
	[ForeignPhoneClass] [char](1) NOT NULL,
	[ForeignPhoneOCNDescription] [varchar](40) NOT NULL,
	[ForeignPhoneOCN] [char](5) NOT NULL,
	[PhoneAllocation] [varchar](40) NOT NULL,
	[PhoneAllocationStationStart] [char](4) NOT NULL,
	[PhoneAllocationStationEnd] [char](4) NOT NULL,
	[PhoneAllocationMethod] [char](1) NOT NULL,
	[PhoneAllocationExpireDate] [smalldatetime] NULL,
	[AllocationPhoneStart] [char](10) NOT NULL,
	[AllocationPhoneEnd] [char](10) NOT NULL,
	[PhoneList] [varchar](40) NOT NULL,
	[PhoneListManagementMethod] [char](1) NOT NULL,
	[PhoneService] [varchar](40) NOT NULL,
	[LIDBClassCode] [char](3) NOT NULL,
	[LIDBClassEffectiveDate] [smalldatetime] NULL,
	[LIDBBlock] [char](1) NOT NULL,
	[LIDBBlockEffectiveDate] [smalldatetime] NULL,
	[DirectoryPublicationClassCode] [char](2) NOT NULL,
	[UsageRestrictionClassCode] [char](1) NOT NULL,
	[CallerName] [varchar](15) NOT NULL,
	[CallerNamePrivacyMethod] [char](1) NOT NULL,
	[LocalServiceFreeze] [char](1) NOT NULL,
	[PhoneClassOfServiceCode] [char](1) NOT NULL,
	[IntralataPICEffectiveDate] [smalldatetime] NULL,
	[IntralataPICFreezeCode] [char](1) NOT NULL,
	[IntralataCIC] [char](5) NOT NULL,
	[IntralataPICReason] [varchar](40) NOT NULL,
	[InterlataPICEffectiveDate] [smalldatetime] NULL,
	[InterlataPICFreezeCode] [char](1) NOT NULL,
	[InterlataCIC] [char](5) NOT NULL,
	[InterlataPICReason] [varchar](40) NOT NULL,
	[InternationalPICEffectiveDate] [smalldatetime] NULL,
	[InternationalPICFreezeCode] [char](1) NOT NULL,
	[InternationalCIC] [char](5) NOT NULL,
	[InternationalPICReason] [varchar](40) NOT NULL,
	[PhoneSwitch] [char](40) NOT NULL,
	[PhoneSwitchClass] [char](40) NOT NULL,
	[PhoneSwitchCLLI] [char](11) NOT NULL,
	[PhoneSwitchTimeZoneClassCode] [char](2) NOT NULL,
	[PhoneSwitchTimeZoneClass] [varchar](40) NOT NULL,
	[WatsTerminatingNumber] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimPhoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PhoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
