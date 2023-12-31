USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetNonPayLast6Months]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[PBB_GetNonPayLast6Months](
             @AccountCode varchar(10)
			,@AsOfDate date
			)
RETURNS @AccountDetails TABLE 
(AccountCode varchar(10)
,TranDate date
,NonPayCount Int
)
AS
BEGIN

		INSERT INTO @AccountDetails
		select nd.Accountcode, @AsOfDate, count(distinct d.disconnectrun) NonPayCount 
		  from pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[CV_NoticeDisconnect_V100] nd
		  join pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[ArDisconnectRun] d on nd.DisconnectRun = d.DisconnectRun
		 where cast(d.DisconnectRunDate as date) between (dateadd(month,-6,@AsOfDate)) and @AsOfDate
		   AND nd.AccountCode = @AccountCode
		 group by nd.accountcode


		 RETURN
END


GO
