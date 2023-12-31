USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_CableSubscriberCount_Tab_Details]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_CableSubscriberCount_Tab_Details]
@StartDate		DATETIME = NULL,
@EndDate		DATETIME = NULL,
--
@TabName		VARCHAR(250) = NULL,
@DetailName		VARCHAR(250) = NULL,
--
@GenericParam1	VARCHAR(250) = NULL,
@GenericParam2	VARCHAR(250) = NULL,
@GenericParam3	VARCHAR(250) = NULL,
@GenericParam4	VARCHAR(250) = NULL,
@GenericParam5	VARCHAR(250) = NULL,
--
@AccountType	VARCHAR(250) = NULL,
@Market			VARCHAR(250) = NULL,
@AccountGroupCode VARCHAR(250) = NULL

AS
    BEGIN
;With cablecat AS 
	(SELECT DISTINCT 
                sli.DimAccountId, 
                sli.DimServiceLocationID, 
                MAX(ISNULL(r.rnk, 0)) rnk
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			  JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
              JOIN PrdCableRank r ON pc.Category = r.Category
        WHERE Activation_DimDateId <= GETDATE()
        AND	  Deactivation_DimDateId > GETDATE()
        AND   EffectiveStartDate <= GETDATE()
        AND   EffectiveEndDate > GETDATE()
		AND	  ISNULL(ItemDeactivationDate,'12-31-2050') > GETDATE()
        GROUP BY sli.DimAccountId, 
                  sli.DimServiceLocationID),
IntCat AS 
		(SELECT DISTINCT 
                sli.DimAccountId, 
                sli.DimServiceLocationID, 
                MAX(ISNULL(r.rnk, 0)) rnk
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
			  JOIN DimCustomerItem dci on sli.DimCustomerItemId = dci.DimCustomerItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
              JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PrdComponentMap pc ON ci.ComponentCode = pc.ComponentCode
              JOIN PrdInternetRank r ON pc.SpeedTier = r.Category
        WHERE Activation_DimDateId <= GETDATE()
        AND	  Deactivation_DimDateId > GETDATE()
        AND   EffectiveStartDate <= GETDATE()
        AND   EffectiveEndDate > GETDATE()
		AND   ISNULL(ItemDeactivationDate,'12-31-2050') > GETDATE()
        GROUP BY sli.DimAccountId, 
                  sli.DimServiceLocationID
				  ),
RESULT AS
		(SELECT 
			sli.DimAccountId, 
            sli.DimCustomerItemId, 
            a.accountcode, 
            sli.DimServiceLocationID, 
			cast(a.accountcode as nvarchar(10))+'|'+cast(sli.DimServiceLocationID as nvarchar(10)) AccountLocation, 
            --a.dimaccountid,
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
			IsFreeHD,
			EffectiveStartDate
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
		   AND	sli.DimAccountId <> 0
           AND	pc.IsIgnored = 0
		   AND	(pc.IsCable = 1 or pc.IsData = 1)
		   AND	 ISNULL(ItemDeactivationDate,'12-31-2050') > GETDATE()     
	 )
	SELECT  * 
	INTO	#RESULT
	FROM	RESULT
	WHERE	(NULLIF(@AccountType, '')		IS NULL OR AccountType		= @AccountType)
	AND		(NULLIF(@AccountGroupCode, '')	IS NULL OR AccountGroupCode = @AccountGroupCode)
	AND		(NULLIF(@Market, '')			IS NULL OR Market			= @Market)
	AND		Market IN ('BRI', 'CPC', 'DUF' ) --11/17/2021 Jackie + Alan comment

	--AND		(NULLIF(@StartDate, '')			IS NULL OR EffectiveStartDate >= @StartDate)
	--AND		(NULLIF(@EndDate, '')			IS NULL OR EffectiveStartDate <= @EndDate)

	IF (@StartDate IS NOT NULL)
	BEGIN
		--SELECT  * 
		--FROM	#RESULT
		--WHERE	EffectiveStartDate >= @StartDate
		PRINT 'StartDate NOT NULL'
	END

	IF (@EndDate IS NOT NULL)
	BEGIN
		--SELECT  * 
		--FROM	#RESULT
		--WHERE	EffectiveStartDate <= @EndDate
		PRINT 'EndDate NOT NULL'
	END

