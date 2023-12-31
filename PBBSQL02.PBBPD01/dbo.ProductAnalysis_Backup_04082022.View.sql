USE [PBBPDW01]
GO
/****** Object:  View [dbo].[ProductAnalysis_Backup_04082022]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[ProductAnalysis_Backup_04082022]
as
	WITH cycle_and_zone
		AS (SELECT alsc.DimAccountId
				,alsc.DimServiceLocationId
				,dad.[FM AddressID]
				,dad.[Omnia SrvItemLocationID]
				,alsc.CycleDescription
				,alsc.CycleNumber
				,dad.[Location Zone]
				,dad.Cabinet
				,dad.[Wirecenter Region]
		    FROM [dbo].PBB_AccountLocationServiceClass alsc
			    LEFT JOIN dbo.DimAddressDetails_pbb dad ON alsc.DimServiceLocationId = dad.DimServiceLocationId
		    GROUP BY alsc.DimAccountId
				  ,alsc.DimServiceLocationId
				  ,dad.[FM AddressID]
				  ,dad.[Omnia SrvItemLocationID]
				  ,alsc.CycleDescription
				  ,alsc.CycleNumber
				  ,dad.[Location Zone]
				  ,dad.Cabinet
				  ,dad.[Wirecenter Region]),
		acct
		AS (SELECT sli.DimAccountId
				,a.accountcode
				,a.AccountName
				,a.AccountActivationDate
				,a.AccountDeactivationDate
				,a.AccountStatus
				,a.AccountPhoneNumber
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
				,ServiceLocationRegion_WireCenter SalesRegion
				,slp.pbb_LocationProjectCode ProjectCode
				,sl.ServiceLocationStreet StreetName
				,BillingAddressStreetLine1
				,BillingAddressStreetLine2
				,BillingAddressStreetLine3
				,BillingAddressStreetLine4
				,BillingAddressCity
				,BillingAddressState
				,BillingAddressPostalCode
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON sli.DimAccountId = a.DimAccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation_pbb slp on sl.LocationId = slp.LocationId
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
				  ,a.AccountActivationDate
				  ,a.AccountDeactivationDate
				  ,a.AccountStatus
				  ,a.AccountPhoneNumber
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
				  ,ServiceLocationTaxArea
				  ,ServiceLocationRegion_WireCenter
				  ,slp.pbb_LocationProjectCode
				  ,sl.ServiceLocationStreet
				  ,BillingAddressStreetLine1
				  ,BillingAddressStreetLine2
				  ,BillingAddressStreetLine3
				  ,BillingAddressStreetLine4
				  ,BillingAddressCity
				  ,BillingAddressState
				  ,BillingAddressPostalCode),
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
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS IntGrpSvcnet
			   -- cabGrp
			  ,CASE
				  WHEN IsCableSvc = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS CabGrpSvcItemPrice
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
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS CabGrpAddOnnet
			   -- SmartHome
			  ,CASE
				  WHEN [IsSmartHome] = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS SmartHomeItemPrice
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
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS SmartHomePodnet 
			   --PointGuard
			  ,CASE
				  WHEN [IsPointGuard] = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PointGuardItemPrice
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
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS IntGrpAddOnnet
			   --phnGrp 
			  ,CASE
				  WHEN IsLocalPhn = 1
					  or IsComplexPhn = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PhnGrpSvcItemPrice
			  ,CASE
				  WHEN IsLocalPhn = 1
					  or IsComplexPhn = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS PhnGrpSvcnet
			   --OtherAddOn
			  ,CASE
				  WHEN IsPhone = 1
					  and IsLocalPhn = 0
					  and IsComplexPhn = 0
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PhnGrpAddOnItemPrice
			  ,CASE
				  WHEN IsPhone = 1
					  and IsLocalPhn = 0
					  and IsComplexPhn = 0
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS PhnGrpAddOnnet
			  ,CASE
				  WHEN IsPromo = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PromoPrice
			  ,CASE
				  WHEN IsPromo = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS Promonet
			  ,CASE
				  WHEN IsTaxOrFee = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS TaxOrFeePrice
			  ,CASE
				  WHEN IsTaxOrFee = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS TaxFeeNet
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
			  ,SUM(CAST(pc.IsComplexPhn AS INT)) IsComplexSvc
			  ,SUM(CAST(pc.IsTaxOrFee AS INT)) IsTaxOrFee
		 FROM
			 (
				select distinct 
					  DimCustomerItemId
					 ,DimCatalogItemId
					 ,dimaccountid
					 ,dimservicelocationid
					 ,itemprice
					 ,itemid
					 ,itemquantity
					 ,Activation_DimDateId
					 ,Deactivation_DimDateId
					 ,EffectiveEndDate
					 ,EffectiveStartDate
				from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem]
			 ) sli
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
			  AND PC.ComponentClass <> 'Package'
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
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--SmartHome
			    ,CASE
				    WHEN [IsSmartHome] = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
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
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END 
				--PointGuard
			    ,CASE
				    WHEN [IsPointGuard] = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
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
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,CASE
				    WHEN IsCableSvc = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
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
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,CASE
				    WHEN IsLocalPhn = 1
					    or IsComplexPhn = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsLocalPhn = 1
					    or IsComplexPhn = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--OtherAddOn
			    ,CASE
				    WHEN IsPhone = 1
					    and IsLocalPhn = 0
					    and IsComplexPhn = 0
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsPhone = 1
					    and IsLocalPhn = 0
					    and IsComplexPhn = 0
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,CASE
				    WHEN IsPromo = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsPromo = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,CASE
				    WHEN IsTaxOrFee = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsTaxOrFee = 1
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
				,a.AccountCode
				,a.AccountName
				,DSL.DimServiceLocationId
				 --,fci.ItemID
				,case
					when count(distinct fci.itemid) > 1
					then dcat.itemprintdescription + ' (' + cast(count(distinct fci.itemid) as nvarchar(100)) + ')' else dcat.itemprintdescription
				 end as Package
				,sum(fci.ItemPrice) as TotalPackageCharge
		    from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
			    JOIN DimCustomerItem dci on fci.DimCustomerItemId = dci.DimCustomerItemId
			    join DimCatalogItem dcat on fci.DimCatalogItemId = dcat.DimCatalogItemId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a on a.DimAccountId = fci.DimAccountId
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] prd on dcat.ComponentCode = prd.ComponentCode
			    inner join [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation DSL on fci.DimServiceLocationId = DSL.DimServiceLocationId
		    where prd.ComponentClassID = 200
				and Activation_DimDateId <= GETDATE()
				AND Deactivation_DimDateId > GETDATE()
				AND EffectiveStartDate <= GETDATE()
				AND EffectiveEndDate > GETDATE()
				and isnull(ItemDeactivationDate,'12-31-2050') > getdate()
				AND fci.DimAccountId <> 0
		    group by a.DimAccountId
				  ,a.AccountCode
				  ,a.AccountName
				  ,DSL.DimServiceLocationId
				  ,dcat.itemprintdescription),
		PackageSummary
		as (select dimaccountid
				,accountcode
				,accountname
				,DimServiceLocationid
				,Package = stuff(
				 (
					Select distinct 
						  '; ' + Package
					from PackageClassify IPC
					where IPC.accountcode = PC.accountcode
						 and IPC.dimservicelocationid = PC.DimservicelocationID for xml path('')
				 ),1,2,'')
				,sum(TotalPackageCharge) TotalPackageCharge
		    from PackageClassify PC
		    --	where accountcode = 300411828
		    group by DimAccountId
				  ,accountcode
				  ,accountname
				  ,DimServiceLocationid)
		SELECT a.AccountGroupCode
			 ,a.AccountType
			 ,a.DimAccountId
			 ,a.AccountCode
			 ,a.AccountName
			 ,a.AccountActivationDate
			 ,a.AccountDeactivationDate
			 ,a.AccountStatus
			 ,a.AccountPhoneNumber
			 ,a.DimServiceLocationID
			 ,cz.[FM AddressID]
			 ,cz.[Omnia SrvItemLocationID]
			 ,ServiceLocationFullAddress ServiceAddress
			 ,StreetName ServiceStreetName
			 ,ServiceLocationState ServiceState
			 ,ServiceLocationCity ServiceCity
			 ,ServiceLocationPostalCode ServicePostalCode
			 ,ServiceLocationTaxArea ServiceTaxArea
			 ,SalesRegion ServiceSalesRegion
			 ,ProjectCode ServiceProjectCode
			 ,BillingAddressStreetLine1 BillingAddressLine1
			 ,BillingAddressStreetLine2 BillingAddressLine2
			 ,BillingAddressStreetLine3 BillingAddressLine3
			 ,BillingAddressStreetLine4 BillingAddressLine4
			 ,BillingAddressCity
			 ,BillingAddressState
			 ,BillingAddressPostalCode
			 ,cz.CycleDescription
			 ,cz.CycleNumber
			 ,cz.[Location Zone]
			 ,cz.Cabinet
			 ,cz.[Wirecenter Region]
			 ,a.Internal
			 ,a.Courtesy
			 ,a.MilitaryDiscount
			 ,a.SeniorDiscount
			 ,a.PointPause
			  --Package
			 ,case
				 when pack.DimAccountId is not null
				 THEN 'Y' ELSE 'N'
			  END HasPackage
			 ,isnull(Package,'') Package
			 ,isnull(TotalPackageCharge,'') TotalPackageCharge
			  --,Internet
			 ,CASE
				 WHEN SUM(CAST(sc.IsData AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasData
			 ,CASE
				 WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasDataSvc
			 ,isnull(DataCategory,'') DataCategory
			 ,isnull(agg.DataSvc,'') DataSvc
			 ,cast(Sum(isnull(sc.IntGrpSvcItemPrice,0) * IsDataSvc) as money) DataServiceCharge
			 ,cast(Round(SUM(isnull(sc.IntGrpSvcnet,0) * IsDataSvc),2) as money) DataServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasSmartHome
			 ,cast(Sum(isnull(sc.SmartHomeItemPrice,0) * IsSmartHome) as money) SmartHomeServiceCharge
			 ,cast(Sum(isnull(sc.SmartHomeNet,0) * IsSmartHome) as money) SmartHomeServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasSmartHomePod
			 ,cast(Sum(isnull(sc.SmartHomePodItemPrice,0) * IsSmartHomePod) as money) SmartHomePodCharge
			 ,cast(Sum(isnull(sc.SmartHomePodNet,0) * IsSmartHomePod) as money) SmartHomePodNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPointGuard
			 ,cast(Sum(isnull(sc.PointGuardItemPrice,0) * IsPointGuard) as money) PointGuardCharge
			 ,cast(Sum(isnull(sc.PointGuardNet,0) * IsPointGuard) as money) PointGuardNetCharge
			 ,cast(SUM(isnull(sc.IntGrpAddOnItemPrice,0) * IsData) as money) DataAddOnCharge
			 ,cast(SUM(isnull(sc.IntGrpAddOnnet,0) * IsData) as money) DataAddOnNetCharge
			  --Cable,
			 ,CASE
				 WHEN SUM(CAST(sc.IsCable AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasCable
			 ,CASE
				 WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasCableSvc
			 ,isnull(CableCategory,'') CableCategory
			 ,isnull(agg.CableSvc,'') CableSvc
			 ,cast(Sum(sc.CabGrpSvcItemPrice * IsCableSvc) as money) CableServiceCharge
			 ,cast(Round(SUM(sc.CabGrpSvcnet * IsCableSvc),2) as money) CableServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasHBO
			 ,cast(Sum(sc.HBOItemPrice * IsHBO) as money) HBOServiceCharge
			 ,cast(Sum(sc.HBONet * IsHBO) as money) HBONetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasCinemax
			 ,cast(Sum(sc.CinemaxItemPrice * IsCinemax) as money) CinemaxServiceCharge
			 ,cast(Sum(sc.CinemaxNet * IsCinemax) as money) CinemaxNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasShowtime
			 ,cast(Sum(sc.ShowtimeItemPrice * IsShowtime) as money) ShowtimeServiceCharge
			 ,cast(Sum(sc.ShowtimeNet * IsShowtime) as money) ShowtimeNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasStarz
			 ,cast(Sum(sc.StarzItemPrice * IsStarz) as money) StarzServiceCharge
			 ,cast(Sum(sc.StarzNet * IsStarz) as money) StarzNetCharge
			 ,cast(SUM(sc.CabGrpAddOnItemPrice * IsCable) as money) CableAddOnCharge
			 ,cast(SUM(sc.CabGrpAddOnnet * IsCable) as money) CableAddOnNetCharge
			  --Phone
			 ,CASE
				 WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPhone
			 ,CASE
				 WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPhoneSvc
			 ,CASE
				 WHEN SUM(CAST(sc.IsComplexSvc AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasComplexPhoneSvc
			 ,isnull(agg.PhoneSvc,'') PhoneSvc
			  --PhnGrp,             
			 ,cast(Sum((PhnGrpSvcItemPrice * IsPhoneSvc) + (PhnGrpSvcItemPrice * IsComplexSvc)) as money) PhoneServiceCharge
			 ,cast(Sum((PhnGrpSvcnet * IsPhoneSvc) + (PhnGrpSvcnet * IsComplexSvc)) as money) PhoneServiceNetCharge
			 ,cast(SUM(sc.PhnGrpAddOnItemPrice * IsPhone) as money) PhoneAddOnCharge
			 ,cast(SUM(sc.PhnGrpAddOnnet * IsPhone) as money) PhoneAddOnNetCharge
			  --Promo
			 ,CASE
				 WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPromo
			 ,cast(Sum(sc.PromoPrice * IsPromo) as money) PromoCharge
			 ,cast(Round(SUM(sc.Promonet * IsPromo),2) as money) PromoNetCharge
			  --TaxOrFee
			 ,CASE
				 WHEN SUM(CAST(sc.IsTaxOrFee AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasTaxOrFee
			 ,cast(Sum(sc.TaxOrFeePrice * IsTaxOrFee) as money) TaxFeeCharge
			 ,cast(Round(SUM(sc.TaxFeeNet * IsTaxOrFee),2) as money) TaxFeeNetCharge
		-- select *
		FROM acct a
			JOIN cycle_and_zone cz ON a.DimAccountId = cz.DimAccountId
								 AND a.DimServiceLocationId = cz.DimServiceLocationId
			join ServiceClassify sc on a.DimAccountId = sc.DimAccountId
								  AND a.DimServiceLocationId = sc.DimServiceLocationId
			Left join dbo.[PBB_AccountLocation_ServicesBrokenOut_Aggregation](getdate(),', ') agg on a.DimAccountId = agg.dimaccountid
																				    and a.DimServiceLocationId = agg.dimservicelocationid
			left join PackageSummary pack on a.DimAccountId = pack.DimAccountId
									   AND a.DimServiceLocationId = pack.DimServiceLocationId
		GROUP BY a.AccountGroupCode
			   ,a.AccountType
			   ,a.DimAccountId
			   ,a.AccountCode
			   ,a.AccountName
			   ,a.AccountActivationDate
			   ,a.AccountDeactivationDate
			   ,a.AccountStatus
			   ,a.AccountPhoneNumber
			   ,a.DimServiceLocationID
			   ,cz.[FM AddressID]
			   ,cz.[Omnia SrvItemLocationID]
			   ,ServiceLocationFullAddress
			   ,StreetName
			   ,ServiceLocationState
			   ,ServiceLocationCity
			   ,ServiceLocationPostalCode
			   ,ServiceLocationTaxArea
			   ,SalesRegion
			   ,ProjectCode
			   ,BillingAddressStreetLine1
			   ,BillingAddressStreetLine2
			   ,BillingAddressStreetLine3
			   ,BillingAddressStreetLine4
			   ,BillingAddressCity
			   ,BillingAddressState
			   ,BillingAddressPostalCode
			   ,cz.CycleDescription
			   ,cz.CycleNumber
			   ,cz.[Location Zone]
			   ,cz.Cabinet
			   ,cz.[Wirecenter Region]
			   ,a.Internal
			   ,a.Courtesy
			   ,a.MilitaryDiscount
			   ,a.SeniorDiscount
			   ,a.PointPause
			   ,DataCategory
			   ,isnull(agg.DataSvc,'')
			   ,CableCategory
			   ,isnull(agg.CableSvc,'')
			   ,isnull(agg.PhoneSvc,'')
			   ,case
				   when pack.DimAccountId is not null
				   THEN 'Y' ELSE 'N'
			    END
			   ,Package
			   ,TotalPackageCharge

GO
