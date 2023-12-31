USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SF_MONTHLY]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from [dbo].[PBB_DB_SF_MONTHLY]('10/09/2022')
*/

CREATE FUNCTION [dbo].[PBB_DB_SF_MONTHLY](
			@ReportDate date)
RETURNS TABLE
AS
	RETURN(
	WITH COL_NAMES
		AS (SELECT distinct 
				 pbb_MarketSummary
				,SUBSTRING(pbb_AccountMarket,4,255) AS AccountMarket
				,max(SUBSTRING(pbb_AccountMarket,1,2)) AS SortOrder
		    FROM DimAccountCategory_pbb
		    WHERE pbb_AccountMarket NOT LIKE ''
		    group by pbb_MarketSummary
				  ,SUBSTRING(pbb_AccountMarket,4,255)
		    UNION
		    SELECT pbb_ExternalMarketAccountGroupMarketSummary
				,pbb_ExternalMarketAccountGroupMarket AS AccountMarket
				,pbb_ExternalMarketSort AS SortOrder
		    FROM DimExternalMarket_pbb
		    WHERE pbb_ExternalMarketAccountGroupMarket NOT LIKE ''),
		Data
		AS (
		--Internal Install 
		Select 'I' as source
			 ,Count(SalesOrderId) As 'InstallCount'
			 ,'' as 'InstallReconnectCount'
			 ,'' As 'DisconnectCount'
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(SalesOrderId) Else 0
			  End As 'InstallVATNCount'
			 ,'' as 'InstallVATNReconnectCount'
			 ,'' As 'DisconnectVATNCount'
			 ,pbb_AccountMarket
			 ,Count(D.pbb_MarketSummary) As 'VATN'
			 ,D.pbb_MarketSummary As 'VATNGroup'
			 ,SalesOrderType
			 ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd As PBB_MonthlyGoalTargetAdd
			 ,'' As pbb_MonthlyGoalTargetDisconnect
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then(DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd) Else 0
			  End As Goal_Install_VATN
			 ,'' As Goal_Disconnect_VATN
			 ,'' As pbb_DimMonthlyGoalsId
		from PBB_DB_MONTHLY_DETAIL_V2(@ReportDate) D
			inner join DimDate on DimDate.DimDateID = case
												 when datepart(weekday,@ReportDate) = 2
												 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											  end --FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimMonthlyGoals_pbb ON DimDate.Month = DATEPART(Month,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And DimDate.Year = DATEPART(YEAR,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And SUBSTRING(D.pbb_AccountMarket,4,255) = DimMonthlyGoals_pbb.pbb_MarketSummary
		Where SalesOrderType = 'Install'
			 And pbb_OrderActivityType = 'Install'
		--And (case
		--	when datepart(weekday,@ReportDate) = 2
		--	then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
		-- end >= DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID
		-- and case
		--	    when datepart(weekday,@ReportDate) = 2
		--	    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
		--	end <= DimMonthlyGoals_pbb.pbb_MonthlyGoalEndDate_DimDateID)
		Group By pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,D.pbb_MarketSummary
			   ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd
		Union
		Select 'I' as source
			 ,'' as 'InstallCount'
			 ,Count(SalesOrderId) As 'InstallReconnectCount'
			 ,'' As 'DisconnectCount'
			 ,'' as 'InstallVATNCount'
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(SalesOrderId) Else 0
			  End As 'InstallVATNReconnectCount'
			 ,'' As 'DisconnectVATNCount'
			 ,pbb_AccountMarket
			 ,Count(D.pbb_MarketSummary) As 'VATN'
			 ,D.pbb_MarketSummary As 'VATNGroup'
			 ,SalesOrderType
			 ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd As PBB_MonthlyGoalTargetAdd
			 ,'' As pbb_MonthlyGoalTargetDisconnect
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then(DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd) Else 0
			  End As Goal_Install_VATN
			 ,'' As Goal_Disconnect_VATN
			 ,'' As pbb_DimMonthlyGoalsId
		from PBB_DB_MONTHLY_DETAIL_V2(@ReportDate) D
			inner join DimDate on DimDate.DimDateID = case
												 when datepart(weekday,@ReportDate) = 2
												 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											  end --FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimMonthlyGoals_pbb ON DimDate.Month = DATEPART(Month,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And DimDate.Year = DATEPART(YEAR,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And SUBSTRING(D.pbb_AccountMarket,4,255) = DimMonthlyGoals_pbb.pbb_MarketSummary
		Where SalesOrderType = 'Install'
			 And pbb_OrderActivityType = 'Install'
			 and SalesOrderClassification in
									  (
									   'Reconnect'
									  ,'New Connect'
									  )
		Group By pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,D.pbb_MarketSummary
			   ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd
		Union

		--Internal Disconnect
		Select 'I' as source
			 ,'' As 'InstallCount'
			 ,'' as 'InstallReconnectCount'
			 ,Count(SalesOrderId) As 'DisconnectCount'
			 ,'' As 'InstallVATNCount'
			 ,'' as 'InstallVATNReconnectCount'
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then Count(SalesOrderId) Else 0
			  End As 'DisconnectVATNCount'
			 ,pbb_AccountMarket
			 ,Count(D.pbb_MarketSummary) As 'VATN'
			 ,D.pbb_MarketSummary As 'VATNGroup'
			 ,SalesOrderType
			 ,'' As PBB_MonthlyGoalTargetAdd
			 ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetDisconnect As pbb_MonthlyGoalTargetDisconnect
			 ,'' As Goal_Install_VATN
			 ,Case
				 When D.pbb_MarketSummary = '01-Total VA/TN'
				 Then(DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetDisconnect) Else 0
			  End As Goal_Disconnect_VATN
			 ,'' As pbb_DimMonthlyGoalsId
		from PBB_DB_MONTHLY_DETAIL(@ReportDate) D
			inner join DimDate on DimDate.DimDateID = case
												 when datepart(weekday,@ReportDate) = 2
												 then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											  end --FactSalesOrder.CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimMonthlyGoals_pbb ON DimDate.Month = DATEPART(Month,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And DimDate.Year = DATEPART(YEAR,DimMonthlyGoals_pbb.pbb_MonthlyGoalBeginningDate_DimDateID)
									   And pbb_AccountMarket = DimMonthlyGoals_pbb.pbb_MarketSummary
		Where SalesOrderType = 'Disconnect'
			 And pbb_OrderActivityType = 'Disconnect'
		Group By pbb_AccountMarket
			   ,SalesOrderType
			   ,AccountType
			   ,D.pbb_MarketSummary
			   ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetDisconnect
		Union ALL

		--External Markets  
		Select 'E' as source
			 ,Install
			 ,'' as 'InstallReconnectCount'
			 ,Disconnect
			 ,InstallResVATNCount
			 ,'' as 'InstallVATNReconnectCount'
			 ,InstallBusVATNCount
			 ,pbb_AccountMarket
			 ,'' As 'VATN'
			 ,VATNGroup
			 ,'' As 'SalesOrderType'
			 ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetAdd As PBB_MonthlyGoalTargetAdd
			 ,DimMonthlyGoals_pbb.pbb_MonthlyGoalTargetDisconnect As pbb_MonthlyGoalTargetDisconnect
			 ,'' As Goal_Install_VATN
			 ,'' As Goal_Disconnect_VATN
			 ,D.pbb_DimMonthlyGoalsId
		from PBB_DB_MONTHLY_DETAIL_EXTERNALMARKET(@ReportDate) D
			LEFT JOIN DimDate on CreatedOn_DimDateId = DimDate.DimDateID
			LEFT JOIN DimMonthlyGoals_pbb ON D.pbb_DimMonthlyGoalsId = DimMonthlyGoals_pbb.pbb_DimMonthlyGoalsId)
		select s.pbb_MarketSummary
			 ,s.AccountMarket
			 ,s.SortOrder
			 ,s.InstallCount
			 ,s.InstallReconnectCount
			 ,s.DisconnectCount
			 ,s.InstallVATNCount
			 ,s.InstallVATNReconnectCount
			 ,s.DisconnectVATNCount
			 ,s.pbb_AccountMarket
			 ,s.VATN
			 ,g.pbb_MonthlyGoalTargetAdd
			 ,g.pbb_MonthlyGoalTargetDisconnect
		from
			(
			    SELECT cn.pbb_MarketSummary
					,cn.AccountMarket
					,cn.SortOrder
					,Sum(IsNull(data.InstallCount,0)) As 'InstallCount'
					,sum(Isnull(data.InstallReconnectCount,0)) as 'InstallReconnectCount'
					,Sum(IsNull(data.DisconnectCount,0)) As 'DisconnectCount'
					,Sum(IsNull(data.InstallVATNCount,0)) As 'InstallVATNCount'
					,sum(Isnull(data.InstallVATNReconnectCount,0)) as 'InstallVATNReconnectCount'
					,Sum(IsNull(data.DisconnectVATNCount,0)) As 'DisconnectVATNCount'
					,IsNull(data.pbb_AccountMarket,0) AS 'pbb_AccountMarket'
					,Sum(IsNull(data.VATN,0)) As 'VATN'
			    FROM COL_Names as cn
				    full outer join Data on cn.AccountMarket = data.pbb_AccountMarket
			    Group By cn.pbb_MarketSummary
					  ,cn.AccountMarket
					  ,cn.SortOrder
					  ,data.pbb_AccountMarket
			) s
			inner join DimMonthlyGoals_pbb g on g.pbb_MarketSummary = s.AccountMarket
										 and case
											    when datepart(weekday,@ReportDate) = 2
											    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											end >= g.pbb_MonthlyGoalBeginningDate_DimDateID
										 and case
											    when datepart(weekday,@ReportDate) = 2
											    then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
											end <= g.pbb_MonthlyGoalEndDate_DimDateID)
GO
