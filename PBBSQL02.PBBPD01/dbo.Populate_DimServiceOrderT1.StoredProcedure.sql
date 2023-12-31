USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[Populate_DimServiceOrderT1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ====================================================================  
-- Description:	T1 load procedure for DimServiceOrderT1 table
--
-- Input:     void
--
-- Change histrory: 
-- Name			Author		Date		Version		Description 
-- Comment      Todd        11/26/2023   02.00       Revamped version
--              
-- 
-- ====================================================================


CREATE PROCEDURE [dbo].[Populate_DimServiceOrderT1]
AS
    
BEGIN

	   set nocount on


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Start Logging
-----------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @Version				  VARCHAR(10) = 'v2.00';
	DECLARE @LogParentID              numeric(18,0)
	DECLARE @ProcessDate			  DATE;
	DECLARE @RC						  int
	DECLARE @EtlName				  varchar(50)        
	DECLARE @V_LoadDttm				  varchar(40)             = GETDATE()
	DECLARE @ProcGUID				  varchar(50)
	DECLARE @ExecutionGUID			  varchar(50)
	DECLARE @MachineName			  varchar(50)             = HOST_NAME()
	DECLARE @UserName				  varchar(50)             = SUSER_NAME()
	DECLARE @ExecutionStep			  varchar(1000)
	DECLARE @ExecutionMsg			  varchar(MAX)          
	DECLARE @LogID					  numeric(18,0)           = @LogParentID 
	DECLARE @V_Table                  varchar(MAX)
	DECLARE @V_TargetSchema           varchar(MAX)
	DECLARE @V_ExecutionGroup         varchar(MAX)
	DECLARE @V_CurrentTimestamp		  datetime				  = GETDATE()

	DECLARE @MaxKey bigint;

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

BEGIN TRY
SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBPDW01.info.ExecutionLog
SET @V_ExecutionGroup = 'Load into T1 Table'
SET @V_TargetSchema = 'dbo'
SET @V_Table = 'DimServiceOrderT1'
SET @ExecutionMsg = 'Starting Process'
SET @EtlName = concat(@V_TargetSchema, '.', @V_Table);	
SET @ExecutionStep = concat(@EtlName,'|' , 'Step01');

	EXECUTE @RC = info.ExecutionLogStart
	   @LogParentID
	  ,@V_ExecutionGroup
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,NULL
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;

	 
----------------------------------------------------------------------
-- Step 2 - Collect Distribution Center locations
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');
	SET @ExecutionMsg = 'Collect Distribution Center Locations';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	DROP TABLE if exists #MDUAddresses;

  	SELECT Distinct dsl.DimServiceLocationId
	     , dsl.LocationId
		 , dsl.ServiceLocationFullAddress
	     , dc.cus_DistributionCenterName
	     , ab.AccountNumber  as MDUAccountCode
		 , case when csl.cus_Serviceable = '972050000' then 'Y' else 'N' end ServiceableAddress
		 , case when ab.AccountNumber is not null then 'Bulk' else 'MDU' end BulkMduCode
	  INTO #MDUAddresses
	  FROM pbbpdw01.Transient.cus_DistributionCenterBase         dc   
	  JOIN pbbpdw01.Transient.chr_servicelocation                csl  ON dc.cus_distributioncenterId   = csl.cus_ServiceLocationsId
	  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation            dsl  ON dsl.locationid                = csl.chr_masterlocationid
	  LEFT JOIN pbbpdw01.Transient.AccountBase                   ab   ON ab.AccountId                  = dc.cus_BulkBillingAccount    -- Get the BULK master account
	;
	-- select * from #MDUAddresses order by cus_DistributionCenterName, ServiceLocationFullAddress


----------------------------------------------------------------------
-- Step 3 - Collect All Service Orders    - 6.5 Min
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step03');
	SET @ExecutionMsg = 'Collect All Service Orders';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


    DROP TABLE if exists PBBPDW01.stg.SOdailyOrderInfo;

  -- 4 Min
  	SELECT     da.AccountCode, fca.AccountId, fso.DimAccountId ,  coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId) DimServiceLocationId
	         , substring(dacp.pbb_AccountMarket,4,99) AccountMarket, dacp.pbb_ReportingMarket ReportingMarket
			 , max(mdu.BulkMduCode) BulkMduCode
		     , dso.SalesOrderId, dso.SalesOrderNumber, dso.SalesOrderFulfillmentStatus, dso.SalesOrderStatus, dso.SalesOrderType
		     , SalesOrderDisconnectReason, dso.OrderWorkflowName, fso.ProvisioningDate_DimDateId, fso.OrderClosed_DimDateId   
			 , dsop.pbb_SalesOrderReviewDate pbb_SalesOrderReviewDateUTC
			 , OMNIA_EPBB_P_PBB_DW.dbo.F_ConvertUTCDateToLocalTime(dsop.pbb_SalesOrderReviewDate) pbb_SalesOrderReviewDate
		     , case when dso.SalesOrderType in ('Install','Change') then cast(OMNIA_EPBB_P_PBB_DW.dbo.F_ConvertUTCDateToLocalTime(dsop.pbb_SalesOrderReviewDate) as date) 
			        when fso.orderclosed_DimDateId  = '19000101'    then cast(OMNIA_EPBB_P_PBB_DW.dbo.F_ConvertUTCDateToLocalTime(dsop.pbb_SalesOrderReviewDate) as date) 
			        else fso.orderclosed_DimDateId  end  OrderDate 
		  INTO PBBPDW01.stg.SOdailyOrderInfo
		  FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimSalesOrder]                dso
			JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrder                   fso   ON fso.DimSalesOrderId                    = dso.DimSalesOrderId
			JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccount                       da    ON da.DimAccountId                        = fso.DimAccountId 
			LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactCustomerAccount         fca   ON fca.DimAccountId                       = da.DimAccountId
			                                                                    AND fca.EffectiveEndDate = '20500101'
			JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory               dac   ON dac.DimAccountCategoryId               = fso.DimAccountCategoryId
			JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccountCategory_pbb           dacp  ON dacp.SourceId                          = dac.SourceId
			JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder_pbb                dsop  ON dso.SalesOrderId                       = dsop.SalesOrderId
						                                                        AND dsop.pbb_SalesOrderReviewDate is not null
			LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrderLineItem      fsoli ON fsoli.DimSalesOrderId                  = dso.DimSalesOrderId
            LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.PBB_OCComponent_View        oc    on oc.SalesOrderId                        = dso.SalesOrderId  
			LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation          dsl   on dsl.LocationId                         = oc.LocationId
			LEFT JOIN #MDUAddresses                                       mdu   on mdu.LocationId                         = oc.LocationId
		group by 
		       da.AccountCode,fca.AccountId, fso.DimAccountId ,  coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId)  
	         , substring(dacp.pbb_AccountMarket,4,99)   , dacp.pbb_ReportingMarket
		     , dso.SalesOrderId, dso.SalesOrderNumber, dso.SalesOrderFulfillmentStatus, dso.SalesOrderStatus, dso.SalesOrderType
		     , SalesOrderDisconnectReason, dso.OrderWorkflowName, fso.ProvisioningDate_DimDateId, fso.OrderClosed_DimDateId   
			 , dsop.pbb_SalesOrderReviewDate
		     , case when dso.SalesOrderType in ('Install','Change') then cast(OMNIA_EPBB_P_PBB_DW.dbo.F_ConvertUTCDateToLocalTime(dsop.pbb_SalesOrderReviewDate) as date) 
			        when fso.orderclosed_DimDateId  = '19000101'    then cast(OMNIA_EPBB_P_PBB_DW.dbo.F_ConvertUTCDateToLocalTime(dsop.pbb_SalesOrderReviewDate) as date) 
			        else fso.orderclosed_DimDateId  end    
	;

	create index idx_nu1_SOdailyOrderInfo on PBBPDW01.stg.SOdailyOrderInfo (DimAccountId, DimServiceLocationId);

	-- update statistics PBBPDW01.stg.SOdailyOrderInfo

	-- select AccountCode, DimServiceLocationId, SalesOrderNumber, count(*) from PBBPDW01.stg.SOdailyOrderInfo  group by  AccountCode, DimServiceLocationId, SalesOrderNumber having count(*) > 1
	-- select * from PBBPDW01.stg.SOdailyOrderInfo  where  SalesOrderNumber = 'ORD-235989-B4C0B3'



