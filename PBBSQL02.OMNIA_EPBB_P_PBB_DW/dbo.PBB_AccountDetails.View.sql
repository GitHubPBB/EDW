USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_AccountDetails]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_AccountDetails]
AS
     WITH AccountSummary
          AS (SELECT ac.AccountGroup AS [AccountGroup], 
                     ac.AccountType, 
                     a.AccountStatus, 
                     fca.DimAccountId, 
                     a.AccountCode AS [Account Number], 
                     a.AccountName AS [AccountName], 
                     a.AccountEMailAddress, 
                     a.AccountPhoneNumber, 
                     a.BillingAddressPhone, 
                     a.CpniPassword, 
                     a.PrintGroup,
					 CASE WHEN a.PrintGroup = 'Electronic Invoice' THEN  'Y' ELSE 'N' END as Ebill_Flag,
                     ac.CycleDescription, 
                     a.AccountActivationDate, 
                     a.AccountDeactivationDate, 
                     LastPayment.[Payment Date], 
                     LastPayment.[Payment Amount], 
                     AccountBalance.OpenBalanceTotal AS [Current Balance]
              FROM [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_FactCustomerAccount_Fixed] fca WITH(NOLOCK)
                   INNER JOIN [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a WITH(NOLOCK) ON a.DimAccountID = fca.DimAccountID
                   INNER JOIN [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac WITH(NOLOCK) ON ac.DimAccountCategoryID = fca.DimAccountCategoryID
                   LEFT JOIN
              (
                  SELECT [AccountID], 
                         [Payment Date], 
                         [Payment Amount]
                  FROM [PBBSQL01].[OMNIA_EPBB_P_PBB_AR].[dbo].[PBB_AccountLastPayment] WITH(NOLOCK)
                  WHERE [Payment Amount] <> 0
              ) LastPayment ON LastPayment.AccountID = fca.AccountID
                   LEFT JOIN
              (
                  SELECT DimAccountId, 
                         OpenBalanceTotal
                  FROM [PBBSQL02].[OMNIA_EPBB_P_PBB_DW].[dbo].[FactAccount] WITH(NOLOCK)
              ) AccountBalance ON AccountBalance.DimAccountId = fca.DimAccountId
              WHERE fca.EffectiveStartDate <= GETDATE()
                    AND fca.EffectiveEndDate > GETDATE()),
          RecurringPayment
          AS (SELECT AccountCode, 
                     STRING_AGG(CONVERT(NVARCHAR(MAX), Method), ', ') AS Method
              FROM [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_AccountRecurringPaymentMethod WITH(NOLOCK)
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
                     a.AccountCode
              FROM FactCustomerItem f WITH(NOLOCK)
                   JOIN DimCustomerItem d WITH(NOLOCK) ON f.DimCustomerItemId = d.DimCustomerItemId
                   JOIN DimAccount A WITH(NOLOCK) ON F.DimAccountId = A.DimAccountId
                   JOIN DimCatalogItem CI WITH(NOLOCK) ON F.DimCatalogItemId = CI.DimCatalogItemId
                   JOIN PrdComponentMap cm WITH(NOLOCK) ON CONVERT(NCHAR(7), [CI].[ComponentCode], 0) = cm.ComponentCode
              WHERE f.EffectiveStartDate <= GETDATE()
                    AND f.EffectiveEndDate >= GETDATE()
                    AND itemstatus IN('A', 'N')
                   AND IsNRC_Scheduling = 0
                   AND IsIgnored = 0)
          SELECT acctsum.AccountType, 
                 acctsum.AccountGroup, 
                 acctsum.AccountStatus AS CurrentAccountStatus, 
                 acctsum.[Account Number] AS AccountNumber, 
                 acctsum.DimAccountId, 
                 UPPER(acctsum.AccountName) AS AccountName, 
                 LOWER(acctsum.AccountEMailAddress) AS Email, 
                 Address1_Telephone1 Telephone1, 
                 Telephone1 Phone, 
                 Telephone2 Phone2, 
                 Telephone3 Phone3, 
                 acctsum.CpniPassword AS CPNIPassword, 
                 LOWER(chr_CPNIEmailAddress) AS CPNIEmail,
                 CASE
                     WHEN PortalUserExists = 'Y'
                     THEN 'Y'
                     ELSE 'N'
                 END AS PortalUserExists, 
                 LOWER(PortalEmail) PortalEmail, 
                 acctsum.PrintGroup,
				 acctsum.Ebill_Flag,
                 acctsum.CycleDescription AS BillCycle, 
                 CAST(acctsum.AccountActivationDate AS DATETIME) AS ActivationDate, 
                 CAST(acctsum.AccountDeactivationDate AS DATETIME) AS DeactivationDate, 
                 acctsum.[Payment Date] AS [Last Payment Date], 
                 acctsum.[Payment Amount] AS [Payment Amount], 
                 acctsum.[Current Balance] AS [Open Balance_As of Previous Day], 
                 ISNULL(rp.Method, '') AS [Recurring Payment Method],
                 CASE
                     WHEN activesvc.AccountCode IS NOT NULL
                     THEN 'Y'
                     ELSE 'N'
                 END AS ActiveServices, 
                 chr_thirdpartycustomernumber AS LegacySystemAccountID
          FROM AccountSummary acctsum
               LEFT JOIN pbbsql01.pbb_p_mscrm.dbo.account a ON acctsum.[Account Number] = a.AccountNumber COLLATE SQL_Latin1_General_CP1_CI_AS
               LEFT JOIN PortalCustomer CB ON CB.BillingAccountID COLLATE SQL_Latin1_General_CP1_CI_AS = acctsum.[Account Number] COLLATE SQL_Latin1_General_CP1_CI_AS
               LEFT JOIN RecurringPayment rp ON rp.AccountCode = acctsum.[Account Number]
               LEFT JOIN activesvc ON activesvc.AccountCode = acctsum.[Account Number] COLLATE SQL_Latin1_General_CP1_CI_AS
          WHERE a.accountnumber IS NOT NULL;
GO
