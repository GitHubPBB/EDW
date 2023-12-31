USE [PBBPDW01]
GO
/****** Object:  Table [AcqPbbDW].[DimAccount_pbb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimAccount_pbb](
	[pbb_DimAccountId] [int] NOT NULL,
	[AccountId] [nvarchar](400) NOT NULL,
	[pbb_AccountRecurringPaymentExpirationDate] [date] NULL,
	[pbb_AccountRecurringPaymentLastFour] [varchar](20) NOT NULL,
	[pbb_AccountRecurringPaymentStartDate] [date] NULL,
	[pbb_AccountRecurringPaymentEndDate] [date] NULL,
	[pbb_AccountRecurringPaymentType] [varchar](10) NOT NULL,
	[pbb_AccountRecurringPaymentCardType] [varchar](50) NOT NULL,
	[pbb_AccountDiscountPercentage] [decimal](15, 2) NOT NULL,
	[pbb_AccountDiscountNames] [nvarchar](1000) NOT NULL,
	[pbb_BundleType] [nvarchar](100) NOT NULL,
	[pbb_AccountDiscount_DimGLMapIds] [nvarchar](100) NOT NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [char](1) NOT NULL
) ON [PRIMARY]
GO
