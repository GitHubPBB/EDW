USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_InstallTypeBySalesOrder]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from PBB_ServiceLocationItem where locationid = 1511269
--select top 100 * from PBB_ServiceLocationAccountALL where dimservicelocationid = 1181108
--select * from PBB_ServiceLocationAccountMinRank where locationid = 1511269;
--AllLocations
--as (select *
--    from PBB_ServiceLocationAccountALL),
--select * from PBB_ServiceLocationAccountALL
--select * from PBB_ServiceLocationItem
--select * from dbo.PBB_InstallTypeBySalesOrder

CREATE VIEW [dbo].[PBB_InstallTypeBySalesOrder]
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
				,fso.DimAccountId
				,cast(sopbb.pbb_SalesOrderReviewDate as date) as [Order Review Date]
				,lag(sl.DimServiceLocationID) over(partition by fso.DimAccountId
				 order by cast(sopbb.pbb_SalesOrderReviewDate as date) desc) as LastLocationThisAccount
				,lag(fso.DimAccountId) over(partition by sl.DimServiceLocationId
				 order by cast(sopbb.pbb_SalesOrderReviewDate as date) desc) as LastAccountThisLocation
		    from FactSalesOrder fso
			    left join DimAccountCategory ac on ac.DimAccountCategoryId = fso.DimAccountCategoryId
			    --left join DimAccountCategory_pbb acpbb on acpbb.SourceId = ac.SourceId
			    left join DimSalesOrder so on fso.DimSalesOrderId = so.DimSalesOrderId
			    left join DimSalesOrder_pbb sopbb on sopbb.SalesOrderId = so.SalesOrderId
			    left join DimSalesOrderView_pbb sovpbb on sovpbb.SalesOrderId = so.SalesOrderId
			    left join DimAccount a on a.DimAccountId = fso.DimAccountId
			    inner join DimAccount_pbb apbb on apbb.AccountId = a.AccountId
			    left join DimServiceLocation sl on sl.DimServiceLocationid = sovpbb.DimServiceLocationId
		    where so.SalesOrderType = N'Install'
				and so.SalesOrderStatus <> N'Canceled'
				and so.OrderWorkflowName <> N'Billing Correction'
				and sovpbb.pbb_OrderActivityType = N'Install'
				and apbb.pbb_AccountDiscountNames not like N'%INTERNAL USE ONLY - Zero Rate Test Acct%'
				and apbb.pbb_AccountDiscountNames not like N'%Courtesy%'),
		AllActiveServiceItems
		as (select *
		    from PBB_ServiceLocationItem
		    where IsNRC_Scheduling = 0
				and IsIgnored = 0
				and ItemStatus = 'A'
				and AccountStatus in
								(
								 'N'
								,'A'
								))
		-- NOT NEW INSTALLS
		-- in this query, we're only interested in orders which can be completely resolved within the order history since conversion 
		-- so we won't look at New Installs here
		select AllInstalls.SalesOrderId
			 ,AllInstalls.SalesOrderNumber
			 ,AllInstalls.SalesOrderName
			 ,AllInstalls.ServiceLocationFullAddress
			 ,AllInstalls.DimServiceLocationId
			 ,AllInstalls.LocationId
			 ,AllInstalls.AccountId
			 ,AllInstalls.DimAccountId
			 ,AllInstalls.[Order Review Date]
			 ,case
				 when LastLocationThisAccount is null
					 and LastAccountThisLocation is null
				 then 'New Install'
				 when LastLocationThisAccount = DimServiceLocationID
					 and LastAccountThisLocation = DimAccountId
				 then 'Reconnect'
				 when LastLocationThisAccount is null
					 and LastAccountThisLocation != DimAccountID
				 then 'New Connect'
				 when LastLocationThisAccount is not null
					 and LastAccountThisLocation is null
				 then 'New Install (Existing Account)' -- this is a location which has never had an account installed to an account which HAS had a previous install
				 else 'Restart'
			  end as InstallType
		from AllInstalls
		where case
				when LastLocationThisAccount is null
					and LastAccountThisLocation is null
				then 'New Install'
				when LastLocationThisAccount = DimServiceLocationID
					and LastAccountThisLocation = DimAccountId
				then 'Reconnect'
				when LastLocationThisAccount is null
					and LastAccountThisLocation != DimAccountID
				then 'New Connect'
				when LastLocationThisAccount is not null
					and LastAccountThisLocation is null
				then 'New Install (Existing Account)' -- this is a location which has never had an account installed to an account which HAS had a previous install
			     else 'Restart'
			 end not in
					 (
					  'New Install'
					 ,'New Install (Existing Account)'
					 )
		-- NEW INSTALLS
		-- Here, we're going to take what the above query thought were new installs and see if we can match them up with any active service items from prior to conversion
		union
		select distinct 
			  SalesOrderId
			 ,SalesOrderNumber
			 ,SalesOrderName
			 ,ServiceLocationFullAddress
			 ,DimServiceLocationId
			 ,LocationId
			 ,AccountId
			 ,DimAccountId
			 ,[Order Review Date]
			 ,case
				 when JoinLocationID is NULL
				 then 'New Install'
				 when JoinLocationID is NOT NULL
					 and Historic_LastLocationThisAccount = LocationId
				 then 'Reconnect'
				 when JoinLocationID is NOT NULL
					 and Historic_LastAccountThisLocation != AccountID
				 then 'New Install (Existing Account)' 
				 else 'New Install'
			  end as [InstallType]
		--,LI
		--,rownumber
		from
			(
			    select ai.*
					,lag(sli.LocationID) over(partition by sli.CRMAccountId
					 order by cast(sli.ItemDeactivationDate as date) desc) as Historic_LastLocationThisAccount
					,lag(sli.CRMAccountId) over(partition by sli.LocationId
					 order by cast(sli.ItemDeactivationDate as date) desc) as Historic_LastAccountThisLocation
					,sli.LocationID as JoinLocationID
					,Row_Number() over(Partition by sli.LocationID
					 order by sli.ItemActivationDate Desc) as rownumber
					,case
						when LastLocationThisAccount is null
							and LastAccountThisLocation is null
						then 'New Install'
						when LastLocationThisAccount = DimServiceLocationID
							and LastAccountThisLocation = DimAccountId
						then 'Reconnect'
						when LastLocationThisAccount is null
							and LastAccountThisLocation != DimAccountID
						then 'New Connect'
						when LastLocationThisAccount is not null
							and LastAccountThisLocation is null
						then 'New Install (Existing Account)' -- this is a location which has never had an account installed to an account which HAS had a previous install
						else 'Restart'
					 end as InstallType
			    from AllInstalls ai
				    left join AllActiveServiceItems sli on sli.LocationId = ai.LocationId
												   and sli.ItemDeactivationDate <= ai.[Order Review Date]  -- only interested in history prior to Order Review Date
			    where case
					    when LastLocationThisAccount is null
						    and LastAccountThisLocation is null
					    then 'New Install'
					    when LastLocationThisAccount = DimServiceLocationID
						    and LastAccountThisLocation = DimAccountId
					    then 'Reconnect'
					    when LastLocationThisAccount is null
						    and LastAccountThisLocation != DimAccountID
					    then 'New Connect'
					    when LastLocationThisAccount is not null
						    and LastAccountThisLocation is null
					    then 'New Install (Existing Account)' -- this is a location which has never had an account installed to an account which HAS had a previous install
					    else 'Restart'
					end in
						 (
						  'New Install'
						 ,'New Install (Existing Account)'
						 )
			) d
		where rownumber = 1
			 or JoinLocationID is NULL
GO
