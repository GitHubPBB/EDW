USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_SalesOrderServiceActivity]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[PBB_SalesOrderServiceActivity]
AS
WITH OrderServiceActivity AS
(SELECT DimSalesOrderLineItem.SalesOrderLineItemAgents
	,FactSalesOrderLineItem.CreatedOn_DimDateId AS LineItemCreatedOnDate
	,DimSalesOrderLineItem.SalesOrderLineItemActivity
	,DimAccountCategory.AccountGroupCode
	,DimAccountCategory_pbb.pbb_AccountMarket
	,DimAccountCategory_pbb.pbb_ReportingMarket
	,DimAccount.AccountCode
	,DimAccountCategory.AccountTypeCode
	,PrdComponentMap.IsData
	,PrdComponentMap.IsPhone
	,PrdComponentMap.IsCable
	,PrdComponentMap.IsSmartHome
	,PrdComponentMap.IsSmartHomePod
	,PrdComponentMap.IsPointGuard
	,PrdComponentMap.IsPromo
	,PrdComponentMap.SpeedTier
	,FactSalesOrderLineItem.SalesOrderLineItemPrice
	,DimCatalogItem.ComponentCode
	,DimCatalogItem.ComponentName
	,DimCatalogItem.ItemIsService
	,DimAccount_pbb.pbb_AccountDiscountNames
	,Parent_DimCatalogItem.ComponentName AS Parent_ComponentName
	,Parent_DimCatalogItem.ComponentCode AS Parent_ComponentCode
	,DimSalesOrder.SalesOrderNumber
	,DimSalesOrder.SalesOrderType

	/********************************/
	,DimSalesOrder_pbb.pbb_SalesOrderReviewDate
	/********************************/

FROM FactSalesOrderLineItem
JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimSalesOrderLineItem ON FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
JOIN DimAccount ON FactSalesOrderLineItem.DimAccountId = DimAccount.DimAccountId
JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
JOIN DimAccountCategory ON FactSalesOrderLineItem.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
JOIN DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
JOIN DimCatalogItem ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
JOIN DimCatalogItem AS Parent_DimCatalogItem ON FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_DimCatalogItem.DimCatalogItemId
LEFT JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode

/********************************/
LEFT JOIN DimSalesOrder_pbb ON DimSalesOrder_pbb.SalesOrderId = DimSalesOrder.SalesOrderId AND DimSalesOrder_pbb.SalesOrderId <> '0'
/********************************/

WHERE DimCatalogItem.ItemIsService = 'Is Service'
AND FactSalesOrderLineItem.DimSalesOrderId <> 0
AND DimSalesOrder.SalesOrderFulfillmentStatus <> 'Order Cancelled') --40095

,OrderComponentActivity AS
(SELECT DimSalesOrderLineItem.SalesOrderLineItemAgents
	,FactSalesOrderLineItem.CreatedOn_DimDateId AS LineItemCreatedOnDate
	,DimSalesOrderLineItem.SalesOrderLineItemActivity
	,DimAccountCategory_pbb.pbb_AccountMarket
	,DimAccountCategory_pbb.pbb_ReportingMarket
	,DimAccount.AccountCode
	,DimAccountCategory.AccountTypeCode
	,PrdComponentMap.IsData
	,PrdComponentMap.IsPhone
	,PrdComponentMap.IsCable
	,PrdComponentMap.IsSmartHome
	,PrdComponentMap.IsSmartHomePod
	,PrdComponentMap.IsPointGuard
	,PrdComponentMap.IsPromo
	,PrdComponentMap.SpeedTier
	,FactSalesOrderLineItem.SalesOrderLineItemPrice
	,DimCatalogItem.ComponentCode
	,DimCatalogItem.ComponentName
	,DimCatalogItem.ItemIsService
	,DimAccount_pbb.pbb_AccountDiscountNames
	,Parent_DimCatalogItem.ComponentName AS Parent_ComponentName
	,Parent_DimCatalogItem.ComponentCode AS Parent_ComponentCode
	,DimSalesOrder.SalesOrderNumber
	,DimSalesOrder.SalesOrderType
FROM FactSalesOrderLineItem
JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimSalesOrderLineItem ON FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
JOIN DimAccount ON FactSalesOrderLineItem.DimAccountId = DimAccount.DimAccountId
JOIN DimAccount_pbb ON DimAccount.AccountId = DimAccount_pbb.AccountId
JOIN DimAccountCategory ON FactSalesOrderLineItem.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
JOIN DimAccountCategory_pbb ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
JOIN DimCatalogItem ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
JOIN DimCatalogItem AS Parent_DimCatalogItem ON FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_DimCatalogItem.DimCatalogItemId
LEFT JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
WHERE DimCatalogItem.ItemIsService = 'Is not a Service'
AND FactSalesOrderLineItem.DimSalesOrderId <> 0)

