USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_FormatPostalCode]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[PBB_FormatPostalCode](
			@value varchar(50))
returns varchar(50)
AS
	begin

	    if len(@value) = 9
		   begin
			  return substring(@value,1,5) + '-' + substring(@value,6,4)
		   end

	    return @value
	end
GO
