USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_AverageInstallMRC_OLD]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[PBB_AverageInstallMRC_OLD](
			 @reportDate as date = '2/1/2022'
									)
AS
    begin

	   select @reportDate = convert(date,convert(varchar(2),datepart(month,@reportDate)) + '/1/' + convert(varchar(4),datepart(year,@reportDate)))

	   declare @sql varchar(max) = ''

	   set nocount on

	   select AsOfDate
		    ,[AcctMarket]
		    ,AccountType
		    ,Market
		    ,[Order Type]
		    ,Count([SalesOrderNumber]) as [Number of Accounts]
		    ,Avg([MRC]) as [Average MRC]
	   into #AvgInstallMRC
	   from
		   (
			  select substring(convert(varchar(30),dateadd(day,-1,@reportdate),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.BundleType,'Other') as [Order Type]
				   ,[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](@ReportDate) d
				  left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
														  and fcb.DimServiceLocationId = d.dimservicelocationid
			  where SalesOrderType = 'Install'
				   and (@ReportDate >= fcb.EffectiveStartDate
					   and @ReportDate < fcb.EffectiveEndDate)
				   or fcb.EffectiveStartDate is null
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@ReportDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.BundleType,'Other') as [Order Type]
				   ,[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-1,@ReportDate)) d
				  left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
														  and fcb.DimServiceLocationId = d.dimservicelocationid
			  where SalesOrderType = 'Install'
				   and (dateadd(month,-1,@ReportDate) >= fcb.EffectiveStartDate
					   and dateadd(month,-1,@ReportDate) < fcb.EffectiveEndDate)
				   or fcb.EffectiveStartDate is null
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@ReportDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.BundleType,'Other') as [Order Type]
				   ,[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-2,@ReportDate)) d
				  left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
														  and fcb.DimServiceLocationId = d.dimservicelocationid
			  where SalesOrderType = 'Install'
				   and (dateadd(month,-2,@ReportDate) >= fcb.EffectiveStartDate
					   and dateadd(month,-2,@ReportDate) < fcb.EffectiveEndDate)
				   or fcb.EffectiveStartDate is null
		   ) d
	   group by [AsOfDate]
			 ,[AcctMarket]
			 ,AccountType
			 ,Market
			 ,[Order Type];

	   --select substring(convert(varchar(30),dateadd(day,-1,@reportdate),23),1,7) as [AsOfDate]
	   --  ,[AccountType]
	   --  ,[pbb_AccountMarket] as [Market]
	   --  ,fcb.BundleType as [Order Type]
	   --  ,[SalesOrderNumber]
	   --  ,[SalesOrderTotalMRC] as [MRC]
	   --from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](@ReportDate) d
	   -- left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
	   --									  and fcb.DimServiceLocationId = d.dimservicelocationid
	   --where SalesOrderType = 'Install'
	   --  and (@ReportDate >= fcb.EffectiveStartDate
	   --   and @ReportDate < fcb.EffectiveEndDate)
	   --  or fcb.EffectiveStartDate is null
	   --union
	   --select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@ReportDate)),23),1,7) as [AsOfDate]
	   --  ,[AccountType]
	   --  ,[pbb_AccountMarket] as [Market]
	   --  ,fcb.BundleType as [Order Type]
	   --  ,[SalesOrderNumber]
	   --  ,[SalesOrderTotalMRC] as [MRC]
	   --from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-1,@ReportDate)) d
	   -- left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
	   --									  and fcb.DimServiceLocationId = d.dimservicelocationid
	   --where SalesOrderType = 'Install'
	   --  and (dateadd(month,-1,@ReportDate) >= fcb.EffectiveStartDate
	   --   and dateadd(month,-1,@ReportDate) < fcb.EffectiveEndDate)
	   --  or fcb.EffectiveStartDate is null
	   --union
	   --select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@ReportDate)),23),1,7) as [AsOfDate]
	   --  ,[AccountType]
	   --  ,[pbb_AccountMarket] as [Market]
	   --  ,fcb.BundleType as [Order Type]
	   --  ,[SalesOrderNumber]
	   --  ,[SalesOrderTotalMRC] as [MRC]
	   --from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-2,@ReportDate)) d
	   -- left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
	   --									  and fcb.DimServiceLocationId = d.dimservicelocationid
	   --where SalesOrderType = 'Install'
	   --  and (dateadd(month,-2,@ReportDate) >= fcb.EffectiveStartDate
	   --   and dateadd(month,-2,@ReportDate) < fcb.EffectiveEndDate)
	   --  or fcb.EffectiveStartDate is null

	   select *
		    ,[Average MRC] * [Number of Accounts] as [Total MRC]
	   from #AvgInstallMRC
	   select substring(convert(varchar(30),dateadd(day,-1,@reportdate),23),1,7) as [AsOfDate]
		    ,[AccountType]
		    ,[pbb_AccountMarket] as [Market]
		    ,fcb.BundleType as [Order Type]
		    ,[SalesOrderNumber]
		    ,[SalesOrderTotalMRC] as [MRC]
	   from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](@ReportDate) d
		   left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
												   and fcb.DimServiceLocationId = d.dimservicelocationid
	   where SalesOrderType = 'Install'
		    and (@ReportDate >= fcb.EffectiveStartDate
			    and @ReportDate < fcb.EffectiveEndDate)
		    or fcb.EffectiveStartDate is null
	   union
	   select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@ReportDate)),23),1,7) as [AsOfDate]
		    ,[AccountType]
		    ,[pbb_AccountMarket] as [Market]
		    ,fcb.BundleType as [Order Type]
		    ,[SalesOrderNumber]
		    ,[SalesOrderTotalMRC] as [MRC]
	   from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-1,@ReportDate)) d
		   left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
												   and fcb.DimServiceLocationId = d.dimservicelocationid
	   where SalesOrderType = 'Install'
		    and (dateadd(month,-1,@ReportDate) >= fcb.EffectiveStartDate
			    and dateadd(month,-1,@ReportDate) < fcb.EffectiveEndDate)
		    or fcb.EffectiveStartDate is null
	   union
	   select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@ReportDate)),23),1,7) as [AsOfDate]
		    ,[AccountType]
		    ,[pbb_AccountMarket] as [Market]
		    ,fcb.BundleType as [Order Type]
		    ,[SalesOrderNumber]
		    ,[SalesOrderTotalMRC] as [MRC]
	   from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_DB_MONTHLY_DETAIL](dateadd(month,-2,@ReportDate)) d
		   left join [dbo].FactCustomerBundleType_pbb fcb on fcb.DimAccountId = d.dimaccountid
												   and fcb.DimServiceLocationId = d.dimservicelocationid
	   where SalesOrderType = 'Install'
		    and (dateadd(month,-2,@ReportDate) >= fcb.EffectiveStartDate
			    and dateadd(month,-2,@ReportDate) < fcb.EffectiveEndDate)
		    or fcb.EffectiveStartDate is null

	   drop table #AvgInstallMRC
    end
GO