----------------------------------------------------------------------
-- Step 4 - Verify Service Order Effect  - 34 min
----------------------------------------------------------------------


	SET @ExecutionStep = concat(@EtlName,'|' , 'Step04');
	SET @ExecutionMsg = 'Verify Service Order Effect';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


    DROP TABLE if exists PBBPDW01.stg.SOdailyOrderInfo2;

  	SELECT x.* 
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,-2,cast(OrderDate as date)),SalesOrderType) ActiveItemsYminus1
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,-1,cast(OrderDate as date)),SalesOrderType) ActiveItemsYesterday
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId,              cast(OrderDate as date),SalesOrderType)  ActiveItemsToday
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,1,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTomorrow
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,2,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus1
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,3,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus2
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,4,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus3
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,5,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus4
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,6,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus5
	     , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, dateadd(d,7,cast(OrderDate as date)),SalesOrderType)  ActiveItemsTplus6
		 , OMNIA_EPBB_P_PBB_DW.dbo.PBB_GetActiveItemCount(DimAccountId, DimServiceLocationId, OrderClosed_DimDateId , SalesOrderType)  ActiveItemsAtOrderClose
	     , row_number()                    over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) row_Seq
	     , row_number()                    over (partition by DimAccountId, DimServiceLocationId, Orderdate    order by pbb_SalesOrderReviewDate desc, SalesOrderNumber desc) row_DailySeq
	     , lag(SalesOrderType)             over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) PrevSalesOrderType
	     , lag(cast(OrderDate as date))    over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) PrevOrderDate
	     , lag(SalesOrderNumber)           over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) PrevSalesOrderNumber
	     , lag(SalesOrderType,2)           over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) Prev2SalesOrderType
	     , lag(cast(OrderDate as date),2)  over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) Prev2OrderDate
	     , lead(SalesOrderType)            over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) NextSalesOrderType
	     , lead(cast(OrderDate as date))   over (partition by DimAccountId, DimServiceLocationId               order by OrderDate, SalesOrderNumber ) NextOrderDate
	  INTO  PBBPDW01.stg.SOdailyOrderInfo2
	  FROM  PBBPDW01.stg.SOdailyOrderInfo x
	     WHERE not (x.SalesOrderFulfillmentStatus   like '%Cancel%' and OrderClosed_DimDateId = '19000101')
		 
			  AND x.SalesOrderType IN
										    (
											 'Install'
										    ,'Reconn'
											,'Change'
											,'Disconnect'
										    )
  ;


  
