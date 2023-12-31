USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[ProductAnalysis_Test]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[ProductAnalysis_Test]
AS
WITH
acct
AS (
	SELECT DISTINCT sli.DimAccountId
		,a.accountcode
		,a.AccountName
		,a.AccountActivationDate
		,a.AccountDeactivationDate
		,a.AccountStatus		
		,sli.DimServiceLocationID
		,dad.[FM AddressID]
		,dad.[Omnia SrvItemLocationID]
		,ac.CycleDescription
		,CycleNumber
		,dad.[Location Zone]
		,dad.Cabinet
		,dad.[Wirecenter Region]	
		,rp.AutoPay
		,CASE WHEN a.PrintGroup = 'Electronic Invoice' THEN  'Y' ELSE 'N' END as Ebill_Flag
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%'
				THEN 'Y'
			ELSE 'N'
			END AS Internal
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%'
				THEN 'Y'
			ELSE 'N'
			END AS Courtesy
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'
				THEN 'Y'
			ELSE 'N'
			END AS MilitaryDiscount
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%'
				THEN 'Y'
			ELSE 'N'
			END AS SeniorDiscount
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%'
				THEN 'Y'
			ELSE 'N'
			END AS PointPause
		,((pbb_AccountDiscountPercentage * - 1) / 100) DiscPerc
		,CASE 
			WHEN ac.AccountGroupCode = ''
				THEN 'NONE'
			ELSE ac.AccountGroupCode
			END AS AccountGroupCode
		,CASE 
			WHEN AC.AccountGroupCode LIKE '%RES'
				THEN 'Residential'
			WHEN ac.AccountGroupCode LIKE '%BUS'
				THEN 'Business'
			WHEN ac.AccountGroupCode LIKE 'WHL%'
				THEN 'Business'
			ELSE ac.AccountGroupCode
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
	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod AutoPay on AutoPay.accountcode=a.AccountCode
	LEFT JOIN (  SELECT  AccountCode
			,STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS AutoPay
		 FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod
      GROUP BY AccountCode) rp ON rp.AccountCode= a.AccountCode
	WHERE Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
		AND isnull(ItemDeactivationDate, '12-31-2050') > getdate()
		AND sli.DimAccountId <> 0

	GROUP BY sli.DimAccountId
		,a.accountname
		,a.accountcode
		,a.AccountActivationDate
		,a.AccountDeactivationDate
		,a.AccountStatus
		,sli.DimServiceLocationID
		,dad.[FM AddressID]
		,dad.[Omnia SrvItemLocationID]
		,ac.CycleDescription
		,CycleNumber
		,dad.[Location Zone]
		,dad.Cabinet
		,dad.[Wirecenter Region]
		, CASE 
		    WHEN a.PrintGroup = 'Electronic Invoice'
			   THEN  'Y' 
			ELSE 'N' 
			END
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%'
				THEN 'Y'
			ELSE 'N'
			END
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%'
				THEN 'Y'
			ELSE 'N'
			END
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'
				THEN 'Y'
			ELSE 'N'
			END
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%'
				THEN 'Y'
			ELSE 'N'
			END
		,CASE 
			WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%'
				THEN 'Y'
			ELSE 'N'
			END
		,((pbb_AccountDiscountPercentage * - 1) / 100)
		,CASE 
			WHEN ac.AccountGroupCode = ''
				THEN 'NONE'
			ELSE ac.AccountGroupCode
			END
		,CASE 
			WHEN AC.AccountGroupCode LIKE '%RES'
				THEN 'Residential'
			WHEN ac.AccountGroupCode LIKE '%BUS'
				THEN 'Business'
			WHEN ac.AccountGroupCode LIKE 'WHL%'
				THEN 'Business'
			ELSE ac.AccountGroupCode
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
		,rp.AutoPay
	),

/*	AutoPay as
(SELECT distinct arp.AccountCode, 
                STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS AutoPay
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod arp
		 Join  [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a
		 ON a.AccountCode=arp.AccountCode 
         GROUP BY arp.AccountCode),*/
