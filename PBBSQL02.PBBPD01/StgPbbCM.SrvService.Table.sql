USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[SrvService]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[SrvService](
	[ServiceID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[ServiceIndex] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductVersion] [smallint] NOT NULL,
	[ProductClassID] [int] NOT NULL,
	[ConfigurationID] [int] NULL,
	[ConfigurationVersion] [smallint] NULL,
	[BundleID] [int] NULL,
	[BundleVersion] [smallint] NULL,
	[BundleIndex] [smallint] NULL,
	[OfferingID] [int] NULL,
	[OfferingVersion] [smallint] NULL,
	[ConnectDate] [smalldatetime] NOT NULL,
	[DisconnectDate] [smalldatetime] NULL,
	[ServiceContactID] [int] NULL,
	[ServiceOrderID] [int] NULL,
	[ServiceOrderVersion] [smallint] NULL,
	[ServiceRemarkID] [int] NULL,
	[DivisionID] [int] NULL,
	[ContractID] [int] NULL,
	[NonpayDiscDate] [smalldatetime] NULL,
	[ServiceStatus] [char](1) NOT NULL,
	[AgentID] [int] NULL,
	[ExemptionTypeID] [int] NULL,
	[AlertMask] [int] NOT NULL,
	[ReportAreaID] [int] NOT NULL,
	[BusResIndicator] [char](1) NULL,
	[AdditionalInformation] [char](40) NULL,
	[ServiceOrderContractID] [int] NULL,
	[RootProductComponentID] [int] NULL,
	[CollectionMethod] [char](1) NULL,
	[AutoRenew] [char](1) NULL,
	[PeriodDuration] [char](1) NULL,
	[PrepaidPeriods] [int] NULL,
	[PaidThruDate] [smalldatetime] NULL,
	[PromoCodeApplied] [nvarchar](250) NULL,
	[PriceListId] [int] NULL,
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
