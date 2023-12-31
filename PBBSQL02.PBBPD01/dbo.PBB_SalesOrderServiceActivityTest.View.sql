USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_SalesOrderServiceActivityTest]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_SalesOrderServiceActivityTest]
AS
WITH SalesActivityDetails
AS (
	SELECT	DimSalesOrderLineItem.SalesOrderLineItemAgents
			,FactSalesOrderLineItem.CreatedOn_DimDateId AS LineItemCreatedOnDate
			,DimSalesOrderLineItem.SalesOrderLineItemActivity
			,DimAccountCategory.AccountGroupCode
			,DimAccountCategory_pbb.pbb_AccountMarket
			,DimAccountCategory_pbb.pbb_ReportingMarket
			,DimAccount.AccountCode
			,DimAccountCategory.AccountTypeCode
			,DimSalesOrder.SalesOrderNumber
			,DimCatalogItem.ItemIsService
			,PrdComponentMap.IsData
			,PrdComponentMap.IsPhone
			,PrdComponentMap.IsCable
			,PrdComponentMap.IsPromo
			,PrdComponentMap.SpeedTier
			,PrdComponentMap.IsSmartHome
			,PrdComponentMap.IsSmartHomePod
			,PrdComponentMap.IsPointGuard
			,FactSalesOrderLineItem.SalesOrderLineItemPrice
			,DimCatalogItem.ComponentCode
			,DimCatalogItem.ComponentName
			,DimAccount_pbb.pbb_AccountDiscountNames
		    ,CASE WHEN (	  DimAccount_pbb.pbb_AccountRecurringPaymentStartDate <= GETDATE()
					  AND DimAccount_pbb.pbb_AccountRecurringPaymentExpirationDate >= GETDATE()) THEN 1
				ELSE 0 END AS IsAutoPay
			,Parent_DimCatalogItem.ComponentName AS Parent_ComponentName
			,Parent_DimCatalogItem.ComponentCode AS Parent_ComponentCode
			,DimSalesOrder.SalesOrderType
			,DimSalesOrder_pbb.pbb_SalesOrderReviewDate
	FROM	FactSalesOrderLineItem
			INNER JOIN DimSalesOrder
					ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			INNER JOIN DimSalesOrderLineItem
					ON FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
			INNER JOIN DimAccount 
					ON FactSalesOrderLineItem.DimAccountId = DimAccount.DimAccountId
			INNER JOIN DimAccount_pbb 
					ON DimAccount.AccountId = DimAccount_pbb.AccountId
			INNER JOIN DimAccountCategory 
					ON FactSalesOrderLineItem.DimAccountCategoryId = DimAccountCategory.DimAccountCategoryId
			INNER JOIN DimAccountCategory_pbb 
					ON DimAccountCategory.SourceId = DimAccountCategory_pbb.SourceId
			INNER JOIN DimCatalogItem 
					ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
			INNER JOIN DimCatalogItem AS Parent_DimCatalogItem 
					ON FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_DimCatalogItem.DimCatalogItemId
			 LEFT JOIN PrdComponentMap 
			  	    ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
			 LEFT JOIN DimSalesOrder_pbb 
					ON DimSalesOrder_pbb.SalesOrderId = DimSalesOrder.SalesOrderId 
				   AND DimSalesOrder_pbb.SalesOrderId <> '0'
WHERE FactSalesOrderLineItem.DimSalesOrderId <> 0
  AND DimSalesOrder.SalesOrderFulfillmentStatus <> 'Order Cancelled'
),
OrderServicesActivity 
AS (SELECT SAD.SalesOrderNumber,
		   SAD.SalesOrderLineItemActivity AS SalesOrderServiceActivity,
		   SAD.SalesOrderLineItemAgents,
		   SAD.LineItemCreatedOnDate,
		   SAD.AccountTypeCode,
		   SAD.AccountGroupCode,
		   SAD.pbb_ReportingMarket AS ReportingMarket,
		   SAD.AccountCode,
		   SAD.pbb_AccountDiscountNames AS AccountDiscounts,
		   CASE WHEN MAX(SAD.IsData) > 0 THEN 'Yes' ELSE 'No' END AS [Data],
		   CASE WHEN MAX(SAD.IsCable) > 0 THEN 'Yes' ELSE 'No' END AS Cable,
		   CASE WHEN MAX(SAD.IsPhone) > 0 THEN 'Yes' ELSE 'No' END AS Phone,
		   CASE WHEN MAX(SAD.IsAutoPay) > 0 THEN 'Yes' ELSE 'No' END AS AutoPay,
		   SAD.SalesOrderType,
		   SAD.pbb_AccountMarket,
		   SAD.pbb_SalesOrderReviewDate
	FROM   SalesActivityDetails SAD
	WHERE  ItemIsService = 'Is Service'
	GROUP BY SAD.SalesOrderNumber,
			 SAD.SalesOrderLineItemActivity,
			 SAD.SalesOrderLineItemAgents,
			 SAD.LineItemCreatedOnDate,
			 SAD.AccountTypeCode,
			 SAD.AccountGroupCode,
			 SAD.pbb_ReportingMarket,
			 SAD.AccountCode,
			 SAD.pbb_AccountDiscountNames,
			 SAD.SalesOrderType,
			 SAD.pbb_AccountMarket,
			 SAD.pbb_SalesOrderReviewDate
),
OrderComponentActivity 
AS (SELECT SAD.SalesOrderNumber,
		   SAD.SalesOrderLineItemActivity AS SalesOrderServiceActivity,
		   CASE WHEN MAX(SAD.IsSmartHome) > 0 THEN 'Yes' ELSE 'No' END AS SmartHome,
		   CASE WHEN MAX(SAD.IsSmartHomePod) > 0 THEN 'Yes' ELSE 'No' END AS SmartHomePod,
		   CASE WHEN MAX(SAD.IsPointGuard) > 0 THEN 'Yes' ELSE 'No' END AS PointGuard,
		   CASE WHEN MAX(SAD.IsPromo) > 0 THEN 'Yes' ELSE 'No' END AS Promo,
		   dbo.PBB_GetSalesOrderPromotions(SAD.SalesOrderNumber, SAD.SalesOrderLineItemActivity) AS PromoList
	FROM   SalesActivityDetails SAD
	WHERE  ItemIsService = 'Is not a Service'
	GROUP BY SAD.SalesOrderLineItemAgents,
			 SAD.LineItemCreatedOnDate,
			 SAD.SalesOrderNumber,
			 SAD.AccountTypeCode,
			 SAD.AccountGroupCode,
			 SAD.pbb_ReportingMarket,
			 SAD.AccountCode,
			 SAD.pbb_AccountDiscountNames,
			 SAD.SalesOrderType,
			 SAD.SalesOrderLineItemActivity,
			 SAD.pbb_AccountMarket,
			 SAD.pbb_SalesOrderReviewDate
),
SalesDataSpeed 
AS (
	SELECT	DISTINCT SalesOrderNumber,
			SalesOrderLineItemActivity,
			ComponentName AS SpeedDescription
	FROM	SalesActivityDetails
	WHERE	IsData = 1
		AND	SpeedTier <> '0'
		AND ItemIsService = 'Is Not a Service'
),
SalesOrderInetRank
AS (
	SELECT	DimSalesOrder.SalesOrderNumber,
			MAX(PrdInternetRank.Rnk) as InternetRank
	FROM	FactSalesOrderLineItem
			INNER JOIN DimSalesOrder 
					ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			INNER JOIN DimCatalogItem 
					ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
			 LEFT JOIN PrdComponentMap 
					ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
			 LEFT JOIN PrdInternetRank 
					ON PrdComponentMap.SpeedTier = PrdInternetRank.Category
	GROUP BY DimSalesOrder.SalesOrderNumber
   ),
