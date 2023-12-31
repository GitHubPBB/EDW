USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_ProductAnalysisDetails]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[PBB_Populate_ProductAnalysisDetails]
AS


BEGIN

	TRUNCATE TABLE dbo.PBB_ProductAnalysisDetails_stage;
	TRUNCATE TABLE dbo.PBB_ProductAnalysisDetails;

--	DROP TABLE if exists dbo.PBB_ProductAnalysisDetails_stage;
--	DROP TABLE if exists dbo.PBB_ProductAnalysisDetails;

	DROP TABLE if exists #AcctTemp;
	
WITH 
PortalCustomer

AS (SELECT *
      FROM
              (
                  SELECT BillingAccountID, 
                         ROW_NUMBER() OVER(PARTITION BY BillingAccountID ORDER BY CAST(CB.CreatedDateTime AS DATE) DESC) AS [Row],
                         CASE WHEN cw.UserName IS NOT NULL
                              THEN 'Y' ELSE 'N'
                         END AS PortalUserExists, 
                         Email AS PortalEmail
                  FROM pbbsql01.CHRWEB.dbo.CHRWebUser_BillingAccount CB
                  JOIN pbbsql01.CHRWEB.dbo.chrwebuser                cw ON cb.chrwebuserid = cw.CHRWebUserID
                  WHERE 1=1
				        AND ishomebillingaccountid = 1
                        AND isenabled = 1
                        AND recordstatusid = 1
              ) inr
     WHERE row = 1
),
mininstalldate