,OrderSummaryActivity AS
(SELECT OrderServiceActivity.SalesOrderLineItemAgents
	,OrderServiceActivity.LineItemCreatedOnDate
	,OrderServiceActivity.SalesOrderNumber
	,OrderServiceActivity.AccountTypeCode
	,OrderServiceActivity.AccountGroupCode
	,OrderServiceActivity.pbb_ReportingMarket AS ReportingMarket
	,OrderServiceActivity.AccountCode
	,OrderServiceActivity.pbb_AccountDiscountNames AS AccountDiscounts
	,CASE WHEN MAX(OrderComponentActivity.IsSmartHome) > 0 THEN 'Yes' ELSE 'No' END AS SmartHome
	,CASE WHEN MAX(OrderComponentActivity.IsSmartHomePod) > 0 THEN 'Yes' ELSE 'No' END AS SmartHomePod
	,CASE WHEN MAX(OrderComponentActivity.IsPointGuard) > 0 THEN 'Yes' ELSE 'No' END AS PointGuard
	,CASE WHEN MAX(OrderComponentActivity.IsPromo) > 0 THEN 'Yes' ELSE 'No' END AS Promo
	,CASE WHEN MAX(OrderServiceActivity.IsData) > 0 THEN 'Yes' ELSE 'No' END AS [Data]
	,CASE WHEN MAX(OrderServiceActivity.IsCable) > 0 THEN 'Yes' ELSE 'No' END AS Cable
	,CASE WHEN MAX(OrderServiceActivity.IsPhone) > 0 THEN 'Yes' ELSE 'No' END AS Phone
	,OrderServiceActivity.SalesOrderType
	,OrderServiceActivity.SalesOrderLineItemActivity AS SalesOrderServiceActivity
	,OrderServiceActivity.pbb_AccountMarket
	,'InstallDate' = OrderServiceActivity.pbb_SalesOrderReviewDate

FROM OrderServiceActivity
LEFT JOIN OrderComponentActivity ON OrderServiceActivity.SalesOrderNumber = OrderComponentActivity.SalesOrderNumber
GROUP BY OrderServiceActivity.SalesOrderLineItemAgents
	,OrderServiceActivity.LineItemCreatedOnDate
	,OrderServiceActivity.SalesOrderNumber
	,OrderServiceActivity.AccountTypeCode
	,OrderServiceActivity.AccountGroupCode
	,OrderServiceActivity.pbb_ReportingMarket
	,OrderServiceActivity.AccountCode
	,OrderServiceActivity.pbb_AccountDiscountNames
	,OrderServiceActivity.SalesOrderType
	,OrderServiceActivity.SalesOrderLineItemActivity
	,OrderServiceActivity.pbb_AccountMarket
	,OrderServiceActivity.pbb_SalesOrderReviewDate
	)

,SalesOrderInetRank AS
(SELECT DimSalesOrder.SalesOrderNumber
	,MAX(PrdInternetRank.Rnk) as InternetRank
FROM FactSalesOrderLineItem
JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimCatalogItem ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
LEFT JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
LEFT JOIN PrdInternetRank ON PrdComponentMap.SpeedTier = PrdInternetRank.Category
GROUP BY DimSalesOrder.SalesOrderNumber)

