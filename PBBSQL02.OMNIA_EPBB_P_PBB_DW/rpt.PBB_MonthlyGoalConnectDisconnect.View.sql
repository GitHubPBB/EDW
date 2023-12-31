USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_MonthlyGoalConnectDisconnect]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

CREATE   VIEW  [rpt].[PBB_MonthlyGoalConnectDisconnect] AS (

SELECT   Goal.[AccountMarket]
		,Goal.[AccountMarketSortKey]
		,Goal.MonthlyGoalBeginningDate
		,Goal.TargetConnect
		,Conn.ActualConnect
		,Goal.TargetDisconnect
		,Disc.ActualDisconnect
FROM ( SELECT DISTINCT AccountMarketName AS [AccountMarket]
			,AccountMarketSortKey AS [AccountMarketSortKey]
			,pbb_MonthlyGoalBeginningDate_DimDateID AS MonthlyGoalBeginningDate
			,pbb_MonthlyGoalTargetAdd AS TargetConnect
			,pbb_MonthlyGoalTargetDisconnect AS TargetDisconnect
		FROM [PBBPDW01].[dbo].DimMarketT1 dm
		JOIN OMNIA_EPBB_P_PBB_DW.dbo.DimMonthlyGoals_pbb G ON dm.AccountMarketName = G.pbb_MarketSummary ) Goal
   LEFT JOIN ( SELECT CAST(DATEADD(m, DATEDIFF(m, 0, [Order-ReviewDate]), 0) AS DATE) AS [Order-ReviewDate]
				,[Mkt-AccountMarket]
				,SUM([Acct-Count]) AS [ActualDisconnect]
			FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_SalesOrderDisconnect_BV]
			GROUP BY CAST(DATEADD(m, DATEDIFF(m, 0, [Order-ReviewDate]), 0) AS DATE)
				,[Mkt-AccountMarket] ) Disc ON Disc.[Order-ReviewDate] = Goal.MonthlyGoalBeginningDate
													AND Disc.[Mkt-AccountMarket] = Goal.[AccountMarket]
   LEFT JOIN ( SELECT CAST(DATEADD(m, DATEDIFF(m, 0, [Order-ReviewDate]), 0) AS DATE) AS [Order-ReviewDate]
				,[Mkt-AccountMarket]
				,SUM([Acct-Count]) AS ActualConnect
			FROM [OMNIA_EPBB_P_PBB_DW].[rpt].PBB_SalesOrderConnect_BV
			GROUP BY CAST(DATEADD(m, DATEDIFF(m, 0, [Order-ReviewDate]), 0) AS DATE)
				,[Mkt-AccountMarket] ) Conn  ON Conn.[Order-ReviewDate] = Goal.MonthlyGoalBeginningDate
													AND Conn.[Mkt-AccountMarket] = Goal.[AccountMarket] 
	)
GO