/**************************Internet Counts****************************/
IF	@TabName = 'InternetCounts'
	BEGIN
		SELECT		RowLabels =  AccountType, 
					AccountGroupCode, 
					Category,
					SpeedTier,
					AccountLocation = COUNT(AccountLocation)
		FROM		#RESULT

		WHERE		IsData = 1
		AND			IsDataSvc= 1
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS', 'HAGBUS', 'HAGRES', 'OPLRES', 'WHSBVU')

		GROUP BY	AccountType, AccountGroupCode, Category, SpeedTier
		ORDER BY	AccountType, AccountGroupCode, Category, SpeedTier
	END
/**************************************************************/
/**************************BRI CableCounts****************************/
ELSE  IF	@TabName = 'BRICableCounts'
	BEGIN
		SELECT		CableCategory = Market,						
					Category, 
					ComponentCode,
					ItemMarketingDescription,
					AccountLocation = COUNT(AccountLocation),
					ItemQuantity = SUM (ItemQuantity)
		FROM		#RESULT
		WHERE		IsCable = 1
		AND			IsCableSvc= 1
		AND			Market IN ('BRI', 'CPC')	

		GROUP BY	Market, /*CableCategory,*/ Category, ComponentCode, ItemMarketingDescription
		ORDER BY	Market, Category
	END
/**************************************************************/
/**************************Sports Southeast****************************/
ELSE  IF	@TabName = 'SportsSoutheast'
	BEGIN
		SELECT		CableCategory = ServiceLocationPostalCode, 
					Category, 
					ComponentCode,
					ItemMarketingDescription,
					AccountLocation = COUNT(AccountLocation),
					ItemQuantity = SUM (ItemQuantity)
		FROM		#RESULT
		WHERE		IsCable = 1
		AND			IsCableSvc= 1
		AND			Market = 'BRI'
		AND			ServiceLocationPostalCode IN (24201, 24251, 24258, 24270)

		GROUP BY	ServiceLocationPostalCode, Category, ComponentCode, ItemMarketingDescription
		ORDER BY	ServiceLocationPostalCode, Category, ComponentCode, ItemMarketingDescription
	END
/**************************************************************/
/**************************DUF Cable Counts****************************/
ELSE  IF	@TabName = 'DUFCableCounts'
	BEGIN
		SELECT		CableCategory = Category,			
					DMA, 
					ComponentCode,
					ItemMarketingDescription,	
					--Market,
					AccountLocation = COUNT(AccountLocation),
					ItemQuantity = SUM (ItemQuantity)
		FROM		#RESULT
		WHERE		IsCable = 1
		AND			IsCableSvc= 1
		AND			Market = 'DUF'

		GROUP BY	Category,DMA, ComponentCode, ItemMarketingDescription --,Market
		ORDER BY	Category,DMA, ComponentCode, ItemMarketingDescription
	END
/**************************************************************/

/**************************QVC_HSN****************************/
ELSE  IF	@TabName = 'QVC_HSN'
	BEGIN
		SELECT		CableCategory = Market,			
					ServiceLocationPostalCode, 
					Category,
					ComponentCode,
					ItemMarketingDescription,			
					AccountLocation = COUNT(AccountLocation),
					ItemQuantity = SUM (ItemQuantity)
		FROM		#RESULT
		WHERE		IsCable = 1
		AND			IsCableSvc= 1
		AND			CableCategory in ('VB', 'VE', 'VG', 'VI'  )
		AND			Market in ('BRI', 'CPC', 'DUF')

		GROUP BY	Market,	ServiceLocationPostalCode, Category, ComponentCode, ItemMarketingDescription
		ORDER BY	Market,	ServiceLocationPostalCode, Category, ComponentCode, ItemMarketingDescription
	END
/**************************************************************/

/**************************Premium Counts****************************/
/*****HBO*****/
ELSE  IF	@TabName = 'HBO'
	BEGIN
		SELECT		
					RowLabels =  HBO,
					AccountType,
					AccountGroupCode,
					--AccountLocation = SUM (ItemQuantity)
					AccountLocation = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			(HBO IS NOT NULL AND HBO <> '' )
		AND			HBO IN ('HBOQV', 'HBOSA')
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')
		GROUP BY	HBO, AccountType, AccountGroupCode
		ORDER BY	HBO, AccountType, AccountGroupCode
	END
/*****HBO BULK*****/
ELSE  IF	@TabName = 'HBOBULK'
	BEGIN
		SELECT		HBO,
					AccountType,
					AccountGroupCode,
					ItemQuantity = SUM (ItemQuantity)
					--ItemQuantity = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			(HBO IS NOT NULL AND HBO <> '' )
		AND			HBO IN ('HBOBulk')
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')
		GROUP BY	HBO, AccountType, AccountGroupCode
		ORDER BY	HBO, AccountType, AccountGroupCode
	END
