USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_AverageDisconnectNETMRC]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[PBB_AverageDisconnectNETMRC](
			  @reportDate as date = '9/1/2022'
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
		    ,isnull([Order Type],'None') as [Order Type]
		    ,Speed
		    ,Project
		    ,Count([SalesOrderNumber]) as [Number of Accounts]
		    ,Avg([MRC]) as [Average MRC]
	   into #AvgInstallMRC
	   from
		   (
			  select substring(convert(varchar(30),dateadd(day,-1,@reportdate),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.PBB_BundleType,'Other') as [Order Type]
				   ,Speed
				   ,Project
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [dbo].[PBB_AVGDISCONNECTNETMRC](@ReportDate) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@ReportDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.PBB_BundleType,'Other') as [Order Type]
				   ,Speed
				   ,Project
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-1,@ReportDate)) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@ReportDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.PBB_BundleType,'Other') as [Order Type]
				   ,Speed
				   ,Project
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
			  from [dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-2,@ReportDate)) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
			  -- union all the external markets
			  --union all
			  --select convert(varchar(4),datepart(year,[InstallMonth])) + '-' + right('0' + convert(varchar(3),datepart(month,[InstallMonth])),2) as [AsOfDate]
				 --  ,[pbb_AccountMarket] as [AcctMarket]
				 --  ,[AccountType]
				 --  ,[pbb_AccountMarket] as [Market]
				 --  ,[BundleType] as [Order Type]
				 --  ,[Speed]
				 --  ,'Legacy' 
				 --  ,[AccountCode] as [SalesOrderNumber]
				 --  ,[GrossMRC] as [MRC]
			  --from [OMNIA_EPBB_P_PBB_DW].[dbo].[AvgMRCByMarket_ExternalData]
			  --where [InstallMonth] >= dateadd(month,-2,@ReportDate)
				 --  and [InstallMonth] <= @ReportDate
		   ) d
	   group by [AsOfDate]
			 ,[AcctMarket]
			 ,AccountType
			 ,Market
			 ,[Order Type]
			 ,Speed
			 ,Project

	   select @reportDate as [ReportDate]
		    ,*
		    ,[Average MRC] * [Number of Accounts] as [Total MRC]
	   from #AvgInstallMRC
	   --select *
	   --from
		  -- (
			 -- select substring(convert(varchar(30),dateadd(day,-1,@reportdate),23),1,7) as [AsOfDate]
				--   ,[AccountType]
				--   ,[pbb_AccountMarket] as [Market]
				--   ,fcb.PBB_BundleType as [Order Type]
				--   ,Speed
				--   ,Project
				--   ,d.[SalesOrderNumber]
				--   ,[SalesOrderTotalMRC] as [MRC]
			 -- from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](@ReportDate) d
				--  left join [dbo].PBB_SalesOrderBundleType_UseForInstallsOnly fcb on fcb.DimAccountId = d.dimaccountid
				--													    and fcb.DimServiceLocationId = d.dimservicelocationid
			 -- where SalesOrderType = 'Install'
			 -- union
			 -- select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@ReportDate)),23),1,7) as [AsOfDate]
				--   ,[AccountType]
				--   ,[pbb_AccountMarket] as [Market]
				--   ,fcb.PBB_BundleType as [Order Type]
				--   ,Speed
				--   ,Project
				--   ,d.[SalesOrderNumber]
				--   ,[SalesOrderTotalMRC] as [MRC]
			 -- from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-1,@ReportDate)) d
				--  left join [dbo].PBB_SalesOrderBundleType_UseForInstallsOnly fcb on fcb.DimAccountId = d.dimaccountid
				--													    and fcb.DimServiceLocationId = d.dimservicelocationid
			 -- where SalesOrderType = 'Install'
			 -- union
			 -- select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@ReportDate)),23),1,7) as [AsOfDate]
				--   ,[AccountType]
				--   ,[pbb_AccountMarket] as [Market]
				--   ,fcb.PBB_BundleType as [Order Type]
				--   ,Speed
				--   ,Project
				--   ,d.[SalesOrderNumber]
				--   ,[SalesOrderTotalMRC] as [MRC]
			 -- from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-2,@ReportDate)) d
				--  left join [dbo].PBB_SalesOrderBundleType_UseForInstallsOnly fcb on fcb.DimAccountId = d.dimaccountid
				--													    and fcb.DimServiceLocationId = d.dimservicelocationid
			 -- where SalesOrderType = 'Install'
			 -- union all
			 -- select convert(varchar(4),datepart(year,[InstallMonth])) + '-' + right('0' + convert(varchar(3),datepart(month,[InstallMonth])),2) as [AsOfDate]
				--   ,[AccountType]
				--   ,[pbb_AccountMarket] as [Market]
				--   ,[BundleType] as [Order Type]
				--   ,Speed
				--   ,'Legacy'
				--   ,[AccountCode] as [SalesOrderNumber]
				--   ,[GrossMRC] as [MRC]
			 -- from [OMNIA_EPBB_P_PBB_DW].[dbo].[AvgMRCByMarket_ExternalData]
			 -- where [InstallMonth] >= dateadd(month,-2,@ReportDate)
		  -- ) d
	   --order by AsOfDate desc
			 --,Market
			 --,AccountType
			 --,[Order Type]
			 --,Speed
			 --,Project

	   drop table #AvgInstallMRC
    end
GO
