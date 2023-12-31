USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_TRUCK_ROLL_TROUBLE_CALL_OUTLOOK_DAILY_DETAIL]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE FUNCTION [dbo].[PBB_DB_TRUCK_ROLL_TROUBLE_CALL_OUTLOOK_DAILY_DETAIL](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
(With CTE
	As (SELECT convert(varchar(20),fa.ScheduledStart_DimDateId,101) as [Date]
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
			,ac.AccountGroupCode
			,CONVERT(VARCHAR(20),fa.ScheduledStart_DimDateId,101) As 'ScheduledStart_DimDateId'
			,SUBSTRING(_ac.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			,_ac.pbb_MarketSummary As MarketSummary
			,dc.DimCaseID
			,'LessThan' As 'ReportData'
	    FROM PBB_FactAppointment fa
		    INNER JOIN DimCase dc ON dc.DimCaseId = fa.DimCaseId
		    LEFT JOIN DimAppointment_Pbb appt ON appt.ActivityId = fa.ActivityId
		    LEFT JOIN DimAccount a ON a.DimAccountId = fa.DimAccountId
		    JOIN DimAccount_pbb ON a.AccountId = DimAccount_pbb.AccountId
		    LEFT JOIN DimAccountCategory ac ON ac.DimAccountCategoryId = fa.DimAccountCategoryId
		    LEFT JOIN DimAccountCategory_pbb _ac ON _ac.SourceId = ac.SourceId
	    WHERE 1 = 1
			And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
			AND DateDiff(DAY,Convert(Date,dateadd(day,-1,@ReportDate)),fa.ScheduledStart_DimDateId) Between 0 And 2
			AND fa.DimSalesOrderId = 0
			AND fa.DimCaseId <> 0
			AND pbb_SFLAppointmentStatus NOT IN
										(
										 'Completed'
										,'Cannot Complete'
										)
			AND dc.TicketStatus NOT IN('Canceled','Resolved')
	    Union All
	    SELECT convert(varchar(20),fa.ScheduledStart_DimDateId,101) as [Date]
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
			,ac.AccountGroupCode
			,CONVERT(VARCHAR(20),fa.ScheduledStart_DimDateId,101) As 'ScheduledStart_DimDateId'
			,SUBSTRING(_ac.pbb_AccountMarket,4,255) AS pbb_AccountMarket
			,_ac.pbb_MarketSummary As MarketSummary
			,dc.DimCaseID
			,'MoreThan' As 'ReportData'
	    FROM PBB_FactAppointment fa
		    INNER JOIN DimCase dc ON dc.DimCaseId = fa.DimCaseId
		    LEFT JOIN DimAppointment_Pbb appt ON appt.ActivityId = fa.ActivityId
		    LEFT JOIN DimAccount a ON a.DimAccountId = fa.DimAccountId
		    JOIN DimAccount_pbb ON a.AccountId = DimAccount_pbb.AccountId
		    LEFT JOIN DimAccountCategory ac ON ac.DimAccountCategoryId = fa.DimAccountCategoryId
		    LEFT JOIN DimAccountCategory_pbb _ac ON _ac.SourceId = ac.SourceId
	    WHERE 1 = 1
			And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
			AND DateDiff(DAY,Convert(Date,dateadd(day,-1,@ReportDate)),fa.ScheduledStart_DimDateId) > 2
			AND fa.DimSalesOrderId = 0
			AND fa.DimCaseId <> 0
			AND pbb_SFLAppointmentStatus NOT IN
										(
										 'Completed'
										,'Cannot Complete'
										)
			AND dc.TicketStatus NOT IN('Canceled','Resolved'))
	Select *
	from CTE
)
GO
