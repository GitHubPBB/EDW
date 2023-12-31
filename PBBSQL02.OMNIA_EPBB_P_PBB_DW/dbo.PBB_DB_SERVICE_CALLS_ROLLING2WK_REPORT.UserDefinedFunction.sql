USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_SERVICE_CALLS_ROLLING2WK_REPORT]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE FUNCTION [dbo].[PBB_DB_SERVICE_CALLS_ROLLING2WK_REPORT](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
--declare @ReportDate Date = '8-20-2021'
(
-- DECLARE @ReportDate date = cast(getdate() as date);

		WITH DateList AS ( 
				SELECT @ReportDate AsOfDate       , 14 DayNum, DATEPART(WEEKDAY, @ReportDate )                 DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-1  ,@ReportDate), 13 DayNum, DATEPART(WEEKDAY, DATEADD(d,-1  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-2  ,@ReportDate), 12 DayNum, DATEPART(WEEKDAY, DATEADD(d,-2  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-3  ,@ReportDate), 11 DayNum, DATEPART(WEEKDAY, DATEADD(d,-3  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-4  ,@ReportDate), 10 DayNum, DATEPART(WEEKDAY, DATEADD(d,-4  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-5  ,@ReportDate), 9  DayNum, DATEPART(WEEKDAY, DATEADD(d,-5  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-6  ,@ReportDate), 8  DayNum, DATEPART(WEEKDAY, DATEADD(d,-6  ,@ReportDate) ) DOW, 1 WeekNum UNION
				SELECT DATEADD(d,-7  ,@ReportDate), 7  DayNum, DATEPART(WEEKDAY, DATEADD(d,-7  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-8  ,@ReportDate), 6  DayNum, DATEPART(WEEKDAY, DATEADD(d,-8  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-9  ,@ReportDate), 5  DayNum, DATEPART(WEEKDAY, DATEADD(d,-9  ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-10 ,@ReportDate), 4  DayNum, DATEPART(WEEKDAY, DATEADD(d,-10 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-11 ,@ReportDate), 3  DayNum, DATEPART(WEEKDAY, DATEADD(d,-11 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-12 ,@ReportDate), 2  DayNum, DATEPART(WEEKDAY, DATEADD(d,-12 ,@ReportDate) ) DOW, 2 WeekNum UNION
				SELECT DATEADD(d,-13 ,@ReportDate), 1  DayNum, DATEPART(WEEKDAY, DATEADD(d,-13 ,@ReportDate) ) DOW, 2 WeekNum   
		)
		-- SELECT * from DateList

SELECT convert(varchar(20),fa.ScheduledStart_DimDateId,101) as [Date]
	   ,dl.AsOfDate
	   ,dl.DayNum
	   ,dl.DOW
	   ,dl.WeekNum
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
FROM PBB_Factappointment     fa
     JOIN DimCase            dc   ON dc.DimCaseId = fa.DimCaseId
     JOIN DimAppointment_Pbb appt ON appt.ActivityId = fa.ActivityId
     JOIN DimAccount         a    ON a.DimAccountId = fa.DimAccountId
	 JOIN DimAccount_pbb          ON a.AccountId = DimAccount_pbb.AccountId
     LEFT JOIN DimAccountCategory     ac ON ac.DimAccountCategoryId = fa.DimAccountCategoryId
     LEFT JOIN DimAccountCategory_pbb _ac ON _ac.SourceId = ac.SourceId
	 JOIN DateList dl             ON dl.AsOfDate = cast(fa.ScheduledStart_DimDateId as date)
WHERE 1 = 1
And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
      AND fa.DimSalesOrderId = 0
      AND fa.DimCaseId <> 0
      AND pbb_SFLAppointmentStatus IN ('Completed')
      AND dc.TicketStatus IN ('Active', 'Resolved')
 )
GO