----------------------------------------------------------------------
-- Step 5 - Parse Order Effect Results  - 1 sec
----------------------------------------------------------------------


	SET @ExecutionStep = concat(@EtlName,'|' , 'Step05');
	SET @ExecutionMsg = 'Parse Order Effect Results';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


    DROP TABLE if exists pbbpdw01.transient.PBB_OrderInfo; 
    
    WITH
    OrderOrder AS (
    SELECT *
	     , lead(row_DailySeq)           over (partition by DimAccountId, DimServiceLocationId
		                                       , case when SalesOrderType = 'Install' then pbb_SalesOrderReviewDate else OrderClosed_DimDateId end  
											   order by OrderDate, SalesOrderNumber 
		                                     ) row_DailyNextSeq
      FROM  PBBPDW01.stg.SOdailyOrderInfo2 y 
	 )
    SELECT  AccountCode, AccountId, DimAccountId, DimServiceLocationId, AccountMarket, ReportingMarket, BulkMduCode, cast('N' as char(1)) CourtesyInternalFlag, SalesOrderId, SalesOrderNumber, PrevSalesOrderNumber, SalesOrderFulfillmentStatus
          , SalesOrderStatus, SalesOrderType, SalesOrderDisconnectReason, OrderWorkflowName
	      , ProvisioningDate_DimDateId ProvisioningDate, OrderClosed_DimDateId OrderClosedDate, pbb_SalesOrderReviewDate, pbb_SalesOrderReviewDateUTC, OrderDate
		  , row_Seq, row_DailySeq, row_DailyNextSeq, PrevSalesOrderType, PrevOrderDate, Prev2SalesOrderType, Prev2OrderDate, NextSalesOrderType, NextOrderDate 
		  , left(ActiveItemsYminus1,1) ActiveItemsYminus1Start, substring(ActiveItemsYminus1,3,1) ActiveItemsYminus1End, substring(ActiveItemsYminus1,5,99) ActiveItemsYminus1DiscoDate
		  , left(ActiveItemsYesterday,1) ActiveItemsYesterdayStart, substring(ActiveItemsYesterday,3,1) ActiveItemsYesterdayEnd, substring(ActiveItemsYesterday,5,99) ActiveItemsYesterdayDiscoDate
		  , left(ActiveItemsToday,1) ActiveItemsTodayStart, substring(ActiveItemsToday,3,1) ActiveItemsTodayEnd, substring(ActiveItemsToday,5,99) ActiveItemsTodayDiscoDate
		  , left(ActiveItemsTomorrow,1) ActiveItemsTomorrowStart, substring(ActiveItemsTomorrow,3,1) ActiveItemsTomorrowEnd, substring(ActiveItemsTomorrow,5,99) ActiveItemsTomorrowDiscoDate
		  , left(ActiveItemsTplus1,1) ActiveItemsTplus1Start, substring(ActiveItemsTplus1,3,1) ActiveItemsTplus1End, substring(ActiveItemsTplus1,5,99) ActiveItemsTplus1DiscoDate
		  , left(ActiveItemsTplus2,1) ActiveItemsTplus2Start, substring(ActiveItemsTplus2,3,1) ActiveItemsTplus2End, substring(ActiveItemsTplus2,5,99) ActiveItemsTplus2DiscoDate
		  , left(ActiveItemsTplus3,1) ActiveItemsTplus3Start, substring(ActiveItemsTplus3,3,1) ActiveItemsTplus3End, substring(ActiveItemsTplus3,5,99) ActiveItemsTplus3DiscoDate
		  , left(ActiveItemsTplus4,1) ActiveItemsTplus4Start, substring(ActiveItemsTplus4,3,1) ActiveItemsTplus4End, substring(ActiveItemsTplus4,5,99) ActiveItemsTplus4DiscoDate
		  , left(ActiveItemsTplus5,1) ActiveItemsTplus5Start, substring(ActiveItemsTplus5,3,1) ActiveItemsTplus5End, substring(ActiveItemsTplus5,5,99) ActiveItemsTplus5DiscoDate
		  , left(ActiveItemsTplus6,1) ActiveItemsTplus6Start, substring(ActiveItemsTplus6,3,1) ActiveItemsTplus6End, substring(ActiveItemsTplus6,5,99) ActiveItemsTplus6DiscoDate
		  , left(ActiveItemsAtOrderClose,1) ActiveItemsAtOrderCloseStart, substring(ActiveItemsAtOrderClose,3,1) ActiveItemsAtOrderCloseEnd, substring(ActiveItemsAtOrderClose,5,99) ActiveItemsAtOrderCloseDiscoDate
		  , OrderDate ActualOrderDate
		  , cast(SalesOrderType as varchar(20)) pbb_OrderActivityType -- Placeholder to be updated below
	   INTO pbbpdw01.transient.PBB_OrderInfo from OrderOrder
	   WHERE DimAccountId <>0
	   ORDER by DimAccountId, DimServiceLocationId, OrderClosed_DimDateId, row_DailySeq
	 ;

	 create index idx_nu1_PBB_OrderInfo on pbbpdw01.transient.PBB_OrderInfo (DimAccountId, DimServiceLocationId) ;
	 create unique index idx_u1_PBB_OrderInfo on pbbpdw01.transient.PBB_OrderInfo (SalesOrderNumber, DimServiceLocationId);

	 -- select * into  pbbpdw01.transient.PBB_OrderInfo from  pbbpdw01.transient.PBB_OrderInfo2
	 -- select top 100 * from pbbpdw01.transient.TempOrders toi left join omnia_epbb_p_pbb_dw.dbo.DimSalesOrderView_pbb_tb sovp on sovp.SalesOrderId = toi.SalesOrderId    where AccountCode = '200346551' order by row_seq, row_dailyseq
	 -- select top 100 * from  pbbpdw01.transient.PBB_OrderInfo where salesordernumber = 'ORD-178372-W4G8D2'
	   

	   
