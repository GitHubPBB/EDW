USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_DisconnectedPhoneLines_Report]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_DisconnectedPhoneLines_Report]
@Market			VARCHAR(250) = NULL,
@AccountType	VARCHAR(250) = NULL,
@StartDate		DATETIME,
@EndDate		DATETIME
AS
   BEGIN
	
	DECLARE @SQL NVARCHAR(MAX)

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


	SET @SQL = '
	SELECT		PhoneNumber				= PhoneNumber,
				sli.Deactivation_DimDateId AS DeactivationDate,
				PhoneStatus				= PhoneStatus,
				AccountId,
				phoneseries,
				phoneexchangecode,
				Name					= AccountName, 
				AccountCode				= AccountCode,
				AccountType				= AccountType,
				Address					= ServiceLocationFullAddress,
				City					= ServiceLocationCity, 
				State					= ServiceLocationState, 
				Zip						= ServiceLocationPostalCode,			
				Listing					= CASE 
											WHEN DirectoryPublicationClassCode = ''P''	 THEN ''Public''
											WHEN DirectoryPublicationClassCode = ''NP''	 THEN ''Non Public''
											WHEN DirectoryPublicationClassCode = '''' 	 THEN ''Non specified''
											ELSE DirectoryPublicationClassCode											
										  END, 
				CallerName				= CallerName, 
				CallerNamePrivacyMethod	= CallerNamePrivacyMethod,
				Market					= LEFT(AccountGroupCode,3)

	FROM	[OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] sli
	JOIN	[OMNIA_EPBB_P_PBB_DW].[dbo].[DimCatalogItem] ci ON ci.DimCatalogItemId = sli.DimCatalogItemId
	JOIN	dimaccount a ON sli.dimaccountid = a.dimaccountid
	JOIN	dimaccountcategory ac ON sli.dimaccountcategoryid = ac.dimaccountcategoryid
	JOIN	DimServiceLocation sl ON sli.DimServiceLocationId = sl.DimServiceLocationId
	JOIN	DIMPHONE ph ON sli.dimphoneid = ph.dimphoneid

	WHERE	sli.Deactivation_DimDateId >= ''' + CONVERT(VARCHAR, ISNULL(@StartDate, GETDATE()), 23) + '''
	AND		sli.Deactivation_DimDateId <= ''' + CONVERT(VARCHAR, ISNULL(@EndDate, GETDATE()), 23) + '''
	AND		PhoneNumber <> ''''
	AND		sli.dimphoneid <> ''0''
	AND		accountcode <> ''''	
	'
	
	IF (@Market IS NOT  NULL)
	BEGIN 
	 SET @SQL = @SQL + ' AND ISNULL (LEFT(AC.AccountGroupCode, 3), ''-1'') IN ('''+ @Var_Market + ''')' 
	 --SET @SQL = @SQL + ' AND LEFT(AccountGroupCode,3) IN ('''+ @Var_Market + ''')' 
	END		

	IF (@AccountType IS NOT  NULL)
	BEGIN 
	 SET @SQL = @SQL + ' AND ISNULL (AC.AccountType, ''-1'') IN ('''+ @Var_AccountType + ''')' 
	END		
	
	SET @SQL = @SQL + ' ORDER BY AccountCode, PhoneNumber'

	PRINT (@SQL)
	EXEC (@SQL)
END
GO
