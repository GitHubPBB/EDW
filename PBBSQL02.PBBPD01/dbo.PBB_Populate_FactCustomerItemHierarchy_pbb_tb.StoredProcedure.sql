USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb_tb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Change:  2202-09-09		Todd Boyer		Tuning
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb_tb]
as
    begin

	   set nocount on
	   truncate table [dbo].[FactCustomerItemHierarchy_pbb_tb];

	   DROP TABLE if exists #AllItems;
	   DROP TABLE if exists #AllItems1;
	   DROP TABLE if exists #AllItems2;
	   DROP TABLE if exists #AllItems3;
	   DROP TABLE if exists #AllItems4;
	   DROP TABLE if exists #AllItems5;
	   DROP TABLE if exists #AllItemsFinal;

	   -- All data to local server
	   select       ca.AccountID
		           ,ca.AccountCode
				   ,si.LocationID
				   ,si.ItemID
				   ,si.ParentItemID
				   ,si.PWBParentItemID
				   ,si.RootItemID
				   ,si.ServiceID
				   ,si.ComponentID
				   ,si.ComponentVersion
				   ,si.ComponentClassID
				   ,si.ActivationDate
				   ,si.DeactivationDate
				   ,si.ItemStatus
				   ,si.DisplayName
			  into #AllItems
			  from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].SrvItem    si  WITH (NOLOCK)
			  join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].SrvService ss  WITH (NOLOCK) on ss.ServiceID = si.ServiceID
			  join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].CusAccount ca  WITH (NOLOCK) on ca.AccountID = ss.AccountId
			  where ActivationDate    < getdate()
			    and (DeactivationDate > getdate()
				     or DeactivationDate is null
				    )
		;
		CREATE UNIQUE INDEX pk_AllItems on #AllItems (ItemId);

		-- select * from #AllItems where serviceid = 218973


	   with allItems1 AS (
		     select AccountID
		           ,AccountCode
				   ,LocationID
				   ,ItemID
				   ,ParentItemID
				   ,PWBParentItemID
				   ,RootItemID
				   ,ServiceID
				   ,ComponentID
				   ,ComponentVersion
				   ,ComponentClassID
				   ,ActivationDate
				   ,DeactivationDate
				   ,ItemStatus
				   ,DisplayName
				   ,cast(row_number() over (order by ItemID) as varchar(max)) collate Latin1_General_BIN as SortOrder
				   ,cast(row_number() over (order by ItemID) as varchar(max)) collate Latin1_General_BIN as SortOrder2
			  from #AllItems
			  where(PWBParentItemID is null
				   and RootItemID = Itemid)
				   and (ActivationDate   < getdate()
				   and (DeactivationDate > getdate()
						  or DeactivationDate is null)
					   )
			) 
			SELECT * INTO #AllItems1 from AllItems1
			;
			-- Select * from #AllItems1
		    -- select * from #AllItems1 where serviceid = 218973

			WITH AllItems2 AS (
			 select a1.AccountID
		           ,a1.AccountCode
				   ,si.LocationID
				   ,si.ItemID
				   ,si.ParentItemID
				   ,si.PWBParentItemID
				   ,si.RootItemID
				   ,si.ServiceID
				   ,si.ComponentID
				   ,si.ComponentVersion
				   ,si.ComponentClassID
				   ,si.ActivationDate
				   ,si.DeactivationDate
				   ,si.ItemStatus
				   ,si.DisplayName
				   ,a1.SortOrder
				   ,a1.sortorder + '.' + cast(row_number() over(partition by a1.ItemID
				                                                 order by si.ItemId) as varchar(max)) collate Latin1_General_BIN SortOrder2
			  from #AllItems1                                        a1
			  join #AllItems                                         si  on si.ServiceId        = a1.ServiceId
			                                                             and si.PWBParentItemID = a1.ItemID
																		 and si.ItemID          <> a1.ItemID
			)			
			SELECT * INTO #AllItems2 from AllItems2
			;
			-- Select * from #AllItems2 order by cast(sortorder as int),sortorder2
		    -- select * from #AllItems2 where serviceid = 218973

			WITH AllItems3 AS (
			 select a2.AccountID
		           ,a2.AccountCode
				   ,si.LocationID
				   ,si.ItemID
				   ,si.ParentItemID
				   ,si.PWBParentItemID
				   ,si.RootItemID
				   ,si.ServiceID
				   ,si.ComponentID
				   ,si.ComponentVersion
				   ,si.ComponentClassID
				   ,si.ActivationDate
				   ,si.DeactivationDate
				   ,si.ItemStatus
				   ,si.DisplayName 
				   ,a2.sortorder2 SortOrder
				   ,a2.sortorder2 + '.' + cast(row_number() over(partition by a2.ItemID
				                                                 order by si.ItemId) as varchar(max)) collate Latin1_General_BIN sortorder2
			  from #AllItems2                                        a2
			  join #AllItems                                         si  on  si.ServiceId       = a2.ServiceId
			                                                             and si.PWBParentItemID = a2.ItemID
																		 and si.ItemID          <> a2.ItemID
			)			
			SELECT * INTO #AllItems3 from AllItems3
			;
			-- Select * from #AllItems3 order by cast(sortorder as int),sortorder2
		    -- select * from #AllItems3 where serviceid = 218973

				
			WITH AllItems4 AS (
			 select a3.AccountID
		           ,a3.AccountCode
				   ,si.LocationID
				   ,si.ItemID
				   ,si.ParentItemID
				   ,si.PWBParentItemID
				   ,si.RootItemID
				   ,si.ServiceID
				   ,si.ComponentID
				   ,si.ComponentVersion
				   ,si.ComponentClassID
				   ,si.ActivationDate
				   ,si.DeactivationDate
				   ,si.ItemStatus
				   ,si.DisplayName 
				   ,a3.sortorder2 SortOrder
				   ,a3.sortorder2 + '.' + cast(row_number() over(partition by a3.ItemID
				                                                 order by si.ItemId) as varchar(max)) collate Latin1_General_BIN sortorder2
			  from #AllItems3                                        a3
			  join #AllItems                                         si  on  si.ServiceId       = a3.ServiceId
			                                                             and si.PWBParentItemID = a3.ItemID
																		 and si.ItemID          <> a3.ItemID
			)			
			SELECT * INTO #AllItems4 from AllItems4
			;
			-- Select * from #AllItems4 order by  sortorder ,sortorder2

							
			WITH AllItems5 AS (
			 select a4.AccountID
		           ,a4.AccountCode
				   ,si.LocationID
				   ,si.ItemID
				   ,si.ParentItemID
				   ,si.PWBParentItemID
				   ,si.RootItemID
				   ,si.ServiceID
				   ,si.ComponentID
				   ,si.ComponentVersion
				   ,si.ComponentClassID
				   ,si.ActivationDate
				   ,si.DeactivationDate
				   ,si.ItemStatus
				   ,si.DisplayName 
				   ,a4.sortorder2 SortOrder
				   ,a4.sortorder2 + '.' + cast(row_number() over(partition by a4.ItemID
				                                                 order by si.ItemId) as varchar(max)) collate Latin1_General_BIN sortorder2
			  from #AllItems4                                        a4
			  join #AllItems                                         si  on  si.ServiceId       = a4.ServiceId
			                                                             and si.PWBParentItemID = a4.ItemID
																		 and si.ItemID          <> a4.ItemID
			)			
			SELECT * INTO #AllItems5 from AllItems5
			;
			-- Select * from #AllItems5 order by  sortorder ,sortorder2

		   SELECT * INTO #AllItemsFinal FROM   
			(SELECT * FROM #AllItems1
			  UNION
			 SELECT * FROM #AllItems2
			  UNION
			 SELECT * FROM #AllItems3
			  UNION
			 SELECT * FROM #AllItems4
			  UNION
			 SELECT * FROM #AllItems5
			 )    x
			 ;
	 
	 
		   WITH
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

		   insert into [dbo].[FactCustomerItemHierarchy_pbb_tb]
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
					 ,allItems.[sortorder2] SortOrder
					 ,
					  (
						 select count(*)
						 from string_split(convert(varchar(max),sortorder2),'.')
					  ) as HierarchyLevel
				from #AllItemsFinal allItems
					--inner join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].CusAccount ca on ca.AccountId = allItems.AccountID
					inner join [dbo].[DimAccount] a  on a.AccountCode = allItems.AccountCode
					inner join catalogItems       ci on ci.ItemID     = allItems.ItemID
				order by AccountID
					   ,LocationID
					   ,sortorder

    end
GO
