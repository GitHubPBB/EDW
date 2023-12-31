USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_SalesOrderConnect]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











create view [rpt].[PBB_SalesOrderConnect] as (

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
	   , NULL             AccountDiscountNames
       , 0.00             SalesOrderTotalMRC
       , 0.00             SalesOrderTotalNRC
       , 0.00             SalesOrderTotalTax
       , 0.00             SalesOrderTotalAmount
       , pbb_ExternalMarketAccountGroupMarket AccountMarket
       , pbb_ExternalMarketName ReportingMarket
       , NULL             MarketSummary
       , 'Unknown'        BundleType
	   , NULL             SmartHome
       , 0                Tenure
       , NULL             PaidInvoicesLast6Months
       , NULL             PartialInvoicesLast6Months
       , NULL             NonPayCountLast6Months
	   , NULL             Speed
	   , NULL             ProjectCode
	   , NULL             ProjectServiceableDate
	   , NULL             Cabinet
       , 0                LocationId
       , cast(0.00 as varchar(11))            Latitude
       , cast(0.00 as varchar(11))            Longitude
       , case when x.pbb_DimExternalMarketId in (42,55,53)    then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48)      then 'OH'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             DistributionCenter
	   , NULL             OrderWorkflowName

	   , NULL             AccountName
	   , NULL             PrintGroup
	   , NULL             RecurringPaymentMethod
	   , NULL             PortalUserExists
	   , NULL             DimAccountId 

	   , NULL			LocationProjectCode
	   , NULL			ProjectName
	   , 'Unknown'			CalcProjectName

       , pbb_DailyStatisticsResidentialAdds                AccountCount     
   --     , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where pbb_DailyStatisticsResidentialAdds <> 0
    and cast(x.pbb_DimDateId as date) < '20221003' 

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
       , upper(concat('EXT','BUS'))             AccountGroupCode
       , upper(concat('EXT',' ','Business')) AccountGroup
       , 'Commercial'    AccountType
	   , NULL             AccountDiscountNames
       , 0.00             SalesOrderTotalMRC
       , 0.00             SalesOrderTotalNRC
       , 0.00             SalesOrderTotalTax
       , 0.00             SalesOrderTotalAmount
       , pbb_ExternalMarketAccountGroupMarket AccountMarket
       , pbb_ExternalMarketName ReportingMarket
       , NULL             MarketSummary
       , 'Unknown'        BundleType
	   , NULL             SmartHome
       , 0                Tenure
       , NULL             PaidInvoicesLast6Months
       , NULL             PartialInvoicesLast6Months
       , NULL             NonPayCountLast6Months
	   , NULL             Speed
	   , NULL             ProjectCode
	   , NULL             ProjectServiceableDate
	   , NULL             Cabinet
       , 0                LocationId
       , cast(0.00 as varchar(11))                Latitude
       , cast(0.00 as varchar(11))                Longitude
       , case when x.pbb_DimExternalMarketId in (42,55,53) then 'AL'
              when x.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when x.pbb_DimExternalMarketId in (47, 48) then 'OH'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             DistributionCenter
	   , NULL             OrderWorkflowName	   
	   
	   , NULL             AccountName
	   , NULL             PrintGroup
	   , NULL             RecurringPaymentMethod
	   , NULL             PortalUserExists
	   , NULL             DimAccountId 

	   , NULL			LocationProjectCode
	   , NULL			ProjectName
	   , 'Unknown'			CalcProjectName

       , pbb_DailyStatisticsCommercialAdds                AccountCount     
  --      , *
  from dbo.FactExternalDailyStatistics_pbb x
  join dbo.DimExternalMarket_pbb           y on x.pbb_DimExternalMarketId = y.pbb_DimExternalMarketId 
  where pbb_DailyStatisticsCommercialAdds <> 0
    and cast(x.pbb_DimDateId as date) < '20221003'

