USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetSalesOrderPromotions]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_GetSalesOrderPromotions] (@DimSalesOrderId INT,
											 @SalesOrderLineItemActivity VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @PromotionList AS VARCHAR(MAX)
	SET	@PromotionList = ''

	SELECT	@PromotionList = @PromotionList + '; ' + DCI.ComponentName
	FROM	FactSalesOrderLineItem FSOL
			INNER JOIN DimSalesOrder DSO
					ON FSOL.DimSalesOrderId = DSO.DimSalesOrderId
			INNER JOIN DimSalesOrderLineItem  DSOL
					ON FSOL.DimSalesOrderLineItemId = DSOL.DimSalesOrderLineItemId
			INNER JOIN DimCatalogItem DCI
					ON FSOL.DimCatalogItemId = DCI.DimCatalogItemId
			 LEFT JOIN PrdComponentMap PCM
					ON DCI.ComponentCode = PCM.ComponentCode
	WHERE	PCM.IsPromo = 1
	  AND	DCI.ItemIsService = 'Is not a Service'
	  AND	DSO.DimSalesOrderId = @DimSalesOrderId
	  AND	DSOL.SalesOrderLineItemActivity = @SalesOrderLineItemActivity

	SET @PromotionList = STUFF(@PromotionList, 1, 2, '')

	RETURN ISNULL(@PromotionList, '')
END
GO
