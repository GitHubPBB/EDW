USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_SalesOrder_Classification_View]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--USE [OMNIA_EPBB_P_PBB_DW]
--GO

--/****** Object:  View [dbo].[PBB_SalesOrder_Classification_View_TESTING_JH]    Script Date: 12/29/2022 8:27:01 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE view [dbo].[PBB_SalesOrder_Classification_View] as
with AllInstalls
	as (select distinct 
			 fso.SalesOrderId
			,so.SalesOrderNumber
			,so.SalesOrderName
			,sl.ServiceLocationFullAddress
			,sl.DimServiceLocationId
			,sl.LocationId
			,a.AccountId
			,fso.CreatedOn_DimDateId CreatedOn
			,fso.DimAccountId
			,cast(sopbb.pbb_SalesOrderReviewDate as date) as [Order Review Date]
			,cast(EffectiveDate as date) as EffectiveDate
	    from [OMNIA_EPBB_P_PBB_DW].[dbo].FactSalesOrder fso
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccountCategory ac on ac.DimAccountCategoryId = fso.DimAccountCategoryId
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrder so on fso.DimSalesOrderId = so.DimSalesOrderId
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrder_pbb sopbb on sopbb.SalesOrderId = so.SalesOrderId
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrderView_pbb sovpbb on sovpbb.SalesOrderId = so.SalesOrderId
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a on a.DimAccountId = fso.DimAccountId
		    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb on apbb.AccountId = a.AccountId
		    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl on sl.DimServiceLocationid = sovpbb.DimServiceLocationId
		    left join
		    (
			   select distinct 
					salesorderid
				    ,chr_billingdate EffectiveDate
			   from pbbsql01.pbb_p_mscrm.dbo.salesorder
		    ) Eff on fso.SalesOrderId = Eff.SalesOrderId
	    where so.SalesOrderType = N'Install'
			and so.SalesOrderStatus <> N'Canceled'
			and so.OrderWorkflowName <> N'Billing Correction'
			and sovpbb.pbb_OrderActivityType = N'Install'
			and apbb.pbb_AccountDiscountNames not like N'%INTERNAL USE ONLY - Zero Rate Test Acct%'
			and apbb.pbb_AccountDiscountNames not like N'%Courtesy%'
			--and sl.locationid = 260058
	    --and so.SalesOrderNumber in ('ORD-24012-X1R4L9','ORD-57141-D9B0G8')
	    ),
	locclassify
	as (select *
			,case
				when DimAccountID = 0
					and rownumber = 1
				then 'No Account Exists'
				when rownumber = 2
				then 'New Install'
				when rownumber > 2
				then 'New Connect'
			 end as SalesOrderClassification
	    from
		    (
			   select distinct 
					DimServiceLocationId
				    ,LocationID
				    ,DimFMAddressId
				    ,DimAccountID
				    ,CRMAccountID
				    ,AccountStatus
				    ,case when accountstatus not in ('P','Prospect') 
							then cast(LocationAccountActivationDate as date)
							else cast(getdate() as date)
									end 
									as LocationAccountActivationDate
				    ,cast(LocationAccountDeactivationDate as date) as LocationAccountDeactivationDate
				    ,Row_Number() over(Partition by DimServiceLocationId
					order by case when accountstatus not in ('P','Prospect') 
							then cast(LocationAccountActivationDate as date)
							else cast(getdate() as date)
									end) as rownumber
			   from [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_ServiceLocationAccountALL
			   where (accountstatus not in
								    (
									'P'
								    ,'Prospect'
								    )
				    or pbb_ServiceLocationAccountStatus = 'Pending Install Order')
				  --and locationid = 550054
				    
		    --and locationid = 
		    --1150431  Reconnect, New Connect Differenct Accounts, Same Location
		    --790073 Reconnect, New Connect Differenct Accounts, Same Location
		    --200185 New Install, New Connect Same Location
		    --2100060 New Install, incorrectly classified as reconnect
		    ) Typ),
	ConnectDetails
	as (select AllInstalls.SalesOrderId
			,AllInstalls.SalesOrderNumber
			,AllInstalls.SalesOrderName
			,AllInstalls.ServiceLocationFullAddress
			,AllInstalls.DimServiceLocationId
			,AllInstalls.LocationId
			,AllInstalls.AccountId
			,AllInstalls.CreatedOn
			,AllInstalls.DimAccountId
			,AllInstalls.[Order Review Date]
			,AllInstalls.EffectiveDate
			 --,locclassify.DimServiceLocationId
			 -- ,locclassify.LocationID
			,locclassify.DimFMAddressId
			 --,locclassify.DimAccountID
			,locclassify.CRMAccountID
			,locclassify.AccountStatus
			,locclassify.LocationAccountActivationDate
			,locclassify.LocationAccountDeactivationDate
			,locclassify.rownumber
			,case
				when LocationAccountActivationDate < CreatedOn
					and AccountStatus <> 'Prospect'
					and EffectiveDate <> LocationAccountActivationDate
				then 'Reconnect' else locclassify.SalesOrderClassification
			 end as SalesOrderClassification
	    from AllInstalls
		    inner join locclassify on AllInstalls.LocationID = locclassify.LocationID
						    and AllInstalls.AccountId = locclassify.CRMAccountID)
	select *
	from connectdetails --where LocationClassify = 'Reconnect'
		--select * from PBB_ServiceLocationAccountALL where locationid = 1150431
		--select * from 
		--FactSalesOrder fso
		--join DimSalesOrder dso on fso.DimSalesOrderId = dso.DimSalesOrderId
		--join DimSalesOrder_pbb dsop on dsop.SalesOrderId = dso.SalesOrderId
		--where SalesOrderNumber = 'ORD-57252-Q0F1K3'
		--select CreatedOn_DimDateId, BillingEffectiveDate_DimDateId, * 
		--from 
		--FactSalesOrder fso
		--join DimSalesOrder dso on fso.DimSalesOrderId = dso.DimSalesOrderId
		--join DimSalesOrder_pbb dsop on dsop.SalesOrderId = dso.SalesOrderId
		--left join (select distinct DimSalesOrderID, BillingEffectiveDate_DimDateId from FactSalesOrderlineitem) Eff on fso.DimSalesOrderId = Eff.DimSalesOrderId
		--where SalesOrderStatus  in ('Fulfilled','Canceled')
		--and CreatedOn_DimDateId <> BillingEffectiveDate_DimDateId
		--and SalesOrderType = 'Install'
		--and SalesOrderNumber = 'ORD-57252-Q0F1K3'
		--select CreatedOn_DimDateId, BillingEffectiveDate_DimDateId, * from 
		--FactSalesOrder fso
		--join DimSalesOrder dso on fso.DimSalesOrderId = dso.DimSalesOrderId
		--join DimSalesOrder_pbb dsop on dsop.SalesOrderId = dso.SalesOrderId
		--left join (select distinct DimSalesOrderID, BillingEffectiveDate_DimDateId from FactSalesOrderlineitem) Eff on fso.DimSalesOrderId = Eff.DimSalesOrderId
		--where SalesOrderStatus  in ('Fulfilled','Canceled')
		--and CreatedOn_DimDateId <> BillingEffectiveDate_DimDateId
		--and SalesOrderType = 'Install'
--GO


GO
