USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_BACKLOG_MONTH]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[PBB_DB_BACKLOG_MONTH](
			@ReportDate DATE)
RETURNS @backlogmonth TABLE(
					   [Install Date]           DATE
					  ,[Account Group Code]          nvarchar(256)
					  ,[Account Group]          nvarchar(256)
					  ,[Group]                  nvarchar(400)
					  ,[Account Market]         nvarchar(4000)
					  ,[Market Summary]         nvarchar(4000)
					  ,[Reporting Market]       nvarchar(4000)
					  ,AccountClass			    nvarchar(4000)
					  ,AccountType			    nvarchar(4000)
					  ,[Account Number]         NVARCHAR(20)
					  ,[Account Name]           NVARCHAR(250)
					  ,[Street Address]         NVARCHAR(4000)
					  ,[City]                   NVARCHAR(4000)
					  ,[State]                  NVARCHAR(4000)
					  ,[Zip Code]               NVARCHAR(4000)
					  ,[SO Number]              NVARCHAR(100)
					  ,[Order Name]             NVARCHAR(300)
					  ,[Order Type]             NVARCHAR(4000)
					  ,[Order Status]           NVARCHAR(256)
					  ,pbb_SFLAppointmentStatus NVARCHAR(100)
					  ,pbb_SFLAppointmentURL    NVARCHAR(4000)
					  ,ActivityId               NVARCHAR(400)
					  ,[Project Name]			nvarchar(400)
					  ,Cabinet					nvarchar(400)
					  )
AS
	BEGIN
	    INSERT INTO @backlogmonth
			 SELECT DISTINCT 
				   CONVERT(VARCHAR(20),PBB_FactAppointment.ScheduledStart_DimDateId,101) AS [Install Date]
				  ,ac.AccountGroupCode AS [Account Group Code]
				  ,ac.AccountGroup as [Account Group]
				  ,SUBSTRING(ac.AccountGroup,1,3) AS [Group]
				  ,(SUBSTRING(DimAccountCategory_pbb.pbb_AccountMarket,4,255)) [Account Market]
				  ,DimAccountCategory_pbb.pbb_MarketSummary MarketSummary
				  ,pbb_ReportingMarket ReportingMarket
				  ,ac.AccountClass
				  ,ac.AccountType
				  ,a.AccountCode AS [Account Number]
				  ,a.AccountName AS [Account Name]
				  ,a.BillingAddressStreetLine1 AS [Street Address]
				  ,a.BillingAddressCity AS [City]
				  ,a.BillingAddressState AS [State]
				  ,a.BillingAddressPostalCode AS [Zip Code]
				  ,sa.SalesOrderNumber AS [SO Number]
				  ,sa.SalesOrderName AS [Order Name]
				  ,sa.SalesOrderType AS [Order Type]
				  ,sa.SalesOrderFulfillmentStatus AS [Order Status]
				  ,pbb_SFLAppointmentStatus
				  ,pbb_SFLAppointmentURL
				  ,PBB_FactAppointment.ActivityId
				  ,[Project Name]
				  ,Cabinet
			 FROM PBB_FactAppointment
				 JOIN DimAppointment_pbb ON PBB_FactAppointment.ActivityId = DimAppointment_pbb.ActivityId
				 JOIN DimAppointmentView_pbb ON PBB_FactAppointment.ActivityId = DimAppointmentView_pbb.ActivityId
				LEFT JOIN (select distinct Dimservicelocationid, [Project Name], Cabinet from dimaddressdetails_pbb) AD on DimAppointmentView_pbb.DimServiceLocationId = ad.DimServiceLocationId
				LEFT JOIN DimAccount a ON a.DimAccountId = PBB_FactAppointment.DimAccountId
				 JOIN DimAccount_pbb ON a.AccountId = DimAccount_pbb.AccountId
				 LEFT JOIN DimAccountCategory ac ON ac.DimAccountCategoryId = PBB_FactAppointment.DimAccountCategoryId
				 LEFT JOIN DimAccountCategory_pbb ON DimAccountCategory_pbb.SourceId = ac.SourceId
				 LEFT JOIN DimSalesOrder sa ON sa.DimSalesOrderId = PBB_FactAppointment.DimSalesOrderId
			 WHERE DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
				  AND DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%Courtesy%'
				  AND DimAppointmentView_pbb.pbb_OrderActivityType = 'Install'
				  AND OrderWorkflowName <> 'Billing Correction'
				 And (Year(PBB_FactAppointment.Scheduledstart_DimdateId) = Year(@ReportDate)
			 And Month(PBB_FactAppointment.Scheduledstart_DimdateId) = Month(@ReportDate))
		 And cast(PBB_FactAppointment.Scheduledstart_DimdateId as date) >= @ReportDate
			  And (cast(PBB_FactAppointment.ActualEnd_DimDateId as date) >= @ReportDate
					  OR PBB_FactAppointment.ActualEnd_DimDateId = '1900-01-01')
			 ORDER BY ac.AccountGroupCode
				    ,CONVERT(VARCHAR(20),PBB_FactAppointment.ScheduledStart_DimDateId,101);
	    RETURN;
	END;

	
GO
