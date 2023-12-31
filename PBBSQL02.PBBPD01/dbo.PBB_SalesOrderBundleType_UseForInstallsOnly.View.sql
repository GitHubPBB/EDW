USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_SalesOrderBundleType_UseForInstallsOnly]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_SalesOrderBundleType_UseForInstallsOnly] as
	select factsalesorderlineitem.DimSalesOrderId, SalesOrderNumber, DimAccountID, DimServiceLocationID,
	CASE
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Phone Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Internet Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Cable Only'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Double Play-Phone/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Double Play-Internet/Phone'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'Double Play-Internet/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) >= 1
						  AND SUM(PrdComponentMap.IsDataSvc) >= 1
						  AND (SUM(PrdComponentMap.IsLocalPhn) >= 1
							  or SUM(PrdComponentMap.IsComplexPhn) >= 1)
					  THEN 'Triple Play-Internet/Phone/Cable'
					  WHEN SUM(PrdComponentMap.IsCableSvc) = 0
						  AND SUM(PrdComponentMap.IsDataSvc) = 0
						  AND SUM(PrdComponentMap.IsLocalPhn) = 0
						  AND SUM(PrdComponentMap.IsComplexPhn) = 0
					  THEN 'None' ELSE 'Other'
				   END AS PBB_BundleType
	from FactSalesOrderLineItem 
	join DimSalesOrder on FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
	join DimSalesOrderLineItem on FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
	JOIN DimCatalogItem ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
				JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
				where (IsDataSvc = 1 or IsLocalPhn = 1 or IsCableSvc = 1 or IsComplexPhn = 1)
				and DimAccountID <> 0
	group by factsalesorderlineitem.DimSalesOrderId, salesordernumber, DimAccountID, DimServiceLocationID

GO
