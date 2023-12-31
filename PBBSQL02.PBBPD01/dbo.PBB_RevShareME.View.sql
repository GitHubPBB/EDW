USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_RevShareME]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_RevShareME] as

SELECT DISTINCT 
       upper(sld.pbb_locationprojectcode) [Project Name], 
       ac.AccountGroup [Account Group], 
       br.BillingYearYYYY BillingYear, 
       br.BillingMonthMMM BillingMonth, 
       a.Accountcode AccountCode, 
       a.AccountName [Account Name], 
       ServiceLocationFullAddress [Full Address], 
       ServiceLocationCity City, 
       ServiceLocationState State, 
       ServiceLocationPostalCode Zip, 
       sld.pbb_DefaultNetworkDelivery [Network Delivery], 
       sld.pbb_LocationIsServiceable [Location Is Serviceable], 
       c.BilledChargeFractionalization [Charge Type], 
       CatalogPriceIsRecurring [Price Is Recurring],
       sum(CASE
           WHEN gl.RevenueGLAccountNumber NOT IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                AND cai.ComponentName <> 'Business Service Discount'
           THEN BilledChargeAmount
           ELSE 0
       END) AS 'ChargeAmount',
       sum(CASE
           WHEN gl.RevenueGLAccountNumber IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                OR cai.ComponentName = 'Business Service Discount'
           THEN BilledChargeAmount
           ELSE 0
       END) AS 'PromotionAmount', 
       sum(f.BilledChargeDiscountAmount) AS DiscountAmount, 
       sum(f.BilledChargeNetAmount) AS Net
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
WHERE br.BillingYearYYYY = '2021'
      AND pbb_locationprojectcode <> ''
	  and pbb_locationprojectcode  not like '%DUPLICATE - DO NOT USE'
GROUP BY sld.pbb_locationprojectcode, 
       ac.AccountGroup, 
       br.BillingYearYYYY, 
       br.BillingMonthMMM, 
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

union

SELECT DISTINCT 
       upper(sld.pbb_locationprojectcode), 
       ac.AccountGroup, 
       br.BillingYearYYYY, 
       br.BillingMonthMMM, 
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
       sum(CASE
           WHEN gl.RevenueGLAccountNumber NOT IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                AND cai.ComponentName <> 'Business Service Discount'
           THEN BilledChargeAmount
           ELSE 0
       END) AS 'ChargeAmount',
       sum(CASE
           WHEN gl.RevenueGLAccountNumber IN(N'DU_401615', N'SW_401615', N'BL_401615', N'FO_401615', N'CP_401615')
                OR cai.ComponentName = 'Business Service Discount'
           THEN BilledChargeAmount
           ELSE 0
       END) AS 'PromotionAmount', 
       sum(f.BilledChargeDiscountAmount) AS DiscountAmount, 
       sum(f.BilledChargeNetAmount) AS Net
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
WHERE pbb_locationprojectcode <> ''
and pbb_locationprojectcode  not like '%DUPLICATE - DO NOT USE'
GROUP BY sld.pbb_locationprojectcode, 
       ac.AccountGroup, 
       br.BillingYearYYYY, 
       br.BillingMonthMMM, 
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
GO
