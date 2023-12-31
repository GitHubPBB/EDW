USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_SalesOrder_Classification_View_20230103_BEFORE_UPDATE]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[PBB_SalesOrder_Classification_View_20230103_BEFORE_UPDATE]
as
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
		    from [OMNIA_EPBB_P_PBB_DW].[dbo].FactSalesOrder fso
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccountCategory ac on ac.DimAccountCategoryId = fso.DimAccountCategoryId
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrder so on fso.DimSalesOrderId = so.DimSalesOrderId
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrder_pbb sopbb on sopbb.SalesOrderId = so.SalesOrderId
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimSalesOrderView_pbb sovpbb on sovpbb.SalesOrderId = so.SalesOrderId
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a on a.DimAccountId = fso.DimAccountId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb on apbb.AccountId = a.AccountId
			    left join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl on sl.DimServiceLocationid = sovpbb.DimServiceLocationId
		    where so.SalesOrderType = N'Install'
				and so.SalesOrderStatus <> N'Canceled'
				and so.OrderWorkflowName <> N'Billing Correction'
				and sovpbb.pbb_OrderActivityType = N'Install'
				and apbb.pbb_AccountDiscountNames not like N'%INTERNAL USE ONLY - Zero Rate Test Acct%'
				and apbb.pbb_AccountDiscountNames not like N'%Courtesy%'),
		ConnectDetails
		as (select AllInstalls.*
				,SLA.DimServiceLocationID SLADimServiceLocationID
				,SLA.DimAccountID SLADimAccountID
				,LocationAccountActivationDate
				,LocationAccountDeactivationDate
				,Row_Number() over(Partition by SalesOrderNumber
										 ,SLA.DimServiceLocationId
				 order by LocationAccountActivationDate Desc) as rownumber
		    from AllInstalls
			    join [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_ServiceLocationAccountALL SLA on AllInstalls.DimServiceLocationId = SLA.DimServiceLocationId
																	    and SLA.LocationAccountActivationDate <= CreatedOn)
		select *
			 ,case
				 when rownumber = 1
					 and SLADimAccountID = 0
				 then 'New Install'
				 when DimAccountID in(select SLADimAccountID
								  from connectdetails
								  where connectdetails.SalesOrderId = salesorderID)
				 then 'Reconnect'
				 when DimAccountID not in(select SLADimAccountID
									 from connectdetails
									 where connectdetails.SalesOrderId = salesorderID)
				 then 'New Connect' else 'Other'
			  end as SalesOrderClassification
		from connectdetails
		where rownumber = 1


GO
