USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[UpdateProcStatus]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************
 **
 ** Name:      upd_pkg_sts.sql
 **
 ** Purpose:   Update Package Status For Given Package Name
 **
 ** Output:
 **
 ** Revisions:
 **
 ** Ver        Date        Author           Description
 ** ---------  ----------  ---------------  ----------------------------------
 ** 1.0        10/01/2021  Boyer            Created
 **  
 *****************************************************************************/
CREATE PROCEDURE [info].[UpdateProcStatus]
(
  @LogID	   NUMERIC(18),
  @EtlName     VARCHAR(50),
  @Status      VARCHAR(15),
  @ErrMsg      VARCHAR(8000)
) AS

BEGIN TRAN
   UPDATE info.ExecutionControl
   SET EtlStatus       = @Status,
       EtlStatusDttm   = GETDATE(),
	   EtlErrorMsg     = @ErrMsg
   WHERE EtlName       = @EtlName
   ;

COMMIT TRAN;
GO
