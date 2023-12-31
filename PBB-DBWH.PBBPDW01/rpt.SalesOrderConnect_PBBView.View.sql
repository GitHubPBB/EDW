USE [PBBPDW01]
GO
/****** Object:  View [rpt].[SalesOrderConnect_PBBView]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [rpt].[SalesOrderConnect_PBBView] as (

  -- RES INSTALL
  select concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES') SalesOrderId
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES') SalesOrderNumber
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-RES','-',replace(pbb_ExternalMarketName,' ','') ) SalesOrderName
       , 'CSR'            SalesOrderChannel
       , 'RES'            SalesOrderSegment
       , NULL             SalesOrderProvisioningDate
       , NULL             SalesOrderCommitmentDate
       , cast(pbb_DimDateId as date) OrderReviewDate
       , NULL             CompletionDate
       , NULL             AccountActivationDate
       , NULL             AccountDeactivationDate
       , 'Install'        SalesOrderType
       , 'Install'        OrderActivityType
       , 'New Connect'    SalesOrderClassification
       , 'Fulfilled'         SalesOrderStatus
       , 'Complete'            SalesOrderStatusReason
       , 'Billing Review' SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , ''               SalesOrderOwner
       , '000000000'      AccountCode
       , 'S'              AccountClassCode
       , 'Subscriber'     AccountClass
       , upper(concat('EXT','RES'))             AccountGroupCode
       , upper(concat('EXT',' ','Residential')) AccountGroup
       , 'Residential'    AccountType
       , 0.00             SalesOrderTotalMRC
       , 0.00             SalesOrderTotalNRC
       , 0.00             SalesOrderTotalTax
       , 0.00             SalesOrderTotalAmount
       , pbb_ExternalMarketName AccountMarket
       , pbb_ExternalMarketAccountGroupMarket ReportingMarket
       , NULL             MarketSummary
       , NULL             BundleType
       , 0                Tenure
       , NULL             PaidInvoicesLast6Months
       , NULL             PartialInvoicesLast6Months
       , NULL             NonPayCountLast6Months
       , 0                LocationId
       ,  cast(0.00 as varchar(11))            Latitude
       ,  cast(0.00 as varchar(11))            Longitude
       , case when x.pbb_DimExternalMarketId in (42,55,53) then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48) then 'OH'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
       , pbb_DailyStatisticsResidentialAdds                AccountCount     
   --     , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where cast(pbb_dimdateid as date)=dateadd(d,-1,cast(getdate() as date))
  UNION 
   select concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS') SalesOrderId
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS') SalesOrderNumber
       , concat('EXT-',x.pbb_DimExternalMarketId,'-',cast(pbb_DimDateId as date),'-BUS','-',replace(pbb_ExternalMarketName,' ','') ) SalesOrderName
       , 'CSR'            SalesOrderChannel
       , 'BUS'            SalesOrderSegment
       , NULL             SalesOrderProvisioningDate
       , NULL             SalesOrderCommitmentDate
       , cast(pbb_DimDateId as date) OrderReviewDate
       , NULL             CompletionDate
       , NULL             AccountActivationDate
       , NULL             AccountDeactivationDate
       , 'Install'        SalesOrderType
       , 'Install'        OrderActivityType
       , 'New Connect'    SalesOrderClassification
       , 'Fulfilled'         SalesOrderStatus
       , 'Complete'            SalesOrderStatusReason
       , 'Billing Review' SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , ''               SalesOrderOwner
       , '000000000'      AccountCode
       , 'S'              AccountClassCode
       , 'Commercial'     AccountClass
       , upper(concat('EXT','RES'))             AccountGroupCode
       , upper(concat('EXT',' ','Residential')) AccountGroup
       , 'Commercial'    AccountType
       , 0.00             SalesOrderTotalMRC
       , 0.00             SalesOrderTotalNRC
       , 0.00             SalesOrderTotalTax
       , 0.00             SalesOrderTotalAmount
       , pbb_ExternalMarketName AccountMarket
       , pbb_ExternalMarketAccountGroupMarket ReportingMarket
       , NULL             MarketSummary
       , NULL             BundleType
       , 0                Tenure
       , NULL             PaidInvoicesLast6Months
       , NULL             PartialInvoicesLast6Months
       , NULL             NonPayCountLast6Months
       , 0                LocationId
       , cast(0.00 as varchar(11))               Latitude
       , cast(0.00 as varchar(11))                Longitude
       , case when x.pbb_DimExternalMarketId in (42,55,53) then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48) then 'OH'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
       , pbb_DailyStatisticsCommercialAdds                AccountCount     
  --      , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where cast(pbb_dimdateid as date)=dateadd(d,-1,cast(getdate() as date))
  
  union 
 select *   from rpt.PBB_ServiceOrderConnects
   
   )
GO
