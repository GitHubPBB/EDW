USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_BilledUsage]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PBB_BilledUsage]
AS
	SELECT br.BillingYearMonth
		 ,br.BillingCycleID
		 ,a.AccountCode
		 ,ac.AccountGroupCode
		 ,l.LocationId
		 ,f.BillableAmount
	FROM FactBilledUsage f
		JOIN DimBillingRun br on f.DimBillingRunId = br.DimBillingRunId
		JOIN DimAccountCategory ac on f.DimAccountCategoryId = ac.DimAccountCategoryId
		JOIN DimBilledUsage u on f.DimBilledUsageId = u.DimBilledUsageId
		JOIN DimCustomerProduct p on f.DimCustomerProductId = p.DimCustomerProductId
		JOIN DimAccount a on f.DimAccountId = a.DimAccountId
		JOIN DimGLMap gl on f.DimGLMapId = gl.DimGLMapId
		JOIN DimServiceLocation l on f.DimServiceLocationId = l.DimServiceLocationId
	where f.BillableAmount <> 0
GO
