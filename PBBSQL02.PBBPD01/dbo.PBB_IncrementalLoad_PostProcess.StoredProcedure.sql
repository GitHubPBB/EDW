USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_IncrementalLoad_PostProcess]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_IncrementalLoad_PostProcess]
AS
    BEGIN

	   declare @started datetime
			,@ended   datetime

	   SET NOCOUNT ON;

	   set @started = getdate()

	   --creating tables for account location status/ranking
	exec [dbo].[PBB_Populate_PBB_ServiceLocationItem];
	exec [dbo].[PBB_Populate_PBB_ServiceLocationAccountALL];

		   -- Update PrjServiceability
	   TRUNCATE TABLE PrjServiceability;
	   INSERT INTO PrjServiceability
			SELECT chr_name
				 ,cus_serviceableDate
			FROM pbbsql01.pbb_p_mscrm.[dbo].[chr_workorderBase]
			WHERE chr_name LIKE '%Projec%';

	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'Update PrjServiceability'
		  ,@started
		  ,@ended

	   set @started = getdate()

	   --Fix issues with serviceability on cable, phone, data

	   UPDATE dsl
		SET 
		    pbb_data = CASE
					    WHEN cus_data IS NULL
					    THEN ''
					    WHEN cus_data = 972050000
					    THEN 'Yes'
					    WHEN cus_data = 972050001
					    THEN 'No'
					END
	   FROM DimServiceLocation_pbb dsl
		   JOIN DimAddressDetails_pbb ad ON dsl.LocationId = ad.[Omnia SrvItemLocationID]
		   JOIN pbbsql01.pbb_p_mscrm.dbo.chr_servicelocation sl ON dsl.locationid = sl.chr_masterlocationid
	   WHERE pbb_data <> CASE
						WHEN cus_data IS NULL
						THEN ''
						WHEN cus_data = 972050000
						THEN 'Yes'
						WHEN cus_data = 972050001
						THEN 'No'
					 END;
	   UPDATE dsl
		SET 
		    pbb_CATV = CASE
					    WHEN cus_CATV IS NULL
					    THEN ''
					    WHEN cus_CATV = 972050000
					    THEN 'Yes'
					    WHEN cus_CATV = 972050001
					    THEN 'No'
					END
	   FROM DimServiceLocation_pbb dsl
		   JOIN DimAddressDetails_pbb ad ON dsl.LocationId = ad.[Omnia SrvItemLocationID]
		   JOIN pbbsql01.pbb_p_mscrm.dbo.chr_servicelocation sl ON dsl.locationid = sl.chr_masterlocationid
	   WHERE pbb_CATV <> CASE
						WHEN cus_CATV IS NULL
						THEN ''
						WHEN cus_CATV = 972050000
						THEN 'Yes'
						WHEN cus_CATV = 972050001
						THEN 'No'
					 END;
	   UPDATE dsl
		SET 
		    pbb_CATVDigital = CASE
							 WHEN cus_CATVDigital IS NULL
							 THEN ''
							 WHEN cus_CATVDigital = 972050000
							 THEN 'Yes'
							 WHEN cus_CATVDigital = 972050001
							 THEN 'No'
						  END
	   FROM DimServiceLocation_pbb dsl
		   JOIN DimAddressDetails_pbb ad ON dsl.LocationId = ad.[Omnia SrvItemLocationID]
		   JOIN pbbsql01.pbb_p_mscrm.dbo.chr_servicelocation sl ON dsl.locationid = sl.chr_masterlocationid
	   WHERE pbb_CATVDigital <> CASE
							  WHEN cus_CATVDigital IS NULL
							  THEN ''
							  WHEN cus_CATVDigital = 972050000
							  THEN 'Yes'
							  WHEN cus_CATVDigital = 972050001
							  THEN 'No'
						   END;
	   UPDATE dsl
		SET 
		    pbb_Phone = CASE
						WHEN cus_phone IS NULL
						THEN ''
						WHEN cus_phone = 972050000
						THEN 'Yes'
						WHEN cus_phone = 972050001
						THEN 'No'
					 END
	   FROM DimServiceLocation_pbb dsl
		   JOIN DimAddressDetails_pbb ad ON dsl.LocationId = ad.[Omnia SrvItemLocationID]
		   JOIN pbbsql01.pbb_p_mscrm.dbo.chr_servicelocation sl ON dsl.locationid = sl.chr_masterlocationid
	   WHERE pbb_Phone <> CASE
						 WHEN cus_phone IS NULL
						 THEN ''
						 WHEN cus_phone = 972050000
						 THEN 'Yes'
						 WHEN cus_phone = 972050001
						 THEN 'No'
					  END;

	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'Fix issues with serviceability on cable, phone, data'
		  ,@started
		  ,@ended

	   set @started = getdate()

	   --sync project name to workorder name

	   update dsl
		set 
		    pbb_locationprojectcode = wo.chr_name
	   from DimServiceLocation_pbb dsl
		   join DimAddressDetails_pbb ad on dsl.LocationId = ad.[Omnia SrvItemLocationID]
		   join pbbsql01.pbb_p_mscrm.dbo.chr_servicelocation sl on dsl.locationid = sl.chr_masterlocationid
		   join pbbsql01.pbb_p_mscrm.dbo.chr_workorder wo on sl.cus_project = wo.chr_workorderid
	   where wo.chr_name COLLATE SQL_Latin1_General_CP1_CI_AI <> pbb_locationProjectCode COLLATE SQL_Latin1_General_CP1_CI_AI;

	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'sync project name to workorder name'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_DimAppointmentView_pbb];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimAppointmentView_pbb]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_ProductAnalysisDetails]
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_ProductAnalysisDetails]'
		  ,@started
		  ,@ended