SalesOrderInstallPrices 
AS (
	 SELECT	DimSalesOrder.SalesOrderNumber,
			SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Recurring'
					 THEN FactSalesOrderLineItem.SalesOrderLineItemPrice 
				ELSE 0 
				END) AS OrderInstallRecurring
			,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring' 
					   AND PrdComponentMap.IsPromo = 0
					  THEN FactSalesOrderLineItem.SalesOrderLineItemPrice 
				 ELSE 0 
				 END) AS OrderInstallNonRecurring
			,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Recurring'
					   AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
					  THEN FactSalesOrderLineItem.SalesOrderLineItemPrice 
				 ELSE 0 END) AS ServiceInstallRecurring
			,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring'
					   AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
					   AND PrdComponentMap.IsPromo = 0
					  THEN FactSalesOrderLineItem.SalesOrderLineItemPrice 
				 ELSE 0 END) AS ServiceInstallNonRecurring
			,SUM(CASE WHEN DimCatalogPrice.CatalogPriceIsRecurring = 'Not Recurring'
					   AND Parent_DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
					   AND PrdComponentMap.IsPromo = 1
					  THEN FactSalesOrderLineItem.SalesOrderLineItemPrice 
				 ELSE 0 END) AS PromoNonRecurring
	FROM	FactSalesOrderLineItem
			INNER JOIN DimSalesOrderLineItem 
					ON FactSalesOrderLineItem.DimSalesOrderLineItemId = DimSalesOrderLineItem.DimSalesOrderLineItemId
			INNER JOIN DimSalesOrder 
					ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			INNER JOIN DimCatalogItem 
					ON FactSalesOrderLineItem.DimCatalogItemId = DimCatalogItem.DimCatalogItemId
			INNER JOIN DimCatalogPrice 
					ON FactSalesOrderLineItem.DimCatalogPriceId = DimCatalogPrice.DimCatalogPriceId
			INNER JOIN DimCatalogItem AS Parent_DimCatalogItem 
					ON FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_DimCatalogItem.DimCatalogItemId
			INNER JOIN FactSalesOrderLineItem AS Parent_FactSalesOrderLineItem
					ON FactSalesOrderLineItem.DimSalesOrderId = Parent_FactSalesOrderLineItem.DimSalesOrderId
				   AND FactSalesOrderLineItem.Parent_DimCatalogItemId = Parent_FactSalesOrderLineItem.DimCatalogItemId
			INNER JOIN DimSalesOrderLineItem AS Parent_DimSalesOrderLineItem 
					ON Parent_FactSalesOrderLineItem.DimSalesOrderLineItemId = Parent_DimSalesOrderLineItem.DimSalesOrderLineItemId
			 LEFT JOIN PrdComponentMap 
					ON DimCatalogItem.ComponentCode = PrdComponentMap.ComponentCode
	WHERE	DimSalesOrderLineItem.SalesOrderLineItemActivity = 'Install'
	  AND	DimCatalogPrice.CatalogPriceIsRecurring <> ''
	GROUP BY DimSalesOrder.SalesOrderNumber
	)

