USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[TEST]    Script Date: 12/5/2023 3:30:01 PM ******/
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
