USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[weekEndDate]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[weekEndDate](
			 @date date
					  )
returns date
as
	begin

	    declare @thisWeek as int = datepart(week,@date)

	    while datepart(week,@date) = @thisWeek
		   begin
			  set @date = dateadd(day,1,@date)
		   end

	    return dateadd(day,-1,@date)
	end
GO
