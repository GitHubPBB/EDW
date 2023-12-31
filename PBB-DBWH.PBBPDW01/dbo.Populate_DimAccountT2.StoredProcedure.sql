USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[Populate_DimAccountT2]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--DROP dbo.Populate_DimAccountT2

CREATE PROCEDURE [dbo].[Populate_DimAccountT2]
-- =============================================  
-- Description:	Merge Stage table with an Acq table
--  
-- Change histrory: 
-- Name			Auther			Date		Version		Description  
-- Comment      Sunil           11/21/2023  01.00       Initial version
-- =============================================
AS
BEGIN
/*
	CREATE SEQUENCE DimAccountKeySeq
    START WITH 1
    INCREMENT BY 1
    NO CACHE
    ;
*/
---------------------------------------------------------
-- Declare variables
---------------------------------------------------------
	-- logging variables
	--*** increament version with new changes, should match latest entry of change history block
	DECLARE @Version				  VARCHAR(10) = 'v1.00'; 
	DECLARE @LogParentID              numeric(18,0)
	DECLARE @RC						  int
	DECLARE @EtlName				  varchar(50)        
	DECLARE @V_LoadDttm				  varchar(40)
	DECLARE @ProcGUID				  varchar(50)
	DECLARE @ExecutionGUID			  varchar(50)
	DECLARE @MachineName			  varchar(50)             	= HOST_NAME()
	DECLARE @UserName				  varchar(50)             	= SUSER_NAME()
	DECLARE @ExecutionStep			  varchar(1000)
	DECLARE @ExecutionMsg			  varchar(MAX)          
	DECLARE @LogID					  numeric(18,0)           	= @LogParentID 	
	-- process specific variables
	DECLARE @V_Table                  varchar(MAX)
	DECLARE @V_TargetSchema           varchar(MAX)
	DECLARE @V_ExecutionGroup         varchar(MAX)
	DECLARE @V_LoadType				  varchar(20)
	-- variables to hold query result
	DECLARE @V_Prcs_Sts               varchar(20)
	DECLARE @sql_drop_if_exists_temp  varchar(MAX)
	-- variables with default value
	DECLARE @newline 				  nvarchar(2) 			  	= NCHAR(13) + NCHAR(10)
	DECLARE @V_CurrentTimestamp		  datetime				  	= GETDATE()
	DECLARE @V_temp_schema			  varchar(100)				= 'tmp'
	--******** Full Load Flag
	
	--*** Declare any new variable needed in the procedure
	DECLARE @MaxKey smallint=0;
	DECLARE @RunDatetime datetime = getdate();
	DECLARE @V_RowHashExp varchar(MAX);
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

BEGIN TRY
	---*** Either use below logic or call it in from calling process
	SELECT @LogParentID = COALESCE(MAX(LogParentID)+1,100000) FROM PBBPDW01.info.ExecutionLog 
	---*** Either declare ExecutionGroup,TargetSchemaName,TableName here or call it in from calling process
	SET @V_ExecutionGroup = 'LoadDWH_Dim' --LoadDWH_Dim/Fact/Ref
	SET @V_TargetSchema = 'dbo'
	SET @V_Table = 'DimAccountT2'
	SET @V_LoadType = 'LoadDWH_DimT2'
	
	-- Fetch "Execution Status" from control table
	SELECT  @V_Prcs_Sts 		= ExecutionStatus,
			@V_LoadDttm 		= @V_CurrentTimestamp,
			@V_RowHashExp		= ColumnRowHashExp,
			@EtlName			= concat(@V_TargetSchema, '.', @V_Table)
	FROM PBBPDW01.info.ExecutionControlDetail
	WHERE ExecutionGroup = @V_ExecutionGroup
			AND TargetSchemaName = @V_TargetSchema
			AND TargetTableName = @V_Table
			AND LoadType = @V_LoadType
			;

	-- Reset sequence to start from 1
	ALTER SEQUENCE dbo.DimAccountKeySeq
    RESTART WITH 1
	INCREMENT BY 1
	;
			
	-- Check if process is ready to run or not, error code value > 10 means process will raise error and STOP!!!!
	IF @V_Prcs_Sts <> 'READY'
	raiserror('Execution status not set to READY, Please check!', 11, 1)
		
