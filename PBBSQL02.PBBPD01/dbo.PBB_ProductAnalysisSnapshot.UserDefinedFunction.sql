USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_ProductAnalysisSnapshot]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * into FactProductAnalysis_pbb from [dbo].[PBB_ProductAnalysisSnapshot]('4/1/2022')
*/

CREATE function [dbo].[PBB_ProductAnalysisSnapshot](
			@ReportDate date)
RETURNS TABLE
as
	return
	WITH acct
		AS (SELECT DISTINCT 
				 sli.DimAccountId
				,a.accountcode
				,sl.LocationId
				,a.AccountName
				,a.AccountActivationDate
				,a.AccountDeactivationDate
				,a.AccountStatus
				,a.AccountPhoneNumber as PhoneNumber
				,a.AccountEMailAddress as Email
				,sli.DimServiceLocationID
				,dad.[FM AddressID]
				,dad.[Omnia SrvItemLocationID]
				,ac.CycleDescription
				,CycleNumber
				,dad.[Location Zone]
				,dad.Cabinet
				,dad.[Wirecenter Region]
				,rp.AutoPay
				,CASE
					WHEN a.PrintGroup = 'Electronic Invoice'
					THEN 'Y' ELSE 'N'
				 END as Ebill_Flag---added ebillflag logic
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
				,sl.ServiceLocationFullAddress
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
			    JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON sli.DimAccountId = a.DimAccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb apbb ON a.AccountId = apbb.AccountId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation_pbb slp ON sl.LocationId = slp.LocationId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac ON ac.DimAccountCategoryId = sli.DimAccountCategoryId
			    LEFT JOIN dbo.DimAddressDetails_pbb dad ON sli.DimServiceLocationId = dad.DimServiceLocationId
			    LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod AutoPay on AutoPay.accountcode = a.AccountCode
			    LEFT JOIN
			    (
				   SELECT AccountCode
					    ,STRING_AGG(CONVERT(NVARCHAR(MAX),Method),', ') AS AutoPay
				   FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod
				   GROUP BY AccountCode
			    ) rp ON rp.AccountCode = a.AccountCode
		    WHERE Activation_DimDateId <= @ReportDate
				AND Deactivation_DimDateId > @ReportDate
				AND EffectiveStartDate <= @ReportDate
				AND EffectiveEndDate > @ReportDate
				AND isnull(ItemDeactivationDate,'12-31-2050') > @ReportDate
				AND sli.DimAccountId <> 0
		    GROUP BY sli.DimAccountId
				  ,a.accountname
				  ,sl.LocationId
				  ,a.accountcode
				  ,a.AccountActivationDate
				  ,a.AccountDeactivationDate
				  ,a.AccountStatus
				  ,a.AccountPhoneNumber
				  ,a.AccountEMailAddress
				  ,sli.DimServiceLocationID
				  ,dad.[FM AddressID]
				  ,dad.[Omnia SrvItemLocationID]
				  ,ac.CycleDescription
				  ,CycleNumber
				  ,dad.[Location Zone]
				  ,dad.Cabinet
				  ,dad.[Wirecenter Region]
				  ,CASE
					  WHEN a.PrintGroup = 'Electronic Invoice'
					  THEN 'Y' ELSE 'N'
				   END
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
				  ,sl.ServiceLocationFullAddress
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
				  ,BillingAddressPostalCode
				  ,rp.AutoPay),

