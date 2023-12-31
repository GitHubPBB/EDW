USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_IsFiberAccount]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_IsFiberAccount] (@DimAccountId INT
											 ,@DimServiceLocationId INT
											 ,@AsOfDate DATE
											 )
RETURNS INT
AS
BEGIN

	DECLARE @ReturnCount AS INT
	SET	@ReturnCount = 0

	

	select @ReturnCount = count(*) from (

		select top 1000000 x.*, row_number() over (partition by x.ItemId order by x.EffectiveEndDate desc) row_num
	 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId     = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode        = dci.ComponentCode
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCustomerProduct      dcp  ON dcp.DimCustomerProductId = x.DimCustomerProductId
		WHERE 1=1
		AND right(x.sourceid,2) <> '.N'
		and x.DimAccountId         = @DimAccountId
		and x.DimServiceLocationId = @DimServiceLocationId
		and @AsOfDate >= cast(x.EffectiveStartDate as date)
		and @AsOfDate <= cast(x.EffectiveEndDate   as date)
		and x.Deactivation_DimDateId = '20500101'
		and coalesce(pcm.DownloadMB,'') <> ''
		and ProductStatusCode = 'A'
		

	) z
	where row_num=1
      and z.Deactivation_DimDateId > @AsOfDate


 

	RETURN ISNULL(@ReturnCount, 0)
END
GO