----------------------------------------------------------------------
-- Step 6 - Install List  - 15 sec
----------------------------------------------------------------------



	SET @ExecutionStep = concat(@EtlName,'|' , 'Step06');
	SET @ExecutionMsg = 'Install List';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	   DROP TABLE if exists #TempInstallOrders;


	   WITH 
	   InstallOrders
		   AS (
		     SELECT DimSalesOrder.DimSalesOrderId                                        AS DimSalesOrderId
		           ,DimSalesOrder.SalesOrderId                                           AS SalesOrderId
				   ,DimSalesOrder.SalesOrderType                                         AS SalesOrderType
				   ,DimSalesorder.SalesOrderNumber                                       AS SalesOrderNumber
				   ,MIN(coalesce(fsoli.DimAccountId,da.DimAccountId) )                   AS DimAccountId
				   ,MIN(coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId))   AS DimServiceLocationId
				   ,MIN(da.AccountCode)                                                  AS AccountCode
				   ,MIN(case when fsoli.DimAccountid is null then 'OC' else 'FSO' end)   AS Source
				   ,MIN(DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate))     AS pbb_SalesOrderReviewDate
				   ,MIN(coalesce(fsoli.OrderClosed_DimDateId,fso.OrderClosed_DimDateId)) AS OrderClosed_DimDateId

			  FROM OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder     
			      JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrder                   fso   ON fso.DimSalesOrderId                    = DimSalesOrder.DimSalesOrderId
				  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder_pbb                      ON DimSalesOrder.SalesOrderId             = DimSalesOrder_pbb.SalesOrderId
			      LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrderLineItem  fsoli ON fsoli.DimSalesOrderId                  = DimSalesOrder.DimSalesOrderId
                  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.PBB_OCComponent_View    oc    on oc.SalesOrderId                        = DimSalesOrder.SalesOrderId 
				  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccount                   da    on da.dimAccountId                        = fso.DimAccountId
				  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation      dsl   on dsl.LocationId                         = oc.LocationId

			  WHERE DimSalesOrder.SalesOrderType IN
										    (
											 'Install'
										    ,'Change'
										    )
				   AND DimSalesOrder_pbb.pbb_SalesOrderReviewDate IS NOT NULL
				   AND NOT (fsoli.DimSalesOrderId is null and oc.SalesOrderId is null)   

			  GROUP BY  DimSalesOrder.DimSalesOrderId, DimSalesOrder.SalesOrderId, DimSalesOrder.SalesOrderType,  DimSalesorder.SalesOrderNumber 
			  )
			SELECT * INTO #TempInstallOrders FROM InstallOrders --WHERE OrderClosed_DimDateId <> '19000101'
		  ;

			-- select * from #TempInstallOrders where AccountCode = '100547946' source='OC' order by pbb_salesorderreviewdate desc

	 
			 
----------------------------------------------------------------------
-- Step 7 - Disco List  - 15 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step07');
	SET @ExecutionMsg = 'Disco List';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


		   DROP TABLE if exists #TempDisconnectOrders;

		   WITH
		   DisconnectOrders
		   AS (SELECT DimSalesorder.DimSalesOrderId                                      AS DimSalesOrderId
		           ,DimSalesOrder.SalesOrderId                                           AS SalesOrderId
				   ,DimSalesOrder.SalesOrderType                                         AS SalesOrderType
				   ,DimSalesorder.SalesOrderNumber                                       AS SalesOrderNumber
				   ,DimSalesOrder.SalesOrderFulfillmentStatus                            AS SalesOrderFulfillmentStatus
				   ,MIN(coalesce(fsoli.DimAccountId,da.DimAccountId) )                   AS DimAccountId
				   ,MIN(coalesce(fsoli.DimServiceLocationId,dsl.DimServiceLocationId))   AS DimServiceLocationId
				   ,MIN(da.AccountCode)                                                  AS AccountCode
				   ,MIN(case when fsoli.DimAccountid is null then 'OC' else 'FSO' end)   AS Source
				 --  ,MIN(DATEADD(HOUR,-4,DimSalesOrder_pbb.pbb_SalesOrderReviewDate))     AS pbb_SalesOrderReviewDate
				   ,MIN(DimSalesOrder_pbb.pbb_SalesOrderReviewDate)                      AS pbb_SalesOrderReviewDate
				   ,MIN(coalesce(fsoli.OrderClosed_DimDateId,fso.OrderClosed_DimDateId)) AS OrderClosed_DimDateId

			  FROM OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder     
			      JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrder               fso   ON fso.DimSalesOrderId                    = DimSalesOrder.DimSalesOrderId
				  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder_pbb                  ON DimSalesOrder.SalesOrderId             = DimSalesOrder_pbb.SalesOrderId
			      LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.FactSalesOrderLineItem  fsoli ON fsoli.DimSalesOrderId                  = DimSalesOrder.DimSalesOrderId
                  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.PBB_OCComponent_View    oc    on oc.SalesOrderId                        = DimSalesOrder.SalesOrderId 
				  JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimAccount                   da    on da.dimAccountId                        = fso.DimAccountId
				  LEFT JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimServiceLocation      dsl   on dsl.LocationId                         = oc.LocationId
			  WHERE DimSalesOrder.SalesOrderType IN
										    (
											'Disconnect'
										    )
				   AND DimSalesOrder_pbb.pbb_SalesOrderReviewDate IS NOT NULL
				   AND NOT (fsoli.DimSalesOrderId is null and oc.SalesOrderId is null)
				  -- AND DimSalesOrder.SalesOrderNumber in (	select SalesOrderNumber from pbbpdw01.transient.TempOrders where ActiveItemsYesterday > 0 )


			  GROUP BY DimSalesOrder.DimSalesOrderId, DimSalesOrder.SalesOrderId, DimSalesOrder.SalesOrderType, DimSalesorder.SalesOrderNumber, DimSalesOrder.SalesOrderFulfillmentStatus
			  )
		  SELECT * INTO #TempDisconnectOrders FROM DisconnectOrders
		  ;
		  
		  /*
		   select * from #TempDisconnectOrders where source = 'OC' order by pbb_SalesOrderreviewdate desc
		   select * from #TempDisconnectOrders do join dimsalesorderview_pbb p on p.Salesorderid = do.salesorderid where source = 'OC' and Pbb_orderactivitytype='Change'
		   select * from #TempDisconnectOrders where SalesOrderId = 'F6607DB0-7978-EC11-812B-00155D247F26'
		   select top 1000 * from #TempDisconnectOrders where AccountCode = '100004421'
		  */

	



