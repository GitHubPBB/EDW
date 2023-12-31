USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[F_ConvertUTCDateToLocalTime]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--CREATE FUNCTION
CREATE FUNCTION [dbo].[F_ConvertUTCDateToLocalTime] (@DATE datetime)
RETURNS datetime
AS

BEGIN
     DECLARE @OutDate datetime
     SELECT @OutDate = DATEADD(second, DATEDIFF(second, GETUTCDATE(), GETDATE()  ), @Date)

     RETURN(@OutDate)
END
GO
