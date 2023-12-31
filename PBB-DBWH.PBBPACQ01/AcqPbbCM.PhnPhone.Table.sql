USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbCM].[PhnPhone]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbCM].[PhnPhone](
	[PhoneID] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[PhoneSeriesID] [int] NULL,
	[StatusIndicator] [tinyint] NOT NULL,
	[Phone] [char](10) NOT NULL,
	[ItemID] [int] NULL,
	[PhoneStatus] [char](1) NOT NULL,
	[StatusDate] [smalldatetime] NOT NULL,
	[SwitchID] [int] NULL,
	[ESN] [varchar](21) NULL,
	[ExchangeCode] [char](7) NOT NULL,
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