/*****Cinemax*****/
ELSE  IF	@TabName = 'Cinemax'
	BEGIN
		SELECT		RowLabels =  Cinemax,
					AccountType,
					AccountGroupCode,
					--AccountLocation = SUM (ItemQuantity)
					AccountLocation = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			(Cinemax IS NOT NULL AND Cinemax <> '' )
		AND			Cinemax IN ('CinemaxStandAlongSA', 'CinemaxPkgQV')
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')

		GROUP BY	Cinemax, AccountType, AccountGroupCode
		ORDER BY	Cinemax, AccountType, AccountGroupCode
	END
/*****Hispanic*****/
ELSE  IF	@TabName = 'Hispanic'
	BEGIN
		SELECT		RowLabels =  IsHispanic,
					AccountType,
					AccountGroupCode,
					--AccountLocation = SUM (ItemQuantity)
					AccountLocation = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			IsHispanic = 1
		--AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')

		GROUP BY	IsHispanic, AccountType, AccountGroupCode
		ORDER BY	IsHispanic, AccountType, AccountGroupCode
	END	
/*****Showtime*****/
ELSE  IF	@TabName = 'Showtime'
	BEGIN
		SELECT		RowLabels =  Showtime,
					AccountType,
					AccountGroupCode,
					--AccountLocation = SUM (ItemQuantity)
					AccountLocation = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			(Showtime IS NOT NULL AND Showtime <> '' )
		AND			Showtime IN ('ShowtimeQV', 'ShowtimeSA')
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')

		GROUP BY	Showtime, AccountType, AccountGroupCode
		ORDER BY	Showtime, AccountType, AccountGroupCode
	END
/*****Starz*****/
ELSE  IF	@TabName = 'Starz'
	BEGIN
		SELECT		RowLabels =  Starz,
					AccountType,
					AccountGroupCode,
					--AccountLocation = SUM (ItemQuantity)
					AccountLocation = COUNT( Distinct AccountLocation)
		FROM		#RESULT 

		WHERE		IsCable = 1
		AND			(Starz IS NOT NULL AND Starz <> '' )
		AND			Starz IN ('StarzQA', 'StarzQV')
		AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')

		GROUP BY	Starz, AccountType, AccountGroupCode
		ORDER BY	Starz, AccountType, AccountGroupCode
	END
/**************************************************************/
/**************************IsFreeHD****************************/
ELSE  IF	@TabName = 'IsFreeHD'
	BEGIN
		SELECT		CableCategory = ComponentCode, 
					ItemMarketingDescription, 
					AccountLocation = COUNT(DISTINCT AccountLocation), 
					ItemQuantity = SUM(ItemQuantity)
		FROM		#RESULT
		WHERE		IsFreeHD = 1
		AND			IsCable = 1
		GROUP BY	ComponentCode, ItemMarketingDescription
		ORDER BY	ComponentCode
	END
/**************************************************************/
/**************************************************************/
/**************************Details****************************/
ELSE IF	@TabName = 'Details'
	BEGIN
	IF	@DetailName = 'InternetCounts'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsData = 1
			AND			IsDataSvc= 1
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS', 'HAGBUS', 'HAGRES', 'OPLRES', 'WHSBVU')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR AccountType		= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountGroupCode = @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR Category			= @GenericParam3)
			AND			(NULLIF(@GenericParam4, '') IS NULL OR SpeedTier		= @GenericParam4)
		END
/**************************************************************/
/**************************BRI CableCounts****************************/
	ELSE  IF	@DetailName = 'BRICableCounts'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			IsCableSvc= 1
			AND			Market IN ('BRI', 'CPC')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Market					= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR Category 				= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR ComponentCode			= @GenericParam3)
			AND			(NULLIF(@GenericParam4, '') IS NULL OR ItemMarketingDescription	= @GenericParam4)
		END
/**************************************************************/
/**************************Sports Southeast****************************/
	ELSE  IF	@DetailName = 'SportsSoutheast'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			IsCableSvc= 1
			AND			Market = 'BRI'
			AND			ServiceLocationPostalCode IN (24201, 24251, 24258, 24270)
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR ServiceLocationPostalCode	= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR Category 					= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR ComponentCode				= @GenericParam3)
			AND			(NULLIF(@GenericParam4, '') IS NULL OR ItemMarketingDescription		= @GenericParam4)
		END
