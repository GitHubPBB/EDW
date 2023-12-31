USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[SystemUserBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[SystemUserBase](
	[SystemUserId] [uniqueidentifier] NOT NULL,
	[TerritoryId] [uniqueidentifier] NULL,
	[OrganizationId] [uniqueidentifier] NOT NULL,
	[BusinessUnitId] [uniqueidentifier] NOT NULL,
	[ParentSystemUserId] [uniqueidentifier] NULL,
	[FirstName] [nvarchar](64) NULL,
	[Salutation] [nvarchar](20) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](64) NULL,
	[PersonalEMailAddress] [nvarchar](100) NULL,
	[FullName] [nvarchar](200) NULL,
	[NickName] [nvarchar](50) NULL,
	[Title] [nvarchar](128) NULL,
	[InternalEMailAddress] [nvarchar](100) NULL,
	[JobTitle] [nvarchar](100) NULL,
	[MobileAlertEMail] [nvarchar](100) NULL,
	[PreferredEmailCode] [int] NULL,
	[HomePhone] [nvarchar](50) NULL,
	[MobilePhone] [nvarchar](64) NULL,
	[PreferredPhoneCode] [int] NULL,
	[PreferredAddressCode] [int] NULL,
	[PhotoUrl] [nvarchar](200) NULL,
	[DomainName] [nvarchar](1024) NOT NULL,
	[PassportLo] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[PassportHi] [int] NULL,
	[DisabledReason] [nvarchar](500) NULL,
	[ModifiedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[EmployeeId] [nvarchar](100) NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[IsDisabled] [bit] NULL,
	[GovernmentId] [nvarchar](100) NULL,
	[VersionNumber] [int] NULL,
	[Skills] [nvarchar](100) NULL,
	[DisplayInServiceViews] [bit] NULL,
	[CalendarId] [uniqueidentifier] NULL,
	[ActiveDirectoryGuid] [uniqueidentifier] NULL,
	[SetupUser] [bit] NOT NULL,
	[SiteId] [uniqueidentifier] NULL,
	[WindowsLiveID] [nvarchar](1024) NULL,
	[IncomingEmailDeliveryMethod] [int] NOT NULL,
	[OutgoingEmailDeliveryMethod] [int] NOT NULL,
	[ImportSequenceNumber] [int] NULL,
	[AccessMode] [int] NOT NULL,
	[InviteStatusCode] [int] NULL,
	[IsActiveDirectoryUser] [bit] NOT NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[YomiFullName] [nvarchar](200) NULL,
	[YomiLastName] [nvarchar](64) NULL,
	[YomiMiddleName] [nvarchar](50) NULL,
	[YomiFirstName] [nvarchar](64) NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ExchangeRate] [decimal](18, 0) NULL,
	[IsIntegrationUser] [bit] NOT NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[EmailRouterAccessApproval] [int] NOT NULL,
	[DefaultFiltersPopulated] [bit] NOT NULL,
	[CALType] [int] NOT NULL,
	[QueueId] [uniqueidentifier] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[YammerEmailAddress] [nvarchar](100) NULL,
	[IsSyncWithDirectory] [bit] NOT NULL,
	[DefaultMailbox] [uniqueidentifier] NULL,
	[ProcessId] [uniqueidentifier] NULL,
	[UserLicenseType] [int] NOT NULL,
	[IsEmailAddressApprovedByO365Admin] [bit] NOT NULL,
	[YammerUserId] [nvarchar](64) NULL,
	[EntityImageId] [uniqueidentifier] NULL,
	[IsLicensed] [bit] NOT NULL,
	[StageId] [uniqueidentifier] NULL,
	[PositionId] [uniqueidentifier] NULL,
	[TraversedPath] [nvarchar](1250) NULL,
	[MobileOfflineProfileId] [uniqueidentifier] NULL,
	[DefaultOdbFolderName] [nvarchar](200) NOT NULL,
	[SharePointEmailAddress] [nvarchar](1024) NULL,
	[chr_ExternalAgentID] [int] NULL,
	[chr_IsAgent] [bit] NULL,
	[cus_SalesAgent] [uniqueidentifier] NULL,
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
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [SetupUser]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((1)) FOR [IncomingEmailDeliveryMethod]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((1)) FOR [OutgoingEmailDeliveryMethod]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [AccessMode]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [InviteStatusCode]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((1)) FOR [IsActiveDirectoryUser]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [IsIntegrationUser]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [EmailRouterAccessApproval]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [DefaultFiltersPopulated]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [CALType]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [IsSyncWithDirectory]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((3)) FOR [UserLicenseType]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [IsEmailAddressApprovedByO365Admin]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ((0)) FOR [IsLicensed]
GO
ALTER TABLE [StgPbbMSCRM].[SystemUserBase] ADD  DEFAULT ('CRM') FOR [DefaultOdbFolderName]
GO
