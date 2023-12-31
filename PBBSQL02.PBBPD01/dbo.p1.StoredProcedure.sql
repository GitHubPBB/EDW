USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[p1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   proc [dbo].[p1] 
as
begin
WITH acct
               AS (SELECT sli.DimAccountId
                                             ,a.accountcode
                                             ,a.AccountName
                                             ,sli.DimServiceLocationID
                                             ,CASE
                                                            WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%'
                                                            THEN 'Y' ELSE 'N'
                                             END AS Internal
                                             ,CASE
                                                            WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%'
                                                            THEN 'Y' ELSE 'N'
                                             END AS Courtesy
                                             ,CASE
                                                            WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'
                                                            THEN 'Y' ELSE 'N'
                                             END AS MilitaryDiscount
                                             ,CASE
                                                            WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%'
                                                            THEN 'Y' ELSE 'N'
                                             END AS SeniorDiscount
                                             ,CASE
                                                            WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%'
                                                            THEN 'Y' ELSE 'N'
                                             END AS PointPause
                                             ,((pbb_AccountDiscountPercentage * -1) / 100) DiscPerc
                                             ,CASE
                                                            WHEN ac.AccountGroupCode = ''
                                                            THEN 'NONE' ELSE ac.AccountGroupCode
                                             END AS AccountGroupCode
                                             ,CASE
                                                            WHEN AC.AccountGroupCode LIKE '%RES'
                                                            THEN 'Residential'
                                                            WHEN ac.AccountGroupCode LIKE '%BUS'
                                                            THEN 'Business'
                                                            WHEN ac.AccountGroupCode LIKE 'WHL%'
                                                            THEN 'Business' ELSE ac.AccountGroupCode
                                             END AS AccountType
                                             ,ServiceLocationFullAddress
                                             ,ServiceLocationState
                                             ,ServiceLocationCity
                                             ,ServiceLocationPostalCode
                                             ,ServiceLocationTaxArea
                   FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
                                  JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
                                  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON sli.DimAccountId = a.DimAccountId
                                  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
                                  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
                                  JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac ON ac.DimAccountCategoryId = sli.DimAccountCategoryId
                   WHERE Activation_DimDateId <= GETDATE()
                                             AND Deactivation_DimDateId > GETDATE()
                                             AND EffectiveStartDate <= GETDATE()
                                             AND EffectiveEndDate > GETDATE()
                                             and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
                                             AND sli.DimAccountId <> 0
                   GROUP BY sli.DimAccountId
                                               ,a.accountname
                                               ,a.accountcode
                                               ,sli.DimServiceLocationID
                                               ,CASE
                                                              WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%'
                                                              THEN 'Y' ELSE 'N'
                                                END
                                               ,CASE
                                                              WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%'
                                                              THEN 'Y' ELSE 'N'
                                                END
                                               ,CASE
                                                              WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'
                                                              THEN 'Y' ELSE 'N'
                                                END
                                               ,CASE
                                                              WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%'
                                                              THEN 'Y' ELSE 'N'
                                                END
                                               ,CASE
                                                              WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%'
                                                              THEN 'Y' ELSE 'N'
                                                END
                                               ,((pbb_AccountDiscountPercentage * -1) / 100)
                                               ,CASE
                                                              WHEN ac.AccountGroupCode = ''
                                                              THEN 'NONE' ELSE ac.AccountGroupCode
                                                END
                                               ,CASE
                                                              WHEN AC.AccountGroupCode LIKE '%RES'
                                                              THEN 'Residential'
                                                              WHEN ac.AccountGroupCode LIKE '%BUS'
                                                              THEN 'Business'
                                                              WHEN ac.AccountGroupCode LIKE 'WHL%'
                                                              THEN 'Business' ELSE ac.AccountGroupCode
                                                END
                                               ,ServiceLocationFullAddress
                                               ,ServiceLocationState
                                               ,ServiceLocationCity
                                               ,ServiceLocationPostalCode
                                               ,ServiceLocationTaxArea),
               IntCat
               AS (SELECT DISTINCT 
                                              sli.DimAccountId
                                             ,sli.DimServiceLocationID
                                             ,MAX(ISNULL(r.rnk,0)) rnk
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
                   GROUP BY sli.DimAccountId
                                               ,sli.DimServiceLocationID),
               cablecat
               AS (SELECT DISTINCT 
                                              sli.DimAccountId
                                             ,sli.DimServiceLocationID
                                             ,MAX(ISNULL(r.rnk,0)) rnk
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
                   GROUP BY sli.DimAccountId
                                               ,sli.DimServiceLocationID),
               ServiceClassify
               as
               --select * from prdcomponentmap
               (SELECT sli.DimAccountId
                                ,a.accountcode
                                ,sli.DimServiceLocationID
                                 -- IntGroup
                                ,CASE
                                               WHEN IsDataSvc = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS IntGrpSvcItemPrice
                                ,CASE
                                               WHEN IsDataSvc = 1
                                               THEN DiscPerc ELSE 0
                                 END AS IntGrpSvcdiscountpercentage
                                ,CASE
                                               WHEN IsDataSvc = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS IntGrpSvcdiscountrate
                                ,CASE
                                               WHEN IsDataSvc = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS IntGrpSvcnet
                                 -- cabGrp
                                ,CASE
                                               WHEN IsCableSvc = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS CabGrpSvcItemPrice
                                ,CASE
                                               WHEN IsCableSvc = 1
                                               THEN DiscPerc ELSE 0
                                 END AS CabGrpSvcdiscountpercentage
                                ,CASE
                                               WHEN IsCableSvc = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS CabGrpSvcdiscountrate
                                ,CASE
                                               WHEN IsCableSvc = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS CabGrpSvcnet
                                 --HBO
                                ,CASE
                                               WHEN [HBOBulk] = 1
                                                              or HBOQV = 1
                                                              or HBOSA = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS HBOItemPrice
                                ,CASE
                                               WHEN [HBOBulk] = 1
                                                              or HBOQV = 1
                                                              or HBOSA = 1
                                               THEN DiscPerc ELSE 0
                                 END AS HBOdiscountpercentage
                                ,CASE
                                               WHEN [HBOBulk] = 1
                                                              or HBOQV = 1
                                                              or HBOSA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS HBOdiscountrate
                                ,CASE
                                               WHEN [HBOBulk] = 1
                                                              or HBOQV = 1
                                                              or HBOSA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS HBOnet 
                                 --Cinemax
                                ,CASE
                                               WHEN Cinemax_Standalone_QV = 1
                                                              or Cinemax_Standalone_SA = 1
                                                              or Cinemax_pkg_qv = 1
                                                              or Cinemax_Pkg_SA = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS CinemaxItemPrice
                                ,CASE
                                               WHEN Cinemax_Standalone_QV = 1
                                                              or Cinemax_Standalone_SA = 1
                                                              or Cinemax_pkg_qv = 1
                                                              or Cinemax_Pkg_SA = 1
                                               THEN DiscPerc ELSE 0
                                 END AS Cinemaxdiscountpercentage
                                ,CASE
                                               WHEN Cinemax_Standalone_QV = 1
                                                              or Cinemax_Standalone_SA = 1
                                                              or Cinemax_pkg_qv = 1
                                                              or Cinemax_Pkg_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS Cinemaxdiscountrate
                                ,CASE
                                               WHEN Cinemax_Standalone_QV = 1
                                                              or Cinemax_Standalone_SA = 1
                                                              or Cinemax_pkg_qv = 1
                                                              or Cinemax_Pkg_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS Cinemaxnet 
                                 --Showtime
                                ,CASE
                                               WHEN Showtime_QV = 1
                                                              or Showtime_SA = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS ShowtimeItemPrice
                                ,CASE
                                               WHEN Showtime_QV = 1
                                                              or Showtime_SA = 1
                                               THEN DiscPerc ELSE 0
                                 END AS Showtimediscountpercentage
                                ,CASE
                                               WHEN Showtime_QV = 1
                                                              or Showtime_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS Showtimediscountrate
                                ,CASE
                                               WHEN Showtime_QV = 1
                                                              or Showtime_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS Showtimenet 
                                 --Starz
                                ,CASE
                                               WHEN Starz_QV = 1
                                                              or Starz_SA = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS StarzItemPrice
                                ,CASE
                                               WHEN Starz_QV = 1
                                                              or Starz_SA = 1
                                               THEN DiscPerc ELSE 0
                                 END AS Starzdiscountpercentage
                                ,CASE
                                               WHEN Starz_QV = 1
                                                              or Starz_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS Starzdiscountrate
                                ,CASE
                                               WHEN Starz_QV = 1
                                                              or Starz_SA = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS Starznet 
                                 --OtherAddOn
                                ,CASE
                                               WHEN IsCable = 1
                                                              and HBOBulk = 0
                                                              and HBOQV = 0
                                                              and HBOSA = 0
                                                              and Cinemax_pkg_qv = 0
                                                              and Cinemax_Pkg_SA = 0
                                                              and Cinemax_Standalone_QV = 0
                                                              and Cinemax_Standalone_SA = 0
                                                              and Showtime_QV = 0
                                                              and Showtime_SA = 0
                                                              and Starz_QV = 0
                                                              and Starz_SA = 0
                                                              AND IsCableSvc = 0
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS CabGrpAddOnItemPrice
                                ,CASE
                                               WHEN IsCable = 1
                                                              and HBOBulk = 0
                                                              and HBOQV = 0
                                                              and HBOSA = 0
                                                              and Cinemax_pkg_qv = 0
                                                              and Cinemax_Pkg_SA = 0
                                                              and Cinemax_Standalone_QV = 0
                                                              and Cinemax_Standalone_SA = 0
                                                              and Showtime_QV = 0
                                                              and Showtime_SA = 0
                                                              and Starz_QV = 0
                                                              and Starz_SA = 0
                                                              AND IsCableSvc = 0
                                               THEN DiscPerc ELSE 0
                                 END AS CabGrpAddOndiscountpercentage
                                ,CASE
                                               WHEN IsCable = 1
                                                              and HBOBulk = 0
                                                              and HBOQV = 0
                                                              and HBOSA = 0
                                                              and Cinemax_pkg_qv = 0
                                                              and Cinemax_Pkg_SA = 0
                                                              and Cinemax_Standalone_QV = 0
                                                              and Cinemax_Standalone_SA = 0
                                                              and Showtime_QV = 0
                                                              and Showtime_SA = 0
                                                              and Starz_QV = 0
                                                              and Starz_SA = 0
                                                              AND IsCableSvc = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS CabGrpAddOndiscountrate
                                ,CASE
                                               WHEN IsCable = 1
                                                              and HBOBulk = 0
                                                              and HBOQV = 0
                                                              and HBOSA = 0
                                                              and Cinemax_pkg_qv = 0
                                                              and Cinemax_Pkg_SA = 0
                                                              and Cinemax_Standalone_QV = 0
                                                              and Cinemax_Standalone_SA = 0
                                                              and Showtime_QV = 0
                                                              and Showtime_SA = 0
                                                              and Starz_QV = 0
                                                              and Starz_SA = 0
                                                              AND IsCableSvc = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS CabGrpAddOnnet
                                 -- SmartHome
                                ,CASE
                                               WHEN [IsSmartHome] = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS SmartHomeItemPrice
                                ,CASE
                                               WHEN [IsSmartHome] = 1
                                               THEN DiscPerc ELSE 0
                                 END AS SmartHomediscountpercentage
                                ,CASE
                                               WHEN [IsSmartHome] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS SmartHomediscountrate
                                ,CASE
                                               WHEN [IsSmartHome] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS SmartHomenet 
                                 --SmartHomePod
                                ,CASE
                                               WHEN [IsSmartHomePod] = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS SmartHomePodItemPrice
                                ,CASE
                                               WHEN [IsSmartHomePod] = 1
                                               THEN DiscPerc ELSE 0
                                 END AS SmartHomePoddiscountpercentage
                                ,CASE
                                               WHEN [IsSmartHomePod] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS SmartHomePoddiscountrate
                                ,CASE
                                               WHEN [IsSmartHomePod] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS SmartHomePodnet 
                                 --PointGuard
                                ,CASE
                                               WHEN [IsPointGuard] = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS PointGuardItemPrice
                                ,CASE
                                               WHEN [IsPointGuard] = 1
                                               THEN DiscPerc ELSE 0
                                 END AS PointGuarddiscountpercentage
                                ,CASE
                                               WHEN [IsPointGuard] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS PointGuarddiscountrate
                                ,CASE
                                               WHEN [IsPointGuard] = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS PointGuardnet 
                                 --OtherAddOn
                                ,CASE
                                              WHEN IsData = 1
                                                              and IsSmartHome = 0
                                                              and IsSmartHomePod = 0
                                                              and IsPointGuard = 0
                                                              AND IsDataSvc = 0
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS IntGrpAddOnItemPrice
                                ,CASE
                                               WHEN IsData = 1
                                                              and IsSmartHome = 0
                                                              and IsSmartHomePod = 0
                                                              and IsPointGuard = 0
                                                              AND IsDataSvc = 0
                                               THEN DiscPerc ELSE 0
                                 END AS IntGrpAddOndiscountpercentage
                                ,CASE
                                               WHEN IsData = 1
                                                              AND IsDataSvc = 0
                                                              and IsSmartHome = 0
                                                              and IsSmartHomePod = 0
                                                              and IsPointGuard = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS IntGrpAddOndiscountrate
                                ,CASE
                                               WHEN IsData = 1
                                                              and IsSmartHome = 0
                                                              and IsSmartHomePod = 0
                                                              and IsPointGuard = 0
                                                              AND IsDataSvc = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS IntGrpAddOnnet
                                 --phnGrp 
                                 -- ci.Componentcode,ItemMarketingDescription,
                                ,CASE
                                               WHEN IsLocalPhn = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS PhnGrpSvcItemPrice
                                ,CASE
                                               WHEN IsLocalPhn = 1
                                               THEN DiscPerc ELSE 0
                                 END AS PhnGrpSvcdiscountpercentage
                                ,CASE
                                               WHEN IsLocalPhn = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS PhnGrpSvcdiscountrate
                                ,CASE
                                               WHEN IsLocalPhn = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS PhnGrpSvcnet
                                --OtherAddOn
                                ,CASE
                                               WHEN IsPhone = 1
                                                              and IsLocalPhn = 0
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS PhnGrpAddOnItemPrice
                                ,CASE
                                               WHEN IsPhone = 1
                                                              and IsLocalPhn = 0
                                               THEN DiscPerc ELSE 0
                                 END AS PhnGrpAddOndiscountpercentage
                                ,CASE
                                               WHEN IsPhone = 1
                                                              and IsLocalPhn = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS PhnGrpAddOndiscountrate
                                ,CASE
                                               WHEN IsPhone = 1
                                                              and IsLocalPhn = 0
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS PhnGrpAddOnnet
                                ,CASE
                                               WHEN IsPromo = 1
                                               THEN(ItemPrice * ItemQuantity) ELSE 0
                                 END AS PromoPrice
                                ,CASE
                                               WHEN IsPromo = 1
                                               THEN DiscPerc ELSE 0
                                 END AS Promodiscountpercentage
                                ,CASE
                                               WHEN IsPromo = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                 END AS Promodiscountrate
                                ,CASE
                                               WHEN IsPromo = 1
                                               THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                 END AS Promonet
                                ,SUM(CAST(pc.IsPromo AS INT)) IsPromo
                                ,SUM(CAST(pc.IsData AS INT)) IsData
                                ,SUM(CAST(pc.IsDataSvc AS INT)) IsDataSvc
                                ,SUM(CAST([IsSmartHome] AS INT)) IsSmartHome
                                ,SUM(CAST([IsSmartHomePod] AS INT)) IsSmartHomePod
                                ,SUM(CAST([IsPointGuard] AS INT)) IsPointGuard
                                ,irnk.Category AS DataCategory
                                ,SUM(CAST(pc.IsCable AS INT)) IsCable
                                ,SUM(CAST(pc.IsCableSvc AS INT)) IsCableSvc
                                ,SUM(CAST(HBOBulk AS INT)) + SUM(CAST(HBOSA AS INT)) + SUM(CAST(HBOQV AS INT)) IsHBO
                                ,SUM(CAST(Cinemax_pkg_qv AS INT)) + SUM(CAST(Cinemax_Pkg_SA AS INT)) + SUM(CAST(Cinemax_Standalone_QV AS INT)) + SUM(CAST(Cinemax_Standalone_SA AS INT)) IsCinemax
                                ,SUM(CAST(Showtime_QV AS INT)) + SUM(CAST(Showtime_SA AS INT)) IsShowtime
                                ,SUM(CAST(Starz_QV AS INT)) + SUM(CAST(Starz_SA AS INT)) IsStarz
                                ,cirnk.Category AS CableCategory
                                ,SUM(CAST(pc.IsPhone AS INT)) IsPhone
                                ,SUM(CAST(pc.IsLocalPhn AS INT)) IsPhoneSvc
               FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
                              JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
                              JOIN acct a ON sli.DimAccountId = a.DimAccountId
                                                                           and sli.DimServiceLocationId = a.DimServiceLocationId
                              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
                              LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
                              LEFT JOIN intcat ir ON sli.DimAccountId = ir.DimAccountId
                                                                                              AND sli.DimServiceLocationId = ir.DimServiceLocationId
                              LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdInternetRank irnk ON ir.rnk = irnk.Rnk
                              LEFT JOIN cablecat cir ON sli.DimAccountId = cir.DimAccountId
                                                                                                           AND sli.DimServiceLocationId = cir.DimServiceLocationId
                              LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdCableRank cirnk ON cir.rnk = cirnk.Rnk
               WHERE Activation_DimDateId <= GETDATE()
                                AND Deactivation_DimDateId > GETDATE()
                                AND EffectiveStartDate <= GETDATE()
                                AND EffectiveEndDate > GETDATE()
                                and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
                                --AND PC.ComponentClass <> 'Package'
                                AND sli.DimAccountId <> 0
                                AND pc.IsIgnored = 0
               GROUP BY sli.DimAccountId
                                  ,a.accountcode
                                  ,sli.DimServiceLocationID
                                  ,CASE
                                                 WHEN IsDataSvc = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsDataSvc = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsDataSvc = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsDataSvc = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                             --SmartHome
                                  ,CASE
                                                 WHEN [IsSmartHome] = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHome] = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHome] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHome] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --SmartHomePod
                                  ,CASE
                                                 WHEN [IsSmartHomePod] = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHomePod] = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHomePod] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsSmartHomePod] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --PointGuard
                                  ,CASE
                                                 WHEN [IsPointGuard] = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsPointGuard] = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsPointGuard] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [IsPointGuard] = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --OtherAddOn
                                  ,CASE
                                                 WHEN IsData = 1
                                                                and IsSmartHome = 0
                                                                and IsSmartHomePod = 0
                                                                and IsPointGuard = 0
                                                                AND IsDataSvc = 0
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsData = 1
                                                                and IsSmartHome = 0
                                                                and IsSmartHomePod = 0
                                                                and IsPointGuard = 0
                                                                AND IsDataSvc = 0
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsData = 1
                                                                AND IsDataSvc = 0
                                                                and IsSmartHome = 0
                                                                and IsSmartHomePod = 0
                                                                and IsPointGuard = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsData = 1
                                                                and IsSmartHome = 0
                                                                and IsSmartHomePod = 0
                                                                and IsPointGuard = 0
                                                                AND IsDataSvc = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                 ,CASE
                                                 WHEN IsCableSvc = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCableSvc = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCableSvc = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCableSvc = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                             --HBO
                                  ,CASE
                                                 WHEN [HBOBulk] = 1
                                                                or HBOQV = 1
                                                                or HBOSA = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [HBOBulk] = 1
                                                                or HBOQV = 1
                                                                or HBOSA = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [HBOBulk] = 1
                                                                or HBOQV = 1
                                                                or HBOSA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN [HBOBulk] = 1
                                                                or HBOQV = 1
                                                                or HBOSA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --Cinemax
                                  ,CASE
                                                 WHEN Cinemax_Standalone_QV = 1
                                                                or Cinemax_Standalone_SA = 1
                                                                or Cinemax_pkg_qv = 1
                                                                or Cinemax_Pkg_SA = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Cinemax_Standalone_QV = 1
                                                                or Cinemax_Standalone_SA = 1
                                                                or Cinemax_pkg_qv = 1
                                                                or Cinemax_Pkg_SA = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Cinemax_Standalone_QV = 1
                                                                or Cinemax_Standalone_SA = 1
                                                                or Cinemax_pkg_qv = 1
                                                                or Cinemax_Pkg_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Cinemax_Standalone_QV = 1
                                                                or Cinemax_Standalone_SA = 1
                                                                or Cinemax_pkg_qv = 1
                                                               or Cinemax_Pkg_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --Showtime
                                  ,CASE
                                                 WHEN Showtime_QV = 1
                                                                or Showtime_SA = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Showtime_QV = 1
                                                                or Showtime_SA = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Showtime_QV = 1
                                                                or Showtime_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Showtime_QV = 1
                                                                or Showtime_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --Starz
                                  ,CASE
                                                 WHEN Starz_QV = 1
                                                                or Starz_SA = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Starz_QV = 1
                                                                or Starz_SA = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Starz_QV = 1
                                                                or Starz_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN Starz_QV = 1
                                                                or Starz_SA = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END 
                                             --OtherAddOn
                                  ,CASE
                                                 WHEN IsCable = 1
                                                                and HBOBulk = 0
                                                                and HBOQV = 0
                                                                and HBOSA = 0
                                                                and Cinemax_pkg_qv = 0
                                                                and Cinemax_Pkg_SA = 0
                                                                and Cinemax_Standalone_QV = 0
                                                                and Cinemax_Standalone_SA = 0
                                                                and Showtime_QV = 0
                                                                and Showtime_SA = 0
                                                                and Starz_QV = 0
                                                                and Starz_SA = 0
                                                                AND IsCableSvc = 0
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCable = 1
                                                                and HBOBulk = 0
                                                                and HBOQV = 0
                                                                and HBOSA = 0
                                                                and Cinemax_pkg_qv = 0
                                                                and Cinemax_Pkg_SA = 0
                                                                and Cinemax_Standalone_QV = 0
                                                                and Cinemax_Standalone_SA = 0
                                                                and Showtime_QV = 0
                                                                and Showtime_SA = 0
                                                                and Starz_QV = 0
                                                                and Starz_SA = 0
                                                                AND IsCableSvc = 0
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCable = 1
                                                                and HBOBulk = 0
                                                                and HBOQV = 0
                                                                and HBOSA = 0
                                                                and Cinemax_pkg_qv = 0
                                                                and Cinemax_Pkg_SA = 0
                                                                and Cinemax_Standalone_QV = 0
                                                                and Cinemax_Standalone_SA = 0
                                                                and Showtime_QV = 0
                                                                and Showtime_SA = 0
                                                                and Starz_QV = 0
                                                                and Starz_SA = 0
                                                                AND IsCableSvc = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsCable = 1
                                                                and HBOBulk = 0
                                                                and HBOQV = 0
                                                                and HBOSA = 0
                                                                and Cinemax_pkg_qv = 0
                                                                and Cinemax_Pkg_SA = 0
                                                                and Cinemax_Standalone_QV = 0
                                                                and Cinemax_Standalone_SA = 0
                                                                and Showtime_QV = 0
                                                                and Showtime_SA = 0
                                                                and Starz_QV = 0
                                                                and Starz_SA = 0
                                                                AND IsCableSvc = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsLocalPhn = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsLocalPhn = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsLocalPhn = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsLocalPhn = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                             --OtherAddOn
                                  ,CASE
                                                 WHEN IsPhone = 1
                                                                and IsLocalPhn = 0
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPhone = 1
                                                                and IsLocalPhn = 0
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPhone = 1
                                                                and IsLocalPhn = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPhone = 1
                                                                and IsLocalPhn = 0
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPromo = 1
                                                 THEN(ItemPrice * ItemQuantity) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPromo = 1
                                                 THEN DiscPerc ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPromo = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) * DiscPerc,2) ELSE 0
                                             END
                                  ,CASE
                                                 WHEN IsPromo = 1
                                                 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
                                             END
                                  ,ServiceLocationState
                                  ,ServiceLocationCity
                                  ,ServiceLocationPostalCode
                                  ,ServiceLocationTaxArea
                                  ,irnk.Category
                                  ,cirnk.Category),
               PackageClassify
               as (select a.DimAccountId
                                             ,h1.ParentItemID
                                             ,h1.RootItemID
                                             ,a.AccountCode
                                             ,a.AccountName
                                             ,DSL.DimServiceLocationId
                                             ,h1.displayname as ParentComponentName
                                             ,h1.ItemPrice as ParentComponentCharge
                                             ,h2.DisplayName as ChildComponentName
                                             ,h2.ItemPrice as ChildComponentCharge
                                             ,prd.*
                   from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItemHierarchy_pbb] h1
                                  inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItemHierarchy_pbb] h2 on substring(h2.sortorder,1,len(h1.sortorder)) = h1.sortorder
                                                                                                                                                                                                                                                                              and substring(h2.sortorder,1,len(h1.sortorder)) <> h2.sortorder
                                                                                                                                                                                                                                                                              and h1.ItemID = h2.PWBParentItemID
                                  inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a on a.DimAccountId = h1.DimAccountId
                                  inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] prd on h2.ComponentID = prd.ComponentID
                                  inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation DSL on h1.LocationID = DSL.LocationId
                   where h1.ComponentClassID = 200),
               
               ChildList
                                             as(select	h1.RootItemID
                                                            ,a.DimAccountId
                                                            
                                                            ,h1.ParentItemID
                                                            ,a.AccountCode
                                                            ,a.AccountName
                                                            ,h1.displayname as ParentComponentName
                                                            ,h2.DisplayName as ChildComponentName
                                                            from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItemHierarchy_pbb] h1
                                                            inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItemHierarchy_pbb] h2 on substring(h2.sortorder,1,len(h1.sortorder)) = h1.sortorder
                                                            and substring(h2.sortorder,1,len(h1.sortorder)) <> h2.sortorder
                                                            and h1.ItemID = h2.PWBParentItemID
                                                            inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a on a.DimAccountId = h1.DimAccountId
                                                            inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] prd on h2.ComponentID = prd.ComponentID
                                                            inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation DSL on h1.LocationID = DSL.LocationId 
                                                            where h1.ComponentClassID = 200 --and a.AccountCode = 100347795
															group by h1.RootItemID
                                                            ,a.DimAccountId
                                                            
                                                            ,h1.ParentItemID
                                                            ,a.AccountCode
                                                            ,a.AccountName
                                                            ,h1.displayname 
                                                            ,h2.DisplayName
															)
		 ,Aggregator as (SELECT a.AccountGroupCode
                              ,a.AccountType
                              ,a.DimAccountId
                              ,a.AccountCode
                              ,a.AccountName
                              ,a.DimServiceLocationID
                              ,ServiceLocationFullAddress Address
                              ,ServiceLocationState State
                              ,ServiceLocationCity City
                              ,ServiceLocationPostalCode Zip
                              ,ServiceLocationTaxArea TaxArea
                              ,a.Internal
                              ,a.Courtesy
                              ,a.MilitaryDiscount
                              ,a.SeniorDiscount
                              ,a.PointPause
                                -- ,ci.Componentcode,ItemMarketingDescription,
                                --,Internet
                              ,CASE
                                             WHEN SUM(CAST(sc.IsData AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasData
                              ,CASE
                                             WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasDataSvc
                              ,CASE
                                             WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasSmartHome
                              ,CASE
                                             WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasSmartHomePod
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPointGuard
                                --DataCategory,
                              ,Sum(isnull(sc.IntGrpSvcItemPrice,0)) DataServiceCharge
                              ,Round(SUM(isnull(sc.IntGrpSvcnet,0)),2) DataServiceNetCharge
                              ,Sum(isnull(sc.SmartHomeItemPrice,0)) SmartHomeServiceCharge
                              ,Sum(isnull(sc.SmartHomeNet,0)) SmartHomeServiceNetCharge
                              ,Sum(isnull(sc.SmartHomePodItemPrice,0)) SmartHomePodCharge
                              ,Sum(isnull(sc.SmartHomePodNet,0)) SmartHomePodNetCharge
                              ,Sum(isnull(sc.PointGuardItemPrice,0)) PointGuardCharge
                              ,Sum(isnull(sc.PointGuardNet,0)) PointGuardNetCharge
                              ,SUM(isnull(sc.IntGrpAddOnItemPrice,0)) DataAddOnCharge
                              ,SUM(isnull(sc.IntGrpAddOnnet,0)) DataAddOnNetCharge
                                --Cable,
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCable AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCable
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCableSvc
                              ,CASE
                                             WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasHBO
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCinemax
                              ,CASE
                                             WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasShowtime
                              ,CASE
                                             WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasStarz 
                                --CableCategory,
                              ,case
                                             when pack.DimAccountId is not null
                                             THEN 'Y' ELSE 'N'
                                END HasPackage
                              ,isnull(Pack.RootItemID,'') as PackageID
                              ,case
                                             when count(distinct pack.ParentItemID) = 1 then ParentComponentName + '(' + ltrim(str(count( distinct ParentItemID))) + ')'
                                             when count(distinct pack.ParentItemID) > 1
                                                            then (select string_agg(ParentComponentName, ', ') as ParentList from ChildList where ParentItemID = pack.ParentItemID )
															
                                             else ''
                              
							  end PackageName
							 				  
                               -- ,isNull(ParentComponentName,'') as PackageName
                              ,isnull(Pack.ParentComponentCharge, '') as PackageCharge
                              --,isnull((select string_agg(ChildComponentName, ', ') from ChildList where ParentItemId = pack.ParentItemId),'') as ChildItems
                                -- Add Package Price as sum of Prices of the packages available for an account
                              ,Sum(sc.CabGrpSvcItemPrice) CableServiceCharge
                              ,Round(SUM(sc.CabGrpSvcnet),2) CableServiceNetCharge
                              ,Sum(sc.HBOItemPrice) HBOServiceCharge
                              ,Sum(sc.HBONet) HBONetCharge
                              ,Sum(sc.CinemaxItemPrice) CinemaxServiceCharge
                              ,Sum(sc.CinemaxNet) CinemaxNetCharge
                              ,Sum(sc.ShowtimeItemPrice) ShowtimeServiceCharge
                              ,Sum(sc.ShowtimeNet) ShowtimeNetCharge
                              ,Sum(sc.StarzItemPrice) StarzServiceCharge
                              ,Sum(sc.StarzNet) StarzNetCharge
                              ,SUM(sc.CabGrpAddOnItemPrice) CableAddOnCharge
                              ,SUM(sc.CabGrpAddOnnet) CableAddOnNetCharge
                                --Phone
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPhone
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPhoneSvc
                                --PhnGrp,             
                               ,Sum(sc.PhnGrpSvcItemPrice) PhoneServiceCharge
                              ,Round(SUM(sc.PhnGrpSvcnet),2) PhoneServiceNetCharge
                              ,SUM(sc.PhnGrpAddOnItemPrice) PhoneAddOnCharge
                              ,SUM(sc.PhnGrpAddOnnet) PhoneAddOnNetCharge
                                --Promo
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPromo
                              ,Sum(sc.PromoPrice) PromoCharge
                              ,Round(SUM(sc.Promonet),2) PromoNetCharge
               FROM acct a
                              join ServiceClassify sc on a.DimAccountId = sc.DimAccountId
                                                                                                           AND a.DimServiceLocationId = sc.DimServiceLocationId
                              left join PackageClassify pack on a.DimAccountId = pack.DimAccountId
                                                                                                                            AND a.DimServiceLocationId = pack.DimServiceLocationId
               --where a.AccountCode = 100347795
               GROUP BY a.AccountGroupCode
                                 ,a.AccountType
                                 ,a.DimAccountId
                                 ,a.AccountCode
                                 ,a.AccountName
                                 ,a.DimServiceLocationID
                                 ,ServiceLocationFullAddress
                                 ,ServiceLocationState
                                 ,ServiceLocationCity
                                 ,ServiceLocationPostalCode
                                 ,ServiceLocationTaxArea
                                 ,a.Internal
                                 ,a.Courtesy
                                 ,a.MilitaryDiscount
                                 ,a.SeniorDiscount
                                 ,a.PointPause
                                 ,DataCategory
                                 ,CableCategory
                                 ,case
                                                when pack.DimAccountId is not null
                                                THEN 'Y' ELSE 'N'
                                  END
                                 ,Pack.rootItemId
                                 ,Pack.ParentItemID
                                 ,Pack.ParentComponentName
                                 --,Pack.ChildComponentName
                                 ,Pack.ParentComponentName
                                 ,Pack.DimAccountId
                                 ,Pack.ParentComponentCharge
)
               SELECT distinct a.AccountGroupCode
                              ,a.AccountType
                              ,a.DimAccountId
                              ,a.AccountCode
                              ,a.AccountName
                              ,a.DimServiceLocationID
                              ,ServiceLocationFullAddress Address
                              ,ServiceLocationState State
                              ,ServiceLocationCity City
                              ,ServiceLocationPostalCode Zip
                              ,ServiceLocationTaxArea TaxArea
                              ,a.Internal
                              ,a.Courtesy
                              ,a.MilitaryDiscount
                              ,a.SeniorDiscount
                              ,a.PointPause
                                -- ,ci.Componentcode,ItemMarketingDescription,
                                --,Internet
                              ,CASE
                                             WHEN SUM(CAST(sc.IsData AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasData
                              ,CASE
                                             WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasDataSvc
                              ,CASE
                                             WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasSmartHome
                              ,CASE
                                             WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasSmartHomePod
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPointGuard
        --                        --DataCategory,

							  ,case 
									WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0 
										then (select convert(money, sum(DataServiceCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as DataServiceCharge
                              --,Sum(isnull(sc.IntGrpSvcItemPrice,0)) DataServiceCharge
							  ,case 
									WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0 
										then (select convert(money, sum(DataServiceNetCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as DataServiceNetCharge
                              --,Round(SUM(isnull(sc.IntGrpSvcnet,0)),2) DataServiceNetCharge
							  ,case 
									 WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0 
										then (select convert(money, sum(SmartHomeServiceCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as SmartHomeServiceCharge
                              --,Sum(isnull(sc.SmartHomeItemPrice,0)) SmartHomeServiceCharge
							  ,case 
									 WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0 
										then (select convert(money, sum(SmartHomeServiceNetCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as SmartHomeServiceNetCharge
                              --,Sum(isnull(sc.SmartHomeNet,0)) SmartHomeServiceNetCharge
							  ,case 
									 WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
										then (select convert(money, sum(SmartHomePodCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as SmartHomePodCharge
                              --,Sum(isnull(sc.SmartHomePodItemPrice,0)) SmartHomePodCharge
							  ,case 
									 WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
										then (select convert(money, sum(SmartHomePodNetCharge)) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
								end as SmartHomePodNetCharge
                              --,Sum(isnull(sc.SmartHomePodNet,0)) SmartHomePodNetCharge
							  ,case
								 WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0 
									then (select sum(PointGuardCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as PointGuardCharge
                              --,Sum(isnull(sc.PointGuardItemPrice,0)) PointGuardCharge
							  ,case
								 WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0 
									then (select sum(PointGuardNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as PointGuardNetCharge
                              --,Sum(isnull(sc.PointGuardNet,0)) PointGuardNetCharge
							  ,case
								 WHEN SUM(CAST(sc.IsData AS INT)) > 0 
									then (select sum(DataAddOnCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as DataAddOnCharge
                              --,SUM(isnull(sc.IntGrpAddOnItemPrice,0)) DataAddOnCharge
							  ,case
								 WHEN SUM(CAST(sc.IsData AS INT)) > 0 
									then (select sum(DataAddOnNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as DataAddOnNetCharge
                              --,SUM(isnull(sc.IntGrpAddOnnet,0)) DataAddOnNetCharge
                                --Cable,
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCable AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCable
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCableSvc
                              ,CASE
                                             WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasHBO
                              ,CASE
                                             WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasCinemax
                              ,CASE
                                             WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasShowtime
                              ,CASE
                                             WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasStarz 
                                --CableCategory,
                              ,case
                                             when pack.DimAccountId is not null
                                             THEN 'Y' ELSE 'N'
                                END HasPackage
                              ,case
							  
								    when pack.DimAccountId is not null and (select count(distinct ParentComponentName) from PackageClassify where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId) > 1
										then (select convert(varchar(MAX),string_agg(ParentComponentName,'; ')) from (select distinct ParentComponentName from ChildList where DimAccountId = pack.DimAccountId) as DistinctParentComponents)
				
									when pack.DimAccountId is not null and (select count(distinct ParentComponentName) from PackageClassify where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId) = 1
										then pack.ParentComponentName + '(' + ltrim(str((select count(distinct ParentItemID) from PackageClassify where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId))) + ')'
									else ''
								end PackageName
								,case
								 when pack.DimAccountId is not null
									then (select sum(PackageCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as PackageCharge
							 ,case
								WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
									then (select sum(CableServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CableServiceCharge
                              --,Sum(sc.CabGrpSvcItemPrice) CableServiceCharge
							   ,case
								 WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
									then (select sum(CableServiceNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CableServiceNetCharge
                              --,Round(SUM(sc.CabGrpSvcnet),2) CableServiceNetCharge
							   ,case
								WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
									then (select sum(HBOServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as HBOServiceCharge
                              --,Sum(sc.HBOItemPrice) HBOServiceCharge
							 ,case
								WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
									then (select sum(HBONetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as HBONetCharge
                              --,Sum(sc.HBONet) HBONetCharge
							  ,case
								 WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
									then (select sum(CinemaxServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CinemaxServiceCharge
                              --,Sum(sc.CinemaxItemPrice) CinemaxServiceCharge
							  ,case
								 WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
									then (select sum(CinemaxNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CinemaxNetCharge
                              --,Sum(sc.CinemaxNet) CinemaxNetCharge
							  ,case
								  WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
									then (select sum(ShowtimeServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as ShowtimeServiceCharge
                              --,Sum(sc.ShowtimeItemPrice) ShowtimeServiceCharge
							  ,case
								  WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
									then (select sum(ShowtimeNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as ShowtimeNetCharge
                              --,Sum(sc.ShowtimeNet) ShowtimeNetCharge
							  ,case
								  WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
									then (select sum(StarzServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as StarzServiceCharge
                              --,Sum(sc.StarzItemPrice) StarzServiceCharge
							  ,case
								  WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
									then (select sum(StarzNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as StarzNetCharge
                              --,Sum(sc.StarzNet) StarzNetCharge
							  ,case
								  WHEN SUM(CAST(sc.IsCable AS INT)) > 0
									then (select sum(CableAddOnCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CableAddOnCharge
                              --,SUM(sc.CabGrpAddOnItemPrice) CableAddOnCharge
							  ,case
								  WHEN SUM(CAST(sc.IsCable AS INT)) > 0
									then (select sum(CableAddOnNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
									else 0.00
							  end as CableAddOnNetCharge
                              --,SUM(sc.CabGrpAddOnnet) CableAddOnNetCharge
                                --Phone
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPhone
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPhoneSvc
                                --PhnGrp,  
								,CASE
                                             WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
                                             THEN (select sum(PhoneServiceCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PhoneServiceCharge
                               --,Sum(sc.PhnGrpSvcItemPrice) PhoneServiceCharge
							   ,CASE
                                             WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
                                             THEN (select sum(PhoneServiceNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PhoneServiceNetCharge
                              --,Round(SUM(sc.PhnGrpSvcnet),2) PhoneServiceNetCharge
							  ,CASE
                                             WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
                                             THEN (select sum(PhoneAddOnCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PhoneAddOnCharge
                              --,SUM(sc.PhnGrpAddOnItemPrice) PhoneAddOnCharge
							  ,CASE
                                             WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
                                             THEN (select sum(PhoneAddOnNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PhoneAddOnNetCharge
                              --,SUM(sc.PhnGrpAddOnnet) PhoneAddOnNetCharge
                                --Promo
                              ,CASE
                                             WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
                                             THEN 'Y' ELSE 'N'
                                END HasPromo
							  ,CASE
                                             WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
                                             THEN (select sum(PromoCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PromoCharge
                              --,Sum(sc.PromoPrice) PromoCharge
							  ,CASE
                                             WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
                                             THEN (select sum(PromoNetCharge) from aggregator where AccountCode = a.AccountCode and DimServiceLocationId = a.DimServiceLocationId group by AccountCode) 
											 ELSE 0.00
                                END PromoNetCharge
                              --,Round(SUM(sc.Promonet),2) PromoNetCharge
               FROM acct a
                              join ServiceClassify sc on a.DimAccountId = sc.DimAccountId
                                                                                                           AND a.DimServiceLocationId = sc.DimServiceLocationId
                              left join PackageClassify pack on a.DimAccountId = pack.DimAccountId
                                                                                                                            AND a.DimServiceLocationId = pack.DimServiceLocationId
               --where a.AccountCode = 100203857 --in (100000647,100203857,100020005,100013536,100011881,100007521,100003503,100002526,100000833,100203857,100001126,100347795,100000647,100000833,100000647,100000762,100203857,100210729,100203857,100000233,100000050,100347795,100203857)
            
			   GROUP BY a.AccountGroupCode
                                 ,a.AccountType
                                 ,a.DimAccountId
                                 ,a.AccountCode
                                 ,a.AccountName
                                 ,a.DimServiceLocationID
                                 ,ServiceLocationFullAddress
                                 ,ServiceLocationState
                                 ,ServiceLocationCity
                                 ,ServiceLocationPostalCode
                                 ,ServiceLocationTaxArea
                                 ,a.Internal
                                 ,a.Courtesy
                                 ,a.MilitaryDiscount
                                 ,a.SeniorDiscount
                                 ,a.PointPause
                                 ,DataCategory
                                 ,CableCategory
                                 ,case
                                                when pack.DimAccountId is not null
                                                THEN 'Y' ELSE 'N'
                                  END
                                 ,Pack.rootItemId
                                 ,Pack.ParentItemID
                                 ,Pack.ParentComponentName
                                 --,Pack.ChildComponentName
                                 ,Pack.ParentComponentName
                                 ,Pack.DimAccountId
                                 ,Pack.ParentComponentCharge;
end
GO