/*	AutoPay as
(SELECT distinct arp.AccountCode, 
                STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS AutoPay
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod arp
		 Join  [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a
		 ON a.AccountCode=arp.AccountCode 
         GROUP BY arp.AccountCode),*/
		mininstalldate
		AS (SELECT DISTINCT 
				 sli.DimAccountId
				,sli.DimServiceLocationID
				,Min(itemactivationdate) FirstServiceInstallDate
				,max(isnull(itemdeactivationdate,'12-31-2050')) LastServiceDisconnectDate
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
		    WHERE Activation_DimDateId <= @ReportDate
				AND Deactivation_DimDateId > @ReportDate
				AND EffectiveStartDate <= @ReportDate
				AND EffectiveEndDate > @ReportDate
		    GROUP BY sli.DimAccountId
				  ,sli.DimServiceLocationID),
		IntCat
		AS (SELECT DISTINCT 
				 sli.DimAccountId
				,sli.DimServiceLocationID
				,MAX(ISNULL(r.rnk,0)) rnk
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
			    JOIN PrdInternetRank r ON pc.SpeedTier = r.Category
		    WHERE Activation_DimDateId <= @ReportDate
				AND Deactivation_DimDateId > @ReportDate
				AND EffectiveStartDate <= @ReportDate
				AND EffectiveEndDate > @ReportDate
				AND isnull(ItemDeactivationDate,'12-31-2050') > @ReportDate
		    GROUP BY sli.DimAccountId
				  ,sli.DimServiceLocationID),
		cablecat
		AS (SELECT DISTINCT 
				 sli.DimAccountId
				,sli.DimServiceLocationID
				,MAX(ISNULL(r.rnk,0)) rnk
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			    JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			    JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
			    JOIN PrdCableRank r ON pc.Category = r.Category
		    WHERE Activation_DimDateId <= @ReportDate
				AND Deactivation_DimDateId > @ReportDate
				AND EffectiveStartDate <= @ReportDate
				AND EffectiveEndDate > @ReportDate
				AND isnull(ItemDeactivationDate,'12-31-2050') > @ReportDate
		    GROUP BY sli.DimAccountId
				  ,sli.DimServiceLocationID),
		ServiceClassify
		AS
		--select * from prdcomponentmap
		(SELECT DISTINCT 
			   sli.DimAccountId
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
					  OR HBOQV = 1
					  OR HBOSA = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS HBOItemPrice
			  ,CASE
				  WHEN [HBOBulk] = 1
					  OR HBOQV = 1
					  OR HBOSA = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS HBOnet
			   --Cinemax
			  ,CASE
				  WHEN Cinemax_Standalone_QV = 1
					  OR Cinemax_Standalone_SA = 1
					  OR Cinemax_pkg_qv = 1
					  OR Cinemax_Pkg_SA = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS CinemaxItemPrice
			  ,CASE
				  WHEN Cinemax_Standalone_QV = 1
					  OR Cinemax_Standalone_SA = 1
					  OR Cinemax_pkg_qv = 1
					  OR Cinemax_Pkg_SA = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS Cinemaxnet
			   --Showtime
			  ,CASE
				  WHEN Showtime_QV = 1
					  OR Showtime_SA = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS ShowtimeItemPrice
			  ,CASE
				  WHEN Showtime_QV = 1
					  OR Showtime_SA = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS Showtimenet
			   --Starz
			  ,CASE
				  WHEN Starz_QV = 1
					  OR Starz_SA = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS StarzItemPrice
			  ,CASE
				  WHEN Starz_QV = 1
					  OR Starz_SA = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS Starznet
			   --OtherAddOn
			  ,CASE
				  WHEN IsCable = 1
					  AND HBOBulk = 0
					  AND HBOQV = 0
					  AND HBOSA = 0
					  AND Cinemax_pkg_qv = 0
					  AND Cinemax_Pkg_SA = 0
					  AND Cinemax_Standalone_QV = 0
					  AND Cinemax_Standalone_SA = 0
					  AND Showtime_QV = 0
					  AND Showtime_SA = 0
					  AND Starz_QV = 0
					  AND Starz_SA = 0
					  AND IsCableSvc = 0
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS CabGrpAddOnItemPrice
			  ,CASE
				  WHEN IsCable = 1
					  AND HBOBulk = 0
					  AND HBOQV = 0
					  AND HBOSA = 0
					  AND Cinemax_pkg_qv = 0
					  AND Cinemax_Pkg_SA = 0
					  AND Cinemax_Standalone_QV = 0
					  AND Cinemax_Standalone_SA = 0
					  AND Showtime_QV = 0
					  AND Showtime_SA = 0
					  AND Starz_QV = 0
					  AND Starz_SA = 0
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
					  AND IsSmartHome = 0
					  AND IsSmartHomePod = 0
					  AND IsPointGuard = 0
					  AND IsDataSvc = 0
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS IntGrpAddOnItemPrice
			  ,CASE
				  WHEN IsData = 1
					  AND IsSmartHome = 0
					  AND IsSmartHomePod = 0
					  AND IsPointGuard = 0
					  AND IsDataSvc = 0
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS IntGrpAddOnnet
			   --phnGrp 
			  ,CASE
				  WHEN IsLocalPhn = 1
					  OR IsComplexPhn = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PhnGrpSvcItemPrice
			  ,CASE
				  WHEN IsLocalPhn = 1
					  OR IsComplexPhn = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS PhnGrpSvcnet
			   --OtherAddOn
			  ,CASE
				  WHEN IsPhone = 1
					  AND IsLocalPhn = 0
					  AND IsComplexPhn = 0
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS PhnGrpAddOnItemPrice
			  ,CASE
				  WHEN IsPhone = 1
					  AND IsLocalPhn = 0
					  AND IsComplexPhn = 0
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
			   --IsOther
			  ,CASE
				  WHEN IsOther = 1
				  THEN(ItemPrice * ItemQuantity) ELSE 0
			   END AS OtherPrice
			  ,CASE
				  WHEN IsOther = 1
				  THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
			   END AS OtherNet
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
			  ,Sum(CAST(pc.IsOther AS INT)) IsOther
			  ,Sum(CAST(pc.IsEmployee AS INT)) IsEmployee
		 FROM
			 (
				SELECT DISTINCT 
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
				FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem]
			 ) sli
			 JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
			 JOIN acct a ON sli.DimAccountId = a.DimAccountId
						 AND sli.DimServiceLocationId = a.DimServiceLocationId
			 JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
			 LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
			 LEFT JOIN intcat ir ON sli.DimAccountId = ir.DimAccountId
							    AND sli.DimServiceLocationId = ir.DimServiceLocationId
			 LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdInternetRank irnk ON ir.rnk = irnk.Rnk
			 LEFT JOIN cablecat cir ON sli.DimAccountId = cir.DimAccountId
								  AND sli.DimServiceLocationId = cir.DimServiceLocationId
			 LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdCableRank cirnk ON cir.rnk = cirnk.Rnk
		 WHERE Activation_DimDateId <= @ReportDate
			  AND Deactivation_DimDateId > @ReportDate
			  AND EffectiveStartDate <= @ReportDate
			  AND EffectiveEndDate > @ReportDate
			  AND isnull(ItemDeactivationDate,'12-31-2050') > @ReportDate
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
					    AND IsSmartHome = 0
					    AND IsSmartHomePod = 0
					    AND IsPointGuard = 0
					    AND IsDataSvc = 0
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsData = 1
					    AND IsSmartHome = 0
					    AND IsSmartHomePod = 0
					    AND IsPointGuard = 0
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
					    OR HBOQV = 1
					    OR HBOSA = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN [HBOBulk] = 1
					    OR HBOQV = 1
					    OR HBOSA = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--Cinemax
			    ,CASE
				    WHEN Cinemax_Standalone_QV = 1
					    OR Cinemax_Standalone_SA = 1
					    OR Cinemax_pkg_qv = 1
					    OR Cinemax_Pkg_SA = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN Cinemax_Standalone_QV = 1
					    OR Cinemax_Standalone_SA = 1
					    OR Cinemax_pkg_qv = 1
					    OR Cinemax_Pkg_SA = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--Showtime
			    ,CASE
				    WHEN Showtime_QV = 1
					    OR Showtime_SA = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN Showtime_QV = 1
					    OR Showtime_SA = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--Starz
			    ,CASE
				    WHEN Starz_QV = 1
					    OR Starz_SA = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN Starz_QV = 1
					    OR Starz_SA = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--OtherAddOn
			    ,CASE
				    WHEN IsCable = 1
					    AND HBOBulk = 0
					    AND HBOQV = 0
					    AND HBOSA = 0
					    AND Cinemax_pkg_qv = 0
					    AND Cinemax_Pkg_SA = 0
					    AND Cinemax_Standalone_QV = 0
					    AND Cinemax_Standalone_SA = 0
					    AND Showtime_QV = 0
					    AND Showtime_SA = 0
					    AND Starz_QV = 0
					    AND Starz_SA = 0
					    AND IsCableSvc = 0
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsCable = 1
					    AND HBOBulk = 0
					    AND HBOQV = 0
					    AND HBOSA = 0
					    AND Cinemax_pkg_qv = 0
					    AND Cinemax_Pkg_SA = 0
					    AND Cinemax_Standalone_QV = 0
					    AND Cinemax_Standalone_SA = 0
					    AND Showtime_QV = 0
					    AND Showtime_SA = 0
					    AND Starz_QV = 0
					    AND Starz_SA = 0
					    AND IsCableSvc = 0
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,CASE
				    WHEN IsLocalPhn = 1
					    OR IsComplexPhn = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsLocalPhn = 1
					    OR IsComplexPhn = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
				--OtherAddOn
			    ,CASE
				    WHEN IsPhone = 1
					    AND IsLocalPhn = 0
					    AND IsComplexPhn = 0
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsPhone = 1
					    AND IsLocalPhn = 0
					    AND IsComplexPhn = 0
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
				--IsOther
			    ,CASE
				    WHEN IsOther = 1
				    THEN(ItemPrice * ItemQuantity) ELSE 0
				END
			    ,CASE
				    WHEN IsOther = 1
				    THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc),2) ELSE 0
				END
			    ,ServiceLocationState
			    ,ServiceLocationCity
			    ,ServiceLocationPostalCode
			    ,ServiceLocationTaxArea
			    ,irnk.Category
			    ,cirnk.Category),
		PackageClassify
		AS (SELECT DISTINCT 
				 a.DimAccountId
				,a.AccountCode
				,a.AccountName
				,DSL.DimServiceLocationId
				 --,fci.ItemID
				,CASE
					WHEN count(DISTINCT fci.itemid) > 1
					THEN dcat.itemprintdescription + ' (' + cast(count(DISTINCT fci.itemid) AS NVARCHAR(100)) + ')' ELSE dcat.itemprintdescription
				 END AS Package
				,sum(fci.ItemPrice) AS TotalPackageCharge
		    FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
			    JOIN DimCustomerItem dci ON fci.DimCustomerItemId = dci.DimCustomerItemId
			    JOIN DimCatalogItem dcat ON fci.DimCatalogItemId = dcat.DimCatalogItemId
			    INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON a.DimAccountId = fci.DimAccountId
			    INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] prd ON dcat.ComponentCode = prd.ComponentCode
			    INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation DSL ON fci.DimServiceLocationId = DSL.DimServiceLocationId
		    WHERE prd.ComponentClassID = 200
				AND Activation_DimDateId <= @ReportDate
				AND Deactivation_DimDateId > @ReportDate
				AND EffectiveStartDate <= @ReportDate
				AND EffectiveEndDate > @ReportDate
				AND isnull(ItemDeactivationDate,'12-31-2050') > @ReportDate
				AND fci.DimAccountId <> 0
		    GROUP BY a.DimAccountId
				  ,a.AccountCode
				  ,a.AccountName
				  ,DSL.DimServiceLocationId
				  ,dcat.itemprintdescription),
		PackageSummary
		AS (SELECT DISTINCT 
				 dimaccountid
				,accountcode
				,accountname
				,DimServiceLocationid
				,Package = stuff(
				 (
					SELECT DISTINCT 
						  '; ' + Package
					FROM PackageClassify IPC
					WHERE IPC.accountcode = PC.accountcode
						 AND IPC.dimservicelocationid = PC.DimservicelocationID FOR XML path('')
				 ),1,2,'')
				,sum(TotalPackageCharge) TotalPackageCharge
		    FROM PackageClassify PC
		    --	where accountcode = 300411828
		    GROUP BY DimAccountId
				  ,accountcode
				  ,accountname
				  ,DimServiceLocationid),
		PackageParts
		AS (SELECT x.AccountCode
				,x.LocationId
				,sum(case
					    when ComponentClass = 'CALL FEATURES'
						    and L5_DisplayName like '%Line%'
					    then DisperseAmount else 0
					end) PhoneServiceCharge
				,sum(case
					    when ComponentClass = 'CALL FEATURES'
						    and L5_DisplayName not like '%Line%'
					    then DisperseAmount
					    when ComponentClass = 'LD SRV ITEM SPECIFIC CALL PLAN'
					    then DisperseAmount else 0
					end) PhoneAddOnCharge
				,sum(case
					    when ComponentClass like '%Internet%'
						    and L5_DisplayName <> 'Smart Home'
					    then DisperseAmount else 0
					end) DataServiceCharge
				,sum(case
					    when ComponentClass = 'INTERNET FEATURES'
						    and L5_DisplayName = 'Smart Home'
					    then DisperseAmount else 0
					end) SmartHomeCharge
				,sum(case
					    when Componentclass = 'GENERAL USE'
					    then DisperseAmount else 0
					end) PromoCharge
				,min(Allocateable) Allocateable
				,max(case
					    when Allocateable = 'Y'
					    then 1 else 0
					end) AllocateFlag
				,sum(case
					    when Allocateable = 'Y'
					    then DisperseAmount else 0
					end) DisperseAmount
				,sum(case
					    when Allocateable = 'N'
					    then UnallocatedCharge else 0
					end) UnallocatedPkgAmount
		    FROM
			    (
				   SELECT AccountCode
					    ,sh.LocationId
					    ,L5_ComponentClass ComponentClass
					    ,case
						    when L5_DisplayName like '%Line%'
						    then 'Line'
						    when L5_DisplayName like '%Smart Home%'
						    then 'Smart Home' else ''
						end L5_DisplayName
					    ,IsDataSvc
					    ,IsSmartHome
					    ,IsPointGuard
					    ,IsPhone
					    ,IsLocalPhn
					    ,IsUnlimitedLD
					    ,IsCallPlan
					    ,IsCableSvc
					    ,IsPromo
					    ,IsOther
					    ,sum(case
							   when Allocateable = 'Y'
							   then cast(bc1.DisperseAmount as decimal(12,2)) else 0
						    end) / count(*) DisperseAmount
					    ,sum(case
							   when Allocateable = 'N'
							   then cast(bc1.StandardRate as decimal(12,2)) else 0
						    end) / count(*) UnallocatedCharge
					    ,min(Allocateable) Allocateable
				   -- select *
				   FROM PWB_AccountServiceHier_tb sh
					   JOIN dbo.PrdComponentMap pcm on pcm.ComponentId = sh.ComponentId
					   join PWB_PackageWeightsBalancedComponent_tb bc1 on bc1.ProductOffering = sh.L1_DisplayName
															    and bc1.PackageComponent = sh.L4_DisplayName
															    and bc1.component = sh.L5_DisplayName
															    and bc1.PriceList = sh.PriceList
															    and coalesce(bc1.PricePlan,'') = coalesce(sh.PricePlan,'')
				   WHERE bc1.DisperseAmount is not null
					    AND bc1.DisperseAmount <> 0.00
				   --	  AND accountCode = '100514624'
				   GROUP BY AccountCode
						 ,sh.LocationId
						 ,L5_ComponentClass
						 ,case
							 when L5_DisplayName like '%Line%'
							 then 'Line'
							 when L5_DisplayName like '%Smart Home%'
							 then 'Smart Home' else ''
						  end
						 ,IsDataSvc
						 ,IsSmartHome
						 ,IsPointGuard
						 ,IsPhone
						 ,IsLocalPhn
						 ,IsUnlimitedLD
						 ,IsCallPlan
						 ,IsCableSvc
						 ,IsPromo
						 ,IsOther
			    ) x
		    GROUP BY x.AccountCode
				  ,x.LocationId)
		SELECT DISTINCT 
			  a.AccountGroupCode
			 ,a.DimAccountId
			 ,a.DimServiceLocationID
			 ,a.AccountType
			 ,a.AccountCode
			 ,a.AccountName
			 ,a.AccountActivationDate
			 ,a.AccountDeactivationDate
			 ,a.AccountStatus
			 ,a.PhoneNumber
			 ,a.Email
			 ,mid.FirstServiceInstallDate
			 ,mid.LastServiceDisconnectDate
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
			 ,a.CycleDescription
			 ,a.CycleNumber
			 ,a.[Location Zone]
			 ,a.Cabinet
			 ,a.[Wirecenter Region]
			 ,a.[FM AddressID]
			 ,a.[Omnia SrvItemLocationID]
			 ,a.Internal
			 ,a.Courtesy
			 ,CASE
				 WHEN SUM(CAST(sc.IsEmployee AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END EmployeeFlag
			 ,a.MilitaryDiscount
			 ,a.SeniorDiscount
			 ,a.PointPause
			 ,a.Ebill_Flag
			  --Package
			 ,CASE
				 WHEN pack.DimAccountId IS NOT NULL
				 THEN 'Y' ELSE 'N'
			  END HasPackage
			 ,isnull(Package,'') Package
			 ,isnull(TotalPackageCharge,'') TotalPackageCharge
			  --,Internet
			 ,MAX(case
					when Package is not null
						and pkgpna.AccountCode is null
					then TotalPackageCharge else coalesce(pkgpna.UnallocatedPkgAmount,0)
				 end) UnallocatedPackageCharge
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
			 ,cast(Sum(isnull(sc.IntGrpSvcItemPrice,0) * IsDataSvc) AS MONEY) + max(coalesce(pkgp.DataServiceCharge,0) * isnull(pkgp.AllocateFlag,0)) DataServiceCharge
			 ,cast(Round(SUM(isnull(sc.IntGrpSvcnet,0) * IsDataSvc),2) AS MONEY) + max(coalesce(pkgp.DataServiceCharge,0) * isnull(pkgp.AllocateFlag,0)) DataServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasSmartHome
			 ,cast(Sum(isnull(sc.SmartHomeItemPrice,0) * IsSmartHome) AS MONEY) + max(coalesce(pkgp.SmartHomeCharge,0) * isnull(pkgp.AllocateFlag,0)) SmartHomeServiceCharge
			 ,cast(Sum(isnull(sc.SmartHomeNet,0) * IsSmartHome) AS MONEY) + max(coalesce(pkgp.SmartHomeCharge,0) * isnull(pkgp.AllocateFlag,0)) SmartHomeServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasSmartHomePod
			 ,cast(Sum(isnull(sc.SmartHomePodItemPrice,0) * IsSmartHomePod) AS MONEY) SmartHomePodCharge
			 ,cast(Sum(isnull(sc.SmartHomePodNet,0) * IsSmartHomePod) AS MONEY) SmartHomePodNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPointGuard
			 ,cast(Sum(isnull(sc.PointGuardItemPrice,0) * IsPointGuard) AS MONEY) PointGuardCharge
			 ,cast(Sum(isnull(sc.PointGuardNet,0) * IsPointGuard) AS MONEY) PointGuardNetCharge
			 ,cast(SUM(isnull(sc.IntGrpAddOnItemPrice,0) * IsData) AS MONEY) DataAddOnCharge
			 ,cast(SUM(isnull(sc.IntGrpAddOnnet,0) * IsData) AS MONEY) DataAddOnNetCharge
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
			 ,cast(Sum(sc.CabGrpSvcItemPrice * IsCableSvc) AS MONEY) CableServiceCharge
			 ,cast(Round(SUM(sc.CabGrpSvcnet * IsCableSvc),2) AS MONEY) CableServiceNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasHBO
			 ,cast(Sum(sc.HBOItemPrice * IsHBO) AS MONEY) HBOServiceCharge
			 ,cast(Sum(sc.HBONet * IsHBO) AS MONEY) HBONetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasCinemax
			 ,cast(Sum(sc.CinemaxItemPrice * IsCinemax) AS MONEY) CinemaxServiceCharge
			 ,cast(Sum(sc.CinemaxNet * IsCinemax) AS MONEY) CinemaxNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasShowtime
			 ,cast(Sum(sc.ShowtimeItemPrice * IsShowtime) AS MONEY) ShowtimeServiceCharge
			 ,cast(Sum(sc.ShowtimeNet * IsShowtime) AS MONEY) ShowtimeNetCharge
			 ,CASE
				 WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasStarz
			 ,cast(Sum(sc.StarzItemPrice * IsStarz) AS MONEY) StarzServiceCharge
			 ,cast(Sum(sc.StarzNet * IsStarz) AS MONEY) StarzNetCharge
			 ,cast(SUM(sc.CabGrpAddOnItemPrice * IsCable) AS MONEY) CableAddOnCharge
			 ,cast(SUM(sc.CabGrpAddOnnet * IsCable) AS MONEY) CableAddOnNetCharge
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
			 ,cast(Sum((PhnGrpSvcItemPrice * IsPhoneSvc) + (PhnGrpSvcItemPrice * IsComplexSvc)) AS MONEY) + max(coalesce(pkgp.PhoneServiceCharge,0) * isnull(pkgp.AllocateFlag,0)) PhoneServiceCharge
			 ,cast(Sum((PhnGrpSvcnet * IsPhoneSvc) + (PhnGrpSvcnet * IsComplexSvc)) AS MONEY) + max(coalesce(pkgp.PhoneServiceCharge,0) * isnull(pkgp.AllocateFlag,0)) PhoneServiceNetCharge
			 ,cast(SUM(sc.PhnGrpAddOnItemPrice * IsPhone) AS MONEY) + max(coalesce(pkgp.PhoneAddOnCharge,0) * isnull(pkgp.AllocateFlag,0)) PhoneAddOnCharge
			 ,cast(SUM(sc.PhnGrpAddOnnet * IsPhone) AS MONEY) + max(coalesce(pkgp.PhoneAddOnCharge,0) * isnull(pkgp.AllocateFlag,0)) PhoneAddOnNetCharge
			  --Promo
			 ,CASE
				 WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasPromo
			 ,cast(Sum(sc.PromoPrice * IsPromo) AS MONEY) + max(coalesce(pkgp.PromoCharge,0) * isnull(pkgp.AllocateFlag,0)) PromoCharge
			 ,cast(Round(SUM(sc.Promonet * IsPromo),2) AS MONEY) + max(coalesce(pkgp.PromoCharge,0) * isnull(pkgp.AllocateFlag,0)) PromoNetCharge
			  --TaxOrFee
			 ,CASE
				 WHEN SUM(CAST(sc.IsTaxOrFee AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasTaxOrFee
			 ,cast(Sum(sc.TaxOrFeePrice * IsTaxOrFee) AS MONEY) TaxFeeCharge
			 ,cast(Round(SUM(sc.TaxFeeNet * IsTaxOrFee),2) AS MONEY) TaxFeeNetCharge
			  ---Flags
			 ,CASE
				 WHEN SUM(CAST(sc.IsOther AS INT)) > 0
				 THEN 'Y' ELSE 'N'
			  END HasOther
			 ,cast(Sum(sc.OtherPrice * IsOther) AS MONEY) OtherCharge
			 ,cast(Round(SUM(sc.OtherNet * IsOther),2) AS MONEY) OtherNetCharge
			 ,a.AutoPay
			 ,cast(Round(SUM((isnull(sc.IntGrpSvcnet,0) * IsDataSvc) + (isnull(sc.SmartHomeNet,0) * IsSmartHome) + (isnull(sc.SmartHomePodNet,0) * IsSmartHomePod) + (isnull(sc.PointGuardNet,0) * IsPointGuard) + (isnull(sc.IntGrpAddOnnet,0) * IsData) + (isnull(sc.CabGrpSvcnet,0) * IsCableSvc) + (isnull(sc.HBONet,0) * IsHBO) + (isnull(sc.CinemaxNet,0) * IsCinemax) + (isnull(sc.ShowtimeNet,0) * IsShowtime) + (isnull(sc.StarzNet,0) * IsStarz) + (isnull(sc.CabGrpAddOnnet,0) * IsCable) + ((isnull(PhnGrpSvcnet,0) * IsPhoneSvc) + (isnull(PhnGrpSvcnet,0) * IsComplexSvc)) + (isnull(sc.PhnGrpAddOnnet,0) * IsPhone) + (isnull(sc.Promonet,0) * IsPromo) + (isnull(sc.TaxFeeNet,0) * IsTaxOrFee) + (isnull(sc.OtherNet,0) * IsOther)),2) AS MONEY) + max((coalesce(pkgp.DisperseAmount,0))) + MAX(coalesce(pkgpna.UnallocatedPkgAmount,0)) + MAX((case
																																																																																																																																																																							    when Package is not null
																																																																																																																																																																								    and pkgpna.AccountCode is null
																																																																																																																																																																							    then TotalPackageCharge else 0
																																																																																																																																																																							end)) TotalCharge
			 ,min(case
					when coalesce(pkgpna.Allocateable,'') = 'N'
					then 'Package Unallocated'
					when Package is not null
						and pkgpna.AccountCode is null
					then 'Package Unallocated'
					when coalesce(pkgp.Allocateable,'') = 'Y'
					then 'Package Allocated' else null
				 end) PackageAllocation
			 ,@ReportDate as [EffectiveStartDate]
			 ,dateadd(day,1,@ReportDate) as [EffectiveEndDate]		-- select *
		FROM acct a
			Left JOIN mininstalldate mid ON a.DimAccountId = mid.DimAccountId
									  AND a.DimServiceLocationId = mid.DimServiceLocationId
			JOIN ServiceClassify sc ON a.DimAccountId = sc.DimAccountId
								  AND a.DimServiceLocationId = sc.DimServiceLocationId
			LEFT JOIN dbo.[PBB_AccountLocation_ServicesBrokenOut_Aggregation](@ReportDate,', ') agg ON a.DimAccountId = agg.dimaccountid
																					 AND a.DimServiceLocationId = agg.dimservicelocationid
			LEFT JOIN PackageSummary pack ON a.DimAccountId = pack.DimAccountId
									   AND a.DimServiceLocationId = pack.DimServiceLocationId
			LEFT JOIN PackageParts pkgp ON pkgp.AccountCode = a.AccountCode
									 AND pkgp.LocationId = a.LocationId
									 AND pkgp.Allocateable = 'Y'
			LEFT JOIN PackageParts pkgpna ON pkgpna.AccountCode = a.AccountCode
									   AND pkgpna.LocationId = a.LocationId
									   AND pkgpna.Allocateable = 'N'
		-- WHERE A.AccountCode = '100509572'
		GROUP BY a.AccountGroupCode
			   ,a.AccountType
			   ,a.DimAccountId
			   ,a.AccountCode
			   ,a.AccountName
			   ,a.AccountActivationDate
			   ,a.AccountDeactivationDate
			   ,a.AccountStatus
			   ,a.PhoneNumber
			   ,a.Email
			   ,a.DimServiceLocationID
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
			   ,a.CycleDescription
			   ,a.CycleNumber
			   ,a.[Location Zone]
			   ,a.Cabinet
			   ,a.[Wirecenter Region]
			   ,a.[FM AddressID]
			   ,a.[Omnia SrvItemLocationID]
			   ,a.Internal
			   ,a.Courtesy
			   ,a.MilitaryDiscount
			   ,a.SeniorDiscount
			   ,a.PointPause
			   ,DataCategory
			   ,a.Ebill_Flag
			   ,mid.FirstServiceInstallDate
			   ,mid.LastServiceDisconnectDate
			   ,isnull(agg.DataSvc,'')
			   ,CableCategory
			   ,isnull(agg.CableSvc,'')
			   ,isnull(agg.PhoneSvc,'')
			   ,CASE
				   WHEN pack.DimAccountId IS NOT NULL
				   THEN 'Y' ELSE 'N'
			    END
			   ,Package
			   ,TotalPackageCharge
			   ,a.AutoPay
GO
