USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactCustomerProduct]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactCustomerProduct](
	[FactCustomerProductId] [int] NOT NULL,
	[SourceId] [varchar](65) NOT NULL,
	[ServiceID] [int] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[Activity_DimDateId] [date] NOT NULL,
	[Connect_DimDateId] [date] NOT NULL,
	[Disconnect_DimDateId] [date] NOT NULL,
	[NonpayDisconnect_DimDateId] [date] NOT NULL,
	[EffectiveStartDate] [datetime] NOT NULL,
	[EffectiveEndDate] [datetime] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [ServiceID]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimCustomerActivityId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimCustomerProductId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimAgentId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('1900-01-01') FOR [Activity_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('1900-01-01') FOR [Connect_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('1900-01-01') FOR [Disconnect_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('1900-01-01') FOR [NonpayDisconnect_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('1900-01-01') FOR [EffectiveStartDate]
GO
ALTER TABLE [AcqPbbDW].[FactCustomerProduct] ADD  DEFAULT ('2050-01-01') FOR [EffectiveEndDate]
GO