AS (
	SELECT   
			 max(FactCustomerItemId) FactCustomerItemId_min
			,sli.DimAccountId
			,sli.DimServiceLocationID
			,Min(itemactivationdate) FirstServiceInstallDate
			,max(isnull(itemdeactivationdate, '12-31-2050')) LastServiceDisconnectDate
--	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
--	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem    dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem    dci 
	                                                      --  AND isnull(dci.ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli ON sli.DimCustomerItemId = dci.DimCustomerItemId
	                                                        AND sli.Deactivation_DimDateId >  cast(GETDATE() as DATE)
															AND sli.EffectiveEndDate       >  cast(GETDATE() as DATE)
															AND sli.Activation_DimDateId   <= cast(GETDATE() as DATE)
															AND sli.EffectiveStartDate     <= cast(GETDATE() as DATE)
															AND sli.DimAccountId           <> 0
	WHERE 1=1
	    AND isnull(dci.ItemDeactivationDate, '12-31-2051') > cast(GETDATE() as DATE)
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
),
crma

AS (
SELECT   AccountNumber  
        ,Address1_Telephone1  
        ,Telephone1  
        ,Telephone2  
        ,Telephone3  
		,chr_CPNIEmailAddress
  FROM  pbbsql01.pbb_p_mscrm.dbo.account     
),
acpm

AS ( SELECT  AccountCode
			            ,STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS AutoPay
	   FROM (
					SELECT P.AccountCode, 'Recurring Card' Method
					FROM   PBBSQL01.PaymentProcessor.dbo.PaymentProfile PP  
					JOIN   PBBSQL01.PaymentProcessor.dbo.Profile        P ON PP.ProfileId = P.ProfileId
					WHERE (PP.Recurring = 1) AND (PP.RecurringEndDate IS NULL) AND (PP.RecurringStartDate IS NOT NULL)
					and accountcode is not null
					union
					select AccountCode, 'ACH' from dimaccount where AccountACHBankName <> '' and AccountACHEndDate is null
		    ) x
      GROUP BY AccountCode
),
acct

AS (
SELECT   DISTINCT
         a.DimAccountId
		,a.accountcode
		,sl.LocationId
		,a.AccountName
		,a.AccountActivationDate
		,a.AccountDeactivationDate
		,a.AccountStatus
		,a.AccountPhoneNumber  as PhoneNumber
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
	  	,lower(crma.chr_CPNIEmailAddress) CPNIEmail                 
		,crma.Address1_Telephone1 Telephone1
        ,         crma.Telephone1 Phone
        ,         crma.Telephone2 Phone2
        ,         crma.Telephone3 Phone3
	    ,pc.PortalEmail, pc.PortalUserExists 
		,CASE WHEN a.PrintGroup = 'Electronic Invoice' THEN  'Y' ELSE 'N'                   END as Ebill_Flag      ---added ebillflag logic
		,CASE WHEN apbb.pbb_AccountDiscountNames LIKE '%Internal%' 	  THEN 'Y' ELSE 'N'		END AS Internal
		,CASE WHEN apbb.pbb_AccountDiscountNames LIKE '%Courtesy%' 	  THEN 'Y' ELSE 'N'		END AS Courtesy
		,CASE WHEN apbb.pbb_AccountDiscountNames LIKE '%Military%'    THEN 'Y' ELSE 'N'		END AS MilitaryDiscount
		,CASE WHEN apbb.pbb_AccountDiscountNames LIKE '%Senior%' 	  THEN 'Y' ELSE 'N'		END AS SeniorDiscount
		,CASE WHEN apbb.pbb_AccountDiscountNames LIKE '%Point Pause%' THEN 'Y' ELSE 'N'		END AS PointPause
		,((case when coalesce(apbb.pbb_AccountDiscountPercentage,0) < -100 then -100 else coalesce(apbb.pbb_AccountDiscountPercentage,0) end * - 1) / 100) DiscPerc
		,CASE WHEN apbb.pbb_AccountDiscountNames like '%;%;%' THEN 3 WHEN apbb.pbb_AccountDiscountNames like '%;%' THEN 2 ELSE 1 END DiscCount
		,CASE WHEN ac.AccountGroupCode = '' THEN 'NONE' ELSE ac.AccountGroupCode			END AS AccountGroupCode
		,CASE 
			WHEN AC.AccountGroupCode LIKE '%RES' THEN 'Residential'
			WHEN ac.AccountGroupCode LIKE '%BUS' THEN 'Business'
			WHEN ac.AccountGroupCode LIKE 'WHL%' THEN 'Business'
			ELSE ac.AccountGroupCode
			END AS AccountType
		,sl.ServiceLocationFullAddress
		,sl.ServiceLocationState
		,sl.ServiceLocationCity
		,sl.ServiceLocationPostalCode
		,sl.ServiceLocationTaxArea
		,sl.ServiceLocationRegion_WireCenter SalesRegion
	 	,slp.pbb_LocationProjectCode ProjectCode
		,sl.ServiceLocationStreet StreetName
		,a.BillingAddressStreetLine1
		,a.BillingAddressStreetLine2
		,a.BillingAddressStreetLine3
		,a.BillingAddressStreetLine4
		,a.BillingAddressCity
		,a.BillingAddressState
		,a.BillingAddressPostalCode		
    	,mid.FirstServiceInstallDate
		,LastServiceDisconnectDate
		,agg.DataSvc, agg.CableSvc, agg.PhoneSvc
 	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].FactCustomerItem         sli  
	JOIN MinInstallDate                                       mid  ON  sli.FactCustomerItemid   = mid.FactCustomerItemId_Min														 
 	JOIN DimCustomerItem                                      ci   ON  sli.DimCustomerItemId    = ci.DimCustomerItemId
 	                                                               AND coalesce(ci.ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount               a    ON  sli.DimAccountId         = a.DimAccountId
	                                                               AND a.DimAccountId           <> 0
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb           apbb ON  a.AccountId              = apbb.AccountId                            -- Discounts
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation       sl   ON  sli.DimServiceLocationId = sl.DimServiceLocationId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation_pbb   slp  ON  sl.LocationId            = slp.LocationId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccountCategory       ac   ON  sli.DimAccountCategoryId = ac.DimAccountCategoryId   
 --	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PBB_AccountDetails    ad   ON  sli.DimAccountId         = ad.DimAccountId
 --	                                                               AND ad.DimAccountId          <> 0
	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAddressDetails_pbb dad  ON  sli.DimServiceLocationId = dad.DimServiceLocationId
--	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod AutoPay on AutoPay.AccountCode=a.AccountCode
	OUTER APPLY (SELECT * FROM crma crma1 where  crma1.AccountNumber  COLLATE SQL_Latin1_General_CP1_CI_AS = a.AccountCode)     crma   
--	LEFT JOIN                                                 crma ON  crma.AccountNumber  COLLATE SQL_Latin1_General_CP1_CI_AS = a.AccountCode
	OUTER APPLY (SELECT * FROM PortalCustomer pc1 where pc1.BillingAccountId    COLLATE SQL_Latin1_General_CP1_CI_AS = a.AccountCode)  pc
--	LEFT JOIN PortalCustomer                                  pc   ON  pc.BillingAccountId COLLATE SQL_Latin1_General_CP1_CI_AS = a.AccountCode
	OUTER APPLY (SELECT  * FROM acpm acpm1 where acpm1.AccountCode = a.AccountCode) rp 
	LEFT JOIN dbo.[PBB_AccountLocation_ServicesBrokenOut_Aggregation](getdate(), ', ') agg ON mid.DimAccountId = agg.dimaccountid
	                                                             AND mid.DimServiceLocationId = agg.dimservicelocationid
	WHERE   sli.Deactivation_DimDateId >  cast(GETDATE() as DATE)
		AND sli.EffectiveEndDate       >  cast(GETDATE() as DATE)
	    AND sli.Activation_DimDateId   <= cast(GETDATE() as DATE)
		AND sli.EffectiveStartDate     <= cast(GETDATE() as DATE)
		AND sli.DimAccountId           <> 0
		AND sli.DimCustomerItemId      <> 0
)
  SELECT * INTO #AcctTemp FROM acct;

  -- select * from #AcctTemp where accountcode = '100000833'
  -- select * from #AcctTemp where disccount>2
 
WITH
IntCat

AS (
	SELECT DISTINCT sli.DimAccountId
		,sli.DimServiceLocationID
		,MAX(ISNULL(r.rnk, 0)) rnk
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem    dci ON sli.DimCustomerItemId = dci.DimCustomerItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem]   ci  ON ci.DimCatalogItemId   = sli.DimCatalogItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap    pc  ON ci.ComponentCode      = pc.ComponentCode
	JOIN PrdInternetRank                                r   ON pc.SpeedTier          = r.Category
	WHERE   sli.Deactivation_DimDateId >  cast(GETDATE() as DATE)
		AND sli.EffectiveEndDate       >  cast(GETDATE() as DATE)
	    AND sli.Activation_DimDateId   <= cast(GETDATE() as DATE)
		AND sli.EffectiveStartDate     <= cast(GETDATE() as DATE)
		AND isnull(ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
	)
,cablecat

AS (
	SELECT DISTINCT sli.DimAccountId
		,sli.DimServiceLocationID 
		,MAX(ISNULL(r.rnk, 0)) rnk
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN DimCustomerItem                                dci ON  sli.DimCustomerItemId = dci.DimCustomerItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem]   ci  ON  ci.DimCatalogItemId   = sli.DimCatalogItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap    pc  ON  ci.ComponentCode      = pc.ComponentCode
	JOIN PrdCableRank                                   r   ON  pc.Category           = r.Category
	WHERE   sli.Deactivation_DimDateId >  cast(GETDATE() as DATE)
		AND sli.EffectiveEndDate       >  cast(GETDATE() as DATE)
	    AND sli.Activation_DimDateId   <= cast(GETDATE() as DATE)
		AND sli.EffectiveStartDate     <= cast(GETDATE() as DATE)
		AND isnull(ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	GROUP BY sli.DimAccountId
		,sli.DimServiceLocationID
	)
,ServiceClassify

AS (
	SELECT   sli.DimAccountId
		,a.accountcode
		,sli.DimServiceLocationID
		-- IntGroup
		,CASE WHEN IsDataSvc = 1	THEN (ItemPrice * ItemQuantity)	    ELSE 0								END AS IntGrpSvcItemPrice
		,CASE WHEN IsDataSvc = 1	THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
			                        ELSE 0								                                    END AS IntGrpSvcnet
									
		-- SmartHome
		,CASE	WHEN [IsSmartHome] = 1	THEN (ItemPrice * ItemQuantity)	ELSE 0
				END AS SmartHomeItemPrice

		,CASE	WHEN [IsSmartHome] = 1	THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
										ELSE 0                                          				    END AS SmartHomenet

		--SmartHomePod
		,CASE	WHEN [IsSmartHomePod] = 1	THEN (ItemPrice * ItemQuantity)	ELSE 0 				            END AS SmartHomePodItemPrice

		,CASE	WHEN [IsSmartHomePod] = 1	THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
									    ELSE 0																END AS SmartHomePodnet

		-- cabGrp
		,CASE WHEN IsCableSvc = 1	THEN (ItemPrice * ItemQuantity)     ELSE 0								END AS CabGrpSvcItemPrice
		,CASE WHEN IsCableSvc = 1	THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
									ELSE 0								                                    END AS CabGrpSvcnet
		--HBO
		,CASE   WHEN HBOBulk + HBOQV + HBOSA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)			                ELSE 0								END AS HBOItemPrice
		,CASE   WHEN HBOBulk + HBOQV + HBOSA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END AS HBOnet
		--Cinemax
		,CASE   WHEN Cinemax_Standalone_QV + Cinemax_Standalone_SA + Cinemax_pkg_qv + Cinemax_Pkg_SA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)
																		ELSE 0								END AS CinemaxItemPrice
		,CASE 	WHEN Cinemax_Standalone_QV + Cinemax_Standalone_SA + Cinemax_pkg_qv + Cinemax_Pkg_SA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END AS Cinemaxnet
		--Showtime
		,CASE 	WHEN Showtime_QV + Showtime_SA > 0   AND IsCableSvc = 0      				THEN (ItemPrice * ItemQuantity)
																		ELSE 0								END AS ShowtimeItemPrice
		,CASE	WHEN Showtime_QV + Showtime_SA > 0   AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END AS Showtimenet
		--Starz
		,CASE WHEN Starz_QV + Starz_SA > 0		AND IsCableSvc = 0						THEN (ItemPrice * ItemQuantity)
																		ELSE 0								END AS StarzItemPrice
		,CASE WHEN Starz_QV + Starz_SA > 0	    AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END AS Starznet
		--OtherAddOn
		,CASE WHEN  IsCable = 1
				AND IsCableSvc = 0
				AND HBOBulk + HBOQV + HBOSA   = 0
				AND Cinemax_pkg_qv + Cinemax_Pkg_SA + Cinemax_Standalone_QV + Cinemax_Standalone_SA = 0
				AND Showtime_QV + Showtime_SA = 0
				AND Starz_QV + Starz_SA       = 0
				THEN (ItemPrice * ItemQuantity)
																		ELSE 0								END AS CabGrpAddOnItemPrice
		,CASE WHEN  IsCable = 1
				AND IsCableSvc = 0
				AND HBOBulk + HBOQV + HBOSA   = 0
				AND Cinemax_pkg_qv + Cinemax_Pkg_SA + Cinemax_Standalone_QV + Cinemax_Standalone_SA = 0
				AND Showtime_QV + Showtime_SA = 0
				AND Starz_QV + Starz_SA       = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS CabGrpAddOnnet


		--PointGuard
		,CASE	WHEN [IsPointGuard] = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS PointGuardItemPrice

		,CASE	WHEN [IsPointGuard] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS PointGuardnet

		--OtherAddOn
		,CASE	WHEN IsData = 1
				AND IsSmartHome    + IsSmartHomePod + IsPointGuard + IsDataSvc = 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS IntGrpAddOnItemPrice

		,CASE	WHEN IsData = 1
				AND IsSmartHome    + IsSmartHomePod + IsPointGuard + IsDataSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS IntGrpAddOnnet

		--phnGrp 
		,CASE	WHEN IsLocalPhn + IsComplexPhn > 0				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS PhnGrpSvcItemPrice

		,CASE   WHEN IsLocalPhn + IsComplexPhn > 0				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS PhnGrpSvcnet

		--OtherAddOn
		,CASE	WHEN IsPhone = 1		AND IsLocalPhn + IsComplexPhn = 0		THEN (ItemPrice * ItemQuantity)
		        WHEN IsPhone = 0        AND IsLocalPhn + IsComplexPhn = 0 AND (IsCallPlan+IsUnlimitedLD+NonPub+NonList+ForeignList+TollFree) > 0 THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS PhnGrpAddOnItemPrice

		,CASE   WHEN IsPhone = 1		AND IsLocalPhn + IsComplexPhn = 0		THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
		        WHEN IsPhone = 0        AND IsLocalPhn + IsComplexPhn = 0 AND (IsCallPlan+IsUnlimitedLD+NonPub+NonList+ForeignList+TollFree) > 0 THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS PhnGrpAddOnnet

		,CASE	WHEN IsPromo = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS PromoPrice

		,CASE	WHEN IsPromo = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS Promonet

		,CASE	WHEN IsTaxOrFee = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS TaxOrFeePrice

		,CASE	WHEN IsTaxOrFee = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END AS TaxFeeNet
		--IsOther
		,CASE	WHEN IsOther = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END AS OtherPrice

		,CASE	WHEN IsOther = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
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
		SELECT  DimCustomerItemId
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
		WHERE DimCustomerItemId <> 0
		)                                                 sli
	JOIN DimCustomerItem                                  dci  ON  sli.DimCustomerItemId    = dci.DimCustomerItemId
	                                                           AND isnull(dci.ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	JOIN #AcctTemp                                        a    ON  sli.DimAccountId         = a.DimAccountId
		                                                       AND sli.DimServiceLocationId = a.DimServiceLocationId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem]     ci   ON  ci.DimCatalogItemId      = sli.DimCatalogItemId
	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc   ON  ci.ComponentCode         = pc.ComponentCode
	LEFT JOIN intcat                                      ir   ON  sli.DimAccountId         = ir.DimAccountId
		                                                       AND sli.DimServiceLocationId = ir.DimServiceLocationId
	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdInternetRank irnk ON  ir.rnk                   = irnk.Rnk
	LEFT JOIN cablecat                                    cir  ON  sli.DimAccountId         = cir.DimAccountId
		                                                       AND sli.DimServiceLocationId = cir.DimServiceLocationId
	LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdCableRank    cirnk ON cir.rnk                  = cirnk.Rnk
	WHERE 1=1
	    AND sli.Deactivation_DimDateId >  cast(GETDATE() as DATE)
		AND sli.EffectiveEndDate       >  cast(GETDATE() as DATE)
	    AND sli.Activation_DimDateId   <= cast(GETDATE() as DATE)
		AND sli.EffectiveStartDate     <= cast(GETDATE() as DATE)
		AND sli.DimAccountId           <> 0
		AND PC.ComponentClass          <> 'Package'
		AND pc.IsIgnored               = 0
		AND pc.IsNRC_Scheduling        = 0
	GROUP BY sli.DimAccountId
		,a.accountcode
		,sli.DimServiceLocationID
		,CASE 	WHEN IsDataSvc = 1				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE 	WHEN IsDataSvc = 1				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--SmartHome
		,CASE	WHEN [IsSmartHome] = 1			THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN [IsSmartHome] = 1			THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--SmartHomePod
		,CASE	WHEN [IsSmartHomePod] = 1		THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN [IsSmartHomePod] = 1		THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--PointGuard
		,CASE	WHEN [IsPointGuard] = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN [IsPointGuard] = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--OtherAddOn
		,CASE	WHEN IsData = 1
				AND IsSmartHome + IsSmartHomePod + IsPointGuard + IsDataSvc = 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN IsData = 1
				AND IsSmartHome + IsSmartHomePod + IsPointGuard + IsDataSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		,CASE	WHEN IsCableSvc = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN IsCableSvc = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--HBO
		,CASE   WHEN HBOBulk + HBOQV + HBOSA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)			                ELSE 0								END  
		,CASE   WHEN HBOBulk + HBOQV + HBOSA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END  
		--Cinemax
		,CASE   WHEN Cinemax_Standalone_QV + Cinemax_Standalone_SA + Cinemax_pkg_qv + Cinemax_Pkg_SA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)
																		ELSE 0								END  
		,CASE 	WHEN Cinemax_Standalone_QV + Cinemax_Standalone_SA + Cinemax_pkg_qv + Cinemax_Pkg_SA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
																		ELSE 0								END
		--Showtime
		,CASE	WHEN Showtime_QV + Showtime_SA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0
				END
		,CASE	WHEN Showtime_QV + Showtime_SA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0
				END
		--Starz
		,CASE	WHEN Starz_QV + Starz_SA > 0 AND IsCableSvc = 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0	END
		,CASE	WHEN Starz_QV + Starz_SA > 0 AND IsCableSvc = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0	END
		--OtherAddOn
		,CASE	WHEN  IsCable = 1
				AND IsCableSvc = 0
				AND HBOBulk + HBOQV + HBOSA   = 0
				AND Cinemax_pkg_qv + Cinemax_Pkg_SA + Cinemax_Standalone_QV + Cinemax_Standalone_SA = 0
				AND Showtime_QV + Showtime_SA = 0
				AND Starz_QV + Starz_SA       = 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0	END 
		,CASE	WHEN  IsCable = 1
				AND IsCableSvc = 0
				AND HBOBulk + HBOQV + HBOSA   = 0
				AND Cinemax_pkg_qv + Cinemax_Pkg_SA + Cinemax_Standalone_QV + Cinemax_Standalone_SA = 0
				AND Showtime_QV + Showtime_SA = 0
				AND Starz_QV + Starz_SA       = 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0	END
		,CASE	WHEN IsLocalPhn + IsComplexPhn > 0
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN IsLocalPhn + IsComplexPhn > 0
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--OtherAddOn
		,CASE	WHEN IsPhone = 1				AND IsLocalPhn + IsComplexPhn = 0				THEN (ItemPrice * ItemQuantity)
		        WHEN IsPhone = 0        AND IsLocalPhn + IsComplexPhn = 0 AND (IsCallPlan+IsUnlimitedLD+NonPub+NonList+ForeignList+TollFree) > 0 THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN IsPhone = 1				AND IsLocalPhn + IsComplexPhn = 0				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
		        WHEN IsPhone = 0        AND IsLocalPhn + IsComplexPhn = 0 AND (IsCallPlan+IsUnlimitedLD+NonPub+NonList+ForeignList+TollFree) > 0 THEN  ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		,CASE	WHEN IsPromo = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE 	WHEN IsPromo = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		,CASE 	WHEN IsTaxOrFee = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE	WHEN IsTaxOrFee = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		--IsOther
		,CASE	WHEN IsOther = 1
				THEN (ItemPrice * ItemQuantity)
				ELSE 0			END
		,CASE 	WHEN IsOther = 1
				THEN ROUND((ItemPrice * ItemQuantity) - ((ItemPrice * ItemQuantity) * (DiscPerc/DiscCount)), 2)
				ELSE 0			END
		,ServiceLocationState
		,ServiceLocationCity
		,ServiceLocationPostalCode
		,ServiceLocationTaxArea
		,irnk.Category
		,cirnk.Category
	)
