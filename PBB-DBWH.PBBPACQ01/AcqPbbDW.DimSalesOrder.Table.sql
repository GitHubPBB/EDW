USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimSalesOrder]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimSalesOrder](
	[DimSalesOrderId] [int] NOT NULL,
	[SalesOrderId] [nvarchar](400) NOT NULL,
	[SalesOrderNumber] [nvarchar](100) NOT NULL,
	[SalesOrderName] [nvarchar](300) NOT NULL,
	[SalesOrderFulfillmentStatus] [nvarchar](100) NOT NULL,
	[SalesOrderChannel] [nvarchar](256) NOT NULL,
	[SalesOrderSegment] [nvarchar](1000) NOT NULL,
	[SalesOrderProvisioningDate] [datetime] NULL,
	[SalesOrderCommitmentDate] [datetime] NULL,
	[SalesOrderType] [nvarchar](256) NOT NULL,
	[SalesOrderProject] [nvarchar](80) NOT NULL,
	[SalesOrderProjectManager] [nvarchar](200) NOT NULL,
	[SalesOrderOwner] [nvarchar](200) NOT NULL,
	[SalesOrderStatusReason] [nvarchar](256) NOT NULL,
	[SalesOrderStatus] [nvarchar](256) NOT NULL,
	[SalesOrderPriorityCode] [nvarchar](256) NOT NULL,
	[SalesOrderDisconnectReason] [nvarchar](256) NOT NULL,
	[OrderHasServiceActivity] [nvarchar](50) NOT NULL,
	[OrderWorkflowName] [nvarchar](256) NOT NULL,
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
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderNumber]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderName]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderFulfillmentStatus]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderChannel]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderSegment]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderType]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderProject]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderProjectManager]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderOwner]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderStatusReason]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderStatus]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderPriorityCode]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [SalesOrderDisconnectReason]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [OrderHasServiceActivity]
GO
ALTER TABLE [AcqPbbDW].[DimSalesOrder] ADD  DEFAULT ('') FOR [OrderWorkflowName]
GO
