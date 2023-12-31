USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_FormatPhone]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[PBB_FormatPhone](
			 @value varchar(50)
						 )
returns varchar(50)
AS
	begin

	    if len(@value) = 10
		   begin
			  return substring(@value,1,3) + '-' + substring(@value,4,3) + '-' + substring(@value,7,4)
		   end

	    return @value
	end
GO