--SELECT	*
--FROM	OrderServicesActivity
--WHERE	SalesOrderNumber = 'ORD-01288-N6V9H0'

SELECT	OSA.SalesOrderLineItemAgents,
		OSA.LineItemCreatedOnDate,
		OSA.SalesOrderNumber,
		OSA.AccountTypeCode,
		OSA.AccountGroupCode,
		OSA.ReportingMarket,
		OSA.AccountCode,
		OSA.AccountDiscounts,
		OCA.SmartHome,
		OCA.SmartHomePod,
		OCA.PointGuard,
		OCA.Promo,
		OSA.[Data],
		OSA.Cable,
		OSA.Phone,
		OSA.AutoPay AS AccountAutoPay,
		OSA.SalesOrderType,
		OSA.SalesOrderServiceActivity,
		OSA.pbb_AccountMarket,
		OSA.pbb_SalesOrderReviewDate AS InstallDate,
		SDS.SpeedDescription,
		OCA.PromoList,
		PIR.Category,
		SIP.ServiceInstallNonRecurring,
		SIP.ServiceInstallRecurring,
		SIP.OrderInstallNonRecurring,
		SIP.OrderInstallRecurring,
		SIP.PromoNonRecurring
FROM	OrderServicesActivity OSA
		LEFT JOIN OrderComponentActivity OCA
			   ON OSA.SalesOrderNumber = OCA.SalesOrderNumber
			  AND OSA.SalesOrderServiceActivity = OCA.SalesOrderServiceActivity
		LEFT JOIN SalesDataSpeed SDS
			   ON OSA.SalesOrderNumber = SDS.SalesOrderNumber
			  AND OSA.SalesOrderServiceActivity = SDS.SalesOrderLineItemActivity
		LEFT JOIN SalesOrderInetRank SIR
			   ON OSA.SalesOrderNumber = SIR.SalesOrderNumber
		LEFT JOIN PrdInternetRank PIR
			   ON SIR.InternetRank = PIR.Rnk
		LEFT JOIN SalesOrderInstallPrices SIP
			   ON OSA.SalesOrderNumber = SIP.SalesOrderNumber
GO
