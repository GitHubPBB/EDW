USE [PBBPDW01]
GO
/****** Object:  Table [transient].[CusAccountX]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[CusAccountX](
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
	[SegmentID] [int] NULL
) ON [PRIMARY]
GO
