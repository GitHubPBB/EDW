USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_CableSubCount_Details]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PBB_CableSubCount_Details]

AS
    BEGIN
With
     cablecat
     AS (SELECT DISTINCT 
                sli.DimAccountId, 
                sli.DimServiceLocationID, 
                MAX(ISNULL(r.rnk, 0)) rnk
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			  JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
              JOIN PrdCableRank r ON pc.Category = r.Category
         WHERE Activation_DimDateId <= GETDATE()
               AND Deactivation_DimDateId > GETDATE()
               AND EffectiveStartDate <= GETDATE()
               AND EffectiveEndDate > GETDATE()
			   and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
         GROUP BY sli.DimAccountId, 
                  sli.DimServiceLocationID),
     IntCat
     AS (SELECT DISTINCT 
                sli.DimAccountId, 
                sli.DimServiceLocationID, 
                MAX(ISNULL(r.rnk, 0)) rnk
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			  JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
              JOIN PrdInternetRank r ON pc.SpeedTier = r.Category
         WHERE Activation_DimDateId <= GETDATE()
               AND Deactivation_DimDateId > GETDATE()
               AND EffectiveStartDate <= GETDATE()
               AND EffectiveEndDate > GETDATE()
			   and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
         GROUP BY sli.DimAccountId, 
                  sli.DimServiceLocationID)
     SELECT sli.DimAccountId, 
            sli.DimCustomerItemId, 
            a.accountcode, 
            sli.DimServiceLocationID, 
			cast(a.accountcode as nvarchar(10))+'|'+cast(sli.DimServiceLocationID as nvarchar(10)) AccountLocation, 
            a.dimaccountid,
            CASE
                WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%'
                THEN 'Y'
                ELSE 'N'
            END AS Internal,
            CASE
                WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%'
                THEN 'Y'
                ELSE 'N'
            END AS Courtesy,
            CASE
                WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'
                THEN 'Y'
                ELSE 'N'
            END AS MilitaryDiscount,
            CASE
                WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%'
                THEN 'Y'
                ELSE 'N'
            END AS SeniorDiscount,
            CASE
                WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%'
                THEN 'Y'
                ELSE 'N'
            END AS PointPause,
            CASE
                WHEN ac.AccountGroupCode = ''
                THEN 'NONE'
                ELSE ac.AccountGroupCode
            END AS AccountGroupCode, 
			left(ac.AccountGroupCode,3) as Market,
            case when AC.AccountGroupCode like '%RES' then 'Residential'
			when ac.AccountGroupCode like '%BUS' then 'Business'
			when ac.AccountGroupCode like 'WHL%' then 'Business'
			else ac.AccountGroupCode end as AccountType, 
            ci.Componentcode, 
            ItemMarketingDescription, 
            ci.ComponentClass, 
            ItemQuantity, 
            ServiceLocationState, 
            ServiceLocationCity, 
            ServiceLocationPostalCode, 
			DMA,
            ServiceLocationTaxArea, 
            [IsOther], 
            [IsData], 
            [IsDataSvc], 
            [SpeedTier], 
            [IsCable], 
            [IsCableSvc], 
            case when [HBOBulk] = 1 then 'HBOBulk'
            when [HBOSA] = 1 then 'HBOSA'
            when [HBOQV] = 1 then 'HBOQV' else '' end as HBO,
            case when [Cinemax_Standalone_SA] = 1 then 'CinemaxStandAlongSA' 
             when [Cinemax_Standalone_QV] = 1 then 'CinemaxStandAloneQV'
             when [Cinemax_Pkg_SA] = 1 then 'CinemaxPkgSA'
             when [Cinemax_pkg_qv] = 1 then 'CinemaxPkgQV' 
			else '' end as Cinemax,
            case when [Showtime_SA] = 1 then 'ShowtimeSA'
            when [Showtime_QV] = 1 then 'ShowtimeQV'
			else '' end as 'Showtime',
            case when [Starz_SA] = 1 then 'StarzQA'
            when [Starz_QV] = 1 then 'StarzQV'
			else '' end as 'Starz',
			pc.category,
            rnk.Category AS CableCategory, 
            irnk.Category AS DataCategory,
			ishispanic,
			IsFreeHD
     FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
		  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
          JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON sli.DimAccountId = a.DimAccountId
          JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
          JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
          JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
          JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac ON ac.DimAccountCategoryId = sli.DimAccountCategoryId
		  LEFT JOIN ZIPDMA dma on sl.ServiceLocationPostalCode = dma.ZipCode
          LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
          LEFT JOIN cablecat r ON sli.DimAccountId = r.DimAccountId
                                  AND sli.DimServiceLocationId = r.DimServiceLocationId
          LEFT JOIN PrdCableRank rnk ON r.rnk = rnk.Rnk
          LEFT JOIN intcat ir ON sli.DimAccountId = ir.DimAccountId
                                 AND sli.DimServiceLocationId = ir.DimServiceLocationId
          LEFT JOIN PrdInternetRank irnk ON ir.rnk = irnk.Rnk
     WHERE Activation_DimDateId <= GETDATE()
           AND Deactivation_DimDateId > GETDATE()
           AND EffectiveStartDate <= GETDATE()
           AND EffectiveEndDate > GETDATE()
           AND sli.DimAccountId <> 0
           AND pc.IsIgnored = 0
		   and (pc.IsCable = 1 or pc.IsData = 1)
		   and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
     ORDER BY sli.DimAccountId;
	 end;

	 
GO
