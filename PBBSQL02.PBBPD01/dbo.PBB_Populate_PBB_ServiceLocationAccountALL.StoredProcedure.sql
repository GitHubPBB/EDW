USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_PBB_ServiceLocationAccountALL]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PBB_Populate_PBB_ServiceLocationAccountALL]
AS
    BEGIN
        SET NOCOUNT ON;
        TRUNCATE TABLE [dbo].[PBB_ServiceLocationAccountALL];
        WITH AllLocations
             AS (SELECT DimServiceLocationID, 
                        LocationID, 
                        DimFMAddressId
                 FROM FactServiceLocation
                 WHERE EffectiveStartDate <= GETDATE()
                       AND EffectiveEndDate > GETDATE()),
             Open_Order
             AS (SELECT DISTINCT 
                        ISNULL(OmniaLocationID, 0) LocationID, 
                        ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0') CRMAccountID, 
                        AccountStatus,
                        CASE
                            WHEN SUM(OpenInstallOrder) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS OpenInstallOrder,
                        CASE
                            WHEN SUM(NonInstallOrder) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS NonInstallOrder
                 FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.PBB_DW_ServiceLocationAccountOpenOrders
                 GROUP BY ISNULL(OmniaLocationID, 0), 
                          ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0'), 
                          AccountStatus),
             Open_Opportunity
             AS (SELECT DISTINCT 
                        ISNULL(OmniaLocationID, 0) LocationID, 
                        ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0') CRMAccountID, 
                        AccountStatus,
                        CASE
                            WHEN SUM([OpenInstallOpportunity]) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS [OpenInstallOpportunity],
                        CASE
                            WHEN SUM([NonInstallOpportunity]) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS [NonInstallOpportunity]
                 FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.PBB_DW_ServiceLocationAccountOpenOpportunities
                 WHERE OmniaLocationID IS NOT NULL
                 GROUP BY ISNULL(OmniaLocationID, 0), 
                          ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0'), 
                          AccountStatus),
             Open_Lead
             AS (SELECT DISTINCT 
                        ISNULL(OmniaLocationID, 0) LocationID, 
                        ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0') CRMAccountID,
                        CASE
                            WHEN SUM([OpenInstallLead]) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS [OpenInstallLead],
                        CASE
                            WHEN SUM([NonInstallLead]) > 0
                            THEN 'Y'
                            ELSE 'N'
                        END AS [NonInstallLead], 
                        LeadType, 
                        AccountStatus
                 FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.PBB_DW_ServiceLocationAccountOpenLeads
                 WHERE OmniaLocationID IS NOT NULL
                 GROUP BY ISNULL(OmniaLocationID, 0), 
                          ISNULL(CAST(CRMAccountID AS NVARCHAR(100)), '0'), 
                          LeadType, 
                          AccountStatus),
             LocationAccountWithStatuses
             AS (
             --Get all Locations with SrvItem associated
             SELECT SLI.LocationID LocationID, 
                    CAST(SLI.CRMAccountID AS NVARCHAR(100)) CRMAccountID, 
                    SLI.AccountStatus, 
                    MIN(ItemActivationDate) AS LocationAccountActivationDate, 
                    MAX(ISNULL(ItemDeactivationDate, '2050-12-31')) AS LocationAccountDeactivationDate, 
                    SUM(ISNULL(sli.ItemAmount, 0)) AS LocationAccountAmount, 
                    LocationAccountItemStatuses = STUFF(
             (
                 SELECT DISTINCT 
                        '; ' + ItemStatus
                 FROM PBB_ServiceLocationItem S
                 WHERE IsIgnored = 0
                       AND IsNRC_Scheduling = 0
                       AND SLI.CRMAccountID = S.CRMAccountID
                       AND SLI.LocationID = S.LocationID FOR XML PATH('')
             ), 1, 2, ''), 
                    ISNULL(O.OpenInstallOrder, 'N') OpenInstallOrder, 
                    ISNULL(O.NonInstallOrder, 'N') NonInstallOrder, 
                    ISNULL(OPP.OpenInstallOpportunity, 'N') OpenInstallOpportunity, 
                    ISNULL(OPP.NonInstallOpportunity, 'N') NonInstallOpportunity, 
                    ISNULL(L.OpenInstallLead, 'N') OpenInstallLead, 
                    ISNULL(L.NonInstallLead, 'N') NonInstallLead, 
                    ISNULL(L.LeadType, '') LeadType
             FROM PBB_ServiceLocationItem SLI
                  LEFT JOIN Open_Order O ON SLI.LocationID = O.LocationID
                                            AND CAST(SLI.CRMAccountID AS NVARCHAR(100)) = O.CRMAccountID
                  LEFT JOIN Open_Opportunity OPP ON SLI.LocationID = OPP.LocationID
                                                    AND CAST(SLI.CRMAccountID AS NVARCHAR(100)) = OPP.CRMAccountID
                  LEFT JOIN Open_Lead L ON SLI.LocationID = L.LocationID
                                           AND CAST(SLI.CRMAccountID AS NVARCHAR(100)) = L.CRMAccountID
             WHERE IsIgnored = 0
                   AND IsNRC_Scheduling = 0
             GROUP BY SLI.LocationID, 
                      SLI.CRMAccountID, 
                      SLI.AccountStatus, 
                      ISNULL(O.OpenInstallOrder, 'N'), 
                      ISNULL(O.NonInstallOrder, 'N'), 
                      ISNULL(OPP.OpenInstallOpportunity, 'N'), 
                      ISNULL(OPP.NonInstallOpportunity, 'N'), 
                      ISNULL(L.OpenInstallLead, 'N'), 
                      ISNULL(L.NonInstallLead, 'N'), 
                      ISNULL(L.LeadType, '')
             UNION
             --Get all Locations with no account associated
             SELECT CAST(AL.LocationID AS NVARCHAR(100)) LocationID, 
                    '0' CRMAccountID, 
                    '' AS AccountStatus, 
                    '1900-01-01' AS LocationAccountActivationDate, 
                    '2050-12-31' AS LocationAccountDeactivationDate, 
                    0 AS pbb_LocationAccountAmount, 
                    '' AS LocationAccountItemStatuses, 
                    ISNULL(O.OpenInstallOrder, 'N') OpenInstallOrder, 
                    ISNULL(O.NonInstallOrder, 'N') NonInstallOrder, 
                    ISNULL(OPP.OpenInstallOpportunity, 'N') OpenInstallOpportunity, 
                    ISNULL(OPP.NonInstallOpportunity, 'N') NonInstallOpportunity, 
                    ISNULL(L.OpenInstallLead, 'N') OpenInstallLead, 
                    ISNULL(L.NonInstallLead, 'N') NonInstallLead, 
                    ISNULL(L.LeadType, '') LeadType
             FROM AllLocations AL
                  LEFT JOIN Open_Order O ON AL.LocationID = O.LocationID
                                            AND O.CRMAccountID = '0'
                  LEFT JOIN Open_Opportunity OPP ON AL.LocationID = OPP.LocationID
                                                    AND OPP.CRMAccountID = '0'
                  LEFT JOIN Open_Lead L ON AL.LocationID = L.LocationID
                                           AND L.CRMAccountID = '0'
             UNION
             --Get all lead with prospect account associated, no open orders, no open opportunities
             SELECT CAST(AL.LocationID AS NVARCHAR(100)) LocationID, 
                    CAST(L.CRMAccountID AS NVARCHAR(100)) CRMAccountID,
                    CASE
                        WHEN L.AccountStatus = 'Prospect'
                        THEN 'P'
                        ELSE 'P'
                    END AS AccountStatus, 
                    '1900-01-01' AS LocationAccountActivationDate, 
                    '2050-12-31' AS LocationAccountDeactivationDate, 
                    0 AS pbb_LocationAccountAmount, 
                    '' AS LocationAccountItemStatuses, 
                    'N' OpenInstallOrder, 
                    'N' NonInstallOrder, 
                    'N' OpenInstallOpportunity, 
                    'N' NonInstallOpportunity, 
                    ISNULL(L.OpenInstallLead, 'N') OpenInstallLead, 
                    ISNULL(L.NonInstallLead, 'N') NonInstallLead, 
                    ISNULL(L.LeadType, '') LeadType
             FROM AllLocations AL
                  JOIN Open_Lead L ON AL.LocationID = L.LocationID
                                      AND CAST(L.AccountStatus AS NVARCHAR(100)) = 'Prospect'
                  LEFT JOIN Open_Order O ON AL.LocationID = O.LocationID
                                            AND L.CRMAccountID = O.CRMAccountID
                  LEFT JOIN Open_Opportunity OPP ON AL.LocationID = OPP.LocationID
                                                    AND L.CRMAccountID = OPP.CRMAccountID
             WHERE O.CRMAccountID IS NULL
                   AND OPP.CRMAccountID IS NULL
             UNION
             --Get srvitemx rows (moves)
             SELECT DISTINCT 
                    CAST(X.LocationID AS NVARCHAR(100)) LocationID, 
                    CAST(X.CRMAccountID AS NVARCHAR(100)) CRMAccountID, 
                    x.AccountStatus, 
                    ItemActivationDate AS LocationAccountActivationDate, 
                    ItemDeactivationDate AS LocationAccountDeactivationDate, 
                    0 AS LocationAccountAmount, 
                    'I' AS LocationAccountItemStatuses, 
                    'N' OpenInstallOrder, 
                    'N' NonInstallOrder, 
                    'N' OpenInstallOpportunity, 
                    'N' NonInstallOpportunity, 
                    'N' OpenInstallLead, 
                    'N' NonInstallLead, 
                    '' LeadType
             FROM
             (
                 SELECT DISTINCT 
                        acct.accountid CRMAccountID, 
                        A.AccountID, 
                        locationid, 
                        a.accountstatuscode AccountStatus, 
                        MIN(x.activationdate) ItemActivationDate, 
                        ISNULL(MAX(x.deactivationdate), MAX(x.modifydate)) ItemDeactivationDate
                 FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.srvitemx x
                      JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.srvservice s ON x.serviceid = s.serviceid
                      JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.cusaccount a ON s.accountid = a.accountid
                      JOIN pbbsql01.pbb_p_mscrm.dbo.account acct ON a.accountid = acct.chr_accountid
                 GROUP BY acct.accountid, 
                          a.accountid, 
                          locationid, 
                          a.accountstatuscode
             ) x
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        acct.accountid CRMAccountID, 
                        A.AccountID, 
                        locationid
                 FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.srvitem x
                      JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.srvservice s ON x.serviceid = s.serviceid
                      JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.cusaccount a ON s.accountid = a.accountid
                      JOIN pbbsql01.pbb_p_mscrm.dbo.account acct ON a.accountid = acct.chr_accountid
             ) i ON x.AccountID = i.AccountID
                    AND x.LocationID = i.LocationID
             WHERE i.LocationID IS NULL
             UNION

             --Open Order, does not exist in PBB_ServiceLocationItem
             SELECT CAST(L.LocationID AS NVARCHAR(100)) LocationID, 
                    CAST(O.CRMAccountID AS NVARCHAR(100)) CRMAccountID, 
                    O.AccountStatus COLLATE DATABASE_DEFAULT AS AccountStatus, 
                    '1900-01-01' AS LocationAccountActivationDate, 
                    '2050-12-31' AS LocationAccountDeactivationDate, 
                    0 AS LocationAccountAmount, 
                    '' AS LocationAccountItemStatuses, 
                    ISNULL(O.OpenInstallOrder, 'N') OpenInstallOrder, 
                    ISNULL(O.NonInstallOrder, 'N') NonInstallOrder, 
                    ISNULL(OPP.OpenInstallOpportunity, 'N') OpenInstallOpportunity, 
                    ISNULL(OPP.NonInstallOpportunity, 'N') NonInstallOpportunity, 
                    ISNULL(Ld.OpenInstallLead, 'N') OpenInstallLead, 
                    ISNULL(Ld.NonInstallLead, 'N') NonInstallLead, 
                    ISNULL(Ld.LeadType, '') LeadType
             FROM AllLocations L
                  JOIN Open_Order O ON L.LocationID = O.LocationID
                  LEFT JOIN Open_Opportunity Opp ON O.LocationID = Opp.LocationID
                                                    AND O.CRMAccountID = Opp.CRMAccountID
                  LEFT JOIN Open_Lead Ld ON O.LocationID = Ld.LocationID
                                            AND O.CRMAccountID = Ld.CRMAccountID
                  LEFT JOIN PBB_ServiceLocationItem I ON O.CRMAccountID = I.CRMAccountId
             WHERE I.CRMAccountId IS NULL
             UNION 
             --Open Opportunity, does not exist in PBB_ServiceLocationItem, No open Order
             SELECT CAST(L.LocationID AS NVARCHAR(100)) LocationID, 
                    CAST(Opp.CRMAccountID AS NVARCHAR(100)) CRMAccountID, 
                    Opp.AccountStatus COLLATE DATABASE_DEFAULT AS AccountStatus, 
                    '1900-01-01' AS LocationAccountActivationDate, 
                    '2050-12-31' AS LocationAccountDeactivationDate, 
                    0 AS pbb_LocationAccountAmount, 
                    '' AS LocationAccountItemStatuses, 
                    ISNULL(O.OpenInstallOrder, 'N') OpenInstallOrder, 
                    ISNULL(O.NonInstallOrder, 'N') NonInstallOrder, 
                    ISNULL(OPP.OpenInstallOpportunity, 'N') OpenInstallOpportunity, 
                    ISNULL(OPP.NonInstallOpportunity, 'N') NonInstallOpportunity, 
                    ISNULL(Ld.OpenInstallLead, 'N') OpenInstallLead, 
                    ISNULL(Ld.NonInstallLead, 'N') NonInstallLead, 
                    ISNULL(Ld.LeadType, '') LeadType
             FROM AllLocations L
                  JOIN Open_Opportunity Opp ON L.LocationID = Opp.LocationID
                  LEFT JOIN Open_Order O ON O.LocationID = Opp.LocationID
                                            AND O.CRMAccountID COLLATE SQL_Latin1_General_CP1_CI_AI = Opp.CRMAccountID COLLATE SQL_Latin1_General_CP1_CI_AI
                  LEFT JOIN Open_Lead Ld ON Opp.LocationID = Ld.LocationID
                                            AND Opp.CRMAccountID COLLATE SQL_Latin1_General_CP1_CI_AI = Ld.CRMAccountID COLLATE SQL_Latin1_General_CP1_CI_AI
                  LEFT JOIN PBB_ServiceLocationItem I ON Opp.CRMAccountID COLLATE SQL_Latin1_General_CP1_CI_AI = CAST(I.CRMAccountId AS NVARCHAR(100)) COLLATE SQL_Latin1_General_CP1_CI_AI
             WHERE I.CRMAccountId IS NULL
                   AND O.CRMAccountID IS NULL
                   AND Opp.CRMAccountID <> '0')
             INSERT INTO [PBB_ServiceLocationAccountALL]
                    SELECT DISTINCT 
                           L.DimServiceLocationId, 
                           L.LocationID, 
                           L.DimFMAddressId, 
                           A.DimAccountID, 
                           S.CRMAccountID, 
                           S.AccountStatus, 
                           S.LocationAccountActivationDate, 
                           S.LocationAccountDeactivationDate, 
                           S.LocationAccountAmount, 
                           S.LocationAccountItemStatuses, 
                           S.OpenInstallOrder, 
                           S.NonInstallOrder, 
                           S.OpenInstallOpportunity, 
                           S.NonInstallOpportunity, 
                           S.OpenInstallLead, 
                           S.NonInstallLead, 
                           S.LeadType, 
                           pbb_ServiceLocationAccountStatus = CASE
                                                                  WHEN LocationAccountItemStatuses LIKE '%A%'
                                                                  THEN 'Active'
                                                                  WHEN LocationAccountItemStatuses LIKE '%N%'
                                                                  THEN 'Nonpay'
                                                                  WHEN OpenInstallOrder IN('Yes', 'Y')
                                                                  THEN 'Pending Install Order'
                                                                  WHEN OpenInstallOpportunity IN('Yes', 'Y')
                                                                  THEN 'Opportunity'
                                                                  WHEN LeadType NOT LIKE ''
                                                                  THEN LeadType
                                                                  WHEN S.AccountStatus = 'P'
                                                                  THEN 'Prospect'
                                                                  WHEN LocationAccountItemStatuses LIKE '%S%'
                                                                  THEN 'Suspend'
                                                                  WHEN LocationAccountItemStatuses IS NULL
                                                                       AND S.AccountStatus = 'I'
                                                                  THEN 'Inactive' --LocationAccountStatus (locationaccountitemstatus) no items active/pbb_locationaccountstatus acct inactive
                                                                  WHEN LocationAccountItemStatuses LIKE '%I%'
                                                                  THEN 'Inactive'
                                                                  ELSE 'None'
                                                              END, 
                           pbb_ServiceLocationAccountRank = CASE
                                                                WHEN LocationAccountItemStatuses LIKE '%A%'
                                                                THEN 1
                                                                WHEN LocationAccountItemStatuses LIKE '%N%'
                                                                THEN 1
                                                                WHEN OpenInstallOrder IN('Yes', 'Y')
                                                                THEN 2
                                                                WHEN OpenInstallOpportunity IN('Yes', 'Y')
                                                                THEN 3
                                                                WHEN LeadType NOT LIKE ''
                                                                     AND LeadType <> 'Lead-Service Location Validation'
                                                                THEN 4
                                                                WHEN LeadType = 'Lead-Service Location Validation'
                                                                THEN 5
                                                                WHEN S.AccountStatus = 'P'
                                                                THEN 6
                                                                WHEN LocationAccountItemStatuses LIKE '%S%'
                                                                THEN 7
                                                                WHEN LocationAccountItemStatuses IS NULL
                                                                     AND S.AccountStatus = 'I'
                                                                THEN 8 --LocationAccountStatus (locationaccountitemstatus) no items active/pbb_locationaccountstatus acct inactive
                                                                WHEN LocationAccountItemStatuses LIKE '%I%'
                                                                THEN 8
                                                                ELSE 9
                                                            END
                    FROM AllLocations L
                         LEFT JOIN LocationAccountWithStatuses s ON L.LocationID = S.LocationID
                         LEFT JOIN dimaccount a ON CAST(s.CRMAccountid AS NVARCHAR(100)) = a.AccountId;
    END;
GO
