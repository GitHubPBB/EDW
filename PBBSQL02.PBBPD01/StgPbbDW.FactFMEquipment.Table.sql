USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactFMEquipment]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactFMEquipment](
	[FactFMEquipmentId] [int] NOT NULL,
	[EQUIPMENT_Id] [int] NOT NULL,
	[DimFMEquipmentId] [int] NOT NULL,
	[DimFMCircuitId] [int] NOT NULL,
	[DimFMJunctionId] [int] NOT NULL,
	[DimFMFacilityId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
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
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimFMEquipmentId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimFMCircuitId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimFMJunctionId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimFMFacilityId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimFMAddressId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [StgPbbDW].[FactFMEquipment] ADD  DEFAULT ((0)) FOR [DimServiceLocationId]
GO
