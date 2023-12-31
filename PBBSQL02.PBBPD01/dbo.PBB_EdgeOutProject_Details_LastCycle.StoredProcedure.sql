USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_EdgeOutProject_Details_LastCycle]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_EdgeOutProject_Details_LastCycle]
--@BillingYYYY int = '2021',
--@BillingMM int = '05'
AS
    BEGIN
        WITH MAXCYCLE
             AS (SELECT AccountCode, 
                        br.BillingRunID AS LastBillingCycle
                 FROM
                 (
                     SELECT Accountcode, 
                            BillingRunID
                     FROM [OMNIA_ELEG_P_LEG_DW].[dbo].[FactBilledCharge] fbc
                          INNER JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimBillingRun br ON br.DimBillingRunId = fbc.DimBillingRunId
                          INNER JOIN [OMNIA_ELEG_P_LEG_DW].[dbo].[DimAccount] a ON a.DimAccountId = fbc.DimAccountId
                     UNION
                     SELECT Accountcode, 
                            BillingRunID
                     FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[FactBilledCharge] fbc
                          INNER JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimBillingRun br ON br.DimBillingRunId = fbc.DimBillingRunId
                          INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a ON a.DimAccountId = fbc.DimAccountId
                 ) br
				 join (select BillingCycleID, max(billingrunid) BillingRunID
						from
						(select * from DimBillingRun
						union 
						select * from [OMNIA_ELEG_P_LEG_DW].[dbo].DimBillingRun) BC
						where billingcycleid <> 0
						group by billingcycleid) lc on br.BillingRunID = lc.billingrunid 
                 ),
             CHG
             AS (SELECT DISTINCT 
                        sld.pbb_locationprojectcode, 
                        ac.AccountGroup, 
                        br.BillingYearYYYY, 
                        br.BillingMonthMMM, 
                        sl.DimServiceLocationId, 
                        sl.LocationId, 
                        a.DimAccountID, 
                        a.Accountcode, 
                        a.AccountName, 
                        ServiceLocationFullAddress, 
                        ServiceLocationCity, 
                        ServiceLocationState, 
                        ServiceLocationPostalCode, 
                        sld.pbb_DefaultNetworkDelivery, 
                        sld.pbb_LocationIsServiceable, 
                        c.BilledChargeFractionalization, 
                        CatalogPriceIsRecurring, 
                        SUM(CASE
                                WHEN gl.RevenueGLAccountNumber NOT IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                                     AND cai.ComponentName <> 'Business Service Discount'
                                THEN BilledChargeAmount
                                ELSE 0
                            END) AS 'ChargeAmount', 
                        SUM(CASE
                                WHEN gl.RevenueGLAccountNumber IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                                     OR cai.ComponentName = 'Business Service Discount'
                                THEN BilledChargeAmount
                                ELSE 0
                            END) AS 'PromotionAmount', 
                        SUM(f.BilledChargeDiscountAmount) AS DiscountAmount, 
                        SUM(f.BilledChargeNetAmount) AS Net
                 FROM [OMNIA_ELEG_P_LEG_DW].dbo.factbilledcharge f
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimCatalogPrice cp ON f.DimCatalogPriceId = cp.DimCatalogPriceId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimCatalogItem cai ON f.DimCatalogItemId = cai.DimCatalogItemId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimAccount a ON f.DimAccountId = a.DimAccountId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimAccountCategory ac ON f.DimAccountCategoryId = ac.DimAccountCategoryId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimServiceLocation sl ON f.DimServiceLocationId = sl.DimServiceLocationId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation_pbb sld ON sl.LocationId = sld.LocationId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimBillingRun br ON f.DimBillingRunId = br.DimBillingRunId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimBilledCharge c ON f.DimBilledChargeId = c.DimBilledChargeId
                      JOIN [OMNIA_ELEG_P_LEG_DW].dbo.DimGLMap gl ON f.DimGLMapId = gl.DimGLMapId
                      JOIN MAXCYCLE ON BR.BillingRunID = MAXCYCLE.LastBillingCycle
                                       AND a.accountcode = MAXCYCLE.accountcode
                 WHERE pbb_locationprojectcode <> ''
                       AND BilledChargeFractionalization = 'Full'
                 --and br.BillingYearYYYY = @BillingYYYY
                 --and br.BillingMonthMMM = @BillingMM
                 GROUP BY sld.pbb_locationprojectcode, 
                          ac.AccountGroup, 
                          br.BillingYearYYYY, 
                          br.BillingMonthMMM, 
                          sl.DimServiceLocationId, 
                          sl.LocationId, 
                          a.DimAccountID, 
                          a.Accountcode, 
                          a.AccountName, 
                          ServiceLocationFullAddress, 
                          ServiceLocationCity, 
                          ServiceLocationState, 
                          ServiceLocationPostalCode, 
                          sld.pbb_DefaultNetworkDelivery, 
                          sld.pbb_LocationIsServiceable, 
                          c.BilledChargeFractionalization, 
                          CatalogPriceIsRecurring
                 UNION
                 SELECT DISTINCT 
                        sld.pbb_locationprojectcode, 
                        ac.AccountGroup, 
                        br.BillingYearYYYY, 
                        br.BillingMonthMMM, 
                        sl.DimServiceLocationId, 
                        sl.LocationId, 
                        a.DimAccountID, 
                        a.Accountcode, 
                        a.AccountName, 
                        ServiceLocationFullAddress, 
                        ServiceLocationCity, 
                        ServiceLocationState, 
                        ServiceLocationPostalCode, 
                        sld.pbb_DefaultNetworkDelivery, 
                        sld.pbb_LocationIsServiceable, 
                        c.BilledChargeFractionalization, 
                        CatalogPriceIsRecurring, 
                        SUM(CASE
                                WHEN gl.RevenueGLAccountNumber NOT IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                                     AND cai.ComponentName <> 'Business Service Discount'
                                THEN BilledChargeAmount
                                ELSE 0
                            END) AS 'ChargeAmount', 
                        SUM(CASE
                                WHEN gl.RevenueGLAccountNumber IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                                     OR cai.ComponentName = 'Business Service Discount'
                                THEN BilledChargeAmount
                                ELSE 0
                            END) AS 'PromotionAmount', 
                        SUM(f.BilledChargeDiscountAmount) AS DiscountAmount, 
                        SUM(f.BilledChargeNetAmount) AS Net
                 FROM [OMNIA_EPBB_P_PBB_DW].dbo.factbilledcharge f
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogPrice cp ON f.DimCatalogPriceId = cp.DimCatalogPriceId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem cai ON f.DimCatalogItemId = cai.DimCatalogItemId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccount a ON f.DimAccountId = a.DimAccountId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimAccountCategory ac ON f.DimAccountCategoryId = ac.DimAccountCategoryId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation sl ON f.DimServiceLocationId = sl.DimServiceLocationId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation_pbb sld ON sl.LocationId = sld.LocationId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimBillingRun br ON f.DimBillingRunId = br.DimBillingRunId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimBilledCharge c ON f.DimBilledChargeId = c.DimBilledChargeId
                      JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimGLMap gl ON f.DimGLMapId = gl.DimGLMapId
                      JOIN MAXCYCLE ON BR.BillingRunID = MAXCYCLE.LastBillingCycle
                                       AND a.accountcode = MAXCYCLE.accountcode
                 WHERE pbb_locationprojectcode <> ''
                       AND BilledChargeFractionalization = 'Full'
                 --and br.BillingYearYYYY = @BillingYYYY
                 --and br.BillingMonthMMM = @BillingMM
                 GROUP BY sld.pbb_locationprojectcode, 
                          ac.AccountGroup, 
                          br.BillingYearYYYY, 
                          br.BillingMonthMMM, 
                          sl.DimServiceLocationId, 
                          sl.LocationId, 
                          a.DimAccountID, 
                          a.Accountcode, 
                          a.AccountName, 
                          ServiceLocationFullAddress, 
                          ServiceLocationCity, 
                          ServiceLocationState, 
                          ServiceLocationPostalCode, 
                          sld.pbb_DefaultNetworkDelivery, 
                          sld.pbb_LocationIsServiceable, 
                          c.BilledChargeFractionalization, 
                          CatalogPriceIsRecurring)

             --select * from chg
             --Details
             SELECT newid(), --[Location Zone], 
             UPPER([Project Name]) [Project Name], 
			 Cabinet,
             [Wirecenter Region],
             CASE
                 WHEN [Wirecenter Region] LIKE '%Urban%'
                 THEN 'Urban'
				 WHEN [Wirecenter Region] LIKE '%Rural%'
                 THEN 'Rural'
                 ELSE 'Not Defined'
             END AS MarketType, 
             FundType, 
             FundTypeID, 
             [Omnia SrvItemLocationID], 
             [Full Address], 
			 AddressNoPostal,
			 StreetAddress1 ServiceAddress1,
			 StreetAddress2 ServiceAddress2,
			 City,
			 [State Abbreviation],
			 [Postal Code],
             format(CreatedOn, 'MM/dd/yyyy') CreatedOn, 
             replace(ServiceLocationCreatedBy, 'PBBO360\', '') ServiceLocationCreatedBy,
             CASE
                 WHEN LocationIsServicable = ''
                 THEN 'No'
                 ELSE LocationIsServicable
             END AS Serviceability,
             CASE
                 WHEN format(CAST([Serviceable Date] AS DATE), 'MM/dd/yyyy') = '01/01/1900'
                 THEN ''
                 ELSE format(CAST([Serviceable Date] AS DATE), 'MM/dd/yyyy')
             END AS [Serviceable Date], 
             ISNULL([Account-Location Status], 'None') AccountLocationStatus,
			 case when [Account-Location Status] in ('Active','NonPay') then 1 else 0 end as ActiveCount,
             CASE
                 WHEN format(CAST(MIN([Account-Service Activation Date]) AS DATE), 'MM/dd/yyyy') = '01/01/1900'
                 THEN ''
                 ELSE format(CAST(MIN([Account-Service Activation Date]) AS DATE), 'MM/dd/yyyy')
             END AS [Account-Service Activation Date],
             CASE
                 WHEN format(CAST([Account-Service Deactivation Date] AS DATE), 'MM/dd/yyyy') = '01/01/1900'
                 THEN ''
                 ELSE format(CAST([Account-Service Deactivation Date] AS DATE), 'MM/dd/yyyy')
             END AS [Account-Service Deactivation Date], 
			 ad.AccountType,ac.accountgroup,
             ad.AccountCode, 
             ad.AccountName, 
             BillingYearYYYY, 
             BillingMonthMMM, 
             SUM(chg.ChargeAmount) ChargeAmount, 
             SUM(chg.PromotionAmount) PromotionAmount, 
             SUM(chg.DiscountAmount) DiscountAmount, 
             SUM(chg.Net) Net
             FROM DimAddressDetails_pbb ad
				  LEFT JOIN (select distinct accountgroupcode, accountgroup from DimAccountCategory) ac on ad.AccountGroupCode = ac.AccountGroupCode
                  LEFT JOIN CHG ON ad.accountcode = chg.accountcode
                                   AND ad.[Omnia SrvItemLocationID] = chg.LocationID
             WHERE [Project Name] like '%PROJECT%' --or [Project Name] like '%UNIVERSAL%'
             GROUP BY --[Location Zone], 
             FundType, 
             FundTypeID, 
             [Wirecenter Region], 
             [Project Name], 
			 Cabinet,
             [Omnia SrvItemLocationID], 
             [Full Address], 
			 AddressNoPostal,
			 StreetAddress1,
			 StreetAddress2,
			 City,
			 [State Abbreviation],
			 [Postal Code],
             CreatedOn, 
             ServiceLocationCreatedBy, 
             LocationIsServicable, 
             [Serviceable Date], 
             [Account-Location Status], 
			  case when isnull([Account-Location Status],'None') in ('Active','NonPay') then 1 else 0 end,
             [Account-Service Deactivation Date], 
			 AccountType,ac.accountgroup,
             ad.AccountCode, 
             ad.AccountName, 
             BillingYearYYYY, 
             BillingMonthMMM
             ORDER BY [Project Name], 
                      [Account-Location Status];
    END;
GO
