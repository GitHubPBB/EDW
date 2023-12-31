USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_BACKLOG_RUNNING2WK_TOTAL]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Todd Boyer	This version adds the filter by create date from Fact Sale Order
--               This is a test version only, delete after testing



CREATE FUNCTION [dbo].[PBB_DB_BACKLOG_RUNNING2WK_TOTAL](
			@ReportDate date)
RETURNS @backlogtotal TABLE(
					   [Install Date]           Date
					  ,AsOfDate				    Date
				      ,DayNum                   int
				      ,DOW                      int
				      ,WeekNum                  int
					  ,[Account Group Code]     nvarchar(256)
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
		WITH
		DateList AS ( 
		        -- declare @ReportDate date='20221008';
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
	    insert into @backlogtotal

			 SELECT DISTINCT 
				   [Install Date]
				  ,x.AsOfDate
				  ,DayNum
				  ,x.DOW
				  ,WeekNum
				  ,[Account Group Code]
				  ,[Account Group]
				  ,[Group]
				  ,[Account Market]
				  ,MarketSummary
				  ,ReportingMarket
				  ,AccountClass
				  ,AccountType
				  ,[Account Number]
				  ,[Account Name]
				  ,[Street Address]
				  ,[City]
				  ,[State]
				  ,[Zip Code]
				  ,[SO Number]
				  ,[Order Name]
				  ,[Order Type]
				  ,[Order Status]
				  ,pbb_SFLAppointmentStatus
				  ,pbb_SFLAppointmentURL
				  ,ActivityId

			 FROM dbo.pbb_BacklogDailySnapshot x
			 JOIN DateList                     y on x.AsOfDate = y.AsOfDate

			 WHERE 1=1


			 ORDER BY x.AsOfDate
			        ,[Account Group Code]
				    ,[Install Date] desc
			;

	    return
	end
GO
