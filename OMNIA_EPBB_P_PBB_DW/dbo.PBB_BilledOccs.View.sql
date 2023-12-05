USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_BilledOccs]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PBB_BilledOccs]
AS
	SELECT br.BillingYearMonth
		 ,br.BillingCycleID
		 ,l.LocationId
		 ,ItemCode = o.OCCCode
		 ,o.OCCName AS [Description]
		 ,OCCBilledQuantity
		 ,gl.RevenueGLAccountNumber
		 ,gl.RevenueGLSubAccountNumber
	FROM FactBilledOCC f
		JOIN DimBillingRun br on f.DimBillingRunId = br.DimBillingRunId
		JOIN DimAccountCategory ac on f.DimAccountCategoryId = ac.DimAccountCategoryId
		JOIN DimCustomerItem i on f.DimCustomerItemId = i.DimCustomerItemId
		JOIN DimCatalogOCC o on f.DimCatalogOCCId = o.DimCatalogOCCId
		JOIN DimCustomerProduct p on f.DimCustomerProductId = p.DimCustomerProductId
		JOIN DimAccount a on f.DimAccountId = a.DimAccountId
		JOIN DimGLMap gl on f.DimGLMapId = gl.DimGLMapId
		JOIN DimServiceLocation l on f.DimServiceLocationId = l.DimServiceLocationId
		JOIN DimAgent ag on f.DimAgentId = ag.DimAgentId
GO
