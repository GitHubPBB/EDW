USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_TRUCK_ROLL_TROUBLE_CALL_MONTHLY_DETAIL]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE FUNCTION [dbo].[PBB_DB_TRUCK_ROLL_TROUBLE_CALL_MONTHLY_DETAIL](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
(SELECT convert(date,dc.casecreatedon,101) as [CreatedOn]
	 ,convert(varchar(20),fa.ScheduledStart_DimDateId,101) as [Date]
	 ,ac.AccountGroupCode as [Account Group]
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
	 ,_ac.pbb_MarketSummary As MarketSummary
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
	 And fa.ScheduledStart_DimDateId < @ReportDate
	 AND Year(fa.ScheduledStart_DimDateId) = Year(case
											when datepart(weekday,@ReportDate) = 2
											then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
										 end)
	 And Month(fa.ScheduledStart_DimDateId) = Month(case
											  when datepart(weekday,@ReportDate) = 2
											  then dateadd(day,-3,@ReportDate) else dateadd(day,-1,@ReportDate)
										   end)
	 AND fa.DimSalesOrderId = 0
	 AND fa.DimCaseId <> 0
	 AND pbb_SFLAppointmentStatus IN('Completed')
	AND dc.TicketStatus IN('Active','Resolved')
)
GO
