USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[CusAccountX]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[CusAccountX](
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
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
