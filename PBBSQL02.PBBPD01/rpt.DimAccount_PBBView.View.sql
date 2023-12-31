USE [PBBPDW01]
GO
/****** Object:  View [rpt].[DimAccount_PBBView]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- DROP VIEW [rpt].[dim_account]
CREATE VIEW [rpt].[DimAccount_PBBView] AS
WITH CTE_PrintGroup AS (
  SELECT 
    CAST(PGA.AccountID AS INT) AS chr_AccountId, 
    PG.PrintGroup, 
    CAST(PGA.ModifyDate AS DATETIME) ModifyDate, 
    CAST(PGA.ModifyDate AS DATETIME) AS EffectiveStartDate, 
    CASE WHEN LEAD(CAST(PGA.ModifyDate AS DATETIME), 1, '2050-01-01') OVER (
		PARTITION BY CAST(PGA.AccountId AS INT) ORDER BY CAST(PGA.ModifyDate AS DATETIME)) = '2050-01-01' 
	  THEN '2050-01-01' 
	ELSE DATEADD(s,-1,LEAD(CAST(PGA.ModifyDate AS DATETIME),1,'2050-01-01') OVER (
		PARTITION BY CAST(PGA.AccountId AS INT) ORDER BY CAST(PGA.ModifyDate AS DATETIME))) 
	END AS EffectiveEndDate, 
    ROW_NUMBER() OVER(ORDER BY AccountID, CAST(PGA.ModifyDate AS DATETIME)) AS Row 
  FROM 
    PBBSQL01.[OMNIA_EPBB_P_PBB_CM].[dbo].[ICPrintGroupAccountX] PGA 
    JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].[dbo].[ICPrintGroup] PG ON PGA.PrintGroupID = PG.PrintGroupID 
  WHERE 
    PGA.TransactionType <> 'D' 
    --AND AccountID IN ('104322','105699','158333','102357','101978','103684')
), 

CTE_Account AS (
  SELECT 
    CAST(CX.AccountId AS INT) AS chr_AccountID, 
    LKP_AB.AccountId AS AccountID, 
    CX.AccountCode, 
    LKP_AB.Name AS AccountName, 
    LKP_CSR.CustomerServiceRegion CustomerServiceRegion, 
    LKP_AT.AccountType AccountType, 
    LKP_BC.cycleid AS CycleNumber, 
    LKP_BC.[cycle] AS CycleDescription, 
    LKP_BC.cycleday AS CycleDay, 
    LKP_AS.chr_Name AccountStatus, 
    CX.AccountStatusCode, 
    LKP_AC.AccountClass AccountClass, 
    LKP_AG.chr_Name AS AccountGroup, 
    LKP_AG.chr_AccountGroupCode AS AccountGroupCode, 
    LKP_AG.cus_Market AS Market, 
    LKP_AG.cus_ReportingMarket AS ReportingMarket, 
    LKP_IF.chr_Name AS InvoiceFormat, 
    CX.AccountActivationDate, 
    COALESCE(CX.AccountDeactivationDate, '1900-01-01') AccountDeactivationDate, 
    Min(Version) As Version, 
    CAST(CX.ModifyDate AS DATETIME) ModifyDate, 
    CAST(CX.ModifyDate AS DATETIME) AS EffectiveStartDate, 
    CASE WHEN LEAD(CAST(CX.ModifyDate AS DATETIME),1,'2050-01-01') OVER (
		PARTITION BY CAST(CX.AccountId AS INT) ORDER BY CAST(CX.ModifyDate AS DATETIME)) = '2050-01-01'
	THEN '2050-01-01' 
	ELSE DATEADD(s, -1, LEAD(CAST(CX.ModifyDate AS DATETIME), 1, '2050-01-01') OVER (
        PARTITION BY CAST(CX.AccountId AS INT) ORDER BY CAST(CX.ModifyDate AS DATETIME))) 
	END AS EffectiveEndDate 
  FROM 
    [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[cusaccountx] CX 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_chr_AccountGroupBase] LKP_AG ON CX.AccountGroupID = LKP_AG.chr_BillingAccountGroupId 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_CusAccountClass] LKP_AC ON CX.AccountClassCode = LKP_AC.AccountClassCode 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_CusAccountType] LKP_AT ON CX.AccountTypeID = LKP_AT.AccountTypeID 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_CusCustomerServiceRegion] LKP_CSR ON CX.CustomerServiceRegionID = LKP_CSR.CustomerServiceRegionID 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_chr_AccountStatusBase] LKP_AS ON CX.AccountStatusCode = LKP_AS.chr_code 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_BilCycle] LKP_BC ON CX.cycleid = LKP_BC.cycleid 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_AccountBase] LKP_AB ON CX.AccountId = LKP_AB.chr_AccountId 
    LEFT JOIN [OMNIA_EPBB_P_PBB_STG].[dbo].[LKP_chr_BillingInvoiceFormatBase] LKP_IF ON LKP_AB.chr_InvoiceFormatId = LKP_IF.chr_BillingInvoiceFormatId 
 -- WHERE CX.AccountID IN ('104322','105699','158333','102357','101978','103684')
  GROUP BY 
    CAST(CX.AccountId AS INT), 
    LKP_AB.AccountId, 
    CX.AccountCode, 
    LKP_AB.Name, 
    LKP_CSR.CustomerServiceRegion, 
    LKP_AT.AccountType, 
    CAST(CX.ModifyDate AS DATETIME), 
    LKP_BC.cycleid, 
    LKP_BC.[cycle], 
    LKP_BC.cycleday, 
    LKP_AS.chr_Name, 
    CX.AccountStatusCode, 
    LKP_AC.AccountClass, 
    LKP_AG.chr_Name, 
    LKP_AG.chr_AccountGroupCode, 
    LKP_AG.cus_Market, 
    LKP_AG.cus_ReportingMarket, 
    LKP_IF.chr_Name, 
    AccountActivationDate, 
    COALESCE(AccountDeactivationDate, '1900-01-01')
), 

CTE_RCC AS (
	SELECT 
		P.AccountString as chr_AccountId,
		PP.ProfileId,
		CAST(pp.RecurringStartDate AS DATETIME) ModifyDate, 
		COALESCE (CAST(pp.RecurringEndDate AS DATETIME),'1900-01-01 00:00:00.000') RecurringEndDate, 
		CAST(pp.RecurringStartDate AS DATETIME) AS EffectiveStartDate, 
		CASE WHEN LEAD(CAST(pp.RecurringStartDate AS DATETIME),1,'2050-01-01') OVER (
			PARTITION BY CAST(P.AccountString AS INT) ORDER BY CAST(pp.RecurringStartDate AS DATETIME)) = '2050-01-01'
		THEN '2050-01-01' 
		ELSE DATEADD(s, -1, LEAD(CAST(pp.RecurringStartDate AS DATETIME), 1, '2050-01-01') OVER (
			PARTITION BY CAST(P.AccountString AS INT) ORDER BY CAST(pp.RecurringStartDate AS DATETIME))) 
		END AS EffectiveEndDate 
	FROM PBBSQL01.PaymentProcessor.dbo.[PaymentProfileX] PP
		JOIN PBBSQL01.PaymentProcessor.dbo.ProfileX P
			ON PP.ProfileId = P.ProfileId
	WHERE P.accountcode IS NOT NULL AND P.TransactionType <> 'D'
	AND PP.Recurring > 0
	AND P.AccountString IN ('104322','105699','158333','102357','101978','103684')
),

CTE_ACH AS (
	Select 
		AccountId as chr_AccountID,
		CAST(StartDate AS DATETIME) ModifyDate, 
		COALESCE (CAST(EndDate AS DATETIME),'1900-01-01 00:00:00.000') EndDate, 
		CAST(StartDate AS DATETIME) AS EffectiveStartDate, 
		CASE WHEN LEAD(CAST(StartDate AS DATETIME),1,'2050-01-01') OVER (
				PARTITION BY CAST(AccountId AS INT) ORDER BY CAST(StartDate AS DATETIME)) = '2050-01-01'
		THEN '2050-01-01' 
		ELSE DATEADD(s, -1, LEAD(CAST(StartDate AS DATETIME), 1, '2050-01-01') OVER (
				PARTITION BY CAST(AccountId AS INT) ORDER BY CAST(StartDate AS DATETIME))) 
		END AS EffectiveEndDate
	from [PBBSQL01].[OMNIA_EPBB_P_PBB_AR].[DBO].[ARBANKACCOUNTX] ACH
	where ACH.TransactionType <> 'D'
	--AND AccountID IN ('104322','105699','158333','102357','101978','103684')
),

ValidDateRanges AS (
  SELECT 
    chr_AccountId, 
    ModifyDate AS EffectiveStartDate, 
    CASE WHEN LEAD(CAST(ModifyDate AS DATETIME),1,'2050-01-01') OVER (
		PARTITION BY CAST(chr_AccountId AS INT) ORDER BY CAST(ModifyDate AS DATETIME)) = '2050-01-01' 
	THEN '2050-01-01' 
	ELSE DATEADD(s,-1,LEAD(CAST(ModifyDate AS DATETIME), 1, '2050-01-01') OVER (
        PARTITION BY CAST(chr_AccountId AS INT) ORDER BY CAST(ModifyDate AS DATETIME))) 
	END AS EffectiveEndDate 
  FROM (
      SELECT 
        chr_AccountId, 
        ModifyDate 
      FROM 
        CTE_Account 
      UNION 
      SELECT 
        chr_AccountId, 
        ModifyDate 
      FROM 
        CTE_PrintGroup
	UNION
	   SELECT 
		 chr_AccountID,
		 ModifyDate
	  FROM
		 CTE_RCC
	UNION
	   SELECT 
		 chr_AccountID,
		 ModifyDate
	  FROM
		 CTE_ACH
    ) tab
	
), 
result AS (
  SELECT 
    D.chr_AccountId, 
    A.AccountId, 
    A.AccountCode, 
    A.AccountName, 
    A.CustomerServiceRegion, 
    A.AccountType, 
    A.AccountClass, 
    A.AccountActivationDate,
	A.AccountDeactivationDate,	
    A.CycleNumber, 
    A.CycleDescription, 
    A.CycleDay, 
    PG.PrintGroup, 
    A.InvoiceFormat, 
    A.AccountStatus, 
    A.AccountStatusCode, 
    A.AccountGroup, 
    A.AccountGroupCode, 
    A.Market, 
    A.ReportingMarket, 
    A.Version,
	CASE WHEN PG.PrintGroup = 'Electronic Invoice' THEN  'Y' ELSE 'N' END AS Ebill,
	CASE WHEN R.chr_AccountID IS NOT NULL AND R.RecurringEndDate NOT BETWEEN D.EffectiveStartDate AND D.EffectiveEndDate THEN 'Y'
	WHEN R.chr_AccountID IS NOT NULL AND R.RecurringEndDate BETWEEN D.EffectiveStartDate AND D.EffectiveEndDate THEN 'N'
	ELSE 'N' END AS RCC,
	CASE WHEN ACH.chr_AccountID IS NOT NULL AND ACH.EndDate NOT BETWEEN D.EffectiveStartDate AND D.EffectiveEndDate THEN 'Y'
	WHEN ACH.chr_AccountID IS NOT NULL AND ACH.EndDate BETWEEN D.EffectiveStartDate AND D.EffectiveEndDate THEN 'N'
	ELSE 'N' END AS ACH,
    D.EffectiveStartDate, 
    D.EffectiveEndDate, 
    DENSE_RANK() OVER (ORDER BY 
        D.chr_AccountId, 
        A.AccountId, 
        A.AccountCode, 
        A.AccountName, 
        A.CustomerServiceRegion, 
        A.AccountType, 
        A.AccountClass, 
        A.AccountActivationDate, 
        A.CycleNumber, 
        A.CycleDescription, 
        A.CycleDay, 
        PG.PrintGroup, 
        A.InvoiceFormat, 
        A.AccountStatus, 
        A.AccountStatusCode, 
        A.AccountGroup, 
        A.AccountGroupCode, 
        A.Market, 
        A.ReportingMarket
    ) AS ranking 
  FROM 
    ValidDateRanges D 
    LEFT JOIN CTE_Account A 
		ON A.chr_AccountID = D.chr_AccountID 
		AND A.EffectiveEndDate > D.EffectiveStartDate 
		AND A.EffectiveStartDate < D.EffectiveEndDate 
    LEFT JOIN CTE_PrintGroup PG 
		ON PG.chr_AccountID = D.chr_AccountID 
		AND PG.EffectiveEndDate > D.EffectiveStartDate 
		AND PG.EffectiveStartDate < D.EffectiveEndDate
	LEFT JOIN CTE_RCC R
		ON R.chr_AccountID = D.chr_AccountID
		AND R.EffectiveEndDate > D.EffectiveStartDate 
		AND R.EffectiveStartDate < D.EffectiveEndDate
	LEFT JOIN CTE_ACH ACH
		ON ACH.chr_AccountID = D.chr_AccountID
		AND ACH.EffectiveEndDate > D.EffectiveStartDate 
		AND ACH.EffectiveStartDate < D.EffectiveEndDate
	-- to avoid unnecessary history for accounts
	Where D.EffectiveStartDate >= (Select Min(ModifyDate) FROM [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[cusaccountx] 
								WHERE AccountId = D.chr_AccountID)
) 

SELECT 
	chr_AccountId, 
	AccountId, 
	AccountCode, 
	AccountName, 
	CustomerServiceRegion, 
	CycleNumber, 
	CycleDescription, 
	CycleDay, 
	PrintGroup, 
	InvoiceFormat, 
	AccountType, 
	AccountStatus, 
	AccountStatusCode, 
	AccountClass, 
	AccountGroup, 
	AccountGroupCode, 
	Market, 
	ReportingMarket, 
	AccountActivationDate, 
	MIN(Last_deactivationDate) AS AccountDeactivationDate,
	MIN(version) version, 
	Ebill,
	RCC,
	ACH,
	MIN(EffectiveStartDate) AS EffectiveStartDate, 
	MAX(EffectiveEndDate) EffectiveEndDate 
FROM 
  (
    SELECT g.*, SUM(g.consec) OVER (ORDER BY AccountId, EffectiveStartDate ROWS UNBOUNDED PRECEDING) AS grp 
	,LAST_VALUE(AccountDeactivationDate) OVER (ORDER BY AccountId, EffectiveStartDate) AS Last_deactivationDate
    FROM 
      (SELECT 
          result.*, LAG(ranking) OVER (ORDER BY AccountId, EffectiveStartDate) last_effstartdt, 
          CASE WHEN LAG(ranking) OVER (ORDER BY AccountId, EffectiveStartDate) = ranking THEN NULL 
		  ELSE 1 END AS consec 
        FROM 
          result) g
  ) tab 
GROUP BY 
  grp, 
  chr_AccountId, 
  AccountId, 
  AccountCode, 
  AccountName, 
  CustomerServiceRegion, 
  CycleNumber, 
  CycleDescription, 
  CycleDay, 
  PrintGroup, 
  InvoiceFormat, 
  AccountType, 
  AccountStatus, 
  AccountStatusCode, 
  AccountClass, 
  AccountGroup, 
  AccountGroupCode, 
  Market, 
  ReportingMarket, 
  Ebill,
  RCC,
  ACH,
  AccountActivationDate
  ;

 
GO
