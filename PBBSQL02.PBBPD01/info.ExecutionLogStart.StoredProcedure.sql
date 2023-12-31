USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[ExecutionLogStart]    Script Date: 12/5/2023 4:43:07 PM ******/
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
 ** 1.0        09/29/2015  Boyer            Created
 ** 1.1        05/23/2023  Sunil            Updated column naming as per new table structure
 **
 *****************************************************************************/
CREATE PROCEDURE [info].[ExecutionLogStart]
(
  @LogParentID          NUMERIC(18),
  @ExecutionGroup       VARCHAR(25),
  @V_Schema				VARCHAR(50),
  @V_Table				VARCHAR(100),
  @LoadDttm             VARCHAR(40),
  @EtlGUID              VARCHAR(50),
  @ExecutionGUID        VARCHAR(50),
  @MachineName          VARCHAR(50),
  @UserName             VARCHAR(50),
  @LoadType				VARCHAR(200),
  @ExecutionMsg         VARCHAR(2000),
  @LogID                NUMERIC(18) OUTPUT
) AS

DECLARE @RC INT
DECLARE @ErrMsg varchar(1000)
DECLARE @EtlGroup varchar(50)

BEGIN TRAN
 

   INSERT INTO info.ExecutionLog
   (
     LogParentID,
	 EtlGroup,
     EtlName,
     LoadDttm,
     StartDttm,
     StopDttm,
     ElapsedSec,
     EtlGUID,
     ExecutionGUID,
     MachineName,
     UserName,
     ExecutionStatus,
     ExecutionMsg
   )
   VALUES
   (
     @LogParentID,
	 @ExecutionGroup,
     concat(@V_Schema,'.',@V_Table),
     CONVERT(DATETIME, @LoadDttm),
     GETDATE(),
     NULL,
     NULL,
     @EtlGUID,
     @ExecutionGUID,
     @MachineName,
     @UserName,
     0,
     @ExecutionMsg
   );

COMMIT TRAN;

SET @LogID = @@IDENTITY;

UPDATE info.ExecutionControlDetail   
   SET ExecutionStatus       = 'RUNNING',
	   ExecutionLogID		 = @LogParentID,
       ExecutionDttm         = GETDATE(),
	   ExecutionError        = @ErrMsg
 WHERE TargetSchemaName = @V_Schema
   AND SourceTableName   = @V_Table
   AND LoadType = @LoadType


;
GO
