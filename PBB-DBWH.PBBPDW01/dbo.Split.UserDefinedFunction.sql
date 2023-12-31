USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 12/5/2023 5:09:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split](
@str VARCHAR(MAX),
@delimiter CHAR(1)
)
RETURNS @returnTable TABLE (idx INT PRIMARY KEY IDENTITY, item VARCHAR(8000))
AS
BEGIN
DECLARE @pos INT
SELECT @str = @str + @delimiter
WHILE LEN(@str) > 0 
    BEGIN
        SELECT @pos = CHARINDEX(@delimiter,@str)
        IF @pos = 1
            INSERT @returnTable (item)
                VALUES (NULL)
        ELSE
            INSERT @returnTable (item)
                VALUES (SUBSTRING(@str, 1, @pos-1))
        SELECT @str = SUBSTRING(@str, @pos+1, LEN(@str)-@pos)       
    END
RETURN
END
GO
