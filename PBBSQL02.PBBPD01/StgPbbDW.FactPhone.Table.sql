USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[FactPhone]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[FactPhone](
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
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimPhoneId]
GO
ALTER TABLE [StgPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimCustomerItemId]
GO
ALTER TABLE [StgPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimCustomerProductId]
GO
ALTER TABLE [StgPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [StgPbbDW].[FactPhone] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