mininstalldate
AS (
	SELECT DISTINCT sli.DimAccountId
		,sli.DimServiceLocationID
		,Min(itemactivationdate) FirstServiceInstallDate
		,max(isnull(itemdeactivationdate, '12-31-2050')) LastServiceDisconnectDate
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
	WHERE Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
	),
	
	
	IntCat
AS (
	SELECT DISTINCT sli.DimAccountId
		,sli.DimServiceLocationID
		,MAX(ISNULL(r.rnk, 0)) rnk
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
	JOIN PrdInternetRank r ON pc.SpeedTier = r.Category
	WHERE Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
		AND isnull(ItemDeactivationDate, '12-31-2050') > getdate()
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
	)
	,cablecat
AS (
	SELECT DISTINCT sli.DimAccountId
		,sli.DimServiceLocationID
		,MAX(ISNULL(r.rnk, 0)) rnk
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN DimCustomerItem dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
	JOIN PrdCableRank r ON pc.Category = r.Category
	WHERE Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
		AND isnull(ItemDeactivationDate, '12-31-2050') > getdate()
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
	)
	,ServiceClassify
AS
	--select * from prdcomponentmap
	(
	SELECT DISTINCT sli.DimAccountId
		,a.accountcode
		,sli.DimServiceLocationID
		-- IntGroup
		,CASE 
			WHEN IsDataSvc = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS IntGrpSvcItemPrice
		,CASE 
			WHEN IsDataSvc = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS IntGrpSvcnet
		-- cabGrp
		,CASE 
			WHEN IsCableSvc = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS CabGrpSvcItemPrice
		,CASE 
			WHEN IsCableSvc = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS CabGrpSvcnet
		--HBO
		,CASE 
			WHEN [HBOBulk] = 1
				OR HBOQV = 1
				OR HBOSA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS HBOItemPrice
		,CASE 
			WHEN [HBOBulk] = 1
				OR HBOQV = 1
				OR HBOSA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS HBOnet
		--Cinemax
		,CASE 
			WHEN Cinemax_Standalone_QV = 1
				OR Cinemax_Standalone_SA = 1
				OR Cinemax_pkg_qv = 1
				OR Cinemax_Pkg_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS CinemaxItemPrice
		,CASE 
			WHEN Cinemax_Standalone_QV = 1
				OR Cinemax_Standalone_SA = 1
				OR Cinemax_pkg_qv = 1
				OR Cinemax_Pkg_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS Cinemaxnet
		--Showtime
		,CASE 
			WHEN Showtime_QV = 1
				OR Showtime_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS ShowtimeItemPrice
		,CASE 
			WHEN Showtime_QV = 1
				OR Showtime_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS Showtimenet
		--Starz
		,CASE 
			WHEN Starz_QV = 1
				OR Starz_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS StarzItemPrice
		,CASE 
			WHEN Starz_QV = 1
				OR Starz_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
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
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
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
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS CabGrpAddOnnet
		-- SmartHome
		,CASE 
			WHEN [IsSmartHome] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS SmartHomeItemPrice
		,CASE 
			WHEN [IsSmartHome] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS SmartHomenet
		--SmartHomePod
		,CASE 
			WHEN [IsSmartHomePod] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS SmartHomePodItemPrice
		,CASE 
			WHEN [IsSmartHomePod] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS SmartHomePodnet
		--PointGuard
		,CASE 
			WHEN [IsPointGuard] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS PointGuardItemPrice
		,CASE 
			WHEN [IsPointGuard] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS PointGuardnet
		--OtherAddOn
		,CASE 
			WHEN IsData = 1
				AND IsSmartHome = 0
				AND IsSmartHomePod = 0
				AND IsPointGuard = 0
				AND IsDataSvc = 0
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS IntGrpAddOnItemPrice
		,CASE 
			WHEN IsData = 1
				AND IsSmartHome = 0
				AND IsSmartHomePod = 0
				AND IsPointGuard = 0
				AND IsDataSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS IntGrpAddOnnet
		--phnGrp 
		,CASE 
			WHEN IsLocalPhn = 1
				OR IsComplexPhn = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS PhnGrpSvcItemPrice
		,CASE 
			WHEN IsLocalPhn = 1
				OR IsComplexPhn = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS PhnGrpSvcnet
		--OtherAddOn
		,CASE 
			WHEN IsPhone = 1
				AND IsLocalPhn = 0
				AND IsComplexPhn = 0
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS PhnGrpAddOnItemPrice
		,CASE 
			WHEN IsPhone = 1
				AND IsLocalPhn = 0
				AND IsComplexPhn = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS PhnGrpAddOnnet
		,CASE 
			WHEN IsPromo = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS PromoPrice
		,CASE 
			WHEN IsPromo = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS Promonet
		,CASE 
			WHEN IsTaxOrFee = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS TaxOrFeePrice
		,CASE 
			WHEN IsTaxOrFee = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END AS TaxFeeNet
		--IsOther
		,CASE 
			WHEN IsOther = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END AS OtherPrice
		,CASE 
			WHEN IsOther = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
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
	FROM (
		SELECT DISTINCT DimCustomerItemId
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
	WHERE Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
		AND isnull(ItemDeactivationDate, '12-31-2050') > getdate()
		AND PC.ComponentClass <> 'Package'
		AND sli.DimAccountId <> 0
		AND pc.IsIgnored = 0
	GROUP BY sli.DimAccountId
		,a.accountcode
		,sli.DimServiceLocationID
		,CASE 
			WHEN IsDataSvc = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsDataSvc = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--SmartHome
		,CASE 
			WHEN [IsSmartHome] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN [IsSmartHome] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--SmartHomePod
		,CASE 
			WHEN [IsSmartHomePod] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN [IsSmartHomePod] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--PointGuard
		,CASE 
			WHEN [IsPointGuard] = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN [IsPointGuard] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--OtherAddOn
		,CASE 
			WHEN IsData = 1
				AND IsSmartHome = 0
				AND IsSmartHomePod = 0
				AND IsPointGuard = 0
				AND IsDataSvc = 0
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsData = 1
				AND IsSmartHome = 0
				AND IsSmartHomePod = 0
				AND IsPointGuard = 0
				AND IsDataSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		,CASE 
			WHEN IsCableSvc = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsCableSvc = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--HBO
		,CASE 
			WHEN [HBOBulk] = 1
				OR HBOQV = 1
				OR HBOSA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN [HBOBulk] = 1
				OR HBOQV = 1
				OR HBOSA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--Cinemax
		,CASE 
			WHEN Cinemax_Standalone_QV = 1
				OR Cinemax_Standalone_SA = 1
				OR Cinemax_pkg_qv = 1
				OR Cinemax_Pkg_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN Cinemax_Standalone_QV = 1
				OR Cinemax_Standalone_SA = 1
				OR Cinemax_pkg_qv = 1
				OR Cinemax_Pkg_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--Showtime
		,CASE 
			WHEN Showtime_QV = 1
				OR Showtime_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN Showtime_QV = 1
				OR Showtime_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--Starz
		,CASE 
			WHEN Starz_QV = 1
				OR Starz_SA = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN Starz_QV = 1
				OR Starz_SA = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
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
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
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
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		,CASE 
			WHEN IsLocalPhn = 1
				OR IsComplexPhn = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsLocalPhn = 1
				OR IsComplexPhn = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--OtherAddOn
		,CASE 
			WHEN IsPhone = 1
				AND IsLocalPhn = 0
				AND IsComplexPhn = 0
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsPhone = 1
				AND IsLocalPhn = 0
				AND IsComplexPhn = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		,CASE 
			WHEN IsPromo = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsPromo = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		,CASE 
			WHEN IsTaxOrFee = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsTaxOrFee = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		--IsOther
		,CASE 
			WHEN IsOther = 1
				THEN (ItemPrice * ItemQuantity)
			ELSE 0
			END
		,CASE 
			WHEN IsOther = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * DiscPerc), 2)
			ELSE 0
			END
		,ServiceLocationState
		,ServiceLocationCity
		,ServiceLocationPostalCode
		,ServiceLocationTaxArea
		,irnk.Category
		,cirnk.Category
	)
	,PackageClassify
