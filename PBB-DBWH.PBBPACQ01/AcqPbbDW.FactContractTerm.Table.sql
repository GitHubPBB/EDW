USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactContractTerm]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactContractTerm](
	[FactContractTermId] [int] NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[ContractTermLength] [int] NOT NULL,
	[DimContractTermId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[ContractTermStart_DimDateId] [date] NOT NULL,
	[ContractTermEnd_DimDateId] [date] NOT NULL,
	[ContractSignature_DimDateId] [date] NOT NULL,
	[ContractInitialStart_DimDateId] [date] NOT NULL,
	[ContractTermination_DimDateId] [date] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [ContractTermLength]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [DimContractTermId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [DimOpportunityId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ((0)) FOR [DimSalesOrderId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ('1900-01-01') FOR [ContractTermStart_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ('1900-01-01') FOR [ContractTermEnd_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ('1900-01-01') FOR [ContractSignature_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ('1900-01-01') FOR [ContractInitialStart_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactContractTerm] ADD  DEFAULT ('1900-01-01') FOR [ContractTermination_DimDateId]
GO
