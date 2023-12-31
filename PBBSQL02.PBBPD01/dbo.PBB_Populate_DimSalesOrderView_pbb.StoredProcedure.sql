USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimSalesOrderView_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PBB_Populate_DimSalesOrderView_pbb]
AS
    begin

	   set nocount on

	   truncate table [dbo].[DimSalesOrderView_pbb];

	   WITH InstallOrders
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderId
				   ,MIN(DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate)) AS pbb_SalesOrderReviewDate
				   ,MIN(FactSalesOrderLineItem.OrderClosed_DimDateId) AS OrderClosed_DimDateId
				   ,MIN(FactSalesOrderLineItem.DimAccountId) AS DimAccountId
				   ,MIN(FactSalesOrderLineItem.DimServiceLocationId) AS DimServiceLocationId
			  FROM FactSalesOrderLineItem
				  JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				  JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			  WHERE DimSalesOrder.SalesOrderType IN
										    (
											'Install'
										    ,'Reconn'
										    )
				   AND DimSalesOrder_pbb.pbb_SalesOrderReviewDate IS NOT NULL
			  GROUP BY FactSalesOrderLineItem.DimSalesOrderId),
		   OrderLineItems
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderLineItemId
				   ,FactSalesOrderLineItem.DimCustomerItemId
				   ,InstallOrders.*
			  FROM FactSalesOrderLineItem
				  JOIN InstallOrders ON FactSalesOrderLineItem.DimSalesOrderId = InstallOrders.DimSalesOrderId),
		   PreviousInstallOrder
		   AS (SELECT DISTINCT 
				    InstallOrders.DimSalesOrderId
			  FROM InstallOrders
				  JOIN InstallOrders AS PreviousOrders ON InstallOrders.DimAccountId = PreviousOrders.DimAccountId
												  AND InstallOrders.DimServiceLocationId = PreviousOrders.DimServiceLocationId
				  JOIN DimSalesOrder ON PreviousOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
			  WHERE PreviousOrders.pbb_SalesOrderReviewDate < InstallOrders.pbb_SalesOrderReviewDate
				   AND (DimSalesOrder.SalesOrderFulfillmentStatus NOT IN
															 (
															  'Completed'
															 ,'Order Cancelled'
															 )
					   OR PreviousOrders.OrderClosed_DimDateId > InstallOrders.pbb_SalesOrderReviewDate)),
		   ExistingItemRows
		   AS (SELECT InstallOrders.*
				   ,FactCustomerItem.DimCustomerItemId
				   ,FactCustomerItem.Activation_DimDateId
				   ,FactCustomerItem.Deactivation_DimDateId
				   ,FactCustomerItem.EffectiveStartDate
				   ,FactCustomerItem.EffectiveEndDate
			  FROM FactCustomerItem
				  JOIN DimCustomerItem on FactCustomerItem.DimCustomerItemId = DimCustomerItem.DimCustomerItemId
				  JOIN DimAccount ON FactCustomerItem.DimAccountId = DimAccount.DimAccountId
				  JOIN DimServiceLocation ON FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
				  JOIN InstallOrders ON FactCustomerItem.DimAccountId = InstallOrders.DimAccountId
								    AND FactCustomerItem.DimServiceLocationId = InstallOrders.DimServiceLocationId
								    AND FactCustomerItem.EffectiveStartDate <= InstallOrders.pbb_SalesOrderReviewDate
								    AND FactCustomerItem.EffectiveEndDate > InstallOrders.pbb_SalesOrderReviewDate
								    AND FactCustomerItem.Deactivation_DimDateId > InstallOrders.pbb_SalesOrderReviewDate
									AND FactCustomerItem.Activation_DimDateId <= InstallOrders.pbb_SalesOrderReviewDate
				  LEFT JOIN OrderLineItems ON FactCustomerItem.DimAccountId = OrderLineItems.DimAccountId
										AND FactCustomerItem.DimServiceLocationId = OrderLineItems.DimServiceLocationId
										AND FactCustomerItem.DimCustomerItemId = OrderLineItems.DimCustomerItemId
										AND InstallOrders.DimSalesOrderId = OrderLineItems.DimSalesOrderId
			  WHERE OrderLineItems.DimCustomerItemId IS NULL
				AND cast(InstallOrders.pbb_SalesOrderReviewDate as date) >= cast (ItemActivationDate as date)
				and cast(InstallOrders.pbb_SalesOrderReviewDate as date) < cast(isnull(ItemDeactivationDate,'12/31/2050') as date)),
		   DisconnectOrders
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderId
				   ,MIN(DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate)) AS pbb_SalesOrderReviewDate
				   ,MIN(FactSalesOrderLineItem.OrderClosed_DimDateId) AS OrderClosed_DimDateId
				   ,MIN(FactSalesOrderLineItem.DimAccountId) AS DimAccountId
				   ,MIN(FactSalesOrderLineItem.DimServiceLocationId) AS DimServiceLocationId
			  FROM FactSalesOrderLineItem
				  JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				  JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			  WHERE DimSalesOrder.SalesOrderType = 'Disconnect'
				   AND DimSalesOrder_pbb.pbb_SalesOrderReviewDate IS NOT NULL
			  GROUP BY FactSalesOrderLineItem.DimSalesOrderId),
		   DisconnectOrderLineItems
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderLineItemId
				   ,FactSalesOrderLineItem.DimCustomerItemId
				   ,DisconnectOrders.*
			  FROM FactSalesOrderLineItem
				  JOIN DisconnectOrders ON FactSalesOrderLineItem.DimSalesOrderId = DisconnectOrders.DimSalesOrderId),
		   NextDisconnectOrder
		   AS (SELECT DISTINCT 
				    DisconnectOrders.DimSalesOrderId
			  FROM DisconnectOrders
				  JOIN DisconnectOrders AS NextOrders ON DisconnectOrders.DimAccountId = NextOrders.DimAccountId
												 AND DisconnectOrders.DimServiceLocationId = NextOrders.DimServiceLocationId
				  JOIN DimSalesOrder ON NextOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				  JOIN DimSalesOrder discosalesorders on DisconnectOrders.DimSalesOrderId = discosalesorders.dimsalesorderid
			  WHERE NextOrders.pbb_SalesOrderReviewDate > DisconnectOrders.pbb_SalesOrderReviewDate
				   AND (DimSalesOrder.SalesOrderFulfillmentStatus NOT IN
															 (
															  'Completed'
															 ,'Order Cancelled'
															 )
					   OR NextOrders.OrderClosed_DimDateId > DisconnectOrders.pbb_SalesOrderReviewDate)
					    OR (NextOrders.OrderClosed_DimDateId = DisconnectOrders.OrderClosed_DimDateId
							and DimSalesOrder.SalesOrderFulfillmentStatus = 'Completed' and discosalesorders.SalesOrderFulfillmentStatus = 'Completed'
							and NextOrders.pbb_SalesOrderReviewDate > DisconnectOrders.pbb_SalesOrderReviewDate)),
		   ExistingItemRows_Disco
		   AS (SELECT DisconnectOrders.*
				   ,FactCustomerItem.DimCustomerItemId
				   ,FactCustomerItem.Activation_DimDateId
				   ,FactCustomerItem.Deactivation_DimDateId
				   ,FactCustomerItem.EffectiveStartDate
				   ,FactCustomerItem.EffectiveEndDate
			  FROM FactCustomerItem
				  JOIN DimAccount ON FactCustomerItem.DimAccountId = DimAccount.DimAccountId
				  JOIN DimServiceLocation ON FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
				  JOIN DisconnectOrders ON FactCustomerItem.DimAccountId = DisconnectOrders.DimAccountId
									  AND FactCustomerItem.DimServiceLocationId = DisconnectOrders.DimServiceLocationId
									  AND FactCustomerItem.EffectiveStartDate <= DisconnectOrders.pbb_SalesOrderReviewDate
									  AND FactCustomerItem.EffectiveEndDate > DisconnectOrders.pbb_SalesOrderReviewDate
									  AND FactCustomerItem.Deactivation_DimDateId > DisconnectOrders.pbb_SalesOrderReviewDate
				  LEFT JOIN DisconnectOrderLineItems ON FactCustomerItem.DimAccountId = DisconnectOrderLineItems.DimAccountId
												AND FactCustomerItem.DimServiceLocationId = DisconnectOrderLineItems.DimServiceLocationId
												AND FactCustomerItem.DimCustomerItemId = DisconnectOrderLineItems.DimCustomerItemId
												AND DisconnectOrders.DimSalesOrderId = DisconnectOrderLineItems.DimSalesOrderId
			  WHERE DisconnectOrderLineItems.DimCustomerItemId IS NULL)
		   insert into [dbo].[DimSalesOrderView_pbb]
				select *
				from
					(
					    SELECT DISTINCT 
							 DimSalesOrder.SalesOrderId
							,CASE
								WHEN ExistingItemRows.DimSalesOrderId IS NULL
									AND PreviousInstallOrder.DimSalesOrderId IS NULL
								THEN 'Install' ELSE 'Change'
							 END AS pbb_OrderActivityType
							,InstallOrders.DimAccountId
							,InstallOrders.DimServiceLocationId
					    FROM InstallOrders
						    LEFT JOIN
						    (
							   SELECT DISTINCT 
									DimSalesOrderId
							   FROM ExistingItemRows
						    ) AS ExistingItemRows ON InstallOrders.DimSalesOrderId = ExistingItemRows.DimSalesOrderId
						    LEFT JOIN PreviousInstallOrder ON InstallOrders.DimSalesOrderId = PreviousInstallOrder.DimSalesOrderId
						    JOIN DimSalesOrder ON InstallOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
						    JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
					    UNION ALL
					    SELECT DISTINCT 
							 DimSalesOrder.SalesOrderId
							,CASE
								WHEN ExistingItemRows.DimSalesOrderId IS NULL
									AND NextDisconnectOrder.DimSalesOrderId IS NULL
								THEN 'Disconnect' ELSE 'Change'
							 END AS pbb_OrderActivityType
							,DisconnectOrders.DimAccountId
							,DisconnectOrders.DimServiceLocationId
					    FROM DisconnectOrders
						    LEFT JOIN
						    (
							   SELECT DISTINCT 
									DimSalesOrderId
							   FROM ExistingItemRows_Disco
						    ) AS ExistingItemRows ON DisconnectOrders.DimSalesOrderId = ExistingItemRows.DimSalesOrderId
						    LEFT JOIN NextDisconnectOrder ON DisconnectOrders.DimSalesOrderId = NextDisconnectOrder.DimSalesOrderId
						    JOIN DimSalesOrder ON DisconnectOrders.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
						    JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
					) inr
    end
GO
