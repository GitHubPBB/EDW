USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbCM].[SrvItemX]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbCM].[SrvItemX](
	[TransactionType] [char](1) NULL,
	[ItemID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[ItemIndex] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[ComponentVersion] [smallint] NOT NULL,
	[ComponentClassID] [int] NOT NULL,
	[PackageID] [int] NULL,
	[PackageVersion] [smallint] NULL,
	[PackageIndex] [smallint] NULL,
	[Quantity] [int] NOT NULL,
	[ActivationDate] [smalldatetime] NOT NULL,
	[DeactivationDate] [smalldatetime] NULL,
	[LocationID] [int] NOT NULL,
	[ItemOrderID] [int] NULL,
	[ItemOrderVersion] [smallint] NULL,
	[ItemRemarkID] [int] NULL,
	[ParentItemID] [int] NULL,
	[GroupID] [int] NULL,
	[ItemStatus] [char](1) NOT NULL,
	[ItemNonpayDiscDate] [smalldatetime] NULL,
	[ZLocationID] [int] NULL,
	[ProductComponentID] [int] NULL,
	[RootItemID] [int] NULL,
	[PWBParentItemID] [int] NULL,
	[ServiceReference] [varchar](255) NULL,
	[ProviderID] [int] NULL,
	[SegmentID] [int] NULL,
	[ItemStatusChangeDate] [smalldatetime] NULL,
	[DisplayName] [varchar](255) NULL,
	[PricePlanID] [int] NULL,
	[MarketDescription] [varchar](255) NULL,
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
