USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[RPT_ProjectConnectsTrend]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  


CREATE FUNCTION [dbo].[RPT_ProjectConnectsTrend]()
RETURNS @Results TABLE(
				   AccountMarket        nvarchar(25)
				  ,ReportingMarket      nvarchar(25)
				  ,ProjectNaturalKey	nvarchar(20)
				  ,ProjectCode          nvarchar(75) 
				  ,ProjectServiceableDate date
				  ,AgeMonth				smallint
				  ,InstallCount 		smallint
				  ) 
AS


BEGIN

			-- Fiber ??
			WITH ProjInstallAge AS (
			SELECT distinct dp.DimProjectNaturalKey ProjectNaturalKey, dp.ProjectCode, dm.AccountMarketName, dm.ReportingMarketName
			                 , csl.chr_MasterLocationId LocationId
				             , dp.ProjectServiceableDate, to1.OrderDate
							 , case when dateadd(m,1,dp.ProjectServiceableDate) > to1.OrderDate then 1
							        when datepart(day,dp.ProjectServiceableDate) > datepart(day,to1.OrderDate) 
							        then datediff(m,dp.ProjectServiceableDate,to1.OrderDate) 
									else datediff(m,dp.ProjectServiceableDate,to1.OrderDate) +1
									end    AgeMonth
							 , to1.SalesOrderNumber, to1.AccountCode, [OMNIA_EPBB_P_PBB_DW].dbo.[PBB_IsFiberAccount](to1.DimAccountId, to1.DimServiceLocationId, to1.OrderDate) IsFiber
							FROM Transient.chr_servicelocation                   csl  
							JOIN [PBBPDW01].dbo.DimProject                       dp   on dp.ProjectCode = csl.cus_ProjectCode   COLLATE DATABASE_DEFAULT
							JOIN [PBBPDW01].dbo.DimMarket                        dm   on dm.DimMarketId = dp.DimMarketId
							JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation    dsl  on dsl.locationid = csl.chr_masterlocationid
							JOIN pbbpdw01.transient.TempOrders                   to1  on to1.DimServiceLocationId = dsl.DimServiceLocationId   
							JOIN omnia_epbb_p_pbb_dw..DimSalesOrderView_pbb_tb   sov  on sov.DimAccountId = to1.DimAccountId 
                                                                                      and sov.DimServiceLocationId = to1.DimServiceLocationId
														                      	      and sov.SalesOrderId = to1.SalesorderId
																					  and sov.pbb_OrderActivityType = 'Install'
						   WHERE chr_ServiceLocationId is not null 
							 AND dp.ProjectServiceableDate <> '99991231' 
							 AND dp.ProjectServiceableDate > '20201231'
            )
			,Months AS (
				Select 1 as MonthAge union
				Select 2 as MonthAge union
				Select 3 as MonthAge union
				Select 4 as MonthAge union
				Select 5 as MonthAge union
				Select 6 as MonthAge union
				Select 7 as MonthAge union
				Select 8 as MonthAge union
				Select 9 as MonthAge union
				Select 10 as MonthAge union
				Select 11 as MonthAge union
				Select 12 as MonthAge union
				Select 13 as MonthAge union
				Select 14 as MonthAge union
				Select 15 as MonthAge union
				Select 16 as MonthAge union
				Select 17 as MonthAge union
				Select 18 as MonthAge union
				Select 19 as MonthAge union
				Select 20 as MonthAge union
				Select 21 as MonthAge union
				Select 22 as MonthAge union
				Select 23 as MonthAge union
				Select 24 as MonthAge  
			)
			, ProjectList AS (
				select dp.DimProjectNaturalKey ProjectNaturalKey, dp.ProjectCode, dm.AccountMarketName, dm.ReportingMarketName, dp.ProjectServiceableDate, MonthAge
			      FROM  [PBBPDW01].dbo.DimProject                       dp   
				  JOIN [PBBPDW01].dbo.DimMarket                         dm   on dm.DimMarketId = dp.DimMarketId
				  JOIN Months                                                on 1=1
				 WHERE dp.ProjectServiceableDate <> '99991231' 
				  AND dp.ProjectServiceableDate  > '20201231'
			)
		--	select * from ProjectList order by 1,MonthAge
			INSERT INTO @Results
			SELECT AccountMarketName, ReportingMarketName, ProjectNaturalKey, ProjectCode, ProjectServiceableDate, MonthAge, case when AgeMonth=0 then 0 else InstallCount end InstallCount
			  FROM (
			SELECT pl.AccountMarketName, pl.ReportingMarketName, pl.ProjectNaturalKey
			     , pl.ProjectCode, pl.ProjectServiceableDate, pl.MonthAge, coalesce(AgeMonth,0) AgeMonth, count(*) InstallCount
			 
			  FROM ProjectList pl
			  left join ProjInstallAge pia on pia.ProjectNaturalKey = pl.ProjectNaturalKey and pia.AgeMonth = pl.MonthAge and IsFiber = 1
			 WHERE 1=1   AND MonthAge < 25
			 GROUP BY pl.AccountMarketName, pl.ReportingMarketName, pl.ProjectNaturalKey, pl.ProjectCode, pl.ProjectServiceableDate, pl.MonthAge, coalesce(AgeMonth,0)  
			) x
			 ORDER BY AccountMarketName, ReportingMarketName, ProjectCode, MonthAge

			  


	    RETURN
	END
GO