AS (
	SELECT DISTINCT a.DimAccountId
		,a.AccountCode
		,a.AccountName
		,DSL.DimServiceLocationId
		--,fci.ItemID
		,CASE 
			WHEN count(DISTINCT fci.itemid) > 1
				THEN dcat.itemprintdescription + ' (' + cast(count(DISTINCT fci.itemid) AS NVARCHAR(100)) + ')'
			ELSE dcat.itemprintdescription
			END AS Package
		,sum(fci.ItemPrice) AS TotalPackageCharge
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] fci
	JOIN DimCustomerItem dci ON fci.DimCustomerItemId = dci.DimCustomerItemId
	JOIN DimCatalogItem dcat ON fci.DimCatalogItemId = dcat.DimCatalogItemId
	INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount a ON a.DimAccountId = fci.DimAccountId
	INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap] prd ON dcat.ComponentCode = prd.ComponentCode
	INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation DSL ON fci.DimServiceLocationId = DSL.DimServiceLocationId
	WHERE prd.ComponentClassID = 200
		AND Activation_DimDateId <= GETDATE()
		AND Deactivation_DimDateId > GETDATE()
		AND EffectiveStartDate <= GETDATE()
		AND EffectiveEndDate > GETDATE()
		AND isnull(ItemDeactivationDate, '12-31-2050') > getdate()
		AND fci.DimAccountId <> 0
	GROUP BY a.DimAccountId
		,a.AccountCode
		,a.AccountName
		,DSL.DimServiceLocationId
		,dcat.itemprintdescription
	)
	,PackageSummary
