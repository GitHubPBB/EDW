USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbCM].[CusAccountX]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbCM].[CusAccountX](
	[TransactionType] [char](1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[AccountGroupID] [int] NOT NULL,
	[AccountCode] [char](13) NOT NULL,
	[AccountTypeID] [int] NOT NULL,
	[AccountClassCode] [char](1) NOT NULL,
	[CorporationID] [int] NULL,
	[CycleID] [int] NOT NULL,
	[CustomerServiceRegionID] [int] NOT NULL,
	[PatronageAccountID] [int] NULL,
	[AccountStatusCode] [char](1) NOT NULL,
	[AccountRemarkID] [int] NULL,
	[AgentID] [int] NULL,
	[InvoiceFormatID] [int] NOT NULL,
	[ExemptionTypeID] [int] NULL,
	[PreferredBillingFrequency] [char](1) NOT NULL,
	[ChargeScheduleID] [int] NULL,
	[MembershipID] [int] NULL,
	[AccountActivationDate] [smalldatetime] NOT NULL,
	[AccountDeactivationDate] [smalldatetime] NULL,
	[DesiredCycleID] [int] NULL,
	[SegmentID] [int] NULL,
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
) ON [PRIMARY]
GO
