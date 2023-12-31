USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[ExecutionLogError]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************
 **
 ** Name:      exectn_log_error.sql
 **
 ** Purpose:   Insert Audit Log Record
 **
 ** Output:
 **
 ** Revisions:
 **
 ** Ver			Date        Author		Description
 ** ---------	----------  ----------  ----------------------------------
 ** 1.0			09/29/2015  TB			Created
 ** 1.1			09/29/2015  Sunil		altred
 *****************************************************************************/
CREATE   PROCEDURE [info].[ExecutionLogError]
(
  @LogID                NUMERIC(18),
  @V_Schema          	VARCHAR(50),
  @V_Table              VARCHAR(100),
  @LoadType				VARCHAR(200),
  @ExecutionMsg         VARCHAR(2000)
) AS

DECLARE @RC INT
DECLARE @ErrMsg varchar(1000)

BEGIN TRAN
   UPDATE info.ExecutionLog 
   SET ExecutionStatus = -1,
       StopDttm     = GETDATE(),
       ElapsedSec   = DATEDIFF(SECOND, StartDttm, GETDATE()),
       ExecutionMsg = @ExecutionMsg
   WHERE LogID = @LogID 
   ;

   
UPDATE info.ExecutionControlDetail 
   SET ExecutionStatus ='FAILED'
     , ExecutionError  =@ExecutionMsg
 WHERE TargetSchemaName = @V_Schema
   AND SourceTableName   = @V_Table
   AND LoadType = @LoadType


COMMIT TRAN;
GO
