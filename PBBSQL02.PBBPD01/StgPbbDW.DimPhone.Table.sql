USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimPhone]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimPhone](
	[DimPhoneId] [int] NOT NULL,
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
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ((0)) FOR [PhoneStatusIndicator]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneNumber]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneStatus]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneESN]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneExchangeCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSeries]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneCountryCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSeriesStart]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSeriesEnd]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSeriesClassCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [ForeignPhoneClass]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [ForeignPhoneOCNDescription]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [ForeignPhoneOCN]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneAllocation]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneAllocationStationStart]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneAllocationStationEnd]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneAllocationMethod]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [AllocationPhoneStart]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [AllocationPhoneEnd]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneList]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneListManagementMethod]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneService]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [LIDBClassCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [LIDBBlock]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [DirectoryPublicationClassCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [UsageRestrictionClassCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [CallerName]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [CallerNamePrivacyMethod]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [LocalServiceFreeze]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneClassOfServiceCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [IntralataPICFreezeCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [IntralataCIC]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [IntralataPICReason]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InterlataPICFreezeCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InterlataCIC]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InterlataPICReason]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InternationalPICFreezeCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InternationalCIC]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [InternationalPICReason]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSwitch]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSwitchClass]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSwitchCLLI]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSwitchTimeZoneClassCode]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [PhoneSwitchTimeZoneClass]
GO
ALTER TABLE [StgPbbDW].[DimPhone] ADD  DEFAULT ('') FOR [WatsTerminatingNumber]
GO
