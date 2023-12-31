USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimServiceLocationBundleType_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec [dbo].[PBB_Populate_DimServiceLocationBundleType_pbb] '1/18/2022'
exec [dbo].[PBB_Populate_DimServiceLocationBundleType_pbb] '1/20/2022'

*/

CREATE PROCEDURE [dbo].[PBB_Populate_DimServiceLocationBundleType_pbb](
			 @AsOfDimDateID date
													    )
AS
    begin

	   print convert(varchar(20),@AsOfDimDateID)
	   raiserror('',0,1) with nowait;

	   --set @AsOfDimDateID = dateadd(day,1,@AsOfDimDateID)

	   delete from DimServiceLocationBundleType_pbb
	   where AsOfDimDateID = @AsOfDimDateID

	   insert into DimServiceLocationBundleType_pbb
			select DimServiceLocationID
				 ,DimAccountId
				 ,@AsOfDimDateID
				 ,PBB_BundleType
				 ,DoesCustomerHaveOtherServices
			from dbo.[PBB_GetLocationAccountBundleType](@AsOfDimDateID)
			where DimAccountId is not NULL
    end
GO