----------------------------------------------------------------------
-- Step 8 - Create DimSalesOrderView_pbb   - 1 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step08');
	SET @ExecutionMsg = 'Create DimSalesOrderView_pbb ';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;



	       TRUNCATE table OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrderView_pbb_tb;

		   INSERT INTO OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrderView_pbb_tb
				SELECT *                                            --  INTO [dbo].[DimSalesOrderView_pbb_3]
				FROM
					(
					    SELECT DISTINCT 
							 InstallOrders.SalesOrderId
							,CASE WHEN   TORD.row_DailySeq  > 1 then 'No Install'

							      WHEN   TORD.OrderClosedDate = '19000101' 
								          AND NOT (ActiveItemsTodayStart=0 and ActiveItemsTodayEnd=1) 
										  AND NOT (ActiveItemsYesterdayEnd=0 and ActiveItemsTodayStart=1)            THEN 'No Install'
								  
								  WHEN   TORD.SalesOrderType = 'Install' AND  
								        (TORD.ActiveItemsYesterdayEnd+TORD.ActiveItemsTodayEnd+TORD.ActiveItemsTomorrowEnd+TORD.ActiveItemsTplus1End+TORD.ActiveItemsTplus2End
								         +TORD.ActiveItemsTplus3End+TORD.ActiveItemsTplus4End+TORD.ActiveitemsTplus5End+TORD.ActiveItemsTplus6End+
										 (case when coalesce(TORD.NextOrderDate,'99991231') > TORD.OrderClosedDate  then TORD.activeItemsAtOrderCloseEnd else 0 end )) =0   THEN 'No Install'

							      WHEN   TORD.SalesOrderType in ( 'Install','Change')  AND (TORD.ActiveItemsYesterdayEnd = 0 and TORD.ActiveItemsTodayEnd > 0  )   THEN 'Install'  

							     -- WHEN   TORD.SalesOrderType = 'Install' AND (TORD.ActiveItemsYminus1End   = 0 and TORD.PrevOrderDate is null and TORD.row_DailySeq =1 /*and TORD.OrderDate > cast(TORD.pbb_SalesOrderReviewDate as date)  */ ) THEN 'Install'
				
				                  WHEN   TORD.SalesOrderType in ( 'Install','Change') AND 
								          (  ( TORD.ActiveItemsTodayStart    = 0 and TORD.ActiveItemsTodayEnd      > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,0,TORD.OrderDate)  )
							           	  OR ( TORD.ActiveItemsTodayEnd      = 0 and TORD.ActiveItemsTomorrowEnd   > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,1,TORD.OrderDate)  )
							           	  OR ( TORD.ActiveItemsTomorrowEnd   = 0 and TORD.ActiveItemsTplus1End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,2,TORD.OrderDate)  )
							           	  OR ( TORD.ActiveItemsTplus1End     = 0 and TORD.ActiveItemsTplus2End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,3,TORD.OrderDate)  )
							           	  OR ( TORD.ActiveItemsTplus2End     = 0 and TORD.ActiveItemsTplus3End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,4,TORD.OrderDate)  )
							           	  OR ( TORD.ActiveItemsTplus3End     = 0 and TORD.ActiveItemsTplus4End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,5,TORD.OrderDate)  ) 
							           	  OR ( TORD.ActiveItemsTplus4End     = 0 and TORD.ActiveItemsTplus5End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,6,TORD.OrderDate)  ) 
							           	  OR ( TORD.ActiveItemsTplus5End     = 0 and TORD.ActiveItemsTplus6End     > 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,7,TORD.OrderDate)  ) 
								         )                                                                                                                                  THEN 'Install' 

								  WHEN   TORD.SalesOrderType = 'Install'  
										 AND (datediff(d, cast(TORD.pbb_SalesOrderReviewDate as date),TORD.OrderClosedDate) > 7
								         AND (TORD.ActiveItemsYesterdayEnd+TORD.ActiveItemsTodayEnd+TORD.ActiveItemsTomorrowEnd+TORD.ActiveItemsTplus1End+TORD.ActiveItemsTplus2End
								         +TORD.ActiveItemsTplus3End+TORD.ActiveItemsTplus4End+TORD.ActiveitemsTplus5End+TORD.ActiveItemsTplus6End)=0 
								         AND TORD.ActiveItemsAtOrderCloseEnd > 0 and coalesce(TORD.NextOrderDate,'99991231') > TORD.OrderClosedDate)                        THEN 'Install'

								  WHEN   TORD.SalesOrderType = 'Install'  AND 
								        (TORD.ActiveItemsYesterdayEnd+TORD.ActiveItemsTodayEnd+TORD.ActiveItemsTomorrowEnd+TORD.ActiveItemsTplus1End+TORD.ActiveItemsTplus2End
								         +TORD.ActiveItemsTplus3End+TORD.ActiveItemsTplus4End+TORD.ActiveitemsTplus5End+TORD.ActiveItemsTplus6End)=0  THEN 'No Install'

								  WHEN   TORD.SalesOrderType = 'Change'  AND 
								         coalesce(TORD.NextOrderDate, '99991231') > cast(TORD.pbb_SalesOrderReviewDate as date) AND
										 coalesce(TORD.PrevOrderDate, '19000101') < cast(TORD.pbb_SalesOrderReviewDate as date) AND
										 TORD.ActiveItemsYesterdayEnd =0 AND TORD.ActiveItemsTodayEnd = 1
										 THEN 'Install'

								  ELSE 'Change'
							 END AS pbb_OrderActivityType
							,TORD.DimAccountId
							,TORD.DimServiceLocationId
					    FROM #TempInstallOrders InstallOrders
					    JOIN pbbpdw01.transient.PBB_OrderInfo           TORD ON  TORD.SalesOrderNumber     = InstallOrders.SalesOrderNumber  
						                                                     AND TORD.DimServiceLocationId = InstallOrders.DimServiceLocationId
						                                                     AND TORD.SalesOrderType in ('Install','Change')
						
						UNION ALL

					    SELECT DISTINCT 
							 DisconnectOrders.SalesOrderID
							,CASE
							    WHEN   TORD.row_DailySeq  > 1 then 'No Disconnect'

							    WHEN  TORD.OrderClosedDate = '19000101' THEN 'OPEN Disconnect'

							    WHEN  TORD.ActiveItemsTodayDiscoDate <> '' and TORD.ActiveItemsTodayDiscoDate >=  cast(getdate() as date)  THEN 'FUTURE DATED' --DiscoDate
							    WHEN  TORD.ActiveItemsTodayDiscoDate <> '' and TORD.OrderClosedDate           >=  cast(getdate() as date)  THEN 'FUTURE DATED' --DiscoDate
 
								WHEN 
								    (   ( TORD.ActiveItemsYesterdayEnd  > 0 and TORD.ActiveItemsTodayEnd    = 0 )
							         OR ( TORD.ActiveItemsTodayEnd      > 0 and TORD.ActiveitemsTomorrowEnd = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,1,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTomorrowEnd   > 0 and TORD.ActiveItemsTplus1End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,2,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTplus1End     > 0 and TORD.ActiveItemsTplus2End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,3,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTplus2End     > 0 and TORD.ActiveItemsTplus3End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,4,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTplus3End     > 0 and TORD.ActiveItemsTplus4End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,5,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTplus4End     > 0 and TORD.ActiveItemsTplus5End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,6,TORD.OrderDate)  )
									 OR ( TORD.ActiveItemsTplus5End     > 0 and TORD.ActiveItemsTplus6End   = 0 and coalesce(TORD.NextOrderDate,'99991231') > dateadd(d,7,TORD.OrderDate)  )			          
									 )
								THEN 'Disconnect' 

								WHEN  TORD.ActiveItemsTodayStart         = 0 
									  and ActiveItemsYminus1End          > 0
								      and TORD.ActiveItemsYesterdayStart > 0 
								      and ActiveItemsYesterdayDiscoDate  = cast(TORD.pbb_SalesOrderReviewDate as date) 
									  and coalesce(PrevOrderDate,'19000101') < dateadd(d,-1,OrderDate)                                    then 'Disconnect'


							    WHEN  TORD.ActiveItemsTodayDiscoDate          <> '' 
								      and (TORD.ActiveItemsYesterdayDiscoDate =  '' or TORD.ActiveItemsYesterdayDiscoDate >= cast(getdate() as date) )  
									  and  TORD.ActiveItemsTodayDiscoDate     <= cast(getdate() as date)                                  THEN 'Disconnect'   --DiscoDate
 
						 	    WHEN  TORD.ActiveItemsTodayStart               =  0
								      and TORD.ActiveItemsYesterdayEnd         =  0
									  and TORD.SalesOrderDisconnectReason      <> 'Billing Correction'
								      and coalesce(TORD.ActiveItemsTodayDiscoDate,'99991231') < TORD.OrderDate
									  and coalesce(TORD.PrevSalesOrderType,'') =  'Install' 
									  and TORD.ActiveItemsTodayDiscoDate       > coalesce(TORD.PrevOrderDate,'99991231')                 THEN 'Disconnect'   --DiscoDate
 
						 	    WHEN  TORD.ActiveItemsTodayStart               =  0
								      and TORD.ActiveItemsYesterdayEnd         =  0
									  and TORD.SalesOrderDisconnectReason      = 'Billing Correction'
									  and coalesce(TORD.PrevSalesOrderType,'') = 'Disconnect'
									  and coalesce(TORD.Prev2SalesOrderType,'')= 'Install'
								      and coalesce(TORD.ActiveItemsTodayDiscoDate,'99991231') < TORD.OrderDate
								      and coalesce(TORD.ActiveItemsTodayDiscoDate,'19000101') > coalesce(TORD.Prev2OrderDate,'99991231') THEN 'Disconnect'   --DiscoDate
                      
								ELSE 'Change'

							 END AS pbb_OrderActivityType
							,DisconnectOrders.DimAccountId
							,DisconnectOrders.DimServiceLocationId
					    FROM #TempDisconnectOrders                           DisconnectOrders
						LEFT JOIN pbbpdw01.transient.PBB_OrderInfo           TORD ON TORD.SalesOrderNumber          = DisconnectOrders.SalesOrderNumber  
						                                                              AND TORD.DimServiceLocationId = DisconnectOrders.DimServiceLocationId
							                                                          AND TORD.SalesOrderType       in ('Disconnect','Change')
					) inr
		;
						-- select * from #tempdisconnectorders where AccountCode = '360009789'


