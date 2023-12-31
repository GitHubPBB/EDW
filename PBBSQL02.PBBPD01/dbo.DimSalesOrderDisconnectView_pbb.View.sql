USE [PBBPDW01]
GO
/****** Object:  View [dbo].[DimSalesOrderDisconnectView_pbb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DimSalesOrderDisconnectView_pbb] AS

WITH DisconnectOrders AS
(SELECT FactSalesOrderLineItem.DimSalesOrderId
	,MIN(DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate)) AS pbb_SalesOrderReviewDate
	,MIN(FactSalesOrderLineItem.OrderClosed_DimDateId) AS OrderClosed_DimDateId
	,MIN(FactSalesOrderLineItem.DimAccountId) AS DimAccountId
	,MIN(FactSalesOrderLineItem.DimServiceLocationId) AS DimServiceLocationId
FROM FactSalesOrderLineItem
JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
WHERE DimSalesOrder.SalesOrderType = 'Disconnect'
	AND DimSalesOrder_pbb.pbb_SalesOrderReviewDate IS NOT NULL
GROUP BY FactSalesOrderLineItem.DimSalesOrderId)

,OrderLineItems AS
(SELECT FactSalesOrderLineItem.DimSalesOrderLineItemId
	,FactSalesOrderLineItem.DimCustomerItemId
	,DisconnectOrders.*
FROM FactSalesOrderLineItem
JOIN DisconnectOrders ON FactSalesOrderLineItem.DimSalesOrderId = DisconnectOrders.DimSalesOrderId)

,NextDisconnectOrder AS
(SELECT DISTINCT DisconnectOrders.DimSalesOrderId
FROM DisconnectOrders
JOIN DisconnectOrders AS NextOrders ON DisconnectOrders.DimAccountId = NextOrders.DimAccountId
	AND DisconnectOrders.DimServiceLocationId = NextOrders.DimServiceLocationId
JOIN DimSalesOrder ON NextOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
WHERE NextOrders.pbb_SalesOrderReviewDate > DisconnectOrders.pbb_SalesOrderReviewDate
	AND (DimSalesOrder.SalesOrderFulfillmentStatus NOT IN ('Completed','Order Cancelled')
	 OR NextOrders.OrderClosed_DimDateId > DisconnectOrders.pbb_SalesOrderReviewDate))

,ExistingItemRows AS
(SELECT DisconnectOrders.*,
	FactCustomerItem.DimCustomerItemId,
	FactCustomerItem.Activation_DimDateId,
	FactCustomerItem.Deactivation_DimDateId,
	FactCustomerItem.EffectiveStartDate,
	FactCustomerItem.EffectiveEndDate
FROM FactCustomerItem
JOIN DimAccount ON FactCustomerItem.DimAccountId = DimAccount.DimAccountId
JOIN DimServiceLocation ON FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
JOIN DisconnectOrders ON FactCustomerItem.DimAccountId = DisconnectOrders.DimAccountId
	AND FactCustomerItem.DimServiceLocationId = DisconnectOrders.DimServiceLocationId
	AND FactCustomerItem.EffectiveStartDate <= DisconnectOrders.pbb_SalesOrderReviewDate
	AND FactCustomerItem.EffectiveEndDate > DisconnectOrders.pbb_SalesOrderReviewDate
	AND FactCustomerItem.Deactivation_DimDateId > DisconnectOrders.pbb_SalesOrderReviewDate
LEFT JOIN OrderLineItems ON FactCustomerItem.DimAccountId = OrderLineItems.DimAccountId
	AND FactCustomerItem.DimServiceLocationId = OrderLineItems.DimServiceLocationId
	AND FactCustomerItem.DimCustomerItemId = OrderLineItems.DimCustomerItemId
	AND DisconnectOrders.DimSalesOrderId = OrderLineItems.DimSalesOrderId
WHERE OrderLineItems.DimCustomerItemId IS NULL
)

SELECT DISTINCT DimSalesOrder.SalesOrderNumber
	,CASE WHEN ExistingItemRows.DimSalesOrderId IS NULL
		AND NextDisconnectOrder.DimSalesOrderId IS NULL THEN 'Disconnect'
		ELSE 'Change' END AS pbb_OrderActivityType
	,DisconnectOrders.OrderClosed_DimDateId
	,DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate) AS pbb_SalesOrderReviewDate
	,DisconnectOrders.DimAccountId
	,DisconnectOrders.DimServiceLocationId
FROM DisconnectOrders
LEFT JOIN (SELECT DISTINCT DimSalesOrderId FROM ExistingItemRows) AS ExistingItemRows
	ON DisconnectOrders.DimSalesOrderId = ExistingItemRows.DimSalesOrderId
LEFT JOIN NextDisconnectOrder ON DisconnectOrders.DimSalesOrderId = NextDisconnectOrder.DimSalesOrderId
JOIN DimSalesOrder ON DisconnectOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId

--SELECT * FROM DimSalesOrder WHERE SalesOrderNumber = 'ORD-01302-K5Q3W8'
GO
