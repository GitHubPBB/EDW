USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Employee_Discounts_List]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_Employee_Discounts_List]
AS
    BEGIN

		SELECT		DISTINCT 
			
					DimAccount.AccountCode,
					DimAccount.AccountName,
					DimAccountCategory.AccountGroup,
					DimAccountCategory.AccountType,
					DimAccountCategory.AccountClass,
			
					DimAccountCategory.CycleDescription,
					DimAccountCategory.CustomerServiceRegion,
			
					DimCustomerProduct.ProductName,
					DimCustomerProduct.ProductStatus,
					DimCustomerProduct.ProductReportArea,
					DimCatalogPrice.PricePlan			
					--FactCustomerProduct.FactCustomerProductId,
					--,FactCustomerItem.DimCatalogItemId

		FROM		FactCustomerProduct

		INNER JOIN	DimAccount 
		ON			FactCustomerProduct.DimAccountId = DimAccount.DimAccountId

		INNER JOIN	DimAccountCategory 
		ON			FactCustomerProduct.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId

		INNER JOIN	DimCustomerProduct 
		ON			FactCustomerProduct.DimCustomerProductId = DimCustomerProduct.DimCustomerProductId

		INNER JOIN	FactCustomerItem
		ON			FactCustomerItem.DimAccountId = DimAccount.DimAccountId

		INNER JOIN	DimCatalogPrice
		ON			DimCatalogPrice.DimCatalogPriceId = FactCustomerItem.DimCatalogPriceId


		WHERE		DimCatalogPrice.PricePlan like '%EMP%'
		AND			ProductStatus <> 'Inactive' --IN ('Active', 'Non-Pay Disconnected')
		ORDER BY	DimCustomerProduct.ProductStatus
END

--EXEC [dbo].[PBB_Employee_Discounts_List]

--1. Employee Discount Report
--A. Crete NEW REPORT
/* INFORMATION
﻿The employee discount is using the following components
/*
--Table
202557 - EMPPLAN - EMPLOYEE COURTESY PLAN  				- 66100 - GENERAL USE
202558 - EMPENG  - ENGINEER - EMPLOYEE COURTESY PLAN	- 710	- Cross Product Discount
202550 - EMPDATA - Employee Data Plan					- 710	- Cross Product Discount
*/
EMPPLAN – this is a free 300/300 plan for employees
EMPENG – this is 100% discount across account
EMPDATA – is this a discount off what would be the 300/300?
﻿
We need a report that will identify customers with the component active and return 
account details - account code, name, account group, services, employee code
*/
--COMPONENTS
--SELECT * FROM PrdComponentMap WHERE ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
--SELECT * FROM PrdComponentMap WHERE ComponentCode like '%EMP%'
--SELECT * FROM PrdComponentMap WHERE Component like '%EMPloyee%' OR ComponentCode  IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
--SELECT ComponentCode, ProductComponentID, * FROM DimCatalogItem where ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
--SELECT DimCatalogItemId,  * FROM FactCustomerItem where DimCatalogItemId in (SELECT DimCatalogItemId FROM DimCatalogItem where ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA'))

--USE [OMNIA_EPBB_P_PBB_DW]
--GO

--SELECT		DISTINCT TOP 2000
--			DimAccount.AccountCode,
--			DimAccount.AccountName,
--			DimAccountCategory.AccountGroup,
--			DimAccountCategory.AccountType,
--			DimAccountCategory.AccountClass,
			
--			DimAccountCategory.CycleDescription,
--			DimAccountCategory.CustomerServiceRegion,
			
--			DimCustomerProduct.ProductName,
--			DimCustomerProduct.ProductStatus,
--			DimCustomerProduct.ProductReportArea,			

--			FactCustomerProduct.FactCustomerProductId,

--			FactCustomerItem.DimCatalogItemId,
--			--DimCatalogItem.ComponentCode,
--			PrdComponentMap.ComponentCode

--FROM		FactCustomerProduct

--INNER JOIN	DimAccount 
--ON			FactCustomerProduct.DimAccountId = DimAccount.DimAccountId

--INNER JOIN	DimAccountCategory 
--ON			FactCustomerProduct.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId

--INNER JOIN	DimCustomerProduct 
--ON			FactCustomerProduct.DimCustomerProductId = DimCustomerProduct.DimCustomerProductId

--INNER JOIN	FactCustomerItem
--ON			FactCustomerItem.DimAccountId = DimAccount.DimAccountId

--INNER JOIN	DimCatalogItem
--ON			DimCatalogItem.DimCatalogItemId = FactCustomerItem.DimCatalogItemId

--INNER JOIN	PrdComponentMap
--ON			PrdComponentMap.ComponentCode = DimCatalogItem.ComponentCode

--WHERE		PrdComponentMap.ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
--WHERE		PrdComponentMap.Component LIKE '%Emp%' --OR PrdComponentMap.ComponentCode  IN ('EMPPLAN', 'EMPENG', 'EMPDATA')


--
--SELECT TOP 100 * FROM ProductAnalysis

/******Need to take a look*******/
--B. Incorporate into custom mapping for account discounts
--C. Add to Product analysis
--D. Review account reports for mapping
--E. Exclude employee from dashboard


/*
SELECT * FROM PrdComponentMap WHERE ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
SELECT * FROM PrdComponentMap WHERE ComponentCode like '%EMP%'
SELECT * FROM PrdComponentMap WHERE Component like '%EMPloyee%' OR ComponentCode  IN ('EMPPLAN', 'EMPENG', 'EMPDATA')

SELECT DimCatalogItemId, ProductComponentID,   * FROM DimCatalogItem  WHERE ComponentCode IN ('EMPPLAN', 'EMPENG', 'EMPDATA')
SELECT DimCatalogItemId, DimCustomerProductId, * FROM FactCustomerPrice WHERE DimCatalogItemId in (SELECT distinct DimCatalogItemId FROM DimCatalogItem  WHERE ComponentCode like '%EMP%')
SELECT DimCatalogItemId, DimCustomerProductId, * from FactCustomerItem WHERE DimCatalogItemId in (SELECT distinct DimCatalogItemId FROM DimCatalogItem  WHERE ComponentCode like '%EMP%')
*/

/*
SELECT TOP 10 * FROM DimPromoStatus_pbb				
SELECT TOP 10 * FROM DimSalesOrderLineItem			
SELECT TOP 10 * FROM FactSalesOrderItemAgent		
SELECT TOP 10 * FROM FactSalesOrderLineItem			
SELECT TOP 10 * FROM PBB_CableSubCounts				
SELECT TOP 10 * FROM PBB_ComponentLocationCountsByAccountGroupCodeMatrix
SELECT TOP 10 * FROM PBB_PromotionStatus			
SELECT TOP 10 * FROM PBB_UnCategorizedComponents	
SELECT TOP 10 * FROM PrdComponentMap			where ComponentID in ('202550','202558','202557')		
SELECT TOP 10 * FROM prdcomponentmap_backup		where ComponentID in ('202550','202558','202557')	
SELECT TOP 10 * FROM PrdComponentMap_working	where ComponentCode like '%EMP%'--where ComponentID in ('202550','202558','202557')	
SELECT TOP 10 * FROM PWB_PackageWeights				
SELECT TOP 10 * FROM PWB_ProductCatalog				
select * from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[PrdComponent] where ComponentID in ('202550','202558','202557')
*/
GO