--8/25/22 Removing logic for table population, moved to [PBB_Populate_PBB_ServiceLocationAccountALL]
--	   set @started = getdate()
--	   EXEC [dbo].[PBB_Populate_FactServiceLocationAccount_pbb];
--	   set @ended = getdate()
--	   exec dbo.PBB_AddBenchmark 
--		   '[dbo].[PBB_Populate_FactServiceLocationAccount_pbb]'
--		  ,@started
--		  ,@ended

	   --set @started = getdate()
	   --EXEC [dbo].[PBB_Populate_DimAppointmentView_pbb];
	   --set @ended = getdate()
	   --exec dbo.PBB_AddBenchmark 
		  -- '[dbo].[PBB_Populate_DimAppointmentView_pbb]'
		  --,@started
		  --,@ended

--8/25/22 Removing logic for table population, moved to [PBB_Populate_PBB_ServiceLocationAccountALL]
--	   set @started = getdate()
--	   EXEC [dbo].[PBB_Populate_DimServiceLocationAccount_pbb];
--	   set @ended = getdate()
--	   exec dbo.PBB_AddBenchmark 
--		   '[dbo].[PBB_Populate_DimServiceLocationAccount_pbb]'
--		  ,@started
--		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_DimSalesOrderView_pbb];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimSalesOrderView_pbb]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_FactCustomerItemHierarchy_pbb]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [OMNIA_ELEG_P_LEG_DW].[dbo].[PBB_Update_FactBilledAccountSummary];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Update_FactBilledAccountSummary]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_DimAddressDetails_pbb];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimAddressDetails_pbb]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_DimPromoStatus_pbb];
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimPromoStatus_pbb]'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   declare @effectivedate date= Convert(date,GetDate())
	   EXEC [dbo].[PBB_Populate_FactCustomerBundleType_pbb] 
		   @effectivedate;
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_FactCustomerBundleType_pbb]'
		  ,@started
		  ,@ended

	   --Fix space at end of project name
	   set @started = getdate()
	   update dimaddressdetails_pbb
		set 
		    [Project Name] = ltrim(rtrim([project name]));
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'Fix space at end of project name'
		  ,@started
		  ,@ended

	   set @started = getdate()
	   declare @AsOfDimDateId date= convert(date,getdate());
	   EXEC [dbo].[PBB_Populate_DimServiceLocationBundleType_pbb] 
		   @AsOfDimDateID;
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimServiceLocationBundleType_pbb]'
		  ,@started
		  ,@ended
		  
	   set @started = getdate()
	   EXEC [dbo].[PBB_Populate_DimCatalogItem_pbb]
	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   '[dbo].[PBB_Populate_DimCatalogItem_pbb]'
		  ,@started
		  ,@ended

	   -- BEGIN MOD to fix disconnect reasons in DW

	   set @started = getdate()

	   UPDATE so1
		SET 
		    [SalesOrderDisconnectReason] = d.[value]
	   FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[DimSalesOrder] so1
		   INNER JOIN
		   (
			  SELECT oc.id
				   ,so.salesorderid
				   ,sm.value
				   ,oc.disconnectreason
				   ,sm.attributevalue
			  FROM [pbbsql01].[OMNIA_EPBB_P_PBB_CM].dbo.OCOrderCapture oc
				  JOIN [pbbsql01].PBB_P_MSCRM.dbo.salesorderbase so ON oc.salesorderid = so.salesorderid
				  JOIN [pbbsql01].PBB_P_MSCRM.dbo.stringmapbase sm ON oc.disconnectreason = sm.attributevalue
														    AND sm.attributename = 'chr_disconnectreasons'
														    AND sm.objecttypecode = 1088
		   ) d ON d.salesorderid = so1.SalesOrderId
	   WHERE so1.salesorderid LIKE '%-%-%-%-%';

	   -- END MOD 
	   -- BEGIN MOD to fix address serviceable date

	   UPDATE sl
		SET 
		    pbb_locationserviceabledate = CAST(a.modifydate AS DATE)
		   ,pbb_LocationMadeServiceableBy = a.username
	   --select distinct a.SrvLocation_LocationID as LocationID
	   --       ,a.Username
	   --       ,a.ModifyDate, sl.*
	   FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.ADDRESS_History a
		   JOIN DimServiceLocation_pbb sl ON a.srvlocation_locationid = sl.LocationId
		   INNER JOIN
		   (
			  -- find min ModifyDate by LocationID
			  SELECT SrvLocation_LocationID AS LocationID
				   ,MIN(ModifyDate) AS ModifyDate
			  FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.Address_History
			  WHERE Serviceable = 1
			  GROUP BY SrvLocation_LocationID
		   ) h ON h.ModifyDate = a.ModifyDate
				AND h.LocationID = a.SrvLocation_LocationID
	   WHERE a.Serviceable = 1 --and SrvLocation_LocationID = 3950552
		    AND pbb_LocationProjectCode <> 'Duplicate - Do not use'
		    AND pbb_LocationIsServiceable = 'Yes'
		    AND pbb_LocationServiceableDate = '';

	   -- END MOD
	   --Add Internal Discount back to disconnected customers so they dont count on dashboard
	   UPDATE disc
		SET 
		    pbb_AccountDiscountNames = (ISNULL(pbb_AccountDiscountNames,'') + 'INTERNAL USE ONLY - Zero Rate Test Acct')
	   FROM FactSalesOrderLineItem fso
		   JOIN DimSalesOrder dso ON fso.DimSalesOrderId = dso.DimSalesOrderId
		   JOIN DimSalesOrderLineItem li ON fso.DimSalesOrderLineItemId = li.DimSalesOrderLineItemId
		   JOIN dimaccount a ON fso.DimAccountId = a.DimAccountId
		   JOIN DimAccount_pbb disc ON disc.AccountId = a.AccountId
	   WHERE SalesOrderLineItemActivity = 'Disconnect'
		    AND SalesOrderLineItemName LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
		    AND pbb_AccountDiscountNames NOT LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
		    AND a.AccountStatusCode = 'I';

	   --Sync up PrdComponentMap UploadMB & DownloadMB with reporting options
	   UPDATE cm
		SET 
		    UploadMB = UploadRate
		   ,DownloadMB = DownloadRate
	   --select cm.componentcode, UploadMB, UploadRate, DownloadMB, DownloadRate 
	   FROM PrdComponentMap cm
		   JOIN [dbo].[DimCatalogItem] ci ON cm.ComponentCode = ci.ComponentCode
	   WHERE(UploadMB <> UploadRate
		    AND uploadrate <> '')
		   OR (DownloadMB <> DownloadRate
			  AND downloadrate <> '');

	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'fix address serviceable date'
		  ,@started
		  ,@ended

	   set @started = getdate()

	   exec [dbo].[PBB_Populate_PBB_SalseOrder_Classification]

	   -- RE-Create indexes dropped in pre-process

	   select Getdate() as [Post-Process Completed At],'Results' as [tabname]

	   return 

	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactCustomerItem_EffectiveStartDate_EffectiveEndDate'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactCustomerItem_EffectiveStartDate_EffectiveEndDate] ON [dbo].[FactCustomerItem]([EffectiveStartDate] ASC,[EffectiveEndDate] ASC
																										 ) 
				   WITH(PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,SORT_IN_TEMPDB = OFF,DROP_EXISTING = OFF,ONLINE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_DimSalesOrder_SalesOrderType'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_DimSalesOrder_SalesOrderType] ON [dbo].[DimSalesOrder]([SalesOrderType] ASC
																				    ) 
				   WITH(PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,SORT_IN_TEMPDB = OFF,DROP_EXISTING = OFF,ONLINE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_DimComment_CommentCode'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_DimComment_CommentCode] ON [dbo].[DimComment]([CommentCode] ASC
																			) 
				   WITH(PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,SORT_IN_TEMPDB = OFF,DROP_EXISTING = OFF,ONLINE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactCustomerItem_ItemID_ItemQuantity_ItemPrice'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactCustomerItem_ItemID_ItemQuantity_ItemPrice] ON [dbo].[FactCustomerItem]([ItemID] ASC,[ItemQuantity] ASC,[ItemPrice] ASC
																									) 
				   WITH(PAD_INDEX = OFF,STATISTICS_NORECOMPUTE = OFF,SORT_IN_TEMPDB = OFF,DROP_EXISTING = OFF,ONLINE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_DimCatalogPriceId'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_DimCatalogPriceId] ON [dbo].[FactBilledCharge]([DimCatalogPriceId]
																						   ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[BilledChargeNetAmount]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_DimBilledChargeId'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_DimBilledChargeId] ON [dbo].[FactBilledCharge]([DimBilledChargeId]
																						   ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[DimCatalogPriceId],[BilledChargeNetAmount]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_DimBilledChargeId'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_DimBilledChargeId] ON [dbo].[FactBilledCharge]([DimBilledChargeId]
																						   ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[DimCatalogPriceId],[BilledChargeNetAmount]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_BilledChargeNetAmount'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_BilledChargeNetAmount] ON [dbo].[FactBilledCharge]([BilledChargeNetAmount]
																							  ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[DimCatalogPriceId],[DimBilledChargeId]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_DimCatalogPrice_CatalogPriceBillingMethod'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_DimCatalogPrice_CatalogPriceBillingMethod] ON [dbo].[DimCatalogPrice]([CatalogPriceBillingMethod]
																							    ) 
				   WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_DimCatalogItem_ComponentName'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_DimCatalogItem_ComponentName] ON [dbo].[DimCatalogItem]([ComponentName]
																					) 
				   WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_BilledChargeAmount'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_BilledChargeAmount] ON [dbo].[FactBilledCharge]([BilledChargeAmount]
																						    ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[DimCustomerItemId],[DimCustomerPriceId],[DimGLMapId],[DimCatalogItemId],[DimCatalogPriceId],[EndDate_DimDateId],[ChargeBeginDate_DimDateId],[DimBilledChargeId]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactBilledCharge_BilledChargeDiscountAmount'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactBilledCharge_BilledChargeDiscountAmount] ON [dbo].[FactBilledCharge]([BilledChargeDiscountAmount]
																								  ) 
				   INCLUDE([DimAccountId],[DimAccountCategoryId],[DimCustomerItemId],[DimCustomerPriceId],[DimGLMapId],[DimCatalogItemId],[DimCatalogPriceId],[EndDate_DimDateId],[ChargeBeginDate_DimDateId],[DimBilledChargeId]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_DimCustomerItem_ItemActivationDate_ItemDeactivationDate'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_DimCustomerItem_ItemActivationDate_ItemDeactivationDate] ON [dbo].[DimCustomerItem]([ItemActivationDate],[ItemDeactivationDate]
																										) 
				   WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;
	   IF NOT EXISTS
				  (
					 SELECT *
					 FROM sys.indexes
					 WHERE [name] = 'PBB_IX_FactCustomerItem_DimCatalogItemID'
				  )
		  BEGIN
			 CREATE NONCLUSTERED INDEX [PBB_IX_FactCustomerItem_DimCatalogItemID] ON [dbo].[FactCustomerItem]([DimCatalogItemId],[Deactivation_DimDateId],[EffectiveStartDate],[EffectiveEndDate]
																						  ) 
				   INCLUDE([DimAccountId],[DimServiceLocationId]) WITH(STATISTICS_NORECOMPUTE = OFF,FILLFACTOR = 90);
		  END;

	   set @ended = getdate()
	   exec dbo.PBB_AddBenchmark 
		   'Re-create Indexes'
		  ,@started
		  ,@ended
    END;
GO