---------------------------------------------------------
-- Start Logging
---------------------------------------------------------	

	IF @V_Prcs_Sts = 'READY'	
	SET @ExecutionMsg = concat('Starting Process: ', @EtlName, @Version, ' ... ');
	
	EXECUTE @RC = info.ExecutionLogStart
	   @LogParentID
	  ,@V_ExecutionGroup
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_LoadDttm
	  ,@ProcGUID 
	  ,@ExecutionGUID 
	  ,@MachineName 
	  ,@UserName 
	  ,@V_LoadType
	  ,@ExecutionMsg 
	  ,@LogID OUTPUT;
	  

---------------------------------------------------------
-- Create _TEMP table with data from Source table
---------------------------------------------------------

	IF @V_Prcs_Sts = 'READY'
	SET @sql_drop_if_exists_temp = 'IF OBJECT_ID('''+@V_temp_schema+'.'+@V_Table+'_STG'') IS NOT NULL DROP TABLE '+@V_temp_schema+'.'+@V_Table+'_STG';
	
	
	-- For Debug purpose
	---PRINT('1' + @sql_drop_if_exists_temp);
	
	IF @V_Prcs_Sts = 'READY'
	EXEC(@sql_drop_if_exists_temp);
	  
	IF @V_Prcs_sts = 'READY'
	WITH internal_acct
	as
	(
		SELECT
			fci.DimAccountId,
			fci.DimAccountCategoryId
		FROM PBBPACQ01.AcqPbbDW.FactCustomerItem fci
		JOIN PBBPACQ01.AcqPbbDW.DimCatalogItem dci WITH(NOLOCK) 
			ON fci.DimCatalogItemId = dci.DimCatalogItemID
		JOIN PBBPACQ01.AcqPbbDW.PrdComponentMap pcm WITH(NOLOCK) 
			ON CONVERT(NCHAR(7), dci.ComponentCode, 0) = pcm.ComponentCode
		WHERE fci.MetaCurrentRecordIndicator = '1'
			AND fci.MetaOperationCode <> 'D' 
			AND dci.MetaCurrentRecordIndicator = '1'
			AND dci.MetaOperationCode <> 'D' 
			AND pcm.MetaCurrentRecordIndicator = '1'
			AND pcm.MetaOperationCode <> 'D' 
			AND lower(pcm.Component) like '%internal use only%'
	
	),
	courtesy_acct
	as
	(
		SELECT
			fci.DimAccountId,
			fci.DimAccountCategoryId
		FROM PBBPACQ01.AcqPbbDW.FactCustomerItem fci
		JOIN PBBPACQ01.AcqPbbDW.DimCatalogItem dci WITH(NOLOCK) 
			ON fci.DimCatalogItemId = dci.DimCatalogItemID
		JOIN PBBPACQ01.AcqPbbDW.PrdComponentMap pcm WITH(NOLOCK) 
			ON CONVERT(NCHAR(7), dci.ComponentCode, 0) = pcm.ComponentCode
		WHERE fci.MetaCurrentRecordIndicator = '1'
			AND fci.MetaOperationCode <> 'D' 
			AND dci.MetaCurrentRecordIndicator = '1'
			AND dci.MetaOperationCode <> 'D' 
			AND pcm.MetaCurrentRecordIndicator = '1'
			AND pcm.MetaOperationCode <> 'D' 
			AND lower(pcm.Component) like '%courtesy%'
	),
	pre_source
	as
	(
	SELECT 
		da.AccountCode as DimAccountNaturalKey,
		'AccountCode' as DimAccountNatualKeyFields,
		da.AccountCode,
		da.AccountId as SrcAccountId,
		da.DimAccountId as SrcDimAccountId,
		ac_p.pbb_AccountMarket as AccountMarket,
		ac_p.pbb_ReportingMarket as AccountReportingMarket,
		ac.AccountClassCode,
		ac.AccountClass,
		ac.AccountGroupCode,
		ac.AccountGroup,
		CASE 
			WHEN ac.AccountTypeCode = 'BUS' THEN 'BUS'
			WHEN ac.AccountTypeCode = 'RES' THEN 'RES'
			WHEN SUBSTRING(ac.AccountGroupCode,4,3) = 'BUS' THEN 'BUS'
			WHEN SUBSTRING(ac.AccountGroupCode,4,3) = 'RES' THEN 'RES'
			WHEN ac.AccountSegment = 'BUS' THEN 'BUS'
			WHEN ac.AccountSegment = 'RES' THEN 'RES'
		ELSE 'UNK'
		END as AccountTypeCode,
		CASE 
			WHEN ac.AccountTypeCode = 'BUS' THEN 'Business'
			WHEN ac.AccountTypeCode = 'RES' THEN 'Residential'
			WHEN SUBSTRING(ac.AccountGroupCode,4,3) = 'BUS' THEN 'Business'
			WHEN SUBSTRING(ac.AccountGroupCode,4,3) = 'RES' THEN 'Residential'
			WHEN ac.AccountSegment = 'BUS' THEN 'Business'
			WHEN ac.AccountSegment = 'RES' THEN 'Residential'
		ELSE 'Unknown'
		END as AccountType,
		CASE WHEN ac.AccountTypeCode = 'WRT' THEN 1 ELSE 0 END IsWriteOff,
		CASE WHEN courtesy_acct.DimAccountId IS NOT NULL THEN 1 ELSE 0 END IsCourtesy,
		CASE WHEN internal_acct.DimAccountId IS NOT NULL THEN 1 ELSE 0 END IsInternal,
		COALESCE(ac.CustomerServiceRegionCode, 'UNK') as CustomerServiceRegionCode,
		ac.CycleNumber as AccountBillCycleNumber,
		SUBSTRING(ac.CycleDescription,CHARINDEX('Due',ac.CycleDescription)+4,len(ac.CycleDescription)) as AccountPaymentDueDay,
		ac.AccountTaxExemption as AccountTaxExemptions,
		da.AccountStatusCode,
		da.AccountStatus,
		da.AccountName,
		da.AccountActivationDate as ActivationDate,
		da.AccountDeactivationDate as DeactivationDate,
		da.AccountPhoneNumber,
		da.AccountEmailAddress,
		da.AccountSSNLast4Digits,
		da.BillingAddressPhone,
		da.BillingAddressAttention,
		da.BillingAddressStreetLine1,
		da.BillingAddressStreetLine2,
		da.BillingAddressStreetLine3,
		da.BillingAddressCity,
		da.BillingAddressState,
		da.BillingAddressStateAbbreviation,
		da.BillingAddressPostalCode,
		da.InvoiceFormat,
		da.PrintGroup,
		COALESCE(da.CpniOptOut, 'U') as CpniOptOut,
		da.CpniOptOutDate,
		COALESCE(da.CpniOptIn, 'U') as CpniOptIn,
		da.CpniOptInDate,
		da.AccountPreferredContactMethod as PreferredContactMethod,
		CASE da.AccountAllowEmail
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowEmail,
		CASE da.AccountAllowBulkEmail
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowBulkEmail,
		CASE da.AccountAllowPhone
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowPhone,
		CASE da.AccountAllowFax
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowFax,
		CASE da.AccountAllowMail
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowMail,
		CASE da.AccountAllowText
			WHEN 'Allow' THEN 'Y'
			WHEN 'Not Allow' THEN 'N'
			ELSE 'U'
		END as AllowText,
		CASE 
			WHEN da.AccountPromiseToPayExempt = 'Not Promise To Pay Exempt' THEN 0
			ELSE 1
		END as IsPromiseToPayExempt,
		CASE 
			WHEN da.AccountNoticeExempt = 'Is Not Notice Exempt' THEN 0
			ELSE 1
		END as IsNoticeExempt,
		CASE 
			WHEN da.AccountLateFeeExempt = 'Is Not Late Fee Exempt' THEN 0
			ELSE 1
		END as IsLateFeeExempt,
		CASE 
			WHEN da.AccountCreditRatingExempt = 'Is Not Credit Rating Exempt' THEN 0
			ELSE 1
		END as IsCreditRatingExempt,
		CASE 
			WHEN da.AccountCreditEventsExempt = 'Is Not Credit Events Exempt' THEN 0
			ELSE 1
		END as IsCreditEventExempt,
		CASE 
			WHEN da.AccountNonPayDisconnectExempt = 'Is Not NonPay Disconnect Exempt' THEN 0
			ELSE 1
		END as IsNonPayDisconnectExempt,
		da.AccountOwner,
		da.AccountAgent,
		da.AccountACHBankRoutingNumber as ACHBankRoutingNumber,
		da.AccountACHStatus as ACHStatus,
		da.AccountACHStartDate as ACHStartDate,
		da.AccountACHEndDate as ACHEndDate,
		da.AccountACHBankName as ACHBankName,
		'omnia' as MetaSourceSystemCode,
		da.MetaEffectiveStartDatetime,
		da.MetaEffectiveEndDatetime,
		da.MetaInsertDatetime,
		da.MetaUpdateDatetime,
		@LogParentID as MetaEtlProcessId
	FROM PBBPACQ01.AcqPbbDW.FactCustomerAccount fca
	INNER JOIN PBBPACQ01.AcqPbbDW.DimAccount da WITH(NOLOCK) 
		ON da.DimAccountId = fca.DimAccountId
	INNER JOIN PBBPACQ01.AcqPbbDW.DimAccountCategory ac WITH(NOLOCK) 
		--ON PARSENAME(CAST(ac.SourceId AS NVARCHAR),2) = da.AccountId
		--ON (select item from Split(ac.SourceId,'.') a where idx in (6)) = da.AccountId
		ON ac.DimAccountCategoryId = fca.DimAccountCategoryId
		AND ac.MetaCurrentRecordIndicator = '1'
		AND ac.MetaOperationCode <> 'D'
	LEFT JOIN PBBPACQ01.AcqPbbDW.DimAccountCategory_PBB ac_p WITH(NOLOCK) 
		ON ac.DimAccountCategoryId = ac_p.PBB_DimAccountCategoryId
		AND ac_p.MetaCurrentRecordIndicator = '1'
		AND ac_p.MetaOperationCode <> 'D'
	LEFT JOIN courtesy_acct 
		ON courtesy_acct.DimAccountId = da.DimAccountId
		AND courtesy_acct.DimAccountCategoryId = ac.DimAccountCategoryId
	LEFT JOIN internal_acct 
		ON internal_acct.DimAccountId = da.DimAccountId
		AND internal_acct.DimAccountCategoryId = ac.DimAccountCategoryId
	WHERE da.MetaCurrentRecordIndicator = '1'
		AND da.MetaOperationCode <> 'D'
		AND fca.EffectiveStartDate <= GETDATE()
        AND fca.EffectiveEndDate > GETDATE()
		AND fca.MetaCurrentRecordIndicator = '1'
		AND fca.MetaOperationCode <> 'D'
	)
	-- Generate MetaRowHash for CDC *** (use @V_RowHashExp inplace of hardcoded expression) ***
	SELECT 
		*,
		--@V_RowHashExp as MetaRowHash
		HASHBYTES('SHA2_256', TRIM(CAST(ISNULL(DimAccountNaturalKey,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(DimAccountNatualKeyFields AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(SrcAccountId, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(SrcDimAccountId, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountMarket,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountReportingMarket,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountClassCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountClass,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountGroupCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountGroup,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountTypeCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountType,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsWriteOff,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsCourtesy,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsInternal,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(CustomerServiceRegionCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountBillCycleNumber,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(AccountPaymentDueDay AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountTaxExemptions, ' ') AS VARCHAR)) + 
		'|^^|' + TRIM(CAST(ISNULL(AccountStatusCode,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountStatus,' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountName,' ') AS VARCHAR)) + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, ActivationDate, 120)), '1900-01-01') + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, DeactivationDate, 120)), '1900-01-01') + '|^^|' + TRIM(CAST(ISNULL(AccountPhoneNumber, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountEmailAddress, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountSSNLast4Digits, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressPhone, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressAttention, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressStreetLine1, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressStreetLine2, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressStreetLine3, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressCity, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressState, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(BillingAddressStateAbbreviation, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(
					BillingAddressPostalCode, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(InvoiceFormat, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(PrintGroup, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(CpniOptOut AS VARCHAR)) + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, CpniOptOutDate, 120)), '1900-01-01') + '|^^|' + TRIM(CAST(CpniOptIn AS VARCHAR)) + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, CpniOptInDate, 120)), '1900-01-01') + '|^^|' + TRIM(CAST(ISNULL(PreferredContactMethod, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowEmail, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowBulkEmail, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowPhone, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowFax, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowMail, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AllowText, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsPromiseToPayExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsNoticeExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsLateFeeExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsCreditRatingExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(
			CAST(ISNULL(IsCreditEventExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(IsNonPayDisconnectExempt, '0') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountOwner, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(AccountAgent, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(ACHBankRoutingNumber, ' ') AS VARCHAR)) + '|^^|' + TRIM(CAST(ISNULL(ACHStatus, ' ') AS VARCHAR)) + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, ACHStartDate, 120)), '1900-01-01') + '|^^|' + ISNULL(TRIM(CONVERT(NVARCHAR, ACHEndDate, 120)), '1900-01-01') + '|^^|' + TRIM(CAST(ISNULL(ACHBankName, ' ') AS VARCHAR))) 
		as MetaRowHash
		INTO tmp.DimAccountT2_STG
	FROM pre_source	
	;
	
	 -- for debug purpose only
	 -- select * from tmp.DimAccountT2_STG
------------------------------------------------------------------------------
-- Update change rows
------------------------------------------------------------------------------ 
	IF @V_Prcs_Sts = 'READY'
	UPDATE dbo.DimAccountT2
	SET MetaOperationCode = CASE WHEN tgt.MetaOperationCode = 'D' THEN 'D' ELSE 'U' END,
		MetaCurrentRecordIndicator = 'N',
		MetaEffectiveEndDatetime = @V_CurrentTimestamp
	FROM tmp.DimAccountT2_STG src
	JOIN dbo.DimAccountT2 tgt
		ON tgt.DimAccountNaturalKey = src.DimAccountNaturalKey
	WHERE tgt.MetaCurrentRecordIndicator = 'Y'
	--AND src.MetaCurrentRecordIndicator = '1'
	--AND src.MetaOperationCode <> 'D'
	AND src.MetaRowHash <> tgt.MetaRowHash
	;

------------------------------------------------------------------------------
-- Insert change rows
------------------------------------------------------------------------------
	IF @V_Prcs_Sts = 'READY'
	INSERT INTO dbo.DimAccountT2
	(
		 DimAccountKey
		,DimAccountNaturalKey
		,DimAccountNatualKeyFields
		,AccountCode
		,SrcAccountId
		,SrcDimAccountId
		,AccountMarket
		,AccountReportingMarket
		,AccountClassCode
		,AccountClass
		,AccountGroupCode
		,AccountGroup
		,AccountTypeCode
		,AccountType
		,IsWriteOff
		,IsCourtesy
		,IsInternal
		,CustomerServiceRegionCode
		,AccountBillCycleNumber
		,AccountPaymentDueDay
		,AccountTaxExemptions
		,AccountStatusCode
		,AccountStatus
		,AccountName
		,ActivationDate
		,DeactivationDate
		,AccountPhoneNumber
		,AccountEmailAddress
		,AccountSSNLast4Digits
		,BillingAddressPhone
		,BillingAddressAttention
		,BillingAddressStreetLine1
		,BillingAddressStreetLine2
		,BillingAddressStreetLine3
		,BillingAddressCity
		,BillingAddressState
		,BillingAddressStateAbbreviation
		,BillingAddressPostalCode
		,InvoiceFormat
		,PrintGroup
		,CpniOptOut
		,CpniOptOutDate
		,CpniOptIn
		,CpniOptInDate
		,PreferredContactMethod
		,AllowEmail
		,AllowBulkEmail
		,AllowPhone
		,AllowFax
		,AllowMail
		,AllowText
		,IsPromiseToPayExempt
		,IsNoticeExempt
		,IsLateFeeExempt
		,IsCreditRatingExempt
		,IsCreditEventExempt
		,IsNonPayDisconnectExempt
		,AccountOwner
		,AccountAgent
		,ACHBankRoutingNumber
		,ACHStatus
		,ACHStartDate
		,ACHEndDate
		,ACHBankName
		,MetaSourceSystemCode
		,MetaEffectiveStartDatetime
		,MetaEffectiveEndDatetime
		,MetaInsertDatetime
		,MetaCurrentRecordIndicator
		,MetaOperationCode
		,MetaEtlProcessId
		,MetaRowHash
	
	)
	SELECT   tgt.DimAccountKey
			,src.DimAccountNaturalKey
			,src.DimAccountNatualKeyFields
			,src.AccountCode
			,src.SrcAccountId
			,src.SrcDimAccountId
			,src.AccountMarket
			,src.AccountReportingMarket
			,src.AccountClassCode
			,src.AccountClass
			,src.AccountGroupCode
			,src.AccountGroup
			,src.AccountTypeCode
			,src.AccountType
			,src.IsWriteOff
			,src.IsCourtesy
			,src.IsInternal
			,src.CustomerServiceRegionCode
			,src.AccountBillCycleNumber
			,src.AccountPaymentDueDay
			,src.AccountTaxExemptions
			,src.AccountStatusCode
			,src.AccountStatus
			,src.AccountName
			,src.ActivationDate
			,src.DeactivationDate
			,src.AccountPhoneNumber
			,src.AccountEmailAddress
			,src.AccountSSNLast4Digits
			,src.BillingAddressPhone
			,src.BillingAddressAttention
			,src.BillingAddressStreetLine1
			,src.BillingAddressStreetLine2
			,src.BillingAddressStreetLine3
			,src.BillingAddressCity
			,src.BillingAddressState
			,src.BillingAddressStateAbbreviation
			,src.BillingAddressPostalCode
			,src.InvoiceFormat
			,src.PrintGroup
			,src.CpniOptOut
			,src.CpniOptOutDate
			,src.CpniOptIn
			,src.CpniOptInDate
			,src.PreferredContactMethod
			,src.AllowEmail
			,src.AllowBulkEmail
			,src.AllowPhone
			,src.AllowFax
			,src.AllowMail
			,src.AllowText
			,src.IsPromiseToPayExempt
			,src.IsNoticeExempt
			,src.IsLateFeeExempt
			,src.IsCreditRatingExempt
			,src.IsCreditEventExempt
			,src.IsNonPayDisconnectExempt
			,src.AccountOwner
			,src.AccountAgent
			,src.ACHBankRoutingNumber
			,src.ACHStatus
			,src.ACHStartDate
			,src.ACHEndDate
			,src.ACHBankName
			,src.MetaSourceSystemCode AS MetaSourceSystemCode
			,@V_CurrentTimestamp AS MetaEffectiveStartDatetime
			,CAST('9999-12-31 00:00:00' as datetime) AS MetaEffectiveEndDatetime
			,src.MetaUpdateDatetime AS MetaInsertDatetime
			,'Y' AS MetaCurrentRecordIndicator
			,'U' AS MetaOperationCode
			,src.MetaEtlProcessId AS MetaEtlProcessId
			,COALESCE(src.MetaRowHash,0) as MetaRowHash
	FROM tmp.DimAccountT2_STG src JOIN
		dbo.DimAccountT2 tgt ON
		(
		tgt.DimAccountNaturalKey = src.DimAccountNaturalKey AND
		tgt.MetaEffectiveEndDatetime = @V_CurrentTimestamp
		) LEFT JOIN
		dbo.DimAccountT2 chk ON
		(
		chk.DimAccountNaturalKey = src.DimAccountNaturalKey AND
		chk.MetaCurrentRecordIndicator = 'Y'
		)
	WHERE chk.DimAccountNaturalKey IS NULL
	;

------------------------------------------------------------------------------
-- Insert new rows
------------------------------------------------------------------------------
	IF @V_Prcs_Sts = 'READY'
	INSERT INTO dbo.DimAccountT2
	(
		 DimAccountKey
		,DimAccountNaturalKey
		,DimAccountNatualKeyFields
		,AccountCode
		,SrcAccountId
		,SrcDimAccountId
		,AccountMarket
		,AccountReportingMarket
		,AccountClassCode
		,AccountClass
		,AccountGroupCode
		,AccountGroup
		,AccountTypeCode
		,AccountType
		,IsWriteOff
		,IsCourtesy
		,IsInternal
		,CustomerServiceRegionCode
		,AccountBillCycleNumber
		,AccountPaymentDueDay
		,AccountTaxExemptions
		,AccountStatusCode
		,AccountStatus
		,AccountName
		,ActivationDate
		,DeactivationDate
		,AccountPhoneNumber
		,AccountEmailAddress
		,AccountSSNLast4Digits
		,BillingAddressPhone
		,BillingAddressAttention
		,BillingAddressStreetLine1
		,BillingAddressStreetLine2
		,BillingAddressStreetLine3
		,BillingAddressCity
		,BillingAddressState
		,BillingAddressStateAbbreviation
		,BillingAddressPostalCode
		,InvoiceFormat
		,PrintGroup
		,CpniOptOut
		,CpniOptOutDate
		,CpniOptIn
		,CpniOptInDate
		,PreferredContactMethod
		,AllowEmail
		,AllowBulkEmail
		,AllowPhone
		,AllowFax
		,AllowMail
		,AllowText
		,IsPromiseToPayExempt
		,IsNoticeExempt
		,IsLateFeeExempt
		,IsCreditRatingExempt
		,IsCreditEventExempt
		,IsNonPayDisconnectExempt
		,AccountOwner
		,AccountAgent
		,ACHBankRoutingNumber
		,ACHStatus
		,ACHStartDate
		,ACHEndDate
		,ACHBankName
		,MetaSourceSystemCode
		,MetaEffectiveStartDatetime
		,MetaEffectiveEndDatetime
		,MetaInsertDatetime
		,MetaCurrentRecordIndicator
		,MetaOperationCode
		,MetaEtlProcessId
		,MetaRowHash
	
	)
	SELECT  (SELECT COALESCE(MAX(DimAccountKey),0) FROM dbo.DimAccountT2) + NEXT VALUE FOR dbo.DimAccountKeySeq DimAccountKey
			,src.DimAccountNaturalKey
			,src.DimAccountNatualKeyFields
			,src.AccountCode
			,src.SrcAccountId
			,src.SrcDimAccountId
			,src.AccountMarket
			,src.AccountReportingMarket
			,src.AccountClassCode
			,src.AccountClass
			,src.AccountGroupCode
			,src.AccountGroup
			,src.AccountTypeCode
			,src.AccountType
			,src.IsWriteOff
			,src.IsCourtesy
			,src.IsInternal
			,src.CustomerServiceRegionCode
			,src.AccountBillCycleNumber
			,src.AccountPaymentDueDay
			,src.AccountTaxExemptions
			,src.AccountStatusCode
			,src.AccountStatus
			,src.AccountName
			,src.ActivationDate
			,src.DeactivationDate
			,src.AccountPhoneNumber
			,src.AccountEmailAddress
			,src.AccountSSNLast4Digits
			,src.BillingAddressPhone
			,src.BillingAddressAttention
			,src.BillingAddressStreetLine1
			,src.BillingAddressStreetLine2
			,src.BillingAddressStreetLine3
			,src.BillingAddressCity
			,src.BillingAddressState
			,src.BillingAddressStateAbbreviation
			,src.BillingAddressPostalCode
			,src.InvoiceFormat
			,src.PrintGroup
			,src.CpniOptOut
			,src.CpniOptOutDate
			,src.CpniOptIn
			,src.CpniOptInDate
			,src.PreferredContactMethod
			,src.AllowEmail
			,src.AllowBulkEmail
			,src.AllowPhone
			,src.AllowFax
			,src.AllowMail
			,src.AllowText
			,src.IsPromiseToPayExempt
			,src.IsNoticeExempt
			,src.IsLateFeeExempt
			,src.IsCreditRatingExempt
			,src.IsCreditEventExempt
			,src.IsNonPayDisconnectExempt
			,src.AccountOwner
			,src.AccountAgent
			,src.ACHBankRoutingNumber
			,src.ACHStatus
			,src.ACHStartDate
			,src.ACHEndDate
			,src.ACHBankName
			,src.MetaSourceSystemCode AS MetaSourceSystemCode
			,@V_CurrentTimestamp AS MetaEffectiveStartDatetime
			,CAST('9999-12-31 00:00:00' as datetime) AS MetaEffectiveEndDatetime
			,src.MetaInsertDatetime AS MetaInsertDatetime
			,'Y' AS MetaCurrentRecordIndicator
			,'I' AS MetaOperationCode
			,src.MetaEtlProcessId AS MetaEtlProcessId
			,COALESCE(src.MetaRowHash,0) as MetaRowHash
	FROM tmp.DimAccountT2_STG src LEFT JOIN
		dbo.DimAccountT2 tgt ON
		(
		tgt.DimAccountNaturalKey = src.DimAccountNaturalKey
		)
	WHERE tgt.DimAccountNaturalKey IS NULL
	;

------------------------------------------------------------------------------
-- Soft delete deleted records
------------------------------------------------------------------------------
	IF @V_Prcs_Sts = 'READY'
	UPDATE dbo.DimAccountT2
	SET 
		MetaOperationCode = 'D',
		MetaCurrentRecordIndicator = 'N',
		MetaEffectiveEndDatetime = @V_CurrentTimestamp
	FROM dbo.DimAccountT2 tgt
	JOIN (
		SELECT d.DimAccountKey
		FROM dbo.DimAccountT2 d LEFT JOIN
				tmp.DimAccountT2_STG s ON
				(
				s.DimAccountNaturalKey = d.DimAccountNaturalKey
				)
		WHERE d.MetaCurrentRecordIndicator = 'Y'
			AND s.DimAccountNaturalKey IS NULL
		GROUP BY d.DimAccountKey
		) tgt_pre
	ON tgt.DimAccountKey = tgt_pre.DimAccountKey
	WHERE 
		tgt.MetaCurrentRecordIndicator = 'Y'
		AND tgt.MetaOperationCode <> 'D'
	;

---------------------------------------------------------
-- Stop Logging
---------------------------------------------------------
	SET @ExecutionMsg = 'Load is completed sucessfully!';
	
	IF @V_Prcs_Sts = 'RUNNING'
	SET @ExecutionMsg = 'Successful Execution (' + @Version + ')'
	EXECUTE @RC = info.ExecutionLogStop
	   @LogID
	  ,@V_TargetSchema
	  ,@V_Table
	  ,@V_CurrentTimestamp
	  ,@V_LoadType
	  ,@ExecutionMsg;
	  
END TRY


---------------------------------------------------------
-- Log error
---------------------------------------------------------
BEGIN CATCH
 
      SET @ExecutionMsg = 'FAILURE: '
	                              + ' || Error Number : '  + CAST(ERROR_NUMBER() AS VARCHAR(MAX))
                                     + ' , Error Severity : ' + CAST(ERROR_SEVERITY() AS VARCHAR(MAX))
                                     + ' , Error State : '    + CAST(ERROR_STATE() AS VARCHAR(MAX))
                                     + ' , Error Line : '     + CAST(ERROR_LINE() AS VARCHAR(MAX))
                                     + ' , Error Message : '  + ERROR_MESSAGE() + '.'
       EXECUTE @RC = info.ExecutionLogError
			   @LogID
			   ,@V_TargetSchema
			   ,@V_Table
			   ,@V_LoadType
			   ,@ExecutionMsg 
       RETURN;
   
END CATCH

END
GO
