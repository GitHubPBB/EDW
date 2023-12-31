USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_AccountLocation_Services_Aggregation]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
select top(1000) * from dbo.PBB_AccountLocation_Services_Aggregation('10/1/2021', char(13) + char(10)) -- should put each service on a new line in SSRS report
select top(1000) * from dbo.PBB_AccountLocation_Services_Aggregation('10/1/2021',', ') order by DimAccountId
*/

CREATE FUNCTION [dbo].[PBB_AccountLocation_Services_Aggregation](
			@AsOfDate  date
		    ,@Delimiter nvarchar(10) = ', ') -- apparently, optional parameters in table functions DON'T WORK
RETURNS TABLE
AS
	RETURN
		  (
			 select [DimAccountId]
				  ,[DimServiceLocationId]
				  ,String_Agg(convert(nvarchar(max),ComponentName),@Delimiter) within group(order by sortvalue) as [Services]
			 from
				 (
					select fci.[DimAccountId]
						 ,fci.[DimServiceLocationId]
						 ,case
							 when pcm.IsDataSvc = 1
							 then 1
							 when pcm.IsCableSvc = 1
							 then 2
							 when(pcm.IsLocalPhn = 1
								 or pcm.IsComplexPhn = 1)
							 then 3
						  end as sortvalue
						 ,ci.ComponentName + case
											when count(ci.DimCatalogItemId) = 1
											then '' else ' (x' + convert(varchar(10),count(ci.DimCatalogItemId)) + ')'
										 end as [ComponentName]
					from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
						inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCustomerItem] dci on dci.DimCustomerItemId = fci.DimCustomerItemId
						inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci on ci.DimCatalogItemId = fci.DimCatalogItemId
						inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] pcm on pcm.ComponentCode = ci.ComponentCode
					where DimAccountID != 0
						 and (fci.EffectiveStartDate <= @AsOfDate
							 and fci.EffectiveEndDate > @AsOfDate)
						 and (dci.ItemActivationDate <= @AsOfDate
							 and (dci.ItemDeactivationDate > @AsOfDate
								 or dci.ItemDeactivationDate is null))
						 and (pcm.IsCableSvc = 1
							 or pcm.IsDataSvc = 1
							 or pcm.IsLocalPhn = 1
							 or pcm.IsComplexPhn = 1)
					group by fci.DimAccountId
						   ,fci.DimServiceLocationId
						   ,ci.ComponentName
						   ,case
							   when pcm.IsDataSvc = 1
							   then 1
							   when pcm.IsCableSvc = 1
							   then 2
							   when(pcm.IsLocalPhn = 1
								   or pcm.IsComplexPhn = 1)
							   then 3
						    end
				 ) d
			 group by [DimAccountId]
				    ,[DimServiceLocationId]
		  )
GO
