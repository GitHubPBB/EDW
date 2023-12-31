USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_BilledCharges]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PBB_BilledCharges]
AS
	SELECT br.BillingRunID
		 ,br.BillingCycleID
		 ,ac.AccountGroupCode
		 ,ac.AccountSegment
		 ,a.AccountCode
		 ,a.AccountName
		 ,a.AccountStatusCode
		 ,sl.ServiceLocationFullAddress
		 ,f.BilledChargeAmount
		 ,f.BilledChargeDiscountAmount
		 ,f.BilledChargeNetAmount
		 ,f.ChargeBeginDate_DimDateId
		 ,f.ChargeEndDate_DimDateId
		 ,bc.BilledChargeFractionalization
		 ,gl.RevenueGLAccount
		 ,gl.RevenueGLAccountNumber
		 ,cp.CatalogPriceIsRecurring
		 ,ci.ComponentName
		 ,cp.CatalogPriceBillingMethod
		 ,cp.CatalogPriceBillingFrequency
	FROM FactBilledCharge f
		JOIN DimBillingRun br ON f.DimBillingRunId = br.DimBillingRunId
		JOIN DimAccount a ON f.DimAccountId = a.DimAccountId
		JOIN DimAccountCategory ac ON f.DimAccountCategoryId = ac.DimAccountCategoryId
		JOIN DimServiceLocation sl ON f.DimServiceLocationId = sl.DimServiceLocationId
		JOIN DimBilledCharge bc ON f.DimBilledChargeId = bc.DimBilledChargeId
		JOIN DimGLMap gl on f.DimGLMapId = gl.DimGLMapId
		JOIN DimCatalogPrice cp ON f.DimCatalogPriceId = cp.DimCatalogPriceId
		JOIN DimCatalogItem ci ON f.DimCatalogItemId = ci.DimCatalogItemId
	WHERE br.BillingYearMonth = 202102
--AND bc.BilledChargeFractionalization = 'full'
--AND ChargeEndDate_DimDateId = dateadd(day,-1,dateadd(year,1,ChargeBeginDate_DimDateId)) --find annual charges
GO
