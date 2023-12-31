USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimCatalogItem_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[PBB_Populate_DimCatalogItem_pbb]
as
    begin
	   truncate table dbo.DimCatalogItem_pbb

	   insert INTO dbo.DimCatalogItem_pbb
			select distinct dci.DimCatalogItemId
				 ,case
					 when pcm.IsUsed = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsUsed
				 ,case
					 when pcm.IsIgnored = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsIgnored
				 ,case
					 when pcm.IsCable = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsCable
				 ,case
					 when pcm.IsData = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsData
				 ,case
					 when pcm.IsPhone = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsPhone
				 ,case
					 when pcm.IsPointGuard = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsPointGuard
				 ,case
					 when pcm.IsPromo = 1
					 then 'Yes' else 'No'
				  end as CatalotItemIsPromo
				 ,case
					 when pcm.IsRF = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsRF
				 ,case
					 when pcm.IsSmartHome = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsSmartHome
				 ,case
					 when pcm.IsSmartHomePod = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsSmartHomePod
				 ,case
					 when pcm.IsSmartHomePromo = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsSmartHomePromo
				 ,case
					 when pcm.IsUnlimitedLD = 1
					 then 'Yes' else 'No'
				  end as CatalogItemIsUnlimitedLD
			from [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] dci
				left join PrdComponentMap pcm on pcm.ComponentCode = dci.ComponentCode

    end
GO