/**************************************************************/
/**************************DUF Cable Counts****************************/
	ELSE  IF	@DetailName = 'DUFCableCounts'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			IsCableSvc= 1
			AND			Market = 'DUF'
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Category						= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR DMA 							= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR ComponentCode				= @GenericParam3)
			AND			(NULLIF(@GenericParam4, '') IS NULL OR ItemMarketingDescription		= @GenericParam4)

		END
/**************************************************************/

/**************************QVC_HSN****************************/
	ELSE  IF	@DetailName = 'QVC_HSN'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			IsCableSvc= 1
			AND			CableCategory in ('VB', 'VE', 'VG', 'VI'  )
			AND			Market in ('BRI', 'CPC', 'DUF')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Market						= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR ServiceLocationPostalCode 	= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR Category						= @GenericParam3)
			AND			(NULLIF(@GenericParam4, '') IS NULL OR ComponentCode				= @GenericParam4)
			AND			(NULLIF(@GenericParam5, '') IS NULL OR ItemMarketingDescription		= @GenericParam5)
		END
/**************************************************************/

/**************************Premium Counts****************************/
/*****HBO*****/
	ELSE  IF	@DetailName = 'HBO'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			(HBO IS NOT NULL AND HBO <> '' )
			AND			HBO IN ('HBOQV', 'HBOSA')
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')	
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR HBO				= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)
		END
	/*****HBO BULK*****/
	ELSE  IF	@DetailName = 'HBOBULK'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			(HBO IS NOT NULL AND HBO <> '' )
			AND			HBO IN ('HBOBulk')
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')		
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR HBO				= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)
	END
/*****Cinemax*****/
	ELSE  IF	@DetailName = 'Cinemax'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			(Cinemax IS NOT NULL AND Cinemax <> '' )
			AND			Cinemax IN ('CinemaxStandAlongSA', 'CinemaxPkgQV')
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Cinemax			= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)	
		END
/*****Hispanic*****/
	ELSE  IF	@DetailName = 'Hispanic'
		BEGIN
			SELECT		*
			FROM		#RESULT

			WHERE		IsCable = 1
			AND			IsHispanic = 1		
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR IsHispanic		= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)	
		END	
/*****Showtime*****/
	ELSE  IF	@DetailName = 'Showtime'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			(Showtime IS NOT NULL AND Showtime <> '' )
			AND			Showtime IN ('ShowtimeQV', 'ShowtimeSA')
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Showtime			= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)	
		END
/*****Starz*****/
	ELSE  IF	@DetailName = 'Starz'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsCable = 1
			AND			(Starz IS NOT NULL AND Starz <> '' )
			AND			Starz IN ('StarzQA', 'StarzQV')
			AND			AccountGroupCode IN ('BRIBUS','BRIRES', 'CPCRES', 'CPCBUS', 'DUFRES', 'DUFBUS')
			--
			AND			(NULLIF(@GenericParam1, '') IS NULL OR Starz			= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR AccountType 		= @GenericParam2)
			AND			(NULLIF(@GenericParam3, '') IS NULL OR AccountGroupCode	= @GenericParam3)	

		END
/**************************************************************/
/**************************IsFreeHD****************************/
	ELSE  IF	@DetailName = 'IsFreeHD'
		BEGIN
			SELECT		*
			FROM		#RESULT
			WHERE		IsFreeHD = 1
			AND			IsCable = 1		
			AND			(NULLIF(@GenericParam1, '') IS NULL OR ComponentCode				= @GenericParam1)
			AND			(NULLIF(@GenericParam2, '') IS NULL OR ServiceLocationPostalCode	= @GenericParam2)			
		END
	ELSE 
		BEGIN
			SELECT		--TOP 1000--------------------------------------------
						*
			FROM		#RESULT
		END
	END
/**************************************************************/

DROP TABLE #RESULT

END

/*
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'InternetCounts'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'BRICableCounts'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'SportsSoutheast'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'DUFCableCounts'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'QVC_HSN'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'HBO'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'HBOBULK'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Cinemax'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Hispanic'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Showtime'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Starz'
exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'IsFreeHD'
--exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Details'
--exec [dbo].[PBB_CableSubscriberCount_Tab_Details] @TabName = 'Details', @DetailName = 'IsFreeHD'
*/
GO