AS (
	SELECT DISTINCT dimaccountid
		,accountcode
		,accountname
		,DimServiceLocationid
		,Package = stuff((
				SELECT DISTINCT '; ' + Package
				FROM PackageClassify IPC
				WHERE IPC.accountcode = PC.accountcode
					AND IPC.dimservicelocationid = PC.DimservicelocationID
				FOR XML path('')
				), 1, 2, '')
		,sum(TotalPackageCharge) TotalPackageCharge
	FROM PackageClassify PC
	--	where accountcode = 300411828
	GROUP BY DimAccountId
		,accountcode
		,accountname
		,DimServiceLocationid
	)
SELECT DISTINCT a.AccountGroupCode
	,a.AccountType
	,a.DimAccountId
	,a.AccountCode
	,a.AccountName
	,a.AccountActivationDate
	,a.AccountDeactivationDate
	,a.AccountStatus
	,mid.FirstServiceInstallDate
	,mid.LastServiceDisconnectDate
	,a.DimServiceLocationID
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
			THEN 'Y'
		ELSE 'N'
		END EmployeeFlag
	,a.MilitaryDiscount
	,a.SeniorDiscount
	,a.PointPause
	,a.Ebill_Flag
	--Package
	,CASE 
		WHEN pack.DimAccountId IS NOT NULL
			THEN 'Y'
		ELSE 'N'
		END HasPackage
	,isnull(Package, '') Package
	,isnull(TotalPackageCharge, '') TotalPackageCharge
	--,Internet
	,CASE 
		WHEN SUM(CAST(sc.IsData AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasData
	,CASE 
		WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasDataSvc
	,isnull(DataCategory, '') DataCategory
	,isnull(agg.DataSvc, '') DataSvc
	,cast(Sum(isnull(sc.IntGrpSvcItemPrice, 0) * IsDataSvc) AS MONEY) DataServiceCharge
	,cast(Round(SUM(isnull(sc.IntGrpSvcnet, 0) * IsDataSvc), 2) AS MONEY) DataServiceNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasSmartHome
	,cast(Sum(isnull(sc.SmartHomeItemPrice, 0) * IsSmartHome) AS MONEY) SmartHomeServiceCharge
	,cast(Sum(isnull(sc.SmartHomeNet, 0) * IsSmartHome) AS MONEY) SmartHomeServiceNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasSmartHomePod
	,cast(Sum(isnull(sc.SmartHomePodItemPrice, 0) * IsSmartHomePod) AS MONEY) SmartHomePodCharge
	,cast(Sum(isnull(sc.SmartHomePodNet, 0) * IsSmartHomePod) AS MONEY) SmartHomePodNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasPointGuard
	,cast(Sum(isnull(sc.PointGuardItemPrice, 0) * IsPointGuard) AS MONEY) PointGuardCharge
	,cast(Sum(isnull(sc.PointGuardNet, 0) * IsPointGuard) AS MONEY) PointGuardNetCharge
	,cast(SUM(isnull(sc.IntGrpAddOnItemPrice, 0) * IsData) AS MONEY) DataAddOnCharge
	,cast(SUM(isnull(sc.IntGrpAddOnnet, 0) * IsData) AS MONEY) DataAddOnNetCharge
	--Cable,
	,CASE 
		WHEN SUM(CAST(sc.IsCable AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasCable
	,CASE 
		WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasCableSvc
	,isnull(CableCategory, '') CableCategory
	,isnull(agg.CableSvc, '') CableSvc
	,cast(Sum(sc.CabGrpSvcItemPrice * IsCableSvc) AS MONEY) CableServiceCharge
	,cast(Round(SUM(sc.CabGrpSvcnet * IsCableSvc), 2) AS MONEY) CableServiceNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsHBO AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasHBO
	,cast(Sum(sc.HBOItemPrice * IsHBO) AS MONEY) HBOServiceCharge
	,cast(Sum(sc.HBONet * IsHBO) AS MONEY) HBONetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasCinemax
	,cast(Sum(sc.CinemaxItemPrice * IsCinemax) AS MONEY) CinemaxServiceCharge
	,cast(Sum(sc.CinemaxNet * IsCinemax) AS MONEY) CinemaxNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasShowtime
	,cast(Sum(sc.ShowtimeItemPrice * IsShowtime) AS MONEY) ShowtimeServiceCharge
	,cast(Sum(sc.ShowtimeNet * IsShowtime) AS MONEY) ShowtimeNetCharge
	,CASE 
		WHEN SUM(CAST(sc.IsStarz AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasStarz
	,cast(Sum(sc.StarzItemPrice * IsStarz) AS MONEY) StarzServiceCharge
	,cast(Sum(sc.StarzNet * IsStarz) AS MONEY) StarzNetCharge
	,cast(SUM(sc.CabGrpAddOnItemPrice * IsCable) AS MONEY) CableAddOnCharge
	,cast(SUM(sc.CabGrpAddOnnet * IsCable) AS MONEY) CableAddOnNetCharge
	--Phone
	,CASE 
		WHEN SUM(CAST(sc.IsPhone AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasPhone
	,CASE 
		WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasPhoneSvc
	,CASE 
		WHEN SUM(CAST(sc.IsComplexSvc AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasComplexPhoneSvc
	,isnull(agg.PhoneSvc, '') PhoneSvc
	--PhnGrp,             
	,cast(Sum((PhnGrpSvcItemPrice * IsPhoneSvc) + (PhnGrpSvcItemPrice * IsComplexSvc)) AS MONEY) PhoneServiceCharge
	,cast(Sum((PhnGrpSvcnet * IsPhoneSvc) + (PhnGrpSvcnet * IsComplexSvc)) AS MONEY) PhoneServiceNetCharge
	,cast(SUM(sc.PhnGrpAddOnItemPrice * IsPhone) AS MONEY) PhoneAddOnCharge
	,cast(SUM(sc.PhnGrpAddOnnet * IsPhone) AS MONEY) PhoneAddOnNetCharge
	--Promo
	,CASE 
		WHEN SUM(CAST(sc.IsPromo AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasPromo
	,cast(Sum(sc.PromoPrice * IsPromo) AS MONEY) PromoCharge
	,cast(Round(SUM(sc.Promonet * IsPromo), 2) AS MONEY) PromoNetCharge
	--TaxOrFee
	,CASE 
		WHEN SUM(CAST(sc.IsTaxOrFee AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasTaxOrFee
	,cast(Sum(sc.TaxOrFeePrice * IsTaxOrFee) AS MONEY) TaxFeeCharge
	,cast(Round(SUM(sc.TaxFeeNet * IsTaxOrFee), 2) AS MONEY) TaxFeeNetCharge
	---Flags
	,CASE 
		WHEN SUM(CAST(sc.IsOther AS INT)) > 0
			THEN 'Y'
		ELSE 'N'
		END HasOther
	,cast(Sum(sc.OtherPrice * IsOther) AS MONEY) OtherCharge
	,cast(Round(SUM(sc.OtherNet * IsOther), 2) AS MONEY) OtherNetCharge
	,a.AutoPay
	,cast(Round(SUM((isnull(sc.IntGrpSvcnet, 0) * IsDataSvc) + (isnull(sc.SmartHomeNet, 0) * IsSmartHome) + (isnull(sc.SmartHomePodNet, 0) * IsSmartHomePod) + (isnull(sc.PointGuardNet, 0) * IsPointGuard) + (isnull(sc.IntGrpAddOnnet, 0) * IsData) + (isnull(sc.CabGrpSvcnet, 0) * IsCableSvc) + (isnull(sc.HBONet, 0) * IsHBO) + (isnull(sc.CinemaxNet, 0) * IsCinemax) + (isnull(sc.ShowtimeNet, 0) * IsShowtime) + (isnull(sc.StarzNet, 0) * IsStarz) + (isnull(sc.CabGrpAddOnnet, 0) * IsCable) + ((isnull(PhnGrpSvcnet, 0) * IsPhoneSvc) + (isnull(PhnGrpSvcnet, 0) * IsComplexSvc)) + (isnull(sc.PhnGrpAddOnnet, 0) * IsPhone) + (isnull(sc.Promonet, 0) * IsPromo) + (isnull(sc.TaxFeeNet, 0) * IsTaxOrFee) + (isnull(sc.OtherNet, 0) * IsOther
					)), 2) AS MONEY) TotalCharge
-- select *
FROM acct a
Left JOIN mininstalldate mid ON a.DimAccountId = mid.DimAccountId
	AND a.DimServiceLocationId = mid.DimServiceLocationId
JOIN ServiceClassify sc ON a.DimAccountId = sc.DimAccountId
	AND a.DimServiceLocationId = sc.DimServiceLocationId
LEFT JOIN dbo.[PBB_AccountLocation_ServicesBrokenOut_Aggregation](getdate(), ', ') agg ON a.DimAccountId = agg.dimaccountid
	AND a.DimServiceLocationId = agg.dimservicelocationid
LEFT JOIN PackageSummary pack ON a.DimAccountId = pack.DimAccountId
	AND a.DimServiceLocationId = pack.DimServiceLocationId
GROUP BY a.AccountGroupCode
	,a.AccountType
	,a.DimAccountId
	,a.AccountCode
	,a.AccountName
	,a.AccountActivationDate
	,a.AccountDeactivationDate
	,a.AccountStatus
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
	,isnull(agg.DataSvc, '')
	,CableCategory
	,isnull(agg.CableSvc, '')
	,isnull(agg.PhoneSvc, '')
	,CASE 
		WHEN pack.DimAccountId IS NOT NULL
			THEN 'Y'
		ELSE 'N'
		END
	,Package
	,TotalPackageCharge
	,a.AutoPay
GO
