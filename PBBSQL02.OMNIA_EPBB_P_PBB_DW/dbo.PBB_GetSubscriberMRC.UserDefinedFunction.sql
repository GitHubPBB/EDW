USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetSubscriberMRC]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_GetSubscriberMRC] (@DimAccountId INT
											 ,@DimServiceLocationId INT
											 ,@AsOfDate DATE
											 )

RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @ReturnValue1 decimal(8,2) =0.00 , @ReturnValue AS varchar(20)
	SET	@ReturnValue = ''
		
	-- Declare @DimAccountId int =660277, @DimServiceLocationId int =1084576, @AsOfDate date ='20230123',@ReturnValue1 decimal(8,2) =0.00;

	select @ReturnValue1 = sum(itemPrice*ItemQuantity) from (

		select top 1000000 x.* , row_number() over (partition by x.ItemId order by  x.EffectiveEndDate) row_num
	 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		WHERE 1=1
		AND right(x.sourceid,2) <> '.N'
		and x.DimAccountId         = @DimAccountId
		and x.DimServiceLocationId = @DimServiceLocationId
		and @AsOfDate >= cast(x.EffectiveStartDate as date)
		and @AsOfDate <= cast(x.EffectiveEndDate   as date) 
		and x.ItemPrice <> 0
		
	) z
	where 1=1
      and z.Deactivation_DimDateId >= @AsOfDate
	   


	Set @ReturnValue = @ReturnValue1
 

	RETURN ISNULL(@ReturnValue, '')
END
GO
