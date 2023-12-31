USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[tfnSplitString]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[tfnSplitString](
			 -- Add the parameters for the function here
			 @string varchar(max)
			,@delim  varchar(1)
							   )
RETURNS @tokens TABLE(
				  token varchar(max)
				 )
AS
	BEGIN

	    declare @idx int
	    declare @work varchar(max)

	    set @string = LTRIM(RTRIM(ISNULL(@string,'')))

	    if CHARINDEX(@delim,@string) > 0
		   begin

			  while LEN(@string) > 0
				 begin
					set @idx = CHARINDEX(@delim,@string)
					if @idx > 0
					    begin
						   set @work = SUBSTRING(@string,1,@idx - 1)
						   insert into @tokens(token)
						   values
						   (
								@work
						   )
						   --print '@work = ' + @work
						   set @string = SUBSTRING(@string,@idx + 1,LEN(@string) - @idx)
						   --print '@string = ' + @string
					    end
					else
					    begin
						   insert into @tokens(token)
					    values
						   (
							 @string
						   )
						   break
					    end
				 end
		   end
	    else
		   begin
			  --print 'string did not contain delim'
			  insert into @tokens(token)
		   values
			  (
				@string
			  )
		   end

	    RETURN
	END
GO
