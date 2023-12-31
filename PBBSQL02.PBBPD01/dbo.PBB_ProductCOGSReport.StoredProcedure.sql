USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ProductCOGSReport]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PBB_ProductCOGSReport]
AS
BEGIN
WITH ProductCosts
AS (
	SELECT	FCI.DimCatalogItemId,
			FCI.DimAccountId,
			FCI.Activation_DimDateId,
			SUM(FCI.ItemPrice)  AS ProductCost
	FROM	[OMNIA_EPBB_P_PBB_DW].[dbo].[FactCustomerItem] FCI
			INNER JOIN DimCustomerItem DCI 
					ON FCI.DimCustomerItemId = DCI.DimCustomerItemId
			INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] DAC
					ON FCI.DimAccountCategoryId = DAC.DimAccountCategoryId
	WHERE	FCI.Activation_DimDateId <= GETDATE()
	  AND	FCI.Deactivation_DimDateId > GETDATE()
	  AND	FCI.EffectiveStartDate <= GETDATE()
	  AND	FCI.EffectiveEndDate > GETDATE()
	  AND	ISNULL(DCI.ItemDeactivationDate,'12-31-2050') > GETDATE()
	  AND	FCI.DimAccountId <> 0
	  AND	FCI.ItemPrice <> 0 --Pending filter by MRR
	  AND	DAC.AccountGroupCode IN ('NGABUS', 'NGARES')
	GROUP BY FCI.DimCatalogItemId,
			 FCI.DimAccountId,
			 FCI.Activation_DimDateId
)

SELECT	PCD.ProductCode,
		PCD.ServiceCode,
		PCD.AccountName,
		PCD.AccountCode,
		PCD.AccountTerm,
		SUM(PCD.DefaultCost) AS DefaultCost,
		SUM(PCD.DefaultPrice) AS DefaultPrice,
		SUM(PCD.CustomerPrice) AS CustomerPrice,
		MAX(PCD.ProductStartDate) AS ProductStartDate,
		COUNT(PCD.AccountName) AS GroupCount
FROM	(
		SELECT	CASE WHEN DCAI.ItemIsService = 'Is Not a Service' THEN DCAI.ComponentCode -- or PrdComponentMap.Component?
						ELSE ''
				END AS ProductCode,
				CASE WHEN DCAI.ItemIsService = 'Is Service' THEN DCAI.ComponentCode -- or PrdComponentMap.Component?
						ELSE ''
				END AS ServiceCode,
				DA.AccountName,
				DA.AccountCode,
				DCT.ContractTermName AS AccountTerm, --Validation pending
				--PC.ProductCost, 
				PPP.DefaultCost AS DefaultCost,
				PPP.DefaultPrice AS DefaultPrice,
				PC.ProductCost AS CustomerPrice,
				PC.Activation_DimDateId AS ProductStartDate
		FROM	ProductCosts PC
				INNER JOIN DimCatalogItem DCAI
						ON PC.DimCatalogItemId = DCAI.DimCatalogItemId
					LEFT JOIN PrdComponentMap PCM
						ON DCAI.ComponentCode = PCM.ComponentCode
				INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount DA 
						ON PC.DimAccountId = DA.DimAccountId
				INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].DimAccount_pbb DAPBB
						ON DA.AccountId = DAPBB.AccountId
				LEFT JOIN [dbo].[PBB_ProductPrice] PPP
						ON  DCAI.ProductComponentID = PPP.ProductComponentID
						AND PCM.ComponentID = PPP.ComponentId
						AND DA.AccountCode = PPP.AccountCode
					LEFT JOIN FactContractTerm FCT
						ON PC.DimAccountId = FCT.DimAccountId
					LEFT JOIN DimContractTerm DCT
						ON FCT.DimContractTermId = DCT.DimContractTermId
		) AS PCD
GROUP BY PCD.ProductCode, PCD.ServiceCode, PCD.AccountName, PCD.AccountCode, PCD.AccountTerm
ORDER BY PCD.ProductCode, PCD.ServiceCode, PCD.AccountName, PCD.AccountCode, PCD.AccountTerm

END
GO
