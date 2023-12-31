USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_SalesActivityReport]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_SalesActivityReport]
				@StartDate	DATETIME,
				@EndDate	DATETIME,
				@Data		VARCHAR(MAX),
				@Phone		VARCHAR(MAX),
				@Agents		VARCHAR(MAX),
				@Activities	VARCHAR(MAX)

AS
BEGIN

	DECLARE @SQL NVARCHAR(MAX)

	SET @SQL = '
WITH SalesOrderDetails
AS (
SELECT  FSO.DimSalesOrderId,
		DSO.SalesOrderId,
		DSO.SalesOrderNumber,
		DSO.SalesOrderType,
		FSOL.CreatedOn_DimDateId,
		FSOL.DimSalesOrderLineItemId, 
		FSOL.SalesOrderLineItemPrice,
		FSOL.DimCatalogPriceId,
		FSOL.Parent_DimCatalogItemId,
		DSOL.SalesOrderLineItemActivity,
		DSOL.SalesOrderLineItemAgents,
		DA.AccountCode,
		DAC.AccountTypeCode,
		DAP.pbb_AccountDiscountNames,
		DAP.pbb_AccountRecurringPaymentStartDate,
		DAP.pbb_AccountRecurringPaymentExpirationDate,
		DAC.AccountGroupCode,
		DACP.pbb_AccountMarket,
		DACP.pbb_ReportingMarket,
		DCI.ItemIsService,
		DCI.ComponentName,
		DCI.ComponentCode,
		PCM.SpeedTier,
		PCM.IsData,
		PCM.IsCable,
		PCM.IsPhone,
		PCM.IsSmartHome,
		PCM.IsSmartHomePod,
		PCM.IsPointGuard,
		PCM.IsPromo,
		DAG.AgentName
FROM	FactSalesOrder FSO
		INNER JOIN DimSalesOrder DSO
				ON FSO.DimSalesOrderId = DSO.DimSalesOrderId
		INNER JOIN FactSalesOrderLineItem FSOL
				ON	FSO.DimSalesOrderId = FSOL.DimSalesOrderId
		INNER JOIN DimSalesOrderLineItem DSOL
				ON FSOL.DimSalesOrderLineItemId = DSOL.DimSalesOrderLineItemId
		 LEFT JOIN FactSalesOrderItemAgent FSOA
				ON FSOA.DimSalesOrderLineItemId = FSOL.DimSalesOrderLineItemId
		INNER JOIN DimAccount DA
				ON FSO.DimAccountId = DA.DimAccountId
		INNER JOIN DimAccount_pbb DAP
				ON DA.AccountId = DAP.AccountId
		INNER JOIN DimAccountCategory DAC
				ON FSO.DimAccountCategoryId = DAC.DimAccountCategoryId
		INNER JOIN DimAccountCategory_pbb DACP
				ON DAC.SourceId = DACP.SourceId
		LEFT JOIN DimAgent DAG
				ON FSOA.DimAgentId = DAG.DimAgentId
		INNER JOIN DimCatalogItem DCI
				ON FSOL.DimCatalogItemId = DCI.DimCatalogItemId
		 LEFT JOIN PrdComponentMap PCM
				ON DCI.ComponentCode = PCM.ComponentCode
WHERE	FSOL.DimSalesOrderId <> 0
  AND	DA.AccountCode <> ''''
  AND	DAC.AccountTypeCode = ''RES''
  AND	DSO.SalesOrderFulfillmentStatus <> ''Order Cancelled''
  AND	FSOL.CreatedOn_DimDateId >= ''' + CONVERT(VARCHAR, @StartDate, 23) + '''
  AND	FSOL.CreatedOn_DimDateId <= ''' + CONVERT(VARCHAR, @EndDate, 23) + '''
  AND	DAG.AgentName IN ('''+ @Agents + ''')
  ),
SalesOrderMainData
AS (
	SELECT	DISTINCT
			DimSalesOrderId,
			SalesOrderId,
			SalesOrderNumber,
			SalesOrderType,
			SalesOrderLineItemActivity,
			CreatedOn_DimDateId,
			AccountCode,
			AccountTypeCode,
			pbb_AccountDiscountNames,
			pbb_AccountRecurringPaymentStartDate,
			pbb_AccountRecurringPaymentExpirationDate,
			AccountGroupCode,
			pbb_AccountMarket,
			pbb_ReportingMarket,
			AgentName
	FROM	SalesOrderDetails
    WHERE	SalesOrderLineItemActivity IN ('''+ @Activities + ''')
),
SalesOrderServiceActivity
AS (
	SELECT	SOD.DimSalesOrderId,
			SOD.SalesOrderLineItemActivity,
			CASE WHEN MAX(SOD.IsData) > 0 THEN ''Yes'' ELSE ''No'' END AS [Data],
			CASE WHEN MAX(SOD.IsCable) > 0 THEN ''Yes'' ELSE ''No'' END AS Cable,
			CASE WHEN MAX(SOD.IsPhone) > 0 THEN ''Yes'' ELSE ''No'' END AS Phone
	FROM	SalesOrderDetails SOD
	WHERE   SOD.ItemIsService = ''Is Service''
	  AND	SOD.SalesOrderLineItemActivity IN ('''+ @Activities + ''')
	GROUP BY SOD.DimSalesOrderId, SOD.SalesOrderLineItemActivity
),
SalesOrderComponentActivity
AS (
	SELECT	SOD.DimSalesOrderId,
			SOD.SalesOrderLineItemActivity,
			CASE WHEN MAX(SOD.IsSmartHome) > 0 THEN ''Yes'' ELSE ''No'' END AS SmartHome,
			CASE WHEN MAX(SOD.IsSmartHomePod) > 0 THEN ''Yes'' ELSE ''No'' END AS SmartHomePod,
			CASE WHEN MAX(SOD.IsPointGuard) > 0 THEN ''Yes'' ELSE ''No'' END AS PointGuard,
			CASE WHEN MAX(SOD.IsPromo) > 0 THEN ''Yes'' ELSE ''No'' END AS Promo
	FROM	SalesOrderDetails SOD
	WHERE   SOD.ItemIsService = ''Is not a Service''
	  AND	SOD.SalesOrderLineItemActivity IN ('''+ @Activities + ''')
	GROUP BY SOD.DimSalesOrderId, SOD.SalesOrderLineItemActivity
),
SalesOrderDataSpeed 
AS (
	SELECT	DISTINCT SOD.DimSalesOrderId,
			SOD.SalesOrderLineItemActivity,
			SOD.ComponentName AS SpeedDescription,
			SOD.ComponentCode AS DataCode
	FROM	SalesOrderDetails SOD
	WHERE	SOD.IsData = 1
	  AND	SOD.SpeedTier <> ''0''
	  AND   SOD.ItemIsService = ''Is Not a Service''
	  AND	SOD.SalesOrderLineItemActivity IN ('''+ @Activities + ''')
),
SalesOrderInetRank
AS (
	SELECT	SOD.DimSalesOrderId,
			SOD.SalesOrderLineItemActivity,
			MAX(PIR.Rnk) as InternetRank
	FROM	SalesOrderDetails SOD
			 LEFT JOIN PrdInternetRank PIR
					ON SOD.SpeedTier = PIR.Category
	WHERE	SOD.SalesOrderLineItemActivity IN ('''+ @Activities + ''')
	GROUP BY SOD.DimSalesOrderId, SOD.SalesOrderLineItemActivity
   ),
SalesOrderInstallPrices 
AS (
	 SELECT	SOD.DimSalesOrderId,
			SOD.SalesOrderLineItemActivity,
			SUM(CASE WHEN DCP.CatalogPriceIsRecurring = ''Recurring''
					 THEN SOD.SalesOrderLineItemPrice 
				ELSE 0 
				END) AS OrderInstallRecurring
			,SUM(CASE WHEN DCP.CatalogPriceIsRecurring = ''Not Recurring''
					   AND SOD.IsPromo = 0
					  THEN SOD.SalesOrderLineItemPrice 
				 ELSE 0 
				 END) AS OrderInstallNonRecurring
			,SUM(CASE WHEN DCP.CatalogPriceIsRecurring = ''Recurring''
					   AND DSOLParent.SalesOrderLineItemActivity = ''Install''
					  THEN SOD.SalesOrderLineItemPrice 
				 ELSE 0 END) AS ServiceInstallRecurring
			,SUM(CASE WHEN DCP.CatalogPriceIsRecurring = ''Not Recurring''
					   AND DSOLParent.SalesOrderLineItemActivity = ''Install''
					   AND SOD.IsPromo = 0
					  THEN SOD.SalesOrderLineItemPrice 
				 ELSE 0 END) AS ServiceInstallNonRecurring
			,SUM(CASE WHEN DCP.CatalogPriceIsRecurring = ''Not Recurring''
					   AND DSOLParent.SalesOrderLineItemActivity = ''Install''
					   AND SOD.IsPromo = 1
					  THEN SOD.SalesOrderLineItemPrice 
				 ELSE 0 END) AS PromoNonRecurring
	FROM	SalesOrderDetails SOD
			INNER JOIN DimCatalogPrice DCP
					ON SOD.DimCatalogPriceId = DCP.DimCatalogPriceId
			INNER JOIN DimCatalogItem AS DCIParent 
					ON SOD.Parent_DimCatalogItemId = DCIParent.DimCatalogItemId
			INNER JOIN FactSalesOrderLineItem AS FSOLParent
					ON SOD.DimSalesOrderId = FSOLParent.DimSalesOrderId
				   AND SOD.Parent_DimCatalogItemId = FSOLParent.DimCatalogItemId
			INNER JOIN DimSalesOrderLineItem AS DSOLParent 
					ON FSOLParent.DimSalesOrderLineItemId = DSOLParent.DimSalesOrderLineItemId
	WHERE	DCP.CatalogPriceIsRecurring <> ''''
	  AND	SOD.SalesOrderLineItemActivity IN ('''+ @Activities + ''')
	GROUP BY SOD.DimSalesOrderId, SOD.SalesOrderLineItemActivity
	)

