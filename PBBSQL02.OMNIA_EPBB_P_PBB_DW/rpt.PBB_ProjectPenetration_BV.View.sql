USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_ProjectPenetration_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE   VIEW [rpt].[PBB_ProjectPenetration_BV] as
   SELECT   AccountMarketName              [Mkt-AccountMarket]
     , ReportingMarketName            [Mkt-ReportingMarket]
	 , AccountMarketSortKey           [Mkt-Sort]
	 , ProjectCode                    [Addr-ProjectCode]
	 , ProjectName                    [Addr-ProjectName]
	 , CalcProjectName                [Addr-CalcProjectName]
	 , AddressType                    [Addr-ProjectType]
	 , ProjectServiceableDate         [Addr-ProjectServiceableDate]
	 , CompetitiveType                [Addr-ProjectCompetitiveType]
	 , DimProjectNaturalKey           [Addr-ProjectId]
	 , AsOfDate                       [Proj-AsOfDate]
	 , ProjectAgeMonths               [Proj-ProjectAge]
	 , AccountType					[Proj-AccountType]
	 , CompetitiveAddressCount        [Proj-CompetitiveAddresses]
	 , UnderservedAddressCount        [Proj-UnderServedAddresses]
	 , ServiceableAddressCount        [Proj-TotalServiceableAddresses]

	 , ActiveCompetitiveCustomerCount [Proj-CompetitiveSubscribers]
	 , ActiveUnderservedCustomerCount [Proj-UnderServedSubscribers]
	 , ActiveCompetitiveCustomerCount+ActiveUnderservedCustomerCount [Proj-TotalActiveCustomers]

	 , CurrentMonthBilledAvgMRC       [Proj-CurrentMonthlyAvgMRC]

	 , TotalPenetration               [Proj-TotalPenetrationPct]
	 , CompetitivePenetration         [Proj-CompetitivePenetrationPct]
	 , UnderservedPenetration         [Proj-UnderServedPenetrationPct]
	 , ConnectCount					  [Proj-ConnectCount]
	 , DisconnectCount				  [Proj-DisconnectCount]
	 , GetToGreenCustomerCount		  [Proj-GetToGreenCustomerCount]

	 , GrowthGoalTotalColor           [Rpt-GrowthGoalTotalColor]
	 , GrowthGoalCompetitiveColor     [Rpt-GrowthGoalCompetitiveColor]
	 , GrowthGoalUnderServedColor     [Rpt-GrowthGoalUnderServedColor]
	 , GrowthRampGoalRedPct            [Rpt-GrowthRampGoalRedPct]
	 , GrowthRampGoalGreenPct          [Rpt-GrowthRampGoalGreenPct]
	
  from [OMNIA_EPBB_P_PBB_DW].rpt.PBB_ProjectPenetration
  WHERE ProjectName like 'EXT-%' or ProjectName like '%Project%'
GO