----------------------------------------------------------------------
-- Step 9 - Calculate Actual Order Date 1  - 1 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step09');
	SET @ExecutionMsg = 'Calculate Actual Order Date 1';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;



		WITH OrderDateInstallAdj AS (
		   select toi.SalesOrderId, toi.DimServiceLocationId, toi.OrderDate, sov2.pbb_OrderActivityType 
				, case when (sov2.pbb_OrderActivityType = 'NO Install' or sov2.SalesOrderId is null) then OrderDate
				       when toi.OrderClosedDate  = '19000101' then OrderDate
					   when ActiveItemsTodayEnd    > 0 then OrderDate
				       when ActiveItemsTomorrowEnd > 0 then dateadd(d,1,OrderDate) 
				       when ActiveItemsTplus1End   > 0 then dateadd(d,2,OrderDate)
					   when ActiveItemsTplus2End   > 0 then dateadd(d,3,OrderDate)
					   when ActiveItemsTplus3End   > 0 then dateadd(d,4,OrderDate)
					   when ActiveitemsTplus4End   > 0 then dateadd(d,5,OrderDate)
					   when ActiveItemsTplus5End   > 0 then dateadd(d,6,OrderDate)
					   when ActiveItemsTplus6End   > 0 then dateadd(d,7,OrderDate)
					   when ActiveItemsAtOrderCloseEnd > 0 then OrderClosedDate
					   else OrderDate
				  end EventDate
			 from  pbbpdw01.transient.PBB_OrderInfo              toi 
			 left join  omnia_epbb_p_pbb_dw..DimSalesOrderView_pbb_tb sov2 on sov2.SalesOrderId=toi.SalesOrderId and sov2.DimServiceLocationId = toi.DimServiceLocationId 
		    where  toi.SalesOrderType in ('Install','Change') 
 	--		  and  toi.ActiveItemsTodayEnd =0
	  )
	  update  pbbpdw01.transient.PBB_OrderInfo    
	     set  ActualOrderDate = x.EventDate
		from  OrderDateInstallAdj x
	   where  x.SalesOrderId         = Pbb_OrderInfo.SalesOrderId
	     and  x.DimServiceLocationId = Pbb_OrderInfo.DimServiceLocationId
		 and  x.OrderDate            = Pbb_OrderInfo.OrderDate
	  ;

	  delete from pbbpdw01.transient.PBB_OrderInfo   where pbb_SalesOrderReviewDate is null;


	  
