USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_IncrementalLoad_PreProcess]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_IncrementalLoad_PreProcess]
AS
    begin

	   set nocount on

	   return

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactCustomerItem_EffectiveStartDate_EffectiveEndDate'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactCustomerItem_EffectiveStartDate_EffectiveEndDate] ON [dbo].[FactCustomerItem]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_DimSalesOrder_SalesOrderType'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_DimSalesOrder_SalesOrderType] ON [dbo].[DimSalesOrder]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_DimComment_CommentCode'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_DimComment_CommentCode] ON [dbo].[DimComment]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactCustomerItem_ItemID_ItemQuantity_ItemPrice'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactCustomerItem_ItemID_ItemQuantity_ItemPrice] ON [dbo].[FactCustomerItem]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_DimCatalogPriceId'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_DimCatalogPriceId] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_DimCatalogItem_ComponentName'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_DimCatalogItem_ComponentName] ON [dbo].[DimCatalogItem]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_DimBilledChargeId'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_DimBilledChargeId] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_DimBilledChargeId'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_DimBilledChargeId] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_BilledChargeNetAmount'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_BilledChargeNetAmount] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_DimCatalogPrice_CatalogPriceBillingMethod'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_DimCatalogPrice_CatalogPriceBillingMethod] ON [dbo].[DimCatalogPrice]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_BilledChargeAmount'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_BilledChargeAmount] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactBilledCharge_BilledChargeDiscountAmount'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactBilledCharge_BilledChargeDiscountAmount] ON [dbo].[FactBilledCharge]
		  END

	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_DimCustomerItem_ItemActivationDate_ItemDeactivationDate'
			   )
		  BEGIN
			 DROP INDEX [PBB_DimCustomerItem_ItemActivationDate_ItemDeactivationDate] ON [dbo].[DimCustomerItem]
		  END
	   if exists
			   (
				  SELECT *
				  FROM sys.indexes
				  where [name] = 'PBB_IX_FactCustomerItem_DimCatalogItemID'
			   )
		  BEGIN
			 DROP INDEX [PBB_IX_FactCustomerItem_DimCatalogItemID] ON [dbo].[FactCustomerItem]
		  END


    end
GO
