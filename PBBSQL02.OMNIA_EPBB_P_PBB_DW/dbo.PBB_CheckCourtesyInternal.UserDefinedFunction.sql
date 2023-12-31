USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_CheckCourtesyInternal]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_CheckCourtesyInternal] (@DimAccountId INT
											 ,@AsOfDate DATE
											 )

RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @CICount smallint=0, @ReturnValue AS varchar(20)
	SET	@ReturnValue = ''

	 

 	select @CICount = count(*) 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
																	and (component like '%Courtesy%' or component like '%Internal use only%')
		WHERE 1=1
			AND right(x.sourceid,2) <> '.N'
			and x.DimAccountId         = @DimAccountId
			and @AsOfDate >= cast(x.EffectiveStartDate as date) 
			and @AsOfDate <  cast(x.EffectiveEndDate   as date)
			--and x.Deactivation_DimDateId <>'20500101'
 
 	Set @ReturnValue = case when @CICount > 0 then 1 else 0 end
 

	RETURN ISNULL(@ReturnValue, '')
END
GO
