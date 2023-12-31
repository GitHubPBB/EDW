USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_AccountDetails_backup_05202022]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[PBB_AccountDetails_backup_05202022] as
WITH LastPayment
     AS (SELECT [AccountID], 
                [Payment Date], 
                [Payment Amount]
         FROM [PBBSQL01].[OMNIA_EPBB_P_PBB_AR].[dbo].[PBB_AccountLastPayment] with (NOLOCK)
         WHERE [Payment Amount] <> 0),
     AccountBalance
     AS (SELECT *
         FROM [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[FactAccount] with (NOLOCK)),
     AccountSummary
     AS (SELECT ac.AccountGroupCode AS [Account Group], 
                a.AccountCode AS [Account Number], 
                a.AccountName AS [Account Name], 
                alp.[Payment Date], 
                alp.[Payment Amount], 
                ab.OpenBalanceTotal AS [Current Balance]
         FROM [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_FactCustomerAccount_Fixed] fca with (NOLOCK)
              INNER JOIN [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a with (NOLOCK) ON a.DimAccountID = fca.DimAccountID
              INNER JOIN [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac with (NOLOCK) ON ac.DimAccountCategoryID = fca.DimAccountCategoryID
              LEFT JOIN LastPayment alp ON alp.AccountID = fca.AccountID
              LEFT JOIN AccountBalance ab ON ab.DimAccountId = fca.DimAccountId
         WHERE fca.EffectiveStartDate <= GETDATE()
               AND fca.EffectiveEndDate > GETDATE()),
     RecurringPayment
     AS (SELECT AccountCode, 
                STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS Method
         FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod with (NOLOCK)
         GROUP BY AccountCode),
     PortalCustomer
     AS (SELECT *
         FROM
         (
             SELECT BillingAccountID, 
                    ROW_NUMBER() OVER(PARTITION BY BillingAccountID
                    ORDER BY CAST(CB.CreatedDateTime AS DATE) DESC) AS [Row],
                    CASE
                        WHEN cw.UserName IS NOT NULL
                        THEN 'Y'
                        ELSE 'N'
                    END AS PortalUserExists, 
                    Email AS PortalEmail
             FROM pbbsql01.CHRWEB.dbo.CHRWebUser_BillingAccount CB
                  JOIN pbbsql01.CHRWEB.dbo.chrwebuser cw ON cb.chrwebuserid = cw.CHRWebUserID
             WHERE ishomebillingaccountid = 1
                   AND isenabled = 1
                   AND recordstatusid = 1
         ) inr
         WHERE row = 1),
     activesvc
     AS (SELECT DISTINCT 
                AccountCode 
         FROM FactCustomerItem f with (NOLOCK)
              JOIN DimCustomerItem d with (NOLOCK) ON f.DimCustomerItemId = d.DimCustomerItemId
              JOIN DimAccount A with (NOLOCK) ON F.DimAccountId = A.DimAccountId
              JOIN DimCatalogItem CI with (NOLOCK) ON F.DimCatalogItemId = CI.DimCatalogItemId
			  JOIN PrdComponentMap cm with (NOLOCK) on ci.ComponentCode = cm.ComponentCode
         WHERE f.EffectiveStartDate <= GETDATE()
               AND f.EffectiveEndDate >= GETDATE()
               AND itemstatus IN('A', 'N')
			   AND IsNRC_Scheduling = 0
			   AND IsIgnored = 0)
     SELECT DISTINCT 
            chr_accountTypeidName AS AccountType, 
            chr_accountgroupidname AS AccountGroup, 
            chr_accountStatusIDName AS CurrentAccountStatus, 
            AccountNumber, 
            UPPER([Name]) AS AccountName, 
            LOWER(EmailAddress1) AS Email, 
            Address1_Telephone1 AS Telephone1, 
            Telephone1 Phone, 
            Telephone2 Phone2, 
            Telephone3 Phone3, 
            chr_password AS CPNIPassword, 
            LOWER(chr_CPNIEmailAddress) AS CPNIEmail, 
            case when PortalUserExists = 'Y' then 'Y' else 'N' end as PortalUserExists, 
            LOWER(PortalEmail) PortalEmail, 
            chr_PrintGroupIDName AS PrintGroup, 
            chr_cycleidname AS BillCycle, 
            chr_accountactivationdate AS ActivationDate, 
            chr_accountdeactivationdate AS DeactivationDate, 
            acctsum.[Payment Date] AS [Last Payment Date], 
            acctsum.[Payment Amount] AS [Payment Amount], 
            acctsum.[Current Balance] AS [Open Balance_As of Previous Day], 
            ISNULL(rp.Method, '') AS [Recurring Payment Method],
			Case when activesvc.AccountCode is not null then 'Y' else 'N' end as ActiveServices,
            chr_thirdpartycustomernumber AS LegacySystemAccountID
     FROM pbbsql01.pbb_p_mscrm.dbo.account a
          LEFT JOIN PortalCustomer CB ON cb.BillingAccountID COLLATE SQL_Latin1_General_CP1_CI_AS = a.AccountNumber COLLATE SQL_Latin1_General_CP1_CI_AS
          LEFT JOIN AccountSummary acctsum ON acctsum.[Account Number] = AccountNumber COLLATE SQL_Latin1_General_CP1_CI_AS
          LEFT JOIN RecurringPayment rp ON rp.AccountCode = acctsum.[Account Number]
		  LEFT JOIN activesvc on acctsum.[Account Number] = activesvc.AccountCode
     WHERE accountnumber IS NOT NULL
GO
