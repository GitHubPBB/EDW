USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[TEST]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE FUNCTION [dbo].[TEST](
			@ReportDate date
						)
RETURNS TABLE 
AS
RETURN 
(select * from PBB_DB_BACKLOG_MONTH(@ReportDate)
)
GO