----------------------------------------------------------------------
-- Step 10 - Calculate Actual Order Date 2  - 1 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step10');
	SET @ExecutionMsg = 'Calculate Actual Order Date 2';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	  WITH OrderDateDiscoAdj AS (
		   select toi.SalesOrderId, toi.DimServiceLocationId, toi.OrderDate, toi.ActiveItemsTodayDiscoDate, sov2.pbb_OrderActivityType 

				, case when ActiveItemsTodayDiscoDate < OrderDate and cast(pbb_SalesOrderReviewDate as date) = OrderDate then OrderDate

				       when ActiveItemsTodayDiscoDate < OrderDate and ActiveItemsYesterdayStart =1 and ActiveItemsYesterdayEnd =0  and dateadd(d,-1,OrderDate) >=  cast(pbb_SalesOrderReviewDate as date) then dateadd(d,-1,OrderDate) 
				       when ActiveItemsTodayDiscoDate < OrderDate and ActiveItemsYminus1Start   =1 and ActiveItemsYminus1End   =0  and dateadd(d,-2,OrderDate) >=  cast(pbb_SalesOrderReviewDate as date) then dateadd(d,-2,OrderDate)  

				       when ActiveItemsTodayDiscoDate <= OrderDate then OrderDate

				       when ActiveItemsTomorrowEnd = 0 then dateadd(d,1,OrderDate) 
				       when ActiveItemsTplus1End   = 0 then dateadd(d,2,OrderDate)
					   when ActiveItemsTplus2End   = 0 then dateadd(d,3,OrderDate)
					   when ActiveItemsTplus3End   = 0 then dateadd(d,4,OrderDate)
					   when ActiveitemsTplus4End   = 0 then dateadd(d,5,OrderDate)
					   when ActiveItemsTplus5End   = 0 then dateadd(d,6,OrderDate)
					   when ActiveItemsTplus6End   = 0 then dateadd(d,7,OrderDate)
					   when ActiveItemsAtOrderCloseEnd = 0 then OrderClosedDate
				  end EventDate
			 from  pbbpdw01.transient.PBB_OrderInfo              toi 
			 join  omnia_epbb_p_pbb_dw..DimSalesOrderView_pbb_tb sov2 on sov2.SalesOrderId=toi.SalesOrderId and sov2.DimServiceLocationId = toi.DimServiceLocationId 
		    where  SalesOrderType in ('Disconnect') 
			  and  sov2.pbb_OrderActivityType = 'Disconnect' 
			 -- and  toi.ActiveItemsTodayEnd = 1
	  )
	  update  pbbpdw01.transient.PBB_OrderInfo    
	     set  ActualOrderDate = coalesce(x.EventDate, x.ActiveItemsTodayDiscoDate)
		from  OrderDateDiscoAdj x
	   where  x.SalesOrderId         = Pbb_OrderInfo.SalesOrderId
	     and  x.DimServiceLocationId = Pbb_OrderInfo.DimServiceLocationId
		 and  x.OrderDate            = Pbb_OrderInfo.OrderDate
		 and  not (x.EventDate is null )
	  ;
	   

	   
----------------------------------------------------------------------
-- Step 11 - Cleanup OrderActivityType - 1 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step11');
	SET @ExecutionMsg = 'Cleanup OrderActivityType';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	  update oi  
	     set pbb_OrderActivityType = coalesce(x.pbb_OrderActivityType,'Change')
		from pbbpdw01.transient.PBB_OrderInfo    oi
		left join omnia_epbb_p_pbb_dw.dbo.DimSalesOrderView_pbb_tb x on 
						 x.SalesOrderId         = oi.SalesOrderId
					 and x.DimServiceLocationId = oi.DimServiceLocationId
	  ;



----------------------------------------------------------------------
-- Step 12 - Set CourtesyInternal Flag  - 3.5 min
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step12');
	SET @ExecutionMsg = 'Set CourtesyInternal Flag';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	  update pbbpdw01.transient.PBB_OrderInfo  
	     set CourtesyInternalFlag = 'Y'
		where case when omnia_epbb_p_pbb_dw.dbo.[PBB_CheckCourtesyInternal] (DimAccountId, ActualOrderDate) =1 then 'Y' else 'N' end ='Y'  -- Correct Method
	   ;



----------------------------------------------------------------------
-- Step 13 - Set Order Date for conversion orders  - 1 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step13');
	SET @ExecutionMsg = 'Set Order Date for conversion orders';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


	  UPDATE poi
	     SET ActualOrderDate = cast(chg.SalesOrderReviewDate as date)  
	    FROM pbbpdw01.transient.PBB_OrderInfo poi
		JOIN pbbpdw01.dbo.SAVE_SalesOrderChangedOrderDate chg on chg.SalesOrderNumber = poi.SalesOrderNumber and chg.DimServiceLocationId = poi.DimServiceLocationId
	  ;

 

