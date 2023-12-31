USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(
    @sInputList VARCHAR(MAX)
   ,@sDelimiter VARCHAR(8)      
) 
RETURNS @List TABLE ([item] VARCHAR(8000)) 
AS
BEGIN
DECLARE @sItem VARCHAR(MAX) 
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
BEGIN
    SELECT
        @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1)))
        ,@sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

    IF LEN(@sItem) > 0
        INSERT INTO @List SELECT @sItem
    END

    IF LEN(@sInputList) > 0
        INSERT INTO @List SELECT @sInputList
RETURN 
END
GO
