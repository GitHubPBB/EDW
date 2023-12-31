USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Phone_Line_Details]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_Phone_Line_Details]
@Market			VARCHAR(250) = NULL,
@AccountType	VARCHAR(250) = NULL,
@Status			VARCHAR(250) = NULL

AS
    BEGIN
	
	DECLARE @SQL1 VARCHAR(MAX)	
	DECLARE @SQL2 VARCHAR(MAX)

	DECLARE @Var_Market VARCHAR(500)	
	IF(@Market IS NOT NULL AND @Market <> '')
	BEGIN 
		SET @Var_Market = REPLACE (@Market, ',', ''', ''')
	END
	
	ELSE
	BEGIN 
		SET @Market = NULL
	END	
		
	DECLARE @Var_AccountType VARCHAR(500)	
	IF(@AccountType IS NOT NULL AND @AccountType <> '')
	BEGIN 
		SET @Var_AccountType = REPLACE (@AccountType, ',', ''', ''')
	END
	
	ELSE
	BEGIN 
		SET @AccountType = NULL
	END	

	DECLARE @Var_Status VARCHAR(500)	
	IF(@Status IS NOT NULL AND @Status <> '')
	BEGIN 
		SET @Var_Status = REPLACE (@Status, ',', ''', ''')
	END
	
	ELSE
	BEGIN 
		SET @Status = NULL
	END	


	SET @SQL1 = ' 
	;WITH CTE_Result AS (
	SELECT	A.AccountId,
			PH.PhoneNumber,
			PH.PhoneStatus, 
			A.AccountName AS Name, 
			AC.AccountGroupCode,
			A.AccountCode,
			AC.AccountType,
			SL.ServiceLocationFullAddress AS Address,
			SL.ServiceLocationCity AS City, 
			SL.ServiceLocationState AS State, 
			SL.ServiceLocationPostalCode AS Zip,			
			CASE 
				WHEN PH.DirectoryPublicationClassCode = ''P''	 THEN ''Public''
				WHEN PH.DirectoryPublicationClassCode = ''NP''	 THEN ''Non Public''
				WHEN PH.DirectoryPublicationClassCode = '''' 	 THEN ''Non specified''
				ELSE PH.DirectoryPublicationClassCode											
			END AS Listing, 
			PH.CallerName, 
			PH.CallerNamePrivacyMethod,
			CASE WHEN AC.AccountGroupCode IS NULL THEN CAST(PEC.ResultMarket AS VARCHAR(10))
				 ELSE CAST(ISNULL(PEC.ResultMarket, LEFT(AC.AccountGroupCode,3)) AS VARCHAR(10))
			END AS Market,
			PH.PhoneExchangeCode,
			PH.PhoneSeries,
			ISNULL(PEC.IsCorrection, 1) AS IsCorrection
	FROM	[OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] SLI
			INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] CI 
					ON CI.DimCatalogItemId = SLI.DimCatalogItemId
			INNER JOIN dimaccount A
					ON SLI.dimaccountid = A.dimaccountid
			INNER JOIN dimaccountcategory AC 
					ON SLI.dimaccountcategoryid = AC.dimaccountcategoryid
			INNER JOIN DimServiceLocation SL 
					ON SLI.DimServiceLocationId = SL.DimServiceLocationId
			INNER JOIN DIMPHONE PH 
					ON SLI.dimphoneid = PH.dimphoneid
			LEFT JOIN PhoneExchangeCodeConvertion PEC
				   ON  RTRIM(PH.PhoneExchangeCode) = PEC.PhoneExchangeCode
				  AND ISNULL(LEFT(AC.AccountGroupCode,3),'''') = ISNULL(PEC.Market,'''')
	WHERE	SLI.Activation_DimDateId <= GETDATE()
	  AND	SLI.Deactivation_DimDateId > GETDATE()
	  AND	SLI.EffectiveStartDate <= GETDATE()
	  AND	SLI.EffectiveEndDate > GETDATE()
	  AND	SLI.dimphoneid <> ''0''
	  AND	A.accountcode <> ''''	

	UNION


	SELECT	A.AccountId,
			PH.PhoneNumber,
			PH.PhoneStatus, 
			A.AccountName AS Name, 
			AC.AccountGroupCode,
			A.AccountCode,
			AC.AccountType,
			SL.ServiceLocationFullAddress AS Address,
			SL.ServiceLocationCity AS City, 
			SL.ServiceLocationState AS State, 
			SL.ServiceLocationPostalCode AS Zip,			
			CASE 
				WHEN PH.DirectoryPublicationClassCode = ''P''	 THEN ''Public''
				WHEN PH.DirectoryPublicationClassCode = ''NP''	 THEN ''Non Public''
				WHEN PH.DirectoryPublicationClassCode = '''' 	 THEN ''Non specified''
				ELSE PH.DirectoryPublicationClassCode											
			END AS Listing, 
			PH.CallerName, 
			PH.CallerNamePrivacyMethod,
			CASE WHEN AC.AccountGroupCode IS NULL THEN CAST(PEC.ResultMarket AS VARCHAR(10))
				 ELSE CAST(ISNULL(PEC.ResultMarket, LEFT(AC.AccountGroupCode,3)) AS VARCHAR(10))
			END AS Market,
			PH.PhoneExchangeCode,
			PH.PhoneSeries,
			ISNULL(PEC.IsCorrection, 1) AS IsCorrection
	FROM	DIMPHONE PH 
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] SLI 	
				   ON SLI.dimphoneid = PH.dimphoneid	
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] CI 
				   ON CI.DimCatalogItemId = SLI.DimCatalogItemId
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[Dimaccount] A 
				   ON SLI.dimaccountid = A.dimaccountid
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] AC 
				   ON SLI.dimaccountcategoryid = AC.dimaccountcategoryid
			LEFT JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation] SL 
				   ON SLI.DimServiceLocationId = SL.DimServiceLocationId
			LEFT JOIN PhoneExchangeCodeConvertion PEC
				   ON  RTRIM(PH.PhoneExchangeCode) = PEC.PhoneExchangeCode
				  AND ISNULL(LEFT(AC.AccountGroupCode,3),'''') = ISNULL(PEC.Market,'''')
	WHERE	PH.PhoneNumber <> ''''
	AND		PH.PhoneStatus <> ''U''
	)
	'

	SET @SQL2 = ' 
	SELECT	AccountId,
			PhoneNumber,
			CASE 
				WHEN PhoneStatus = ''F'' THEN ''Free''
				WHEN PhoneStatus = ''P'' THEN ''Pending''
				WHEN PhoneStatus = ''U'' THEN ''In Use''
				WHEN PhoneStatus = ''A'' THEN ''Active''
				WHEN PhoneStatus = ''I'' THEN ''Inactive''
				WHEN PhoneStatus = ''D'' THEN ''Ported Out''
				ELSE ''Undefined''
			END AS PhoneStatus,
			Name,
			AccountGroupCode,
			AccountCode,
			ISNULL(AccountType, ''Unassigned'') AS AccountType,
			Address,
			City,
			State,
			Zip,
			Listing,
			CallerName,
			CallerNamePrivacyMethod,
			CAST(ISNULL(Market, ''Unassigned'') AS VARCHAR(10)) AS Market,
			PhoneExchangeCode,
			PhoneSeries,
			IsCorrection
	FROM	CTE_Result 
	WHERE	1 = 1 
	'
	
	IF (@Market IS NOT  NULL)
	BEGIN 
	 SET @SQL2 = @SQL2 + ' AND ISNULL (Market, ''-1'') IN ('''+ @Var_Market + ''')' 
	END		

	IF (@AccountType IS NOT  NULL)
	BEGIN 
	 SET @SQL2 = @SQL2 + ' AND ISNULL (AccountType, ''-1'') IN ('''+ @Var_AccountType + ''')' 
	END		

	IF (@Status IS NOT  NULL)
	BEGIN 
	 SET @SQL2 = @SQL2 + ' AND PhoneStatus IN ('''+ @Var_Status + ''')' 
	END		

	SET @SQL2 = @SQL2 + ' ORDER BY AccountCode, PhoneNumber'

	PRINT (@SQL1)	
	PRINT (@SQL2)	


	EXEC (@SQL1 + @SQL2)
END
GO
