USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactFMCircuit]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactFMCircuit](
	[FactFMCircuitId] [int] NOT NULL,
	[CIRCUIT_Id] [int] NOT NULL,
	[DimFMCircuitId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimWorkOrderId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[Parent_DimFMCircuitId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[Z_DimFMAddressId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMJunctionId] [int] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimFMCircuitId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimWorkOrderId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [Parent_DimFMCircuitId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [Z_DimFMAddressId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
ALTER TABLE [AcqPbbDW].[FactFMCircuit] ADD  DEFAULT ((0)) FOR [DimFMJunctionId]
GO
