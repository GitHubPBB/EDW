USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SERVICE_CALLS_DETAIL_REPORT]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE FUNCTION [dbo].[PBB_DB_SERVICE_CALLS_DETAIL_REPORT](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
--declare @ReportDate Date = '8-20-2021'
(SELECT convert(varchar(20),fa.ScheduledStart_DimDateId,101) as [Date]
,fa.ActualEnd_DimDateId
       ,ac.AccountGroupCode as [Account Group Code]
	   ,ac.AccountGroup as [Account Group]
	   ,ac.AccountClass
	   ,ac.accounttype
	   ,_ac.pbb_MarketSummary as [Market Summary]
       ,a.AccountCode as [Account Number]
       ,a.AccountName as [Account Name]
       ,a.BillingAddressStreetLine1 as [Street Address]
       ,a.BillingAddressCity as [City]
       ,a.BillingAddressState as [State]
       ,a.BillingAddressPostalCode as [Zip Code]
       ,dc.TicketNumber as [Ticket Number]
       ,dc.TicketTitle as [Ticket Title]
       ,dc.TicketStatus as [Ticket Status]
       ,appt.pbb_SFLAppointmentStatus
          ,appt.pbb_SFLAppointmentURL
          ,appt.ActivityId
		  ,SUBSTRING(_ac.pbb_AccountMarket,4,255) AS pbb_AccountMarket
		  ,dc.DimCaseID
FROM PBB_Factappointment fa
     INNER JOIN DimCase dc ON dc.DimCaseId = fa.DimCaseId
     LEFT JOIN DimAppointment_Pbb appt ON appt.ActivityId = fa.ActivityId
     LEFT JOIN DimAccount a ON a.DimAccountId = fa.DimAccountId
	 JOIN DimAccount_pbb ON a.AccountId = DimAccount_pbb.AccountId
     LEFT JOIN DimAccountCategory ac ON ac.DimAccountCategoryId = fa.DimAccountCategoryId
     LEFT JOIN DimAccountCategory_pbb _ac ON _ac.SourceId = ac.SourceId
WHERE 1 = 1
And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
      AND fa.DimSalesOrderId = 0
      AND fa.DimCaseId <> 0
      AND pbb_SFLAppointmentStatus IN ('Completed')
      AND dc.TicketStatus IN ('Active', 'Resolved')
      And (Convert(Date, fa.ScheduledStart_DimDateId) = Convert (Date, Case When Datepart(DW, @ReportDate)= 2 Then  DATEadd(DD, -3,  @ReportDate) Else  DATEadd(DD, -1,  @ReportDate) End)  
      Or Convert(Date,   fa.ScheduledStart_DimDateId) = Convert (Date, Case When Datepart(DW, @ReportDate)= 2 Then  DATEadd(DD, -2,  @ReportDate) Else DATEadd(DD, -1,  @ReportDate) End)  
      Or Convert(Date,   fa.ScheduledStart_DimDateId) = Convert (Date, Case When Datepart(DW, @ReportDate)= 2 Then  DATEadd(DD, -1,  @ReportDate) Else DATEadd(DD, -1,  @ReportDate) End))
	)
GO