--select * from ServiceClassify



-- SET 1
, PreAllocation 

AS (
SELECT   
	 a.DimAccountId  
	,a.DimServiceLocationID
	,a.AccountCode
    ,max(a.AccountGroupCode) AccountGroupCode
	,max(a.AccountType) AccountType
	,max(a.AccountName) AccountName
	,max(a.AccountActivationDate) AccountActivationDate
	,max(a.AccountDeactivationDate) AccountDeactivationDate
	,max(a.AccountStatus ) AccountStatus
	,max(a.PhoneNumber) PhoneNumber
	,max(a.Email) Email
	,max(a.CPNIEmail) CPNIEmail
	,max(a.Telephone1) Telephone1
	,max(a.Phone) Phone
	,max(a.Phone2) Phone2
	,max(a.Phone3) Phone3
	,max(a.PortalEmail) PortalEmail
	,max(a.PortalUserExists) PortalUserExists
	,max(a.FirstServiceInstallDate) FirstServiceInstallDate
	,max(a.LastServiceDisconnectDate) LastServiceDisconnectDate
	,max(ServiceLocationFullAddress) ServiceAddress
	,max(StreetName) ServiceStreetName
	,max(ServiceLocationState) ServiceState
	,max(ServiceLocationCity) ServiceCity
	,max(ServiceLocationPostalCode) ServicePostalCode
	,max(ServiceLocationTaxArea) ServiceTaxArea
	,max(SalesRegion) ServiceSalesRegion
	,max(ProjectCode) ServiceProjectCode
	,max(BillingAddressStreetLine1) BillingAddressLine1
	,max(BillingAddressStreetLine2) BillingAddressLine2
	,max(BillingAddressStreetLine3) BillingAddressLine3
	,max(BillingAddressStreetLine4) BillingAddressLine4
	,max(BillingAddressCity) BillingAddressCity
	,max(BillingAddressState) BillingAddressState
	,max(BillingAddressPostalCode) BillingAddressPostalCode
	,max(a.CycleDescription) CycleDescription
	,max(a.CycleNumber) CycleNumber
	,max(a.[Location Zone]) [Location Zone]
	,max(a.Cabinet) Cabinet
	,max(a.[Wirecenter Region]) [Wirecenter Region]
	,max(a.[FM AddressID]) [FM AddressID]
	,max(a.[Omnia SrvItemLocationID]) [Omnia SrvItemLocationID]
	,max(a.Internal) Internal
	,max(a.Courtesy) Courtesy
	,CASE 	WHEN SUM(CAST(sc.IsEmployee AS INT)) > 0	   THEN 'Y' 			ELSE 'N' 			END EmployeeFlag
	,max(a.MilitaryDiscount) MilitaryDiscount
	,max(a.SeniorDiscount) SeniorDiscount
	,max(a.PointPause) PointPause
	,max(a.Ebill_Flag) Ebill_Flag
	--Package
--	,max(CASE 	WHEN pack.DimAccountId IS NOT NULL   			THEN 'Y'			ELSE 'N'			END) HasPackage
--	,max(isnull(Package, '') )                                                                               Package
--	,max(isnull(TotalPackageCharge, '') )                                                                    TotalPackageCharge
	--,Internet
	,CASE 	WHEN SUM(CAST(sc.IsData AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasData
	,CASE 	WHEN SUM(CAST(sc.IsDataSvc AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasDataSvc
	,max(isnull(DataCategory, '') )                                                                     DataCategory
	,max(isnull(a.DataSvc, '')    )                                                                     DataSvc
	,cast(Sum(isnull(sc.IntGrpSvcItemPrice, 0) * IsDataSvc)     AS DECIMAL(12,2)  )                     DataServiceCharge
	,cast(Round(SUM(isnull(sc.IntGrpSvcnet, 0) * IsDataSvc), 2) AS DECIMAL(12,2)  )                     DataServiceNetCharge
	,CASE	WHEN SUM(CAST(sc.IsSmartHome AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasSmartHome
	,cast(Sum(isnull(sc.SmartHomeItemPrice, 0) * IsSmartHome)       AS DECIMAL(12,2)  )                 SmartHomeServiceCharge
	,cast(Sum(isnull(sc.SmartHomeNet, 0) * IsSmartHome)             AS DECIMAL(12,2)  )                 SmartHomeServiceNetCharge
	,CASE 	WHEN SUM(CAST(sc.IsSmartHomePod AS INT)) > 0	THEN 'Y'			ELSE 'N'			END HasSmartHomePod
	,cast(Sum(isnull(sc.SmartHomePodItemPrice, 0) * IsSmartHomePod) AS DECIMAL(12,2)  )                 SmartHomePodCharge
	,cast(Sum(isnull(sc.SmartHomePodNet, 0) * IsSmartHomePod)       AS DECIMAL(12,2)  )                 SmartHomePodNetCharge
	,CASE 	WHEN SUM(CAST(sc.IsPointGuard AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasPointGuard
	,cast(Sum(isnull(sc.PointGuardItemPrice, 0) * IsPointGuard) AS DECIMAL(12,2)  )                     PointGuardCharge
	,cast(Sum(isnull(sc.PointGuardNet, 0) * IsPointGuard) AS DECIMAL(12,2)  )                           PointGuardNetCharge
	,cast(SUM(isnull(sc.IntGrpAddOnItemPrice, 0) * IsData) AS DECIMAL(12,2)  )                          DataAddOnCharge
	,cast(SUM(isnull(sc.IntGrpAddOnnet, 0) * IsData) AS DECIMAL(12,2)  )                                DataAddOnNetCharge
	--Cable,
	,CASE 	WHEN SUM(CAST(sc.IsCable AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasCable
	,CASE 	WHEN SUM(CAST(sc.IsCableSvc AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasCableSvc
	,max(isnull(CableCategory, '')  )                                                                   CableCategory
	,max(isnull(a.CableSvc, '')     )                                                                   CableSvc
	,cast(Sum(sc.CabGrpSvcItemPrice * IsCableSvc)     AS DECIMAL(12,2)  )                               CableServiceCharge
	,cast(Round(SUM(sc.CabGrpSvcnet * IsCableSvc), 2) AS DECIMAL(12,2)  )                               CableServiceNetCharge
	,CASE 	WHEN SUM(CAST(sc.IsHBO AS INT)) > 0			    THEN 'Y'			ELSE 'N'			END HasHBO
	,cast(Sum(sc.HBOItemPrice * IsHBO) AS  DECIMAL(12,2)  )                                             HBOServiceCharge
	,cast(Sum(sc.HBONet * IsHBO) AS  DECIMAL(12,2)  )													HBONetCharge
	,CASE 	WHEN SUM(CAST(sc.IsCinemax AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasCinemax
	,cast(Sum(sc.CinemaxItemPrice * IsCinemax) AS DECIMAL(12,2)  )                                      CinemaxServiceCharge
	,cast(Sum(sc.CinemaxNet * IsCinemax) AS DECIMAL(12,2)  )                                            CinemaxNetCharge
	,CASE 	WHEN SUM(CAST(sc.IsShowtime AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasShowtime
	,cast(Sum(sc.ShowtimeItemPrice * IsShowtime) AS DECIMAL(12,2)  )                                    ShowtimeServiceCharge
	,cast(Sum(sc.ShowtimeNet * IsShowtime) AS DECIMAL(12,2)  )                                          ShowtimeNetCharge
	,CASE 	WHEN SUM(CAST(sc.IsStarz AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasStarz
	,cast(Sum(sc.StarzItemPrice * IsStarz) AS DECIMAL(12,2)  )                                          StarzServiceCharge
	,cast(Sum(sc.StarzNet * IsStarz) AS DECIMAL(12,2)  )                                                StarzNetCharge
	,cast(SUM(sc.CabGrpAddOnItemPrice * IsCable) AS DECIMAL(12,2)  )                                    CableAddOnCharge
	,cast(SUM(sc.CabGrpAddOnnet * IsCable) AS DECIMAL(12,2)  )                                          CableAddOnNetCharge
	--Phone
	,CASE 	WHEN SUM(CAST(sc.IsPhone AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasPhone
	,CASE 	WHEN SUM(CAST(sc.IsPhoneSvc AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasPhoneSvc
	,CASE 	WHEN SUM(CAST(sc.IsComplexSvc AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasComplexPhoneSvc
	,max(isnull(a.PhoneSvc, '')) PhoneSvc
	--PhnGrp,             
	,cast(Sum((PhnGrpSvcItemPrice * IsPhoneSvc) + (PhnGrpSvcItemPrice * IsComplexSvc)) AS DECIMAL(12,2)  ) PhoneServiceCharge
	,cast(Sum((PhnGrpSvcnet * IsPhoneSvc) + (PhnGrpSvcnet * IsComplexSvc))             AS DECIMAL(12,2)  ) PhoneServiceNetCharge
	,cast(SUM(sc.PhnGrpAddOnItemPrice * IsPhone) AS DECIMAL(12,2)  )                                       PhoneAddOnCharge
	,cast(SUM(sc.PhnGrpAddOnnet * IsPhone)       AS DECIMAL(12,2)  )                                       PhoneAddOnNetCharge
	--Promo
	,CASE 	WHEN SUM(CAST(sc.IsPromo AS INT)) > 0			THEN 'Y'			ELSE 'N'			END HasPromo
	,cast(Sum(sc.PromoPrice * IsPromo)         AS DECIMAL(12,2)  )                                      PromoCharge
	,cast(Round(SUM(sc.Promonet * IsPromo), 2) AS DECIMAL(12,2)  )                                      PromoNetCharge
	--TaxOrFee
	,CASE	WHEN SUM(CAST(sc.IsTaxOrFee AS INT)) > 0		THEN 'Y'			ELSE 'N'			END HasTaxOrFee
	,cast(Sum(sc.TaxOrFeePrice * IsTaxOrFee) AS DECIMAL(12,2)  )                                        TaxFeeCharge
	,cast(Round(SUM(sc.TaxFeeNet * IsTaxOrFee), 2) AS DECIMAL(12,2)  )                                  TaxFeeNetCharge
	---Flags
	,CASE 	WHEN SUM(CAST(sc.IsOther AS INT)) > 0   		THEN 'Y'			ELSE 'N'			END HasOther
	,cast(Sum(sc.OtherPrice * IsOther) AS DECIMAL(12,2)  )                                              OtherCharge
	,cast(Round(SUM(sc.OtherNet * IsOther), 2) AS DECIMAL(12,2)  )                                      OtherNetCharge
	,max(a.AutoPay) AutoPay
	,cast(Round(SUM((isnull(sc.IntGrpSvcnet, 0)    * IsDataSvc) 
	              + (isnull(sc.SmartHomeNet, 0)    * IsSmartHome) 
	              + (isnull(sc.SmartHomePodNet, 0) * IsSmartHomePod)
				  + (isnull(sc.PointGuardNet, 0)   * IsPointGuard) 
				  + (isnull(sc.IntGrpAddOnnet, 0)  * IsData) 
				  + (isnull(sc.CabGrpSvcnet, 0)    * IsCableSvc) 
				  + (isnull(sc.HBONet, 0)          * IsHBO) 
				  + (isnull(sc.CinemaxNet, 0)      * IsCinemax) 
				  + (isnull(sc.ShowtimeNet, 0)     * IsShowtime) 
				  + (isnull(sc.StarzNet, 0)        * IsStarz) 
				  + (isnull(sc.CabGrpAddOnnet, 0)  * IsCable) 
				  + ((isnull(PhnGrpSvcnet, 0)      * IsPhoneSvc) 
				  + (isnull(PhnGrpSvcnet, 0)       * IsComplexSvc)) 
				  + (isnull(sc.PhnGrpAddOnnet, 0)  * IsPhone) 
				  + (isnull(sc.Promonet, 0)        * IsPromo) 
				  + (isnull(sc.TaxFeeNet, 0)       * IsTaxOrFee) 
				  + (isnull(sc.OtherNet, 0)        * IsOther)
					), 2) AS DECIMAL(12,2) ) 
          TotalCharge
	,max(a.LocationId) LocationId
	,max(DiscPerc) DiscPerc
	,max(DiscCount) DiscCount
	FROM #AcctTemp a
	JOIN ServiceClassify     sc  ON  a.DimAccountId         = sc.DimAccountId
								 AND a.DimServiceLocationId = sc.DimServiceLocationId
	GROUP BY 
	 a.DimAccountId  
	,a.DimServiceLocationID
	,a.AccountCode
)
	INSERT INTO dbo.PBB_ProductAnalysisDetails_Stage SELECT *  FROM PreAllocation;

---------------------------------------------------------------------------------
WITH
PackageClassify

AS (
	SELECT a.DimAccountId
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
	FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem]			fci
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCustomerItem			dci  ON  fci.DimCustomerItemId    = dci.DimCustomerItemId
																	 AND isnull(dci.ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimCatalogItem				dcat ON  fci.DimCatalogItemId     = dcat.DimCatalogItemId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount					a    ON  a.DimAccountId           = fci.DimAccountId
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap]			prd  ON  dcat.ComponentCode       = prd.ComponentCode
																	 AND prd.ComponentClassID     = 200
	JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimServiceLocation			DSL  ON  fci.DimServiceLocationId = DSL.DimServiceLocationId
	WHERE prd.ComponentClassID = 200
		AND Deactivation_DimDateId >  cast(GETDATE() as DATE)
		AND EffectiveEndDate       >  cast(GETDATE() as DATE)
		AND Activation_DimDateId   <= cast(GETDATE() as DATE)
		AND EffectiveStartDate     <= cast(GETDATE() as DATE)
		AND isnull(dci.ItemDeactivationDate, '12-31-2050') > cast(GETDATE() as DATE)
		AND fci.DimAccountId <> 0
	GROUP BY a.DimAccountId
		,a.AccountCode
		,a.AccountName
		,DSL.DimServiceLocationId
		,dcat.itemprintdescription
	)
	
,PackageSummary

AS (
	SELECT 
		 dimaccountid
		,DimServiceLocationid
		,accountcode
		,accountname
		,Package = stuff((
				SELECT DISTINCT '; ' + Package
				FROM PackageClassify IPC
				WHERE IPC.accountcode = PC.accountcode
					AND IPC.dimservicelocationid = PC.DimservicelocationID
				FOR XML path('')
				), 1, 2, '')
		,sum(TotalPackageCharge) TotalPackageCharge
	FROM PackageClassify PC
	GROUP BY 		 
		 dimaccountid
		,DimServiceLocationid
		,accountcode
		,accountname		
 
) ,

PackageParts

AS (
    SELECT x.AccountCode
	     , x.LocationId
		 , sum(case when ComponentClass = 'CALL FEATURES' and L5_DisplayName     like '%Line%'             then DisperseAmount*NumOfItems  else 0 end) PhoneServiceCharge
		 , sum(case when ComponentClass = 'CALL FEATURES' and L5_DisplayName not like '%Line%'             then DisperseAmount*NumOfItems  
		            when ComponentClass = 'LD SRV ITEM SPECIFIC CALL PLAN'                                 then DisperseAmount*NumOfItems  else 0 end) PhoneAddOnCharge
		 , sum(case when ComponentClass like '%Internet%'     and L5_DisplayName <> 'Smart Home'           then DisperseAmount*NumOfItems  else 0 end) DataServiceCharge
		 , sum(case when ComponentClass = 'INTERNET FEATURES' and L5_DisplayName =  'Smart Home'           then DisperseAmount*NumOfItems  else 0 end) SmartHomeCharge
		 , sum(case when Componentclass = 'GENERAL USE'                                                    then DisperseAmount*NumOfItems  else 0 end) PromoCharge
		 , min(Allocateable)                                                 Allocateable
		 , max(case when Allocateable='Y' then 1                 else 0 end) AllocateFlag
		 , sum(case when Allocateable='Y' then DisperseAmount*NumOfItems     else 0 end) DisperseAmount
		 , sum(case when Allocateable='N' then UnallocatedCharge*NumOfItems  else 0 end) UnallocatedPkgAmount
	  FROM (
			SELECT AccountCode
				 , sh.LocationId
				 , L5_ComponentClass ComponentClass
				 , case when L5_DisplayName like '%Line%'       then 'Line' 
				        when L5_DisplayName like '%Smart Home%' then 'Smart Home'
						else '' end L5_DisplayName
				 , IsDataSvc, IsSmartHome, IsPointGuard, IsPhone, IsLocalPhn, IsUnlimitedLD, IsCallPlan, IsCableSvc, IsPromo, IsOther
				 , sum(case when Allocateable='Y' then cast(bc1.DisperseAmount as decimal(12,2)) else 0 end)/count(*)  DisperseAmount
				 , sum(case when Allocateable='N' then cast(bc1.StandardRate   as decimal(12,2)) else 0 end)/count(*)  UnallocatedCharge
				 , count(*) NumOfItems
				 , min(Allocateable) Allocateable
				 -- select *
			  FROM PWB_AccountServiceHier_tb                   sh
			  JOIN dbo.PrdComponentMap                         pcm on  pcm.ComponentId      = sh.ComponentId
			  join PWB_PackageWeightsBalancedComponent_tb      bc1 on  bc1.ProductOffering  = sh.L1_DisplayName
														           and bc1.PackageComponent = sh.L4_DisplayName
														           and bc1.component        = sh.L5_DisplayName
														           and bc1.PriceList        = sh.PriceList
														           and coalesce(bc1.PricePlan,'') = coalesce(sh.PricePlan,'')
																   AND coalesce(bc1.DisperseAmount,0.00) <> 0.00 
	--	  AND accountCode = '100514624'
			 GROUP BY AccountCode
				 , sh.LocationId
				 , L5_ComponentClass
				 , case when L5_DisplayName like '%Line%'       then 'Line' 
				        when L5_DisplayName like '%Smart Home%' then 'Smart Home'
						else '' end
				 , IsDataSvc, IsSmartHome, IsPointGuard, IsPhone, IsLocalPhn, IsUnlimitedLD, IsCallPlan, IsCableSvc, IsPromo, IsOther
		) x
		GROUP BY x.AccountCode, x.LocationId 
   ) 

-- PostAllocation
, PostAllocation

AS (
SELECT DISTINCT 
	 a.AccountCode
	,a.LocationId
    ,a.AccountGroupCode
	,a.AccountType
	,a.DimAccountId
	,a.AccountName
	,a.AccountActivationDate
	,a.AccountDeactivationDate
	,a.AccountStatus 
	,a.PhoneNumber
	,a.Email
	,a.CPNIEmail, a.Telephone1, a.Phone, a.Phone2, a.Phone3, a.PortalEmail, a.PortalUserExists 
	,a.FirstServiceInstallDate
	,a.LastServiceDisconnectDate
	,a.DimServiceLocationID
	, ServiceAddress
	, ServiceStreetName
	, ServiceState
	, ServiceCity
	, ServicePostalCode
	, ServiceTaxArea
	, ServiceSalesRegion
	, ServiceProjectCode
	, BillingAddressLine1
	, BillingAddressLine2
	, BillingAddressLine3
	, BillingAddressLine4
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
	, EmployeeFlag
	,a.MilitaryDiscount
	,a.SeniorDiscount
	,a.PointPause
	,a.Ebill_Flag
	--Package
	,CASE WHEN pack.DimAccountId IS NOT NULL THEN 'Y' ELSE 'N' END HasPackage
	,pack.Package
	,pack.TotalPackageCharge
	,pack.TotalPackageCharge - pack.TotalPackageCharge*(DiscPerc/DiscCount) TotalPackageChargeNet
	--,Internet
	, (case when Package is not null and pkgp.AccountCode is null           then TotalPackageCharge -  TotalPackageCharge*(DiscPerc/DiscCount)
	        when TotalPackageCharge < coalesce(pkgp.UnallocatedPkgAmount,0) then TotalPackageCharge -  TotalPackageCharge*(DiscPerc/DiscCount)
			else coalesce(pkgp.UnallocatedPkgAmount,0) - pkgp.UnallocatedPkgAmount*(DiscPerc/DiscCount) end
	  ) UnallocatedPackageCharge
	,HasData
	,HasDataSvc
	,DataCategory
	,DataSvc
	,a.DataServiceCharge        +  (coalesce(pkgp.DataServiceCharge,0)*isnull(pkgp.AllocateFlag,0)) DataServiceCharge
	,DataServiceNetCharge       +  ( (coalesce(pkgp.DataServiceCharge,0)- coalesce(pkgp.DataServiceCharge*(DiscPerc/DiscCount),0) ) * isnull(pkgp.AllocateFlag,0)) DataServiceNetCharge
	,HasSmartHome
	,SmartHomeServiceCharge     +  (coalesce(pkgp.SmartHomeCharge,0)*isnull(pkgp.AllocateFlag,0)) SmartHomeServiceCharge
	,SmartHomeServiceNetCharge  +  ( (coalesce(pkgp.SmartHomeCharge,0)- coalesce(pkgp.SmartHomeCharge*(DiscPerc/DiscCount),0) ) * isnull(pkgp.AllocateFlag,0))    SmartHomeServiceNetCharge
	,HasSmartHomePod
	,SmartHomePodCharge
	,SmartHomePodNetCharge
	,HasPointGuard
	,PointGuardCharge
	,PointGuardNetCharge
	,DataAddOnCharge
	,DataAddOnNetCharge
	--Cable,
	,HasCable
	,HasCableSvc
	,CableCategory
	,CableSvc
	,CableServiceCharge
	,CableServiceNetCharge
	,HasHBO
	,HBOServiceCharge
	,HBONetCharge
	,HasCinemax
	,CinemaxServiceCharge
	,CinemaxNetCharge
	,HasShowtime
	,ShowtimeServiceCharge
	,ShowtimeNetCharge
	,HasStarz
	,StarzServiceCharge
	,StarzNetCharge
	,CableAddOnCharge
	,CableAddOnNetCharge
	--Phone
	,HasPhone
	,HasPhoneSvc
	,HasComplexPhoneSvc
	,PhoneSvc
	--PhnGrp,             
	,a.PhoneServiceCharge    +  (coalesce(pkgp.PhoneServiceCharge,0)*isnull(pkgp.AllocateFlag,0)) PhoneServiceCharge
	,PhoneServiceNetCharge   +  ( (coalesce(pkgp.PhoneServiceCharge,0)- coalesce(pkgp.PhoneServiceCharge*(DiscPerc/DiscCount),0) ) * isnull(pkgp.AllocateFlag,0))  PhoneServiceNetCharge
	,a.PhoneAddOnCharge      +  (coalesce(pkgp.PhoneAddOnCharge,0)*isnull(pkgp.AllocateFlag,0))  PhoneAddOnCharge
	,PhoneAddOnNetCharge     +  ( (coalesce(pkgp.PhoneAddOnCharge,0)- coalesce(pkgp.PhoneAddOnCharge*(DiscPerc/DiscCount),0) )     * isnull(pkgp.AllocateFlag,0))  PhoneAddOnNetCharge
	--Promo
	,HasPromo
	,a.PromoCharge           +  (coalesce(pkgp.PromoCharge,0)*isnull(pkgp.AllocateFlag,0))   PromoCharge
	,PromoNetCharge          +  ( (coalesce(pkgp.PromoCharge,0)- coalesce(pkgp.PromoCharge*(DiscPerc/DiscCount),0) )               * isnull(pkgp.AllocateFlag,0))   PromoNetCharge
	--TaxOrFee
	,HasTaxOrFee
	,TaxFeeCharge
	,TaxFeeNetCharge
	---Flags
	,HasOther
	,OtherCharge
	,OtherNetCharge
	,a.AutoPay
	,TotalCharge  + coalesce(pkgp.DisperseAmount, 0) - coalesce(pkgp.DisperseAmount*(DiscPerc/DiscCount),0)  

				  + (case	when Package is not null and pkgp.AccountCode is null           then TotalPackageCharge - coalesce(TotalPackageCharge*(DiscPerc/DiscCount),0)  
							when TotalPackageCharge < coalesce(pkgp.UnallocatedPkgAmount,0) then TotalPackageCharge - coalesce(TotalPackageCharge*(DiscPerc/DiscCount),0)  
							else coalesce(pkgp.UnallocatedPkgAmount,0)  - coalesce(pkgp.UnallocatedPkgAmount*(DiscPerc/DiscCount),0)  end 
					)

				  + (case   when Package is not null and coalesce(pkgp.DisperseAmount,0)+
							(case	when Package is not null and pkgp.AccountCode is null           then TotalPackageCharge 
									when TotalPackageCharge < coalesce(pkgp.UnallocatedPkgAmount,0) then TotalPackageCharge 
									else coalesce(pkgp.UnallocatedPkgAmount,0) end
							) = 0 then TotalPackageCharge  - coalesce(TotalPackageCharge*(DiscPerc/DiscCount),0)  
							else 0 
							end) TotalCharge

	,    (case when coalesce(pkgp.Allocateable,'') ='N'                then 'Package Unallocated' 
			   when Package is not null and pkgp.AccountCode is null   then 'Package Unallocated'
	           when coalesce(pkgp.Allocateable  ,'')='Y'               then 'Package Allocated'
		       else null
		       end) PackageAllocation
 
 
FROM dbo.PBB_ProductAnalysisDetails_Stage       a
LEFT JOIN PackageParts   pkgp ON pkgp.AccountCode     = a.AccountCode
                              AND pkgp.LocationId      = a.LocationId
LEFT JOIN PackageSummary pack ON a.DimAccountId       = pack.DimAccountId
  	                          AND a.DimServiceLocationId = pack.DimServiceLocationId
)
INSERT INTO   dbo.PBB_ProductAnalysisDetails 
SELECT * 
  FROM PostAllocation 
  ;

 -- CREATE UNIQUE INDEX pk_ProductAnalysisDetails ON dbo.PBB_ProductAnalysisDetails (AccountCode, LocationId);

END
GO
