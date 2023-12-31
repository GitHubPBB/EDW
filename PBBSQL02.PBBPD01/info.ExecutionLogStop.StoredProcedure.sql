USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[ExecutionLogStop]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************
 **
 ** Name:      ExecutionLogStop.sql
 **
 ** Purpose:   Insert Audit Log Record
 **
 ** Output:
 **
 ** Revisions:
 **
 ** Ver        Date        Author           Description
 ** ---------  ----------  ---------------  ----------------------------------
 ** 1.0        10/02/2021  Boyer            Created
 ** 1.1        05/23/2023  Sunil            Updated column naming as per new table structure
 **
 *****************************************************************************/
CREATE PROCEDURE [info].[ExecutionLogStop]
(
  @LogID                NUMERIC(18),
  @V_Schema          	VARCHAR(50),
  @V_Table              VARCHAR(100),
  @V_CurrentTimestamp	datetime,
  @LoadType				VARCHAR(200),
  @ExecutionMsg         VARCHAR(2000)
) AS

DECLARE @RC INT
DECLARE @ErrMsg VARCHAR(1000)
DECLARE @EtlName VARCHAR(50)



BEGIN TRAN
   SELECT @EtlName = EtlName from info.ExecutionLog where LogID = @LogID 

   UPDATE info.ExecutionLog 
   SET ExecutionStatus = 1,
       StopDttm     = GETDATE(),
       ElapsedSec   = DATEDIFF(SECOND, StartDttm, GETDATE()),
       ExecutionMsg = @ExecutionMsg 
   WHERE LogID = @LogID
   ;

   UPDATE info.ExecutionControlDetail 
      SET ExecutionStatus = 'COMPLETED',
	      ExecutionError  = @ErrMsg,
		  LastLoadDttm = @V_CurrentTimestamp
 WHERE TargetSchemaName = @V_Schema
   AND SourceTableName   = @V_Table
	  AND LoadType = @LoadType
;

COMMIT TRAN;
GO
