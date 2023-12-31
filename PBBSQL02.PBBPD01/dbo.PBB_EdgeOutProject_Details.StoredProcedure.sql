USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_EdgeOutProject_Details]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PBB_EdgeOutProject_Details]
@BillingYYYY int = '2021',
@BillingMM int = '05'
AS
    BEGIN

	WITH CHG as
(SELECT DISTINCT 
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
WHERE pbb_locationprojectcode <> ''
and BilledChargeFractionalization = 'Full'
and br.BillingYearYYYY = @BillingYYYY
and br.BillingMonthMMM = @BillingMM
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
union
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
and BilledChargeFractionalization = 'Full'
and br.BillingYearYYYY = @BillingYYYY
and br.BillingMonthMMM = @BillingMM
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


        --Details
        SELECT --[Location Zone], 
                         [Project Name], 
                         [Wirecenter Region],
                         CASE
                             WHEN [Wirecenter Region] LIKE '%Competitive%'
                             THEN 'Competitive'
                             ELSE 'Non-Competitive'
                         END AS MarketType, 
                         FundType, 
                         FundTypeID, 
                         [Omnia SrvItemLocationID], 
                         [Full Address], 
                         format(CreatedOn,'MM-dd-yyyy') CreatedOn, 
                         replace(ServiceLocationCreatedBy,'PBBO360\','') ServiceLocationCreatedBy, 
                         case when LocationIsServicable = '' then 'No' else LocationIsServicable end as Serviceability, 
                         case when format(cast([Serviceable Date] as date),'MM-dd-yyyy') = '01-01-1900' then '' else format(cast([Serviceable Date] as date),'MM-dd-yyyy')
						 end as [Serviceable Date], 
                         ISNULL([Account-Location Status], 'None') AccountLocationStatus, 
                         case when format(cast(MIN([Account-Service Activation Date]) as date),'MM-dd-yyyy') = '01-01-1900' then '' else format(cast(MIN([Account-Service Activation Date]) as date),'MM-dd-yyyy')
						 end as [Account-Service Activation Date], 
                         case when format(cast([Account-Service Deactivation Date] as date),'MM-dd-yyyy') = '01-01-2050' then '' else format(cast([Account-Service Deactivation Date] as date),'MM-dd-yyyy')
						 end as [Account-Service Deactivation Date], 
                         ad.AccountCode, 
                         ad.AccountName, 
                         AccountEMailAddress, 
                         AccountPhoneNumber, 
                         BillingAddressPhone, 
                         sum(chg.ChargeAmount) ChargeAmount,
						 sum(chg.PromotionAmount) PromotionAmount,
						 sum(chg.DiscountAmount) DiscountAmount,
						 sum(chg.Net) Net
        FROM DimAddressDetails_pbb ad
		LEFT JOIN CHG on ad.accountcode = chg.accountcode and ad.[Omnia SrvItemLocationID] = chg.LocationID
		where [Project Name] <> ''
        GROUP BY --[Location Zone], 
                 FundType, 
                 FundTypeID, 
                 [Wirecenter Region], 
                 [Project Name], 
                 [Omnia SrvItemLocationID], 
                 [Full Address], 
                 CreatedOn, 
                 ServiceLocationCreatedBy, 
                 LocationIsServicable, 
                 [Serviceable Date], 
                 [Account-Location Status], 
                 [Account-Service Deactivation Date], 
                 ad.AccountCode, 
                 ad.AccountName, 
                 AccountEMailAddress, 
                 AccountPhoneNumber, 
                 BillingAddressPhone
		order by [Project Name], [Account-Location Status];
    END;
GO
