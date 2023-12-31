USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetActiveItemCount]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_GetActiveItemCount] (@DimAccountId INT
											 ,@DimServiceLocationId INT
											 ,@AsOfDate DATE
											 ,@SalesOrderType varchar(20)
											 )

RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @ReturnValue1 smallint=0, @ReturnValue2 smallint=0, @ReturnDiscDate varchar(8)='', @ReturnValue AS varchar(20)
	SET	@ReturnValue = ''

	

	select @ReturnValue1 = count(*) from (

		select top 1000000 x.* , row_number() over (partition by x.ItemId order by  x.EffectiveEndDate) row_num
	 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
		AND right(x.sourceid,2) <> '.N'
		and x.DimAccountId         = @DimAccountId
		and x.DimServiceLocationId = @DimServiceLocationId
		and @AsOfDate >= cast(x.EffectiveStartDate as date)
		and @AsOfDate <= cast(x.EffectiveEndDate   as date)
		and x.Deactivation_DimDateId >= cast(x.EffectiveStartDate as date)
		--AND @AsOfDate <  Deactivation_DimDateId
	    and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  
		
	) z
	where row_num=1
      and z.Deactivation_DimDateId > @AsOfDate


	select @ReturnValue2 = count(*) from (

		select top 1000000 x.* , row_number() over (partition by x.ItemId order by  x.EffectiveEndDate desc) row_num
	 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
		AND right(x.sourceid,2) <> '.N'
		and x.DimAccountId         = @DimAccountId
		and x.DimServiceLocationId = @DimServiceLocationId
		and @AsOfDate >= cast(x.EffectiveStartDate as date)
		and @AsOfDate <= cast(x.EffectiveEndDate   as date)
		--and x.Deactivation_DimDateId >= cast(x.EffectiveStartDate as date)
		--AND @AsOfDate <  Deactivation_DimDateId
	    and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  
		

	) z
	where row_num=1
      and z.Deactivation_DimDateId > @AsOfDate


	select @ReturnDiscDate = replace(cast(DiscoDate as varchar(20)),'-','') from (

		select top 1000000 max(Deactivation_DimDateId) DiscoDate
	 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
		AND right(x.sourceid,2) <> '.N'
		and x.DimAccountId         = @DimAccountId
		and x.DimServiceLocationId = @DimServiceLocationId
		and @AsOfDate >= cast(x.EffectiveStartDate as date)
		and @AsOfDate <  cast(x.EffectiveEndDate   as date)
	    --	and x.Deactivation_DimDateId >= cast(x.EffectiveStartDate as date)
	    and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  
		-- and x.Deactivation_DimDateId < '20500101'
		

	) z
	where 1=1
	  and z.DiscoDate < '20500101'


	Set @ReturnValue = concat(case when @ReturnValue1 > 0 then 1 else 0 end,'|',case when @ReturnValue2 > 0 then 1 else 0 end,'|', @ReturnDiscDate )
 

	RETURN ISNULL(@ReturnValue, '')
END
GO
