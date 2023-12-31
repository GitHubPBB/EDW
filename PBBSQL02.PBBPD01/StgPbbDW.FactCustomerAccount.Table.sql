USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactCustomerAccount]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactCustomerAccount](
	[FactCustomerAccountId] [int] NOT NULL,
	[SourceId] [varchar](20) NOT NULL,
	[AccountID] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[Activation_DimDateId] [date] NOT NULL,
	[Deactivation_DimDateId] [date] NOT NULL,
	[EffectiveStartDate] [datetime] NOT NULL,
	[EffectiveEndDate] [datetime] NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ((0)) FOR [AccountID]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ((0)) FOR [DimAgentId]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ('1900-01-01') FOR [Activation_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ('1900-01-01') FOR [Deactivation_DimDateId]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ('1900-01-01') FOR [EffectiveStartDate]
GO
ALTER TABLE [StgPbbDW].[FactCustomerAccount] ADD  DEFAULT ('1900-01-01') FOR [EffectiveEndDate]
GO
