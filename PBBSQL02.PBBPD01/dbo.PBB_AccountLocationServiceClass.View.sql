USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_AccountLocationServiceClass]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[PBB_AccountLocationServiceClass]
as
	WITH acct
		AS (SELECT sli.DimAccountId
				,a.accountcode
				,a.AccountName
				,a.AccountPhoneNumber
				,lower(a.AccountEMailAddress) as AccountEmailAddress
				,ac.CycleDescription
				,CycleNumber
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
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON sli.DimAccountId = a.DimAccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac ON ac.DimAccountCategoryId = sli.DimAccountCategoryId
		    WHERE Activation_DimDateId <= GETDATE()
				AND Deactivation_DimDateId > GETDATE()
				AND EffectiveStartDate <= GETDATE()
				AND EffectiveEndDate > GETDATE()
				AND sli.DimAccountId <> 0
		    GROUP BY sli.DimAccountId
				  ,a.accountname
				  ,AccountPhoneNumber
				  ,AccountEmailAddress
				  ,CycleDescription
				  ,CycleNumber
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
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdInternetRank r ON pc.SpeedTier = r.Category
		    WHERE Activation_DimDateId <= GETDATE()
				AND Deactivation_DimDateId > GETDATE()
				AND EffectiveStartDate <= GETDATE()
				AND EffectiveEndDate > GETDATE()
		    GROUP BY sli.DimAccountId
				  ,sli.DimServiceLocationID),
		cablecat
		AS (SELECT DISTINCT 
				 sli.DimAccountId
				,sli.DimServiceLocationID
				,MAX(ISNULL(r.rnk,0)) rnk
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdCableRank r ON pc.Category = r.Category
		    WHERE Activation_DimDateId <= GETDATE()
				AND Deactivation_DimDateId > GETDATE()
				AND EffectiveStartDate <= GETDATE()
				AND EffectiveEndDate > GETDATE()
		    GROUP BY sli.DimAccountId
				  ,sli.DimServiceLocationID),
		ServiceClassify
		as
		--select * from prdcomponentmap
		(SELECT sli.DimAccountId
			  ,a.accountcode
			  ,sli.DimServiceLocationID
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
			LEFT JOIN DimCustomerItem di on sli.DimCustomerItemId = di.DimCustomerItemId
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
			  AND sli.DimAccountId <> 0
			  AND pc.IsIgnored = 0
			  and isnull(di.ItemDeactivationDate,'12-31-2050') > getdate() 
			  and sli.dimcustomeritemid <> 0
		 GROUP BY sli.DimAccountId
			    ,a.accountcode
			    ,sli.DimServiceLocationID
			    ,irnk.Category
			    ,cirnk.Category)
	
		SELECT AccountGroupCode
			 ,AccountType
			 ,a.DimAccountId
			 ,a.AccountCode
			 ,a.AccountName
			 ,AccountPhoneNumber
			 ,AccountEmailAddress
			 ,CycleDescription
			 ,CycleNumber
			 ,a.DimServiceLocationID
			 ,ServiceLocationFullAddress Address
			 ,ServiceLocationState State
			 ,ServiceLocationCity City
			 ,ServiceLocationPostalCode Zip
			 ,ServiceLocationTaxArea TaxArea
			 ,Internal
			 ,Courtesy
			 ,MilitaryDiscount
			 ,SeniorDiscount
			 ,PointPause
			  --Internet
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
			 ,DataCategory
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
			 ,CableCategory				 
			 ,CASE
				 WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPhone
			 ,CASE
				 WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPhoneSvc
		FROM acct a
			join ServiceClassify sc on a.DimAccountId = sc.DimAccountId
								  AND a.DimServiceLocationId = sc.DimServiceLocationId
		GROUP BY AccountGroupCode
			   ,AccountType
			   ,a.DimAccountId
			   ,a.AccountCode
			   ,a.AccountName
			   ,AccountPhoneNumber
			   ,AccountEmailAddress
			   ,CycleDescription
			   ,CycleNumber
			   ,a.DimServiceLocationID
			   ,ServiceLocationFullAddress
			   ,ServiceLocationState
			   ,ServiceLocationCity
			   ,ServiceLocationPostalCode
			   ,ServiceLocationTaxArea
			   ,Internal
			   ,Courtesy
			   ,MilitaryDiscount
			   ,SeniorDiscount
			   ,PointPause
			   ,DataCategory
			   ,CableCategory;
GO
