USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb]
as
    begin

	   set nocount on
	   truncate table [dbo].[FactCustomerItemHierarchy_pbb];

	   with allItems
		   as (select ss.AccountID
				   ,[LocationID]
				   ,[ItemID]
				   ,[ParentItemID]
				   ,PWBParentItemID
				   ,RootItemID
				   ,ss.[ServiceID]
				   ,[ComponentID]
				   ,[ComponentVersion]
				   ,[ComponentClassID]
				   ,[ActivationDate]
				   ,[DeactivationDate]
				   ,[ItemStatus]
				   ,[DisplayName]
				   ,cast(row_number() over(
				    order by SrvItem.ItemID) as varchar(max)) collate Latin1_General_BIN as sortorder
			  from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvItem] WITH (NOLOCK)
			  inner join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].SrvService ss  WITH (NOLOCK) on ss.ServiceID = SrvItem.ServiceID
			  where(PWBParentItemID is null
				   and RootItemID = Itemid)
				   and (ActivationDate < getdate()
				   and (DeactivationDate > getdate()
						  or DeactivationDate is null)
					   )

			  union all

			  select ss.AccountID
				   ,sic.[LocationID]
				   ,sic.[ItemID]
				   ,sic.[ParentItemID]
				   ,sic.PWBParentItemID
				   ,sic.RootItemID
				   ,ss.ServiceID
				   ,sic.[ComponentID]
				   ,sic.[ComponentVersion]
				   ,sic.[ComponentClassID]
				   ,sic.[ActivationDate]
				   ,sic.[DeactivationDate]
				   ,sic.[ItemStatus]
				   ,sic.[DisplayName]
				   ,allItems.sortorder + '.' + cast(row_number() over(partition by sic.PWBParentItemID
				    order by sic.ItemId) as varchar(max)) collate Latin1_General_BIN
			  from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvItem] sic WITH (NOLOCK)
				  inner join allItems on allItems.ItemID = sic.PWBParentItemID
				  inner join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].SrvService ss WITH (NOLOCK) on ss.ServiceID = sic.ServiceID
			  where(sic.ActivationDate < getdate()
				   and (sic.DeactivationDate > getdate()
					   or sic.DeactivationDate is null))
			),

		   catalogItems
		   as (select distinct 
				    convert(int,[ItemID]) as ItemID
				   ,[DimCatalogItemId]
				   ,ItemQuantity
				   ,ItemPrice
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem]
			  where getdate() >= EffectiveStartDate
				   and getdate() < EffectiveEndDate
			)

		   insert into [dbo].[FactCustomerItemHierarchy_pbb]
												  ([DimAccountId]
												  ,[DimCatalogItemId]
												  ,[AccountID]
												  ,[LocationID]
												  ,[ItemID]
												  ,[ParentItemID]
												  ,[PWBParentItemID]
												  ,[RootItemID]
												  ,[ItemQuantity]
												  ,[ItemPrice]
												  ,[ServiceID]
												  ,[ComponentID]
												  ,[ComponentVersion]
												  ,[ComponentClassID]
												  ,[ActivationDate]
												  ,[DeactivationDate]
												  ,[ItemStatus]
												  ,[DisplayName]
												  ,[sortorder]
												  ,[HierarchyLevel]
												  )
				select a.DimAccountId
					 ,ci.[DimCatalogItemId]
					 ,allItems.[AccountID]
					 ,allItems.[LocationID]
					 ,allItems.[ItemID]
					 ,allItems.[ParentItemID]
					 ,allItems.[PWBParentItemID]
					 ,allItems.[RootItemID]
					 ,ci.[ItemQuantity]
					 ,ci.[ItemPrice]
					 ,allItems.[ServiceID]
					 ,allItems.[ComponentID]
					 ,allItems.[ComponentVersion]
					 ,allItems.[ComponentClassID]
					 ,allItems.[ActivationDate]
					 ,allItems.[DeactivationDate]
					 ,allItems.[ItemStatus]
					 ,allItems.[DisplayName]
					 ,allItems.[sortorder]
					 ,
					  (
						 select count(*)
						 from string_split(convert(varchar(max),sortorder),'.')
					  ) as HierarchyLevel
				from allItems
					inner join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].CusAccount ca on ca.AccountId = allItems.AccountID
					inner join [dbo].[DimAccount] a on a.AccountCode = ca.AccountCode
					inner join catalogItems ci on ci.ItemID = allItems.ItemID
				order by AccountID
					   ,LocationID
					   ,sortorder
    end
GO
