USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_StringMapBaseJoin]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[PBB_StringMapBaseJoin](
			 @tablename  nvarchar(255)
			,@columnName nvarchar(255)
									)
RETURNS TABLE
AS
	return
	select distinct 
		  [AttributeValue] as [JoinOnValue]
		 ,[Value]
	from [PBBSQL01].[PBB_P_MSCRM].[MetadataSchema].[Entity] e with (NOLOCK)
		inner join [PBBSQL01].[PBB_P_MSCRM].[dbo].StringMapBase smb with (NOLOCK) on smb.ObjectTypeCode = e.ObjectTypeCode
	where [Name] = @tableName
		 and AttributeName = @columnName
			--order by e.[NAME]
			--	   ,e.OBJECTTYPECODE;
GO
