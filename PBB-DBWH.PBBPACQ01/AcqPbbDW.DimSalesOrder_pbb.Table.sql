USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimSalesOrder_pbb]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimSalesOrder_pbb](
	[pbb_DimSalesOrderId] [int] NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[pbb_SalesOrderReviewDate] [datetime] NULL,
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
