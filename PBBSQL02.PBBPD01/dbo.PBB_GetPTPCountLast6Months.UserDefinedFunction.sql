USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetPTPCountLast6Months]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[PBB_GetPTPCountLast6Months](
             @AccountCode varchar(10)
			,@AsOfDate date
			)
RETURNS @AccountDetails TABLE 
(AccountCode varchar(10)
,TranDate date
,PTPLast6Months Int
)
AS
BEGIN
/* --FROM JACKIE

    SELECT AccountCode,            COUNT(PromiseDate) PTPCount
    FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount AS AA WITH(NOLOCK)
         INNER JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP WITH(NOLOCK) ON AA.AccountID = PTP.AccountID
    WHERE PTP.PromiseDate BETWEEN(DATEADD(month, -6, GETDATE())) AND GETDATE()
    GROUP BY accountcode
*/
     WITH PTPMonth
          AS (	SELECT AccountCode
		             , @AsOfDate TranDate
				     , COUNT(PromiseDate) PTPCount
				  FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount      AS AA  WITH(NOLOCK)
				  JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP WITH(NOLOCK) ON AA.AccountID = PTP.AccountID
				 WHERE PTP.PromiseDate BETWEEN(DATEADD(month, -6, @AsOfDate)) AND @AsOfDate
				   AND AA.AccountCode = @AccountCode
				 GROUP BY AccountCode
		  )
		  INSERT INTO @AccountDetails
          SELECT AccountCode, TranDate, PTPCount
          FROM PTPMonth
		   		  
    RETURN 
END;

GO