,SalesOrderInstallPrices AS
(SELECT DimSalesOrder.SalesOrderNumber
	,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Recurring'
		THEN FactSalesOrderLineItem.SalesOrderLineItemPrice ELSE 0 END) AS OrderInstallRecurring
	,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring'
		AND PrdComponentMap.IsPromo = 0
		THEN FactSalesOrderLineItem.SalesOrderLineItemPrice ELSE 0 END) AS OrderInstallNonRecurring
	,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Recurring'
		AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
		THEN FactSalesOrderLineItem.SalesOrderLineItemPrice ELSE 0 END) AS ServiceInstallRecurring
	,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring'
		AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
		AND PrdComponentMap.IsPromo = 0
		THEN FactSalesOrderLineItem.SalesOrderLineItemPrice ELSE 0 END) AS ServiceInstallNonRecurring
	,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring'
		AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
		AND PrdComponentMap.IsPromo = 1
		THEN FactSalesOrderLineItem.SalesOrderLineItemPrice ELSE 0 END) AS PromoNonRecurring
FROM FactSalesOrderLineItem
JOIN DimSalesOrderLineItem ON FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimCatalogItem ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
JOIN DimCatalogPrice ON FactSalesOrderLineItem.DimCatalogPriceId = DimCatalogPrice.DimCatalogPriceId
JOIN DimCatalogItem AS Parent_DimCatalogItem ON FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_DimCatalogItem.DimCatalogItemId
JOIN FactSalesOrderLineItem AS Parent_FactSalesOrderLineItem
	ON FactSalesOrderLineItem.DimSalesOrderId = Parent_FactSalesOrderLineItem.DimSalesOrderId
	AND FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_FactSalesOrderLineItem.DimCatalogItemId
JOIN DimSalesOrderLineItem AS Parent_DimSalesOrderLineItem ON Parent_FactSalesOrderLineItem.DimSalesOrderLineItemId = Parent_DimSalesOrderLineItem.DimSalesOrderLineItemId
LEFT JOIN PrdComponentMap ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
WHERE DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
	AND DimCatalogPrice.CatalogPriceIsRecurring <> ''
GROUP BY DimSalesOrder.SalesOrderNumber)

SELECT OrderSummaryActivity.SalesOrderLineItemAgents
	,OrderSummaryActivity.LineItemCreatedOnDate
	,OrderSummaryActivity.SalesOrderNumber
	,OrderSummaryActivity.AccountTypeCode
	,OrderSummaryActivity.AccountGroupCode
	,OrderSummaryActivity.ReportingMarket
	,OrderSummaryActivity.AccountCode
	,OrderSummaryActivity.AccountDiscounts
	,OrderSummaryActivity.SmartHome
	,OrderSummaryActivity.SmartHomePod
	,OrderSummaryActivity.PointGuard
	,OrderSummaryActivity.Promo
	,OrderSummaryActivity.[Data]
	,OrderSummaryActivity.Cable
	,OrderSummaryActivity.Phone
	,OrderSummaryActivity.SalesOrderType
	,OrderSummaryActivity.SalesOrderServiceActivity
	,OrderSummaryActivity.pbb_AccountMarket
	,OrderSummaryActivity.InstallDate
	,PrdInternetRank.Category
	,SalesOrderInstallPrices.ServiceInstallNonRecurring
	,SalesOrderInstallPrices.ServiceInstallRecurring
	,SalesOrderInstallPrices.OrderInstallNonRecurring
	,SalesOrderInstallPrices.OrderInstallRecurring
	,SalesOrderInstallPrices.PromoNonRecurring
FROM OrderSummaryActivity
LEFT JOIN SalesOrderInetRank ON OrderSummaryActivity.SalesOrderNumber = SalesOrderInetRank.SalesOrderNumber
LEFT JOIN PrdInternetRank ON SalesOrderInetRank.InternetRank = PrdInternetRank.Rnk
LEFT JOIN SalesOrderInstallPrices ON OrderSummaryActivity.SalesOrderNumber = SalesOrderInstallPrices.SalesOrderNumber
GO