SELECT	SOMD.SalesOrderNumber,
		SOMD.SalesOrderType,
		SOMD.SalesOrderLineItemActivity,
		SOMD.CreatedOn_DimDateId AS LineItemCreatedOnDate,
		SOMD.AccountTypeCode,
		SOMD.AccountGroupCode,
		SOMD.pbb_ReportingMarket AS ReportingMarket,
		SOMD.AccountCode,
		SOMD.pbb_AccountDiscountNames AS AccountDiscounts,
		SUBSTRING(SOMD.pbb_AccountMarket, CHARINDEX(''-'',SOMD.pbb_AccountMarket) + 1, LEN(SOMD.pbb_AccountMarket)) AS AccountMarket,
		CASE WHEN (	SOMD.pbb_AccountRecurringPaymentStartDate <= GETDATE()
				AND SOMD.pbb_AccountRecurringPaymentExpirationDate >= GETDATE()) THEN ''Yes''
			ELSE  ''No'' END AS AutoPay,
		ISNULL(SOSA.Cable, ''No'') AS Cable,
		ISNULL(SOSA.[Data], ''No'') AS [Data],
		ISNULL(SOSA.Phone, ''No'') AS Phone,
		ISNULL(SOCA.SmartHome, ''No'') AS SmartHome,
		ISNULL(SOCA.SmartHomePod, ''No'') AS SmartHomePod,
		ISNULL(SOCA.PointGuard, ''No'') AS PointGuard,
		ISNULL(SOCA.Promo, ''No'') AS Promo,
		DSOP.pbb_SalesOrderReviewDate AS InstallDate,
		dbo.PBB_GetSalesOrderPromotions(SOMD.DimSalesOrderId, SOMD.SalesOrderLineItemActivity) AS PromoNames,
		ISNULL(SODS.DataCode, '''') AS DataCode,
		ISNULL(SODS.SpeedDescription, '''') AS SpeedDescription,
		ISNULL(SOMD.AgentName, '''') AS SalesOrderLineItemAgents,
		ISNULL(PIR.Category, '''') AS Category,
		ISNULL(SOIP.ServiceInstallNonRecurring, 0) AS ServiceInstallNonRecurring,
		ISNULL(SOIP.ServiceInstallRecurring, 0) AS ServiceInstallRecurring,
		ISNULL(SOIP.OrderInstallNonRecurring, 0) AS OrderInstallNonRecurring,
		ISNULL(SOIP.OrderInstallRecurring, 0) AS OrderInstallRecurring,
		ISNULL(SOIP.PromoNonRecurring, 0) AS PromoNonRecurring
FROM	SalesOrderMainData SOMD
		 LEFT JOIN DimSalesOrder_pbb DSOP
				ON SOMD.SalesOrderId = DSOP.SalesOrderId
			   AND DSOP.SalesOrderId <> ''0''
		 LEFT JOIN SalesOrderServiceActivity SOSA
				ON SOMD.DimSalesOrderId = SOSA.DimSalesOrderId
			   AND SOMD.SalesOrderLineItemActivity = SOSA.SalesOrderLineItemActivity
		 LEFT JOIN SalesOrderComponentActivity SOCA
				ON SOMD.DimSalesOrderId = SOCA.DimSalesOrderId
			   AND SOMD.SalesOrderLineItemActivity = SOCA.SalesOrderLineItemActivity
		 LEFT JOIN SalesOrderDataSpeed SODS
				ON SOMD.DimSalesOrderId = SODS.DimSalesOrderId
			   AND SOMD.SalesOrderLineItemActivity = SODS.SalesOrderLineItemActivity
		 LEFT JOIN SalesOrderInetRank SOIR
				ON SOMD.DimSalesOrderId = SOIR.DimSalesOrderId
			   AND SOMD.SalesOrderLineItemActivity = SOIR.SalesOrderLineItemActivity
		 LEFT JOIN PrdInternetRank PIR
				ON SOIR.InternetRank = PIR.Rnk
		 LEFT JOIN SalesOrderInstallPrices SOIP
				ON SOMD.DimSalesOrderId = SOIP.DimSalesOrderId
			   AND SOMD.SalesOrderLineItemActivity = SOIP.SalesOrderLineItemActivity
WHERE	ISNULL(SOSA.[Data], ''No'') IN ('''+ @Data + ''')
  AND	ISNULL(SOSA.Phone, ''No'') IN ('''+ @Phone + ''')
'

	--PRINT @SQL
	EXEC (@SQL)

END
GO
