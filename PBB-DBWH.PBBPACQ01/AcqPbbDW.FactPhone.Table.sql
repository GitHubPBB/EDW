USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactPhone]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactPhone](
	[FactPhoneId] [int] NOT NULL,
	[PhoneId] [int] NOT NULL,
	[DimPhoneId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
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
ALTER TABLE [AcqPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimPhoneId]
GO
ALTER TABLE [AcqPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [AcqPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimCustomerProductId]
GO
ALTER TABLE [AcqPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
