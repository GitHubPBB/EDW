USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[emptyGUID]    Script Date: 12/5/2023 4:42:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[emptyGUID]() RETURNS uniqueidentifier AS
begin

	return '00000000-0000-0000-0000-000000000000'

end
GO