----------------------------------------------------------------------
-- Step 14 - Populate DimServiceOrderT1 - 4 sec
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step14');
	SET @ExecutionMsg = 'Populate DimServiceOrderT1';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;


      DROP TABLE if exists pbbpdw01.dbo.DimServiceOrderT1;

	  SELECT row_number() over(order by toi.SalesOrderNumber) DimServiceOrderKey
	       , toi.SalesOrderNumber DimServiceOrderNaturalKey, 'SalesOrderNumber' DimServiceOrderNaturalKeyFields
	       , toi.AccountCode, toi.AccountId, toi.DimAccountId, toi.DimServiceLocationId, dm.DimMarketKey, toi.AccountMarket, toi.ReportingMarket, toi.BulkMduCode, toi.CourtesyInternalFlag IsCourtesyInternal
	       , toi.SalesOrderType, toi.pbb_OrderActivityType OrderActivityType, toi.SalesOrderStatus
		   , toi.SalesOrderId, toi.SalesOrderNumber, toi.PrevSalesOrderNumber, dso.SalesOrderName, dso.SalesOrderChannel, dso.SalesOrderSegment, sc.SalesOrderClassification, dso.SalesOrderPriorityCode
		   , toi.SalesOrderDisconnectReason, dso.SalesOrderOwner
		   , toi.OrderWorkflowName, toi.ProvisioningDate, toi.pbb_SalesOrderReviewDateUTC SalesOrderReviewDateUTC, toi.pbb_SalesOrderReviewDate SalesOrderReviewDate, toi.OrderDate, toi.OrderClosedDate
		   , toi.ActualOrderDate, toi.row_Seq, toi.row_DailySeq, toi.row_DailyNextSeq, toi.PrevSalesOrderType, toi.PrevOrderDate, toi.Prev2SalesOrderType, toi.Prev2OrderDate, toi.NextSalesOrderType, toi.NextorderDate
		   , toi.ActiveItemsYminus1Start, toi.ActiveItemsYminus1End, toi.ActiveItemsYminus1DiscoDate
		   , toi.ActiveItemsYesterdayStart, toi.ActiveItemsYesterdayEnd, toi.ActiveItemsYesterdayDiscoDate
		   , toi.ActiveItemsTodayStart, toi.ActiveItemsTodayEnd, toi.ActiveItemsTodayDiscoDate
		   , toi.ActiveItemsTomorrowStart, toi.ActiveItemsTomorrowEnd, toi.ActiveItemsTomorrowDiscoDate
		   , toi.ActiveItemsTplus1Start, toi.ActiveItemsTplus1End, toi.ActiveItemsTplus1DiscoDate
		   , toi.ActiveItemsTplus2Start, toi.ActiveItemsTplus2End, toi.ActiveItemsTplus2DiscoDate
		   , toi.ActiveItemsTplus3Start, toi.ActiveItemsTplus3End, toi.ActiveItemsTplus3DiscoDate
		   , toi.ActiveItemsTplus4Start, toi.ActiveItemsTplus4End, toi.ActiveItemsTplus4DiscoDate
		   , toi.ActiveItemsTplus5Start, toi.ActiveItemsTplus5End, toi.ActiveItemsTplus5DiscoDate
		   , toi.ActiveItemsTplus6Start, toi.ActiveItemsTplus6End, toi.ActiveItemsTplus6DiscoDate
		   , toi.ActiveItemsAtOrderCloseStart, toi.ActiveItemsAtOrderCloseEnd, toi.ActiveItemsAtOrderCloseDiscoDate 
		   , getdate() MetaEffectiveStartDatetime
		   , cast('99991231' as date) MetaEffectiveEndDatetime
		   , getdate() MetaInsertDatetime
		   , 1 MetaCurrRecInd
		   , 'I' MetaOperationCode
		   , 0 MetaEtlProcessId
		   , 'Omnia' MetaSourceSystemCode
	    INTO pbbpdw01.dbo.DimServiceOrderT1
	    FROM pbbpdw01.transient.PBB_OrderInfo                              toi
		JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimSalesOrder                         dso  on dso.SalesOrderNumber        = toi.SalesOrderNumber 
		LEFT JOIN pbbpdw01..DimMarketT1                                    dm   on dm.ReportingMarketName      = toi.ReportingMarket
		LEFT JOIN omnia_epbb_p_pbb_dw.dbo.DimSalesOrder_pbb                dsop ON dso.SalesOrderId            = dsop.SalesOrderId
		LEFT join omnia_epbb_p_pbb_dw.dbo.PBB_SalesOrder_Classification    sc   on sc.SalesOrderId             = dsop.SalesOrderId
	  ;
	   
	create unique index idx_u1_DimSalesOrderDetailT1  on pbbpdw01.dbo.DimServiceOrderT1 (SalesOrderNumber, DimServiceLocationId);
	create unique index idx_u2_DimServiceOrderT1      on pbbpdw01.dbo.DimServiceOrderT1 (DimServiceOrderKey);
	create index        idx_nu1_DimSalesOrderDetailT1 on pbbpdw01.dbo.DimServiceOrderT1 (DimAccountId, DimServiceLocationId);



------------------------------------------------------------------------------------
-- Stop Logging
------------------------------------------------------------------------------------

	SET @ExecutionMsg = 'Data Load is completed sucessfully!';

    SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_CurrentTimestamp
	  ,NULL
	  ,@ExecutionMsg;

	END TRY


---------------------------------------------------------
-- Log error
---------------------------------------------------------    

BEGIN CATCH
 
        SET @ExecutionMsg = 'FAILURE: '
		                              + ' || Error Number : '  + CAST(ERROR_NUMBER() AS VARCHAR(MAX))
                                      + ' , Error Severity : ' + CAST(ERROR_SEVERITY() AS VARCHAR(MAX))
                                      + ' , Error State : '    + CAST(ERROR_STATE() AS VARCHAR(MAX))
                                      + ' , Error Line : '     + CAST(ERROR_LINE() AS VARCHAR(MAX))
                                      + ' , Error Message : '  + ERROR_MESSAGE() + '.'
        EXECUTE @RC = info.ExecutionLogError
           @LogID
		  ,@V_TargetSchema
		  ,@V_Table
		  ,NULL
          ,@ExecutionMsg 
        RETURN;
END CATCH


    end
GO
