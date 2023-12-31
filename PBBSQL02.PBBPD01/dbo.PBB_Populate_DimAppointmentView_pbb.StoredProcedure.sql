USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimAppointmentView_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Change:  2202-09-09		Todd Boyer		Tuning
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_DimAppointmentView_pbb]
AS
    begin

	   set nocount on

	   truncate table [dbo].[DimAppointmentView_pbb];

	   DROP TABLE if exists #InstallOrders;
	   DROP TABLE if exists #Appointments;
	   DROP TABLE if exists #OrderLineItems;
	   DROP TABLE if exists #PreviousInstallOrder;
	   DROP TABLE if exists #ExistingItemRows;

	   WITH InstallOrders
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderId
				   ,MIN(FactSalesOrderLineItem.DimAccountId) AS DimAccountId
				   ,MIN(FactSalesOrderLineItem.DimServiceLocationId) AS DimServiceLocationId
				   ,MIN(FactSalesOrderLineItem.OrderClosed_DimDateId) AS OrderClosed_DimDateId
				   ,DimSalesOrder.SalesOrderNumber
			  FROM FactSalesOrderLineItem
				  JOIN DimSalesOrder ON FactSalesOrderLineItem.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				  JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId = DimSalesOrder_pbb.SalesOrderId
			  WHERE DimSalesOrder.SalesOrderType IN
										    (
											'Install'
										    ,'Reconn'
										    )
			  GROUP BY FactSalesOrderLineItem.DimSalesOrderId
					,DimSalesOrder.SalesOrderNumber
		)
		SELECT * INTO #InstallOrders FROM InstallOrders;

		WITH Appointments
		   AS (SELECT PBB_FactAppointment.*
				   ,InstallOrders.DimServiceLocationId
				   ,InstallOrders.SalesOrderNumber
				   ,InstallOrders.OrderClosed_DimDateId
			  FROM PBB_FactAppointment
				  JOIN #InstallOrders InstallOrders ON PBB_FactAppointment.DimSalesOrderId = InstallOrders.DimSalesOrderId
	    )
		SELECT * INTO #Appointments FROM Appointments;

		WITH OrderLineItems
		   AS (SELECT FactSalesOrderLineItem.DimSalesOrderLineItemId
				   ,FactSalesOrderLineItem.DimCustomerItemId
				   ,Appointments.*
			  FROM FactSalesOrderLineItem
				  JOIN #Appointments Appointments ON FactSalesOrderLineItem.DimSalesOrderId = Appointments.DimSalesOrderId
		)
		SELECT * INTO #OrderLineItems FROM OrderLineItems;

		WITH PreviousInstallOrder
		   AS (SELECT DISTINCT 
				    Appointments.DimSalesOrderId
			  FROM #Appointments  Appointments
				  JOIN DimSalesOrder     ON Appointments.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				  join DimSalesOrder_pbb on DimSalesOrder.SalesOrderId   = DimSalesOrder_pbb.SalesOrderId
				  JOIN #Appointments AS PreviousAppointments ON Appointments.DimAccountId = PreviousAppointments.DimAccountId
													  AND Appointments.DimServiceLocationId = PreviousAppointments.DimServiceLocationId
				  JOIN DimSalesOrder PreviousDimSalesOrder ON PreviousAppointments.DimSalesOrderId = PreviousDimSalesOrder.DimSalesOrderId
				  join DimSalesOrder_pbb PreviousDimSalesOrder_pbb on PreviousDimSalesOrder.SalesOrderId = PreviousDimSalesOrder_pbb.SalesOrderId
			  WHERE isnull(PreviousDimSalesOrder_pbb.pbb_SalesOrderReviewDate,'12-31-2050') < isnull(DimSalesOrder_pbb.pbb_SalesOrderReviewDate,'12-31-2050')
				   or (isnull(PreviousDimSalesOrder_pbb.pbb_SalesOrderReviewDate,'12-31-2050') = isnull(DimSalesOrder_pbb.pbb_SalesOrderReviewDate,'12-31-2050')
					  and PreviousAppointments.DimSalesOrderId < Appointments.DimSalesOrderId)
			  --AND (PreviousDimSalesOrder.SalesOrderFulfillmentStatus NOT IN
			  --								 (
			  --								  'Completed'
			  --								 ,'Order Cancelled'
			  --								 )
			  --OR PreviousAppointments.OrderClosed_DimDateId > Appointments.ScheduledStart_DimDateId)
		 )
		 SELECT * INTO #PreviousInstallOrder FROM PreviousInstallOrder;

		 WITH ExistingItemRows
		   AS (SELECT Appointments.*
				   ,FactCustomerItem.DimCustomerItemId
				   ,FactCustomerItem.Activation_DimDateId
				   ,FactCustomerItem.Deactivation_DimDateId
				   ,FactCustomerItem.EffectiveStartDate
				   ,FactCustomerItem.EffectiveEndDate
			  FROM FactCustomerItem
				  JOIN DimAccount ON FactCustomerItem.DimAccountId = DimAccount.DimAccountId
				  JOIN DimServiceLocation ON FactCustomerItem.DimServiceLocationId = DimServiceLocation.DimServiceLocationId
				  JOIN #Appointments Appointments ON FactCustomerItem.DimAccountId = Appointments.DimAccountId
								   AND FactCustomerItem.DimServiceLocationId = Appointments.DimServiceLocationId
								   AND FactCustomerItem.EffectiveStartDate <= Appointments.ScheduledStart_DimDateId
								   AND FactCustomerItem.EffectiveEndDate > Appointments.ScheduledStart_DimDateId
								   AND FactCustomerItem.Deactivation_DimDateId > Appointments.ScheduledStart_DimDateId
				  LEFT JOIN #OrderLineItems OrderLineItems ON FactCustomerItem.DimAccountId = OrderLineItems.DimAccountId
										AND FactCustomerItem.DimServiceLocationId = OrderLineItems.DimServiceLocationId
										AND FactCustomerItem.DimCustomerItemId = OrderLineItems.DimCustomerItemId
										AND Appointments.DimSalesOrderId = OrderLineItems.DimSalesOrderId
			  WHERE OrderLineItems.DimCustomerItemId IS NULL
		 )
		 SELECT * INTO #ExistingItemRows FROM ExistingItemRows;

		 INSERT INTO [dbo].[DimAppointmentView_pbb]
				SELECT DISTINCT 
					  Appointments.ActivityId
					 ,CASE
						 WHEN ExistingItemRows.DimSalesOrderId IS NULL
							 AND PreviousInstallOrder.DimSalesOrderId IS NULL
						 THEN 'Install' ELSE 'Change'
					  END AS pbb_OrderActivityType
					 ,Appointments.OrderClosed_DimDateId
					 ,DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate) AS pbb_SalesOrderReviewDate
					 ,Appointments.ScheduledEnd_DimDateId
					 ,Appointments.DimAccountId
					 ,Appointments.DimServiceLocationId
				FROM #Appointments Appointments
				JOIN DimSalesOrder     ON Appointments.DimSalesOrderId = DimSalesOrder.DimSalesOrderId
				JOIN DimSalesOrder_pbb ON DimSalesOrder.SalesOrderId   = DimSalesOrder_pbb.SalesOrderId
				LEFT JOIN
					(
					    SELECT DISTINCT 
							 DimSalesOrderId
					    FROM #ExistingItemRows
					) AS		                  ExistingItemRows     ON Appointments.DimSalesOrderId = ExistingItemRows.DimSalesOrderId
				LEFT JOIN	#PreviousInstallOrder PreviousInstallOrder ON Appointments.DimSalesOrderId = PreviousInstallOrder.DimSalesOrderId

    end
GO
