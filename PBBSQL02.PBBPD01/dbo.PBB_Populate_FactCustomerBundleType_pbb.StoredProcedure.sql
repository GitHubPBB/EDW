USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_FactCustomerBundleType_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROCEDURE [dbo].[PBB_Populate_FactCustomerBundleType_pbb](
			 @EffectiveDate date
											)
as
    BEGIN

	   begin

		  set nocount on

		  insert INTO dbo.FactCustomerBundleType_pbb
										    (DimAccountId
										    ,DimServiceLocationId
										    ,EffectiveStartDate
										    ,EffectiveEndDate
										    ,BundleType
										    )
			    select distinct 
					 fca.DimAccountId
					,fca.DimServiceLocationId
					,convert(date,@EffectiveDate) as [EffectiveStartDate]
					,'2050-12-31'
					,bt.PBB_BundleType
			    from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fca
				    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_GetLocationAccountBundleType](convert(date,@EffectiveDate)) bt on bt.DimAccountId = fca.DimAccountId
																										    and bt.DimServiceLocationId = fca.DimServiceLocationId

		  update [dbo].[FactCustomerBundleType_pbb]
		    set 
			   EffectiveEndDate = '2050-12-31'
		  where FactcustomerBundleTypeID in
									 (
										select p.FactCustomerBundleTypeID
										from
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) b
											left join
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) p on p.DimAccountId = b.DimAccountId
												  and p.DimServiceLocationId = b.DimServiceLocationId
												  and b.rownumber = 1
												  and p.rownumber = 2
										where b.BundleType = p.BundleType
									 )
										and EffectiveEndDate <> '2050-12-31'

		  update [dbo].[FactCustomerBundleType_pbb]
		    set 
			   EffectiveEndDate = @EffectiveDate
		  where FactcustomerBundleTypeID in
									 (
										select p.FactCustomerBundleTypeID
										from
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) b
											left join
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) p on p.DimAccountId = b.DimAccountId
												  and p.DimServiceLocationId = b.DimServiceLocationId
												  and b.rownumber = 1
												  and p.rownumber = 2
										where b.BundleType <> p.BundleType
									 )

		  delete from [dbo].[FactCustomerBundleType_pbb]
		  where FactcustomerBundleTypeID in
									 (
										select b.FactCustomerBundleTypeID
										from
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) b
											left join
											(
											    select FactCustomerBundleTypeId
													,DimAccountId
													,DimServiceLocationId
													,BundleType
													,EffectiveStartDate
													,ROW_NUMBER() over(partition by DimAccountId
																			 ,DimServiceLocationId
													 Order by EffectiveStartDate DESC) as rownumber
											    from [dbo].[FactCustomerBundleType_pbb]
											) p on p.DimAccountId = b.DimAccountId
												  and p.DimServiceLocationId = b.DimServiceLocationId
												  and b.rownumber = 1
												  and p.rownumber = 2
										where b.BundleType = p.BundleType
									 )
	   end
    end
GO
