USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetTroubleTicketCountLast3Months]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[PBB_GetTroubleTicketCountLast3Months](
             @AccountCode varchar(10)
			,@AsOfDate    date
			,@DurationMo  smallint
			)
RETURNS @AccountDetails TABLE 
(AccountCode varchar(10)
,TranDate date
,TroubleTicketsLastPeriod Int
)
AS
BEGIN
 
     WITH PTPMonth
			  AS (	SELECT AccountCode
						 , @AsOfDate TranDate
						 , COUNT(*)  TroubleTicketsLastPeriod
					FROM PBB_FactAppointment             fa
						JOIN DimAccount                  a    ON a.DimAccountId  = fa.DimAccountId
						JOIN DimAccount_pbb                   ON a.AccountId     = DimAccount_pbb.AccountId
						JOIN DimCase                     dc   ON dc.DimCaseId    = fa.DimCaseId
						LEFT JOIN DimAppointment_Pbb     appt ON appt.ActivityId = fa.ActivityId
						LEFT JOIN DimAccountCategory     ac   ON ac.DimAccountCategoryId = fa.DimAccountCategoryId
						LEFT JOIN DimAccountCategory_pbb _ac  ON _ac.SourceId    = ac.SourceId
					WHERE 1 = 1
					    AND a.AccountCode = @Accountcode
						And DimAccount_pbb.pbb_AccountDiscountNames not like '%INTERNAL USE ONLY - Zero Rate Test Acct%'
						AND cast(fa.ScheduledStart_DimDateId as date) between dateadd(mm,@DurationMo*-1,@AsOfDate) and @AsOfDate
						AND fa.DimCaseId <> 0
						AND pbb_SFLAppointmentStatus NOT IN
													(
													'Cannot Complete'
													)
					GROUP BY AccountCode
		  )
		  INSERT INTO @AccountDetails
          SELECT AccountCode, TranDate, TroubleTicketsLastPeriod
          FROM PTPMonth
		   		  
    RETURN 
END;

GO
