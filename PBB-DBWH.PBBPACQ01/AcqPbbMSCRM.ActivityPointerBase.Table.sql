USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbMSCRM].[ActivityPointerBase]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbMSCRM].[ActivityPointerBase](
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[ActualEnd] [datetime] NULL,
	[VersionNumber] [int] NULL,
	[ActivityId] [uniqueidentifier] NOT NULL,
	[IsBilled] [bit] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[Description] [nvarchar](max) NULL,
	[ModifiedOn] [datetime] NULL,
	[ServiceId] [uniqueidentifier] NULL,
	[ActivityTypeCode] [int] NOT NULL,
	[StateCode] [int] NOT NULL,
	[ScheduledEnd] [datetime] NULL,
	[ScheduledDurationMinutes] [int] NULL,
	[ActualDurationMinutes] [int] NULL,
	[StatusCode] [int] NULL,
	[ActualStart] [datetime] NULL,
	[CreatedOn] [datetime] NULL,
	[PriorityCode] [int] NULL,
	[RegardingObjectId] [uniqueidentifier] NULL,
	[Subject] [nvarchar](200) NULL,
	[IsWorkflowCreated] [bit] NULL,
	[ScheduledStart] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[RegardingObjectTypeCode] [int] NULL,
	[RegardingObjectIdName] [nvarchar](4000) NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[RegardingObjectIdYomiName] [nvarchar](4000) NULL,
	[RecApptMstrOverriddenCreatedOn] [datetime] NULL,
	[RecApptMstrGlobalObjectId] [nvarchar](300) NULL,
	[SeriesStatus] [bit] NULL,
	[RecApptMstrOutlookOwnerApptId] [int] NULL,
	[DeletedExceptionsList] [nvarchar](max) NULL,
	[NextExpansionInstanceDate] [datetime] NULL,
	[RecApptMstrLocation] [nvarchar](200) NULL,
	[GroupId] [uniqueidentifier] NULL,
	[LastExpandedInstanceDate] [datetime] NULL,
	[ExpansionStateCode] [int] NULL,
	[RecApptMstrCategory] [nvarchar](250) NULL,
	[RecApptMstrIsAllDayEvent] [bit] NULL,
	[RecApptMstrSubcategory] [nvarchar](250) NULL,
	[RecApptMstrSubscriptionId] [uniqueidentifier] NULL,
	[RecApptMstrImportSequenceNumber] [int] NULL,
	[ModifiedFieldsMask] [nvarchar](max) NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[InstanceTypeCode] [int] NOT NULL,
	[SeriesId] [uniqueidentifier] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[ExchangeRate] [decimal](18, 0) NULL,
	[IsRegularActivity] [bit] NOT NULL,
	[OriginalStartDate] [datetime] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerIdType] [int] NOT NULL,
	[QteCloseOverriddenCreatedOn] [datetime] NULL,
	[QuoteNumber] [nvarchar](100) NULL,
	[QteCloseImportSequenceNumber] [int] NULL,
	[QteCloseCategory] [nvarchar](250) NULL,
	[QteCloseRevision] [int] NULL,
	[QteCloseSubcategory] [nvarchar](250) NULL,
	[ApptCategory] [nvarchar](250) NULL,
	[ApptGlobalObjectId] [nvarchar](300) NULL,
	[ApptIsAllDayEvent] [bit] NULL,
	[ApptImportSequenceNumber] [int] NULL,
	[ApptOutlookOwnerApptId] [int] NULL,
	[ApptOverriddenCreatedOn] [datetime] NULL,
	[ApptSubcategory] [nvarchar](250) NULL,
	[ApptSubscriptionId] [uniqueidentifier] NULL,
	[ApptLocation] [nvarchar](200) NULL,
	[ActualCost_Base] [money] NULL,
	[CampActImportSequenceNumber] [int] NULL,
	[BudgetedCost_Base] [money] NULL,
	[ActualCost] [money] NULL,
	[IgnoreInactiveListMembers] [bit] NULL,
	[DoNotSendOnOptOut] [bit] NULL,
	[TypeCode] [int] NULL,
	[CampActSubcategory] [nvarchar](250) NULL,
	[CampActOverriddenCreatedOn] [datetime] NULL,
	[ExcludeIfContactedInXDays] [int] NULL,
	[CampActCategory] [nvarchar](250) NULL,
	[BudgetedCost] [money] NULL,
	[CampActChannelTypeCode] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[ReceivedOn] [datetime] NULL,
	[ResponseCode] [int] NULL,
	[YomiLastName] [nvarchar](150) NULL,
	[CampResOverriddenCreatedOn] [datetime] NULL,
	[YomiFirstName] [nvarchar](150) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[CampResCategory] [nvarchar](250) NULL,
	[Telephone] [nvarchar](50) NULL,
	[OriginatingActivityId] [uniqueidentifier] NULL,
	[Fax] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[CampResImportSequenceNumber] [int] NULL,
	[OriginatingActivityIdTypeCode] [int] NULL,
	[EMailAddress] [nvarchar](100) NULL,
	[CampResChannelTypeCode] [int] NULL,
	[YomiCompanyName] [nvarchar](100) NULL,
	[PromotionCodeName] [nvarchar](250) NULL,
	[CampResSubcategory] [nvarchar](250) NULL,
	[SuccessCount] [int] NULL,
	[OperationTypeCode] [int] NULL,
	[BulkOperationNumber] [nvarchar](32) NULL,
	[TargetMembersCount] [int] NULL,
	[CreatedRecordTypeCode] [int] NULL,
	[Parameters] [nvarchar](max) NULL,
	[ErrorNumber] [int] NULL,
	[TargetedRecordTypeCode] [int] NULL,
	[FailureCount] [int] NULL,
	[Compressed] [bit] NULL,
	[ReadReceiptRequested] [bit] NULL,
	[DeliveryReceiptRequested] [bit] NULL,
	[EmailSubcategory] [nvarchar](250) NULL,
	[Notifications] [int] NULL,
	[MessageId] [nvarchar](320) NULL,
	[Sender] [nvarchar](250) NULL,
	[ToRecipients] [nvarchar](500) NULL,
	[EmailOverriddenCreatedOn] [datetime] NULL,
	[SubmittedBy] [nvarchar](250) NULL,
	[EmailImportSequenceNumber] [int] NULL,
	[EmailDirectionCode] [bit] NULL,
	[MimeType] [nvarchar](256) NULL,
	[MessageIdDupCheck] [uniqueidentifier] NULL,
	[DeliveryAttempts] [int] NULL,
	[TrackingToken] [nvarchar](50) NULL,
	[EmailCategory] [nvarchar](250) NULL,
	[SvcApptImportSequenceNumber] [int] NULL,
	[SvcApptLocation] [nvarchar](500) NULL,
	[SvcApptIsAllDayEvent] [bit] NULL,
	[SvcApptSubcategory] [nvarchar](250) NULL,
	[SiteId] [uniqueidentifier] NULL,
	[SvcApptOverriddenCreatedOn] [datetime] NULL,
	[SvcApptCategory] [nvarchar](250) NULL,
	[SvcApptSubscriptionId] [uniqueidentifier] NULL,
	[TaskCategory] [nvarchar](250) NULL,
	[PercentComplete] [int] NULL,
	[TaskOverriddenCreatedOn] [datetime] NULL,
	[TaskSubscriptionId] [uniqueidentifier] NULL,
	[TaskSubcategory] [nvarchar](250) NULL,
	[TaskImportSequenceNumber] [int] NULL,
	[Address] [nvarchar](200) NULL,
	[LetterImportSequenceNumber] [int] NULL,
	[LetterSubscriptionId] [uniqueidentifier] NULL,
	[LetterCategory] [nvarchar](250) NULL,
	[LetterSubcategory] [nvarchar](250) NULL,
	[LetterDirectionCode] [bit] NULL,
	[LetterOverriddenCreatedOn] [datetime] NULL,
	[PhoneOverriddenCreatedOn] [datetime] NULL,
	[PhoneImportSequenceNumber] [int] NULL,
	[PhoneNumber] [nvarchar](200) NULL,
	[PhoneSubcategory] [nvarchar](250) NULL,
	[PhoneDirectionCode] [bit] NULL,
	[PhoneSubscriptionId] [uniqueidentifier] NULL,
	[PhoneCategory] [nvarchar](250) NULL,
	[OrdCloseSubcategory] [nvarchar](250) NULL,
	[OrdCloseImportSequenceNumber] [int] NULL,
	[OrdCloseRevision] [int] NULL,
	[OrderNumber] [nvarchar](100) NULL,
	[OrdCloseCategory] [nvarchar](250) NULL,
	[OrdCloseOverriddenCreatedOn] [datetime] NULL,
	[FaxNumber] [nvarchar](200) NULL,
	[CoverPageName] [nvarchar](100) NULL,
	[NumberOfPages] [int] NULL,
	[FaxSubscriptionId] [uniqueidentifier] NULL,
	[FaxImportSequenceNumber] [int] NULL,
	[BillingCode] [nvarchar](50) NULL,
	[Tsid] [nvarchar](20) NULL,
	[FaxDirectionCode] [bit] NULL,
	[FaxOverriddenCreatedOn] [datetime] NULL,
	[FaxSubcategory] [nvarchar](250) NULL,
	[FaxCategory] [nvarchar](250) NULL,
	[IncResSubcategory] [nvarchar](250) NULL,
	[IncResCategory] [nvarchar](250) NULL,
	[IncResImportSequenceNumber] [int] NULL,
	[IncResOverriddenCreatedOn] [datetime] NULL,
	[TimeSpent] [int] NULL,
	[CompetitorId] [uniqueidentifier] NULL,
	[OppCloseOverriddenCreatedOn] [datetime] NULL,
	[OppCloseImportSequenceNumber] [int] NULL,
	[ActualRevenue_Base] [money] NULL,
	[ActualRevenue] [money] NULL,
	[OppCloseSubcategory] [nvarchar](250) NULL,
	[OppCloseCategory] [nvarchar](250) NULL,
	[EmailAttachmentCount] [int] NOT NULL,
	[ConversationIndex] [nvarchar](2048) NULL,
	[InReplyTo] [nvarchar](320) NULL,
	[CorrelationMethod] [int] NULL,
	[BaseConversationIndexHash] [int] NULL,
	[ParentActivityId] [uniqueidentifier] NULL,
	[SenderMailboxId] [uniqueidentifier] NULL,
	[IsMapiPrivate] [bit] NULL,
	[LeftVoiceMail] [bit] NULL,
	[DeliveryLastAttemptedOn] [datetime] NULL,
	[StageId] [uniqueidentifier] NULL,
	[DeliveryPriorityCode] [int] NULL,
	[SentOn] [datetime] NULL,
	[PostponeActivityProcessingUntil] [datetime] NULL,
	[ProcessId] [uniqueidentifier] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[ImportSequenceNumber] [int] NULL,
	[PostURL] [nvarchar](200) NULL,
	[PostedOn] [datetime] NULL,
	[PostAuthor] [uniqueidentifier] NULL,
	[ThreadId] [nvarchar](160) NULL,
	[PostMessageType] [int] NULL,
	[SentimentValue] [float] NULL,
	[PostId] [nvarchar](160) NULL,
	[PostFromProfileId] [uniqueidentifier] NULL,
	[PostToProfileId] [nvarchar](200) NULL,
	[SocialActivityDirectionCode] [bit] NULL,
	[InResponseTo] [nvarchar](160) NULL,
	[SocialAdditionalParams] [nvarchar](max) NULL,
	[PostAuthorAccount] [uniqueidentifier] NULL,
	[PostAuthorType] [int] NULL,
	[PostAuthorAccountName] [nvarchar](4000) NULL,
	[PostAuthorAccountType] [int] NULL,
	[PostAuthorName] [nvarchar](4000) NULL,
	[PostAuthorYomiName] [nvarchar](4000) NULL,
	[PostAuthorAccountYomiName] [nvarchar](4000) NULL,
	[EmailSender] [uniqueidentifier] NULL,
	[SendersAccount] [uniqueidentifier] NULL,
	[EmailSenderName] [nvarchar](4000) NULL,
	[SendersAccountName] [nvarchar](4000) NULL,
	[EmailSenderObjectTypeCode] [int] NULL,
	[SendersAccountObjectTypeCode] [int] NULL,
	[SendersAccountYomiName] [nvarchar](4000) NULL,
	[EmailSenderYomiName] [nvarchar](4000) NULL,
	[CrmTaskAssignedUniqueId] [uniqueidentifier] NULL,
	[Community] [int] NULL,
	[TraversedPath] [nvarchar](1250) NULL,
	[AttachmentErrors] [int] NULL,
	[IsUnsafe] [int] NULL,
	[CreatedByExternalParty] [uniqueidentifier] NULL,
	[ModifiedByExternalParty] [uniqueidentifier] NULL,
	[ActivityAdditionalParams] [nvarchar](max) NULL,
	[OnHoldTime] [int] NULL,
	[SLAInvokedId] [uniqueidentifier] NULL,
	[SLAId] [uniqueidentifier] NULL,
	[LastOnHoldTime] [datetime] NULL,
	[ImportSequenceNumber_10155] [int] NULL,
	[OverriddenCreatedOn_10155] [datetime] NULL,
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
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [IsBilled]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((-1)) FOR [ActivityTypeCode]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [PriorityCode]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [IsWorkflowCreated]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [SeriesStatus]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [ExpansionStateCode]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [RecApptMstrIsAllDayEvent]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OwnerId]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [InstanceTypeCode]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [IsRegularActivity]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((8)) FOR [OwnerIdType]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [ApptIsAllDayEvent]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [ActualCost]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [IgnoreInactiveListMembers]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [DoNotSendOnOptOut]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [ExcludeIfContactedInXDays]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [BudgetedCost]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [SuccessCount]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [TargetMembersCount]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [FailureCount]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [Compressed]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [ReadReceiptRequested]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [DeliveryReceiptRequested]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ('cc8f99fd-486e-4c39-aef7-7dd4d5fdbd0a') FOR [MessageIdDupCheck]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [SvcApptIsAllDayEvent]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [TimeSpent]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [EmailAttachmentCount]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [CorrelationMethod]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [IsMapiPrivate]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [LeftVoiceMail]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((1)) FOR [DeliveryPriorityCode]
GO
ALTER TABLE [AcqPbbMSCRM].[ActivityPointerBase] ADD  DEFAULT ((0)) FOR [IsUnsafe]
GO
