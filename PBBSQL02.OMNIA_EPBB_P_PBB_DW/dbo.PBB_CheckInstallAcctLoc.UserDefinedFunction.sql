USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_CheckInstallAcctLoc]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_CheckInstallAcctLoc] (@DimAccountId INT
											 ,@DimServiceLocationId INT
											 ,@AsOfDate DATE
											 )

RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @IsAcctPreexisting smallint=0, @IsLocPreexisting smallint=0, @IsAcctLocPreexisting smallint=0, @LocPreexistingDiscoDate date, @ReturnValue AS varchar(20)
	SET	@ReturnValue = ''

	/*
	select * from factcustomeritem where DimAccountId = 768034            -- 2023/08/11  NEW NEW 
	select * from factcustomeritem where DimAccountId = 768034 and DimServiceLocationId = 1290917  -- 2023/08/11
	select * from factcustomeritem where DimServiceLocationId = 1290917   -- 2023/08/11

	select * from factcustomeritem where DimSErviceLocationId = 1337927
	*/ 
	-- DECLARE @IsAcctPreexisting smallint=0, @IsLocPreexisting smallint=0, @IsAcctLocPreexisting smallint=0, @ReturnValue AS varchar(20), @AsOfDate date ='20230811', @DimAccountId int =768034, @DimServiceLocationId int = 1290917, @LocPreexistingDiscoDate date;

	-- DECLARE @IsAcctPreexisting smallint=0, @IsLocPreexisting smallint=0, @IsAcctLocPreexisting smallint=0, @ReturnValue AS varchar(20), @AsOfDate date ='20230808', @DimAccountId int =693057, @DimServiceLocationId int = 1135574, @LocPreexistingDiscoDate date;
	select @IsAcctLocPreexisting = count(*) 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
			AND right(x.sourceid,2) <> '.N'
			and x.DimAccountId         = @DimAccountId
			and x.DimServiceLocationId = @DimServiceLocationId
			and @AsOfDate > cast(x.EffectiveStartDate as date) 
			and x.Deactivation_DimDateId > cast(x.EffectiveStartDate as date) 
			and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  
 
 	select @IsAcctPreexisting = count(*) 
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
			AND right(x.sourceid,2) <> '.N'
			and x.DimAccountId         = @DimAccountId
			and @AsOfDate > cast(x.EffectiveStartDate as date) 
			and x.Deactivation_DimDateId > cast(x.EffectiveStartDate as date) 
			and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  

 select @IsLocPreexisting = count(*), @LocPreexistingDiscoDate = max(x.EffectiveEndDate)
	--select *
		FROM [OMNIA_EPBB_P_PBB_DW].dbo.FactCustomerItem        x
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimCatalogItem          dci  on dci.DimCatalogItemId  = x.DimCatalogItemId  
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.PrdComponentMap         pcm  on pcm.Componentcode     = dci.ComponentCode
		WHERE 1=1
			AND right(x.sourceid,2) <> '.N'
			and x.DimServiceLocationId = @DimServiceLocationId
			and cast(x.EffectiveStartDate as date)  <= dateadd(d,-1,@AsOfDate)
			and x.Deactivation_DimDateId  >= cast(x.EffectiveStartDate as date)
			and ( IsDataSvc + IsLocalPhn + IsComplexPhn + IsCableSvc  > 0  or Component in ('Performance Plus Promo', 'Gig Special','Ohio- Fiber Extreme') )  
		--	order by x.EffectiveStartDate
 
    -- print concat(@IsAcctLocPreexisting,'|', @IsAcctPreexisting,'|',@IsLocPreexisting,'|',@LocPreexistingDiscoDate)
	-- 



	Set @ReturnValue = concat(case when @IsAcctLocPreexisting > 0 then 1 else 0 end,'|',case when @IsAcctPreexisting > 0 then 1 else 0 end,'|', case when @IsLocPreexisting > 0 then 1 else 0 end ,'|',@LocPreexistingDiscoDate)
 

	RETURN ISNULL(@ReturnValue, '')
END
GO
