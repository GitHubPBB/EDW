USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_BilledTax]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PBB_BilledTax]
AS
	SELECT br.BillingYearMonth
		 ,br.BillingCycleID
		 ,a.AccountCode
		 ,ac.AccountGroupCode
		 ,l.LocationId
		 ,f.BilledTaxAmount
	FROM FactBilledTax f
		JOIN DimBillingRun br on f.DimBillingRunId = br.DimBillingRunId
		JOIN DimAccountCategory ac on f.DimAccountCategoryId = ac.DimAccountCategoryId
		JOIN DimBilledTax u on f.DimBilledTaxId = u.DimBilledTaxId
		--JOIN DimCustomerProduct p on f.DimCustomerProductId = p.DimCustomerProductId
		JOIN DimAccount a on f.DimAccountId = a.DimAccountId
		--JOIN DimGLMap gl on f.DimGLMapId = gl.DimGLMapId
		JOIN DimServiceLocation l on f.DimServiceLocationId = l.DimServiceLocationId
GO
