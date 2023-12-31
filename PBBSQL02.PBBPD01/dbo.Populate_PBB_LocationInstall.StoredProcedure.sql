USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[Populate_PBB_LocationInstall]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ====================================================================  
-- Description: RPT load procedure for rpt.PBB_LocationInstall table
--
-- Input:     void
--
-- Change histrory: 
-- Name			Author		Date		Version		Description 
-- Comment      Todd        11/26/2023  01.00       Original version
--              
-- 
-- ====================================================================


CREATE PROCEDURE [dbo].[Populate_PBB_LocationInstall]
             @MonthStart date
AS
    
BEGIN

	   set nocount on


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Start Logging
-----------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @Version				  VARCHAR(10) = 'v1.00';
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
SET @V_ExecutionGroup = 'Load into RPT Table'
SET @V_TargetSchema = 'dbo'
SET @V_Table = 'PBB_LocationInstall'
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
-- Step 2 - Process new install orders
----------------------------------------------------------------------

	SET @ExecutionStep = concat(@EtlName,'|' , 'Step02');
	SET @ExecutionMsg = 'Process new install orders';

	EXECUTE @RC = info.ExecutionLogDetailProc
	        @LogParentID
	       ,@ExecutionStep
	       ,@ExecutionMsg;




		-- Declare @MonthStart date ='20230101';

		-- drop table if exists OMNIA_EPBB_P_PBB_DW.rpt.PBB_LocationInstall;

	insert   into OMNIA_EPBB_P_PBB_DW.rpt.PBB_LocationInstall
	select * 
		 , case 
				when OrderActivityType ='Install' and coalesce(LocStatus,'NewLoc') ='NewLoc' then 'New Connect'
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and coalesce(PrevSalesOrderType,'') in ('Change', 'Disconnect')  and datediff(m,PrevActualOrderDate,ActualOrderDate) =0 then 'Restart'
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and datediff(m,PrevActualOrderDate,ActualOrderDate) >0                                                     then 'Reconnect'
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and PrevLocDiscoDate <= ActualOrderDate                                                                    then 'Reconnect'
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and coalesce(PrevSalesOrderType,'') = ''                                                                   then 'Reconnect' -- new acct/existing other acct at location
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and PrevPrevOrderType='Disconnect' and PrevSalesOrderType='Install' and datediff(m,PrevPrevOrderDate,ActualOrderDate)=0 then 'Restart'
				when OrderActivityType ='Install' and LocStatus ='ExistingLoc' and PrevPrevOrderType='Disconnect' and PrevSalesOrderType='Install' and datediff(m,PrevPrevOrderDate,ActualOrderDate)>0 then 'Reconnect'
				when OrderActivityType ='Install' and AcctStatus ='NewAcct'   and LocStatus = 'ExistingLoc' and coalesce(PrevLocDiscoDate,'99991231') ='20500101' then 'Reconnect'
				else 'Reconnect'
			end LocationInstallType
	  from (
		select x.*
			 , case when CheckAcctLocStatus Like '1%'         then 'ExistingAcctLoc' else 'NewAcctLoc' end AcctLocStatus
			 , case when CheckAcctLocStatus Like '__1%'       then 'ExistingAcct'    else 'NewAcct'    end AcctStatus
			 , case when CheckAcctLocStatus Like '____1|%'    then 'ExistingLoc'     else 'NewLoc'     end LocStatus
			 , reverse(substring(reverse(CheckAcctLocStatus),1,patindex('%|%',reverse(CheckAcctLocStatus))-1)) PrevLocDiscoDate

		  from (
				select toi.[DimServiceOrderKey]
      ,toi.[DimServiceOrderNaturalKey]
      ,toi.[DimServiceOrderNaturalKeyFields]
      ,toi.[AccountCode]
      ,toi.[DimAccountId]
      ,toi.[DimServiceLocationId]
      ,toi.[DimMarketKey]
      ,toi.[AccountMarket]
      ,toi.[ReportingMarket]
      ,toi.[BulkMduCode]
      ,toi.[IsCourtesyInternal]
      ,toi.[SalesOrderType]
      ,toi.[OrderActivityType]
      ,toi.[SalesOrderStatus]
      ,toi.[SalesOrderId]
      ,toi.[SalesOrderNumber]
      ,toi.[SalesOrderName]
      ,toi.[SalesOrderChannel]
      ,toi.[SalesOrderSegment]
      ,toi.[SalesOrderClassification]
      ,toi.[SalesOrderPriorityCode]
      ,toi.[SalesOrderOwner]
      ,toi.[OrderWorkflowName]
      ,toi.[ProvisioningDate]
      ,toi.[SalesOrderReviewDateUTC]
      ,toi.[SalesOrderReviewDate]
      ,toi.[OrderDate]
      ,toi.[OrderClosedDate]
      ,toi.[ActualOrderDate]
      ,toi.[row_Seq]
      ,toi.[row_DailySeq]
      ,toi.[row_DailyNextSeq]
      ,toi.[PrevSalesOrderType]
      ,toi.[PrevOrderDate]
      ,toi.[Prev2SalesOrderType]
      ,toi.[Prev2OrderDate]
      ,toi.[NextSalesOrderType]
      ,toi.[NextorderDate]
      ,toi.[ActiveItemsYminus1Start]
      ,toi.[ActiveItemsYminus1End]
      ,toi.[ActiveItemsYminus1DiscoDate]
      ,toi.[ActiveItemsYesterdayStart]
      ,toi.[ActiveItemsYesterdayEnd]
      ,toi.[ActiveItemsYesterdayDiscoDate]
      ,toi.[ActiveItemsTodayStart]
      ,toi.[ActiveItemsTodayEnd]
      ,toi.[ActiveItemsTodayDiscoDate]
      ,toi.[ActiveItemsTomorrowStart]
      ,toi.[ActiveItemsTomorrowEnd]
      ,toi.[ActiveItemsTomorrowDiscoDate]
      ,toi.[ActiveItemsTplus1Start]
      ,toi.[ActiveItemsTplus1End]
      ,toi.[ActiveItemsTplus1DiscoDate]
      ,toi.[ActiveItemsTplus2Start]
      ,toi.[ActiveItemsTplus2End]
      ,toi.[ActiveItemsTplus2DiscoDate]
      ,toi.[ActiveItemsTplus3Start]
      ,toi.[ActiveItemsTplus3End]
      ,toi.[ActiveItemsTplus3DiscoDate]
      ,toi.[ActiveItemsTplus4Start]
      ,toi.[ActiveItemsTplus4End]
      ,toi.[ActiveItemsTplus4DiscoDate]
      ,toi.[ActiveItemsTplus5Start]
      ,toi.[ActiveItemsTplus5End]
      ,toi.[ActiveItemsTplus5DiscoDate]
      ,toi.[ActiveItemsTplus6Start]
      ,toi.[ActiveItemsTplus6End]
      ,toi.[ActiveItemsTplus6DiscoDate]
      ,toi.[ActiveItemsAtOrderCloseStart]
      ,toi.[ActiveItemsAtOrderCloseEnd]
      ,toi.[ActiveItemsAtOrderCloseDiscoDate]
      ,toi.[MetaEffectiveStartDatetime]
      ,toi.[MetaEffectiveEndDatetime]
      ,toi.[MetaInsertDatetime]
      ,toi.[MetaCurrRecInd]
      ,toi.[MetaOperationCode]
      ,toi.[MetaEtlProcessId]
      ,toi.[MetaSourceSystemCode]
				     , toip.ActualOrderDate PrevActualOrderDate, toip.PrevOrderDate PrevPrevOrderDate, toip.PrevSalesOrderType PrevPrevOrderType    
					 , OMNIA_EPBB_P_PBB_DW.dbo.[PBB_CheckInstallAcctLoc](toi.DimAccountId, toi.DimServiceLocationid, toi.ActualOrderDate) CheckAcctLocStatus 
				  from         pbbpdw01.dbo.DimServiceOrderT1 toi 
				  left join    pbbpdw01.dbo.DimServiceOrderT1 toip on  toip.DimAccountId         = toi.DimAccountId 
																	and toip.DimServiceLocationId = toi.DimServiceLocationId 
																	and toip.row_seq+1            = toi.row_seq
				  left join OMNIA_EPBB_P_PBB_DW.rpt.PBB_LocationInstall targ on targ.SalesOrderId = toi.SalesOrderId
				  where 1=1
					and toi.SalesOrderType in ('Install','Change')
					and toi.OrderActivityType = 'Install'
					and toi.ActualOrderDate >= @MonthStart 
					and toi.SalesOrderStatus     <>  'Canceled'  
					and toi.IsCourtesyInternal   =  'N'
					and coalesce(toi.BulkMduCode,'') <> 'Bulk'   
					and targ.SalesOrderId is null  -- tb 2023/11/25


			   ) x
	) y

	 order by AccountCode, ActualorderDate
	;




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
