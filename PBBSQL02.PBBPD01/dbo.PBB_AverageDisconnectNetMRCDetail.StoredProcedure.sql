USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_AverageDisconnectNetMRCDetail]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
[dbo].[PBB_AverageInstallNetMRCDetail] '2022-07', 'Central AL','Business','Opelika', 'Double Play-Internet/Phone','200/200'
[dbo].[PBB_AverageInstallNetMRCDetail] '7/1/2022', 'Central AL','Business','Opelika', 'Double Play-Internet/Phone'

*/

CREATE procedure [dbo].[PBB_AverageDisconnectNetMRCDetail](
			 @reportDate as    nvarchar(20)  = '2022-08'
			,@AccountMarket as nvarchar(255) = N'ALL'
			,@AccountType as   nvarchar(255) = N'ALL'
			,@Market as        nvarchar(255) = N'ALL'
			,@OrderType as     nvarchar(255) = N'ALL'
			,@Speed as         nvarchar(255) = N'ALL'
			,@Project as       nvarchar(255) = N'ALL'
											  )
AS
    begin

	   select @reportDate = rtrim(@reportDate) + '-01'
	   --return
	   declare @reportDateDate as date= dateadd(month,1,cast(@reportDate as Date))

	   select @reportDateDate = convert(date,convert(varchar(2),datepart(month,@reportDateDate)) + '/1/' + convert(varchar(4),datepart(year,@reportDateDate)))

	   set nocount on

	   if @Speed is null
		  BEGIN
			 set @Speed = N'ALL'
		  END

	   select *
	   from
		   (
			  select substring(convert(varchar(30),dateadd(day,-1,@reportDateDate),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.pbb_BundleType,'Other') as [Order Type]
				   ,[Speed]
				   ,[Project]
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
				   ,d.AccountCode
				   ,d.SalesOrderName
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](@reportDateDate) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-1,@reportDateDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.PBB_BundleType,'Other') as [Order Type]
				   ,[Speed]
				   ,[Project]
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
				   ,d.AccountCode
				   ,d.SalesOrderName
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-1,@reportDateDate)) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
			  union
			  select substring(convert(varchar(30),dateadd(day,-1,dateadd(month,-2,@reportDateDate)),23),1,7) as [AsOfDate]
				   ,[pbb_AccountMarket] as [AcctMarket]
				   ,[AccountType]
				   ,[pbb_ReportingMarket] as [Market]
				   ,isnull(fcb.PBB_BundleType,'Other') as [Order Type]
				   ,[Speed]
				   ,[Project]
				   ,d.[SalesOrderNumber]
				   ,[SalesOrderTotalMRC] as [MRC]
				   ,d.AccountCode
				   ,d.SalesOrderName
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_AVGDISCONNECTNETMRC](dateadd(month,-2,@reportDateDate)) d
				  left join [dbo].[DimServiceLocationBundleType_pbb] fcb on fcb.DimAccountId = d.dimaccountid
																and fcb.DimServiceLocationID = d.dimservicelocationid
																and fcb.AsOfDimDateID = d.CreatedOn_DimDateId
			  where SalesOrderType = 'Disconnect'
	   --union all
	   --select convert(varchar(4),datepart(year,[InstallMonth])) + '-' + right('0' + convert(varchar(3),datepart(month,[InstallMonth])),2) as [AsOfDate]
	   --  ,[pbb_AccountMarket] as [AcctMarket]
	   --  ,[AccountType]
	   --  ,[pbb_AccountMarket] as [Market]
	   --  ,[BundleType] as [Order Type]
	   --  ,Speed
	   --  ,[AccountCode] as [SalesOrderNumber]
	   --  ,[GrossMRC] as [MRC]
	   --  ,[AccountCode]
	   --  ,'NA' as SalesOrderName
	   --from [OMNIA_EPBB_P_PBB_DW].[dbo].[AvgMRCByMarket_ExternalData]
	   --where [InstallMonth] >= dateadd(month,-2,@reportDateDate) and [InstallMonth] <= @reportDateDate
		   ) det
	   where AsOfDate = substring(convert(varchar(30),dateadd(day,-1,@reportDateDate),23),1,7)
		    and AcctMarket = case
							when @AccountMarket = N'ALL'
							then AcctMarket else @AccountMarket
						 end
		    and AccountType = case
							 when @AccountType = N'ALL'
							 then AccountType else @AccountType
						  end
		    and Market = case
						 when @Market = N'ALL'
						 then Market else @Market
					  end
		    and [Order Type] = case
							  when @OrderType = N'ALL'
							  then [Order Type] else @OrderType
						   end
		    and isnull([Speed],'') = case
								   when @Speed = N'ALL'
								   then isnull([Speed],'') else @Speed
							    end
		    and [Project] = case
						    when @Project = N'ALL'
						    then [Project] else @Project
						end
    end
GO