UNION

  select concat('EXT-',OrderNo)			SalesOrderId
       , OrderNo            SalesOrderNumber
       , concat('EXT-',OrderNo,'-',AccountName ) SalesOrderName
       , 'CSR'            SalesOrderChannel
       , case when AccountType ='Residential' then 'RES' else 'BUS' end  SalesOrderSegment
       , NULL             SalesOrderProvisioningDate
       , NULL             SalesOrderCommitmentDate
       , cast(OrderDate as date)           OrderReviewDate
       , cast(OrderDate as date)           CompletionDate
       , cast(x.AccountActivationDate as date)                AccountActivationDate
       , NULL             AccountDeactivationDate
       , 'Install'        SalesOrderType
       , 'Install'        OrderActivityType
       , 'New Connect'    SalesOrderClassification
       , 'Fulfilled'         SalesOrderStatus
       , 'Complete'            SalesOrderStatusReason
       , 'Billing Review' SalesOrderFulfillmentStatus
       , 'Default Value'  SalesOrderPriorityCode
       , ''               SalesOrderOwner
       , cast(AccountCode as nvarchar(20))     AccountCode
       , 'S'              AccountClassCode
       , 'Subscriber'     AccountClass       , upper(concat(case when y.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
						  when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
						  when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
						  when y.pbb_DimExternalMarketId in (41)          then 'NY'
              end   
	                 ,case when x.AccountType='Residential' then 'RES' else 'BUS' end))             AccountGroupCode

       , upper(concat(case when y.pbb_DimExternalMarketId in (50,42,55,53) then 'AL'
					  when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
					  when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
					  when y.pbb_DimExternalMarketId in (41)          then 'NY'
					  end   
	                 ,' ',AccountType)) AccountGroup
	   , upper(x.AccountType)     AccountType
	   , NULL             AccountDiscountNames
       , cast(x.GrossMRC as money) SalesOrderTotalMRC
       , 0.00             SalesOrderTotalNRC
       , 0.00             SalesOrderTotalTax
       , 0.00             SalesOrderTotalAmount       
	   , case when pbb_AccountMarket = 'NY'      then 'New York' 
	          else pbb_AccountMarket   end AccountMarket
       , case when pbb_ReportingMarket = 'NY'    then 'New York' 
	          else pbb_ReportingMarket end ReportingMarket
       , NULL             MarketSummary
       , x.BundleType                    BundleType
	   , NULL             SmartHome
       , 0                Tenure
       , cast(x.PaidInvoicesLast6Months as int)              PaidInvoicesLast6Months
       , cast(x.PartialPaidInvoicesLast6Months as int)       PartialInvoicesLast6Months
       , cast(x.NonPayCountLast6Months as int)               NonPayCountLast6Months
	   , x.Speed                         Speed
	   , NULL             ProjectCode
	   , NULL             ProjectServiceableDate
	   , NULL             Cabinet
       , 0                LocationId
       , coalesce(x.Latitude,'00.0000000')      Latitude
       , coalesce(x.Longitude,'00.0000000')      Longitude
       , case when y.pbb_DimExternalMarketId in (42,55,53)    then 'AL'
              when y.pbb_DimExternalMarketId in (44,45,56,57) then 'MI'
              when y.pbb_DimExternalMarketId in (47, 48)      then 'OH'
			  when y.pbb_DimExternalMarketId in (41)          then 'NY'
              end         ServiceLocationStateAbbrev
       , NULL             ServiceLocationCity
       , NULL             ServiceLocationZip
       , NULL             ServiceLocationFullAddress
	   , NULL             DistributionCenter
	   , NULL             OrderWorkflowName
	   
	   , x.AccountName             AccountName
	   , NULL             PrintGroup
	   , x.RecurringPaymentMethod        RecurringPaymentMethod
	   , x.PortalUserExists              PortalUserExists
	   , NULL             DimAccountId 

	   , NULL			LocationProjectCode
	   , 'Unknown'        ProjectName
	   , 'Unknown'        CalcProjectName

       , 1                AccountCount     
   --     , *
  from [OMNIA_EPBB_P_PBB_DW].dbo.PBB_ExternalMarket_InstallsAndDisconnects  x
  join dbo.DimExternalMarket_pbb           y on case when x.pbb_AccountMarket='NY' then 'New York' else x.pbb_AccountMarket end = y.pbb_ExternalMarketAccountGroupMarket 
 WHERE  upper(x.OrderType) = 'INSTALL'
   AND x.OrderDate > '20221002'
  
UNION 
 select *   from rpt.PBB_ServiceOrderConnects
   
   )
GO
