USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbMSCRM].[AccountBase]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbMSCRM].[AccountBase](
	[AccountId] [uniqueidentifier] NOT NULL,
	[AccountCategoryCode] [int] NULL,
	[TerritoryId] [uniqueidentifier] NULL,
	[DefaultPriceLevelId] [uniqueidentifier] NULL,
	[CustomerSizeCode] [int] NULL,
	[PreferredContactMethodCode] [int] NULL,
	[CustomerTypeCode] [int] NULL,
	[AccountRatingCode] [int] NULL,
	[IndustryCode] [int] NULL,
	[TerritoryCode] [int] NULL,
	[AccountClassificationCode] [int] NULL,
	[BusinessTypeCode] [int] NULL,
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[OriginatingLeadId] [uniqueidentifier] NULL,
	[PaymentTermsCode] [int] NULL,
	[ShippingMethodCode] [int] NULL,
	[PrimaryContactId] [uniqueidentifier] NULL,
	[ParticipatesInWorkflow] [bit] NULL,
	[Name] [nvarchar](160) NULL,
	[AccountNumber] [nvarchar](20) NULL,
	[Revenue] [money] NULL,
	[NumberOfEmployees] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[SIC] [nvarchar](20) NULL,
	[OwnershipCode] [int] NULL,
	[MarketCap] [money] NULL,
	[SharesOutstanding] [int] NULL,
	[TickerSymbol] [nvarchar](10) NULL,
	[StockExchange] [nvarchar](20) NULL,
	[WebSiteURL] [nvarchar](200) NULL,
	[FtpSiteURL] [nvarchar](200) NULL,
	[EMailAddress1] [nvarchar](100) NULL,
	[EMailAddress2] [nvarchar](100) NULL,
	[EMailAddress3] [nvarchar](100) NULL,
	[DoNotPhone] [bit] NULL,
	[DoNotFax] [bit] NULL,
	[Telephone1] [nvarchar](50) NULL,
	[DoNotEMail] [bit] NULL,
	[Telephone2] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Telephone3] [nvarchar](50) NULL,
	[DoNotPostalMail] [bit] NULL,
	[DoNotBulkEMail] [bit] NULL,
	[DoNotBulkPostalMail] [bit] NULL,
	[CreditLimit] [money] NULL,
	[CreditOnHold] [bit] NULL,
	[IsPrivate] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[ParentAccountId] [uniqueidentifier] NULL,
	[Aging30] [money] NULL,
	[StateCode] [int] NOT NULL,
	[Aging60] [money] NULL,
	[StatusCode] [int] NULL,
	[Aging90] [money] NULL,
	[PreferredAppointmentDayCode] [int] NULL,
	[PreferredSystemUserId] [uniqueidentifier] NULL,
	[PreferredAppointmentTimeCode] [int] NULL,
	[Merged] [bit] NULL,
	[DoNotSendMM] [bit] NULL,
	[MasterId] [uniqueidentifier] NULL,
	[LastUsedInCampaign] [datetime] NULL,
	[PreferredServiceId] [uniqueidentifier] NULL,
	[PreferredEquipmentId] [uniqueidentifier] NULL,
	[ExchangeRate] [numeric](23, 10) NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[CreditLimit_Base] [money] NULL,
	[Aging30_Base] [money] NULL,
	[Revenue_Base] [money] NULL,
	[Aging90_Base] [money] NULL,
	[MarketCap_Base] [money] NULL,
	[Aging60_Base] [money] NULL,
	[YomiName] [nvarchar](160) NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerIdType] [int] NOT NULL,
	[StageId] [uniqueidentifier] NULL,
	[ProcessId] [uniqueidentifier] NULL,
	[EntityImageId] [uniqueidentifier] NULL,
	[TraversedPath] [nvarchar](1250) NULL,
	[OpenDeals] [int] NULL,
	[OpenRevenue] [money] NULL,
	[OpenDeals_State] [int] NULL,
	[OpenRevenue_State] [int] NULL,
	[OpenRevenue_Date] [datetime] NULL,
	[OpenRevenue_Base] [money] NULL,
	[OpenDeals_Date] [datetime] NULL,
	[PrimarySatoriId] [nvarchar](200) NULL,
	[ModifiedByExternalParty] [uniqueidentifier] NULL,
	[CreatedByExternalParty] [uniqueidentifier] NULL,
	[PrimaryTwitterId] [nvarchar](20) NULL,
	[LastOnHoldTime] [datetime] NULL,
	[OnHoldTime] [int] NULL,
	[SLAInvokedId] [uniqueidentifier] NULL,
	[SLAId] [uniqueidentifier] NULL,
	[chr_AccountId] [int] NULL,
	[chr_CycleId] [uniqueidentifier] NULL,
	[chr_ExemptClassId] [uniqueidentifier] NULL,
	[chr_InvoiceFormatId] [uniqueidentifier] NULL,
	[chr_SalesAgentId] [uniqueidentifier] NULL,
	[chr_AccountActivationDate] [datetime] NULL,
	[chr_AccountClassId] [uniqueidentifier] NULL,
	[chr_AccountDeactivationDate] [datetime] NULL,
	[chr_AccountGroupId] [uniqueidentifier] NULL,
	[chr_AccountStatusId] [uniqueidentifier] NULL,
	[chr_AccountTypeId] [uniqueidentifier] NULL,
	[chr_AgentId] [uniqueidentifier] NULL,
	[chr_Attention] [nvarchar](50) NULL,
	[chr_BirthDate] [datetime] NULL,
	[chr_CreditLastUpdated] [nvarchar](100) NULL,
	[chr_CreditScore] [int] NULL,
	[chr_CusAccountVersion] [int] NULL,
	[chr_CustomerServiceRegionId] [uniqueidentifier] NULL,
	[chr_DesiredCycleID] [uniqueidentifier] NULL,
	[chr_donottext] [bit] NULL,
	[chr_FederalTaxIDNumber] [nvarchar](100) NULL,
	[chr_ICPrintGroupAccountVersion] [int] NULL,
	[chr_IntegrationAccountId] [int] NULL,
	[chr_light] [nvarchar](100) NULL,
	[chr_NamContactVersion] [int] NULL,
	[chr_NumOfBilledThruDate] [int] NULL,
	[chr_OptInFlag] [bit] NULL,
	[chr_OptInStatus] [nvarchar](1) NULL,
	[chr_OptInStatusDate] [datetime] NULL,
	[chr_OptOutFlag] [bit] NULL,
	[chr_OptOutStatus] [nvarchar](1) NULL,
	[chr_OptOutStatusDate] [datetime] NULL,
	[chr_OUECreditRequestId] [nvarchar](100) NULL,
	[chr_OUELight] [nvarchar](100) NULL,
	[chr_Password] [nvarchar](max) NULL,
	[chr_PasswordDate] [datetime] NULL,
	[chr_PrintGroupID] [uniqueidentifier] NULL,
	[chr_reportid] [nvarchar](100) NULL,
	[chr_ResponsibleFlag] [bit] NULL,
	[chr_SegmentId] [uniqueidentifier] NULL,
	[chr_SocialSecurityNumber] [nvarchar](100) NULL,
	[chr_SSNLast4Digits] [nvarchar](4) NULL,
	[chr_StateId] [uniqueidentifier] NULL,
	[chr_VerificationMethodId] [uniqueidentifier] NULL,
	[chr_partner_createdbycontact] [uniqueidentifier] NULL,
	[chr_partner_modifiedbycontact] [uniqueidentifier] NULL,
	[chr_CPNIEmailAddress] [nvarchar](100) NULL,
	[chr_InvoiceTemplate] [int] NULL,
	[chr_PreferredMethodofNotification] [bit] NULL,
	[chr_ThirdPartyCustomerNumber] [nvarchar](100) NULL,
	[chr_ThirdPartyInvoiceNumber] [nvarchar](100) NULL,
	[chr_ThirdPartyWorkSite] [nvarchar](100) NULL,
	[new_prajna] [nvarchar](100) NULL,
	[cus_StaticIPAddress] [nvarchar](100) NULL,
	[chr_accountsource] [int] NULL,
	[cus_CPELink] [nvarchar](4000) NULL,
	[cus_FSL360AssignmentLink] [nvarchar](4000) NULL,
	[cus_AccountsId] [uniqueidentifier] NULL,
	[cus_VoiceSwitch] [int] NULL,
	[chr_dob] [datetime] NULL,
	[chr_invoicecopiesaccountbilling] [int] NULL,
	[chr_MailingName] [nvarchar](100) NULL,
	[chr_SODetailonInvoice] [bit] NULL,
	[cus_Twitter] [nvarchar](100) NULL,
	[cus_Facebook] [nvarchar](100) NULL,
	[cus_Instagram] [nvarchar](100) NULL,
	[cus_RunProcess] [nvarchar](25) NULL,
	[cus_EmailExempt] [bit] NULL,
	[cus_LegacyAccountNumber] [nvarchar](100) NULL,
	[cus_FormattedAccountNumber] [nvarchar](100) NULL,
	[cus_PowercodeAccountNumber] [nvarchar](25) NULL,
	[cus_LinktoFixedWirelessAccountinPowercode] [nvarchar](400) NULL,
	[cus_FixedWirelessAccountExistsinPowercode] [bit] NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
