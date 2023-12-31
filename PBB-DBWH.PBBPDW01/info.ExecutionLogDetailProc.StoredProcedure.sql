USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[ExecutionLogDetailProc]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*****************************************************************************
 **
 ** Name:      ExecutionLogStart.sql
 **
 ** Purpose:   Insert Audit Log Record
 **
 ** Output:
 **
 ** Revisions:
 **
 ** Ver        Date        Author           Description
 ** ---------  ----------  ---------------  ----------------------------------
 ** 1.0        06/06/2023  Sunil            Created
 **
 *****************************************************************************/
CREATE PROCEDURE [info].[ExecutionLogDetailProc]
(
  @LogID				NUMERIC(18),
  @ExecutionStep		VARCHAR(100),
  @ExecutionMsg         VARCHAR(8000)
) AS



BEGIN TRAN
 

   INSERT INTO info.ExecutionLogDetail
   (
	 LogID,
     LogDttm,
     ExecutionStep,
     ExecutionMsg
   )
   VALUES
   (
	 @LogID,
     GETDATE(),
	 @ExecutionStep,
     @ExecutionMsg
   );

COMMIT TRAN;
;
GO
