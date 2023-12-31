USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_BACKLOG_TOTAL]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[PBB_DB_BACKLOG_TOTAL](
			@ReportDate date)
RETURNS @backlogtotal TABLE(
					   [Install Date]           Date
					  ,[Account Group Code]          nvarchar(256)
					  ,[Account Group]          nvarchar(256)
					  ,[Group]                  nvarchar(400)
					  ,[Account Market]         nvarchar(4000)
					  ,[Market Summary]         nvarchar(4000)
					  ,[Reporting Market]       nvarchar(4000)
					  ,AccountClass			    nvarchar(4000)
					  ,AccountType			    nvarchar(4000)
					  ,[Account Number]         nvarchar(20)
					  ,[Account Name]           nvarchar(250)
					  ,[Street Address]         nvarchar(4000)
					  ,[City]                   nvarchar(4000)
					  ,[State]                  nvarchar(4000)
					  ,[Zip Code]               nvarchar(4000)
					  ,[SO Number]              nvarchar(100)
					  ,[Order Name]             nvarchar(300)
					  ,[Order Type]             nvarchar(4000)
					  ,[Order Status]           nvarchar(256)
					  ,pbb_SFLAppointmentStatus nvarchar(100)
					  ,pbb_SFLAppointmentURL    nvarchar(4000)
					  ,ActivityId               nvarchar(400)
					  )
AS
	begin

	    insert into @backlogtotal
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
			 FROM PBB_FactAppointment
				 JOIN DimAppointment_pbb ON PBB_FactAppointment.ActivityId = DimAppointment_pbb.ActivityId
				 JOIN DimAppointmentView_pbb ON PBB_FactAppointment.ActivityId = DimAppointmentView_pbb.ActivityId
				 LEFT JOIN DimAccount a ON a.DimAccountId = PBB_FactAppointment.DimAccountId
				 JOIN DimAccount_pbb ON a.AccountId = DimAccount_pbb.AccountId
				 LEFT JOIN DimAccountCategory ac ON ac.DimAccountCategoryId = PBB_FactAppointment.DimAccountCategoryId
				 LEFT JOIN DimAccountCategory_pbb ON DimAccountCategory_pbb.SourceId = ac.SourceId
				 LEFT JOIN DimSalesOrder sa ON sa.DimSalesOrderId = PBB_FactAppointment.DimSalesOrderId
			 WHERE DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%INTERNAL USE ONLY - Zero Rate Test Acct%'
				  AND DimAccount_pbb.pbb_AccountDiscountNames NOT LIKE '%Courtesy%'
				  AND DimAppointmentView_pbb.pbb_OrderActivityType = 'Install'
				  AND OrderWorkflowName <> 'Billing Correction'
		  And cast(PBB_FactAppointment.Scheduledstart_DimdateId as date) >= @ReportDate
		 And (cast(PBB_FactAppointment.ActualEnd_DimDateId as date) >= @ReportDate
					  OR PBB_FactAppointment.ActualEnd_DimDateId = '1900-01-01')
			 ORDER BY ac.AccountGroupCode
				    ,CONVERT(VARCHAR(20),PBB_FactAppointment.ScheduledStart_DimDateId,101);
	    return
	end
GO
