USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PWB_AccountServiceHierFunc_AsOf2]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION  [dbo].[PWB_AccountServiceHierFunc_AsOf2] (
			@AsOfDate date)
RETURNS TABLE
AS RETURN (

-- DECLARE @AsOfDate date = '20230204'; 
WITH FCI AS (select *,substring(fci.SourceId, charindex('.',fci.SourceId)+1,  charindex('.', fci.SourceId, charindex('.',fci.SourceId)+1) - charindex('.',fci.SourceId)-1 ) ItemVersion
                 from dbo.FactCustomerItem   fci  
                                     WHERE @AsOfDate between cast(fci.EffectiveStartDate as date) and cast(fci.EffectiveEndDate as date)
									 and right(fci.SourceId ,2) <> '.N'
  )
select distinct
         @AsOfDate AsOfDate, da.AccountCode, dsl.LocationId , s.ServiceId, s.ProductClassId, s.ProductId, siL1.itemId, siL1.[version] L1_ItemVersion, siL1.DisplayName L1_DisplayName
       , siL2.ItemId L2_ItemId, siL2.[version] L2_ItemVersion, siL2.DisplayName L2_DisplayName, siL2.ServiceReference 
       , siL3.ItemId L3_ItemId, siL3.[version] L3_ItemVersion, siL3.DisplayName L3_DisplayName,  pcc3.ComponentClass L3_ComponentClass
       , siL4.ItemId L4_ItemId, siL4.DisplayName L4_DisplayName, siL4.ComponentClassId L4_ComponentClassId, pcc4.ComponentClass L4_ComponentClass
	   , siL4.PricePlanId L4_PricePlanId, ppp.PriceList
       , siL5.ItemId L5_ItemId, siL5.DisplayName L5_DisplayName, siL5.ComponentClassId L5_ComponentClassId, pcc5.ComponentClass L5_ComponentClass
	   , cast(0.00 as decimal(12,2)) L3_Amount, cast(0.00 as decimal(12,2)) L4_Amount , cast(coalesce(siL5p.Amount,0.00) as decimal(12,2)) L5_Amount , ppl.PricePlan 
	   , pc4.DisperseCharges , pc4.DisperseWeight, pc4.IsValid, pc4.OfferEndDate
	   , pw5.DisperseAmount, pw5.DisperseWeight DisperseWeightAlloc, pw5.DisperseCharges DisperseChargesAlloc, siL5.ComponentId
    from dbo.DimAccount                                          da
	join FCI                                                     FCI1   on FCI1.DimAccountId = da.DimAccountId
	join dbo.DimServiceLocation                                  dsl    on dsl.DimServiceLocationId = FCI1.DimServiceLocationId
	join [PBBPDW01].Transient.SrvItemX                           siL1   on  siL1.ItemId          = FCI1.ItemId      
																		and siL1.[Version]       = FCI1.ItemVersion         
                                                                        and siL1.ItemId          = siL1.RootItemId  
																	    and siL1.itemStatus      = 'A'

    join [PBBPDW01].Transient.SrvService                         s      on  siL1.ServiceId       = s.ServiceId

	join FCI                                                     FCI2   on FCI2.DimAccountId     = da.DimAccountId
	join [PBBPDW01].Transient.SrvItemX                           siL2   on  siL2.ServiceId       = s.ServiceId
	                                                                    and siL2.PWBParentItemId = siL1.ItemId     
																	    and siL2.itemStatus      = 'A' 
	                                                                    and siL2.ItemId          = FCI2.ItemId         
																		and SiL2.[Version]       = FCI2.ItemVersion 

	join FCI                                                     FCI3   on FCI3.DimAccountId     = da.DimAccountId
    join [PBBPDW01].Transient.SrvItemX                           siL3   on  s.ServiceId          = siL3.ServiceId      
																	    and siL3.PwbParentItemId = siL2.ItemId        
                                                                        and siL3.ParentItemId    is not null     
																	    and siL3.itemStatus      = 'A'  
	                                                                    and siL3.ItemId          = FCI3.ItemId   
																		and SiL3.[Version]       = FCI3.ItemVersion  
 
	join FCI                                                     FCI4   on FCI4.DimAccountId     = da.DimAccountId
    join [PBBPDW01].Transient.SrvItemX                           siL4   on  s.ServiceId          = siL4.ServiceId    
																	    and siL4.PwbParentItemId = siL3.ItemId 
                                                                        and siL4.ParentItemId    is not null     
																	    and siL4.itemStatus      = 'A' 
	                                                                    and siL4.ItemId          = FCI4.ItemId   
																		and SiL4.[Version]       = FCI4.ItemVersion 
 


																		  
	LEFT join FCI                                                  FCI5   on FCI5.DimAccountId     = da.DimAccountId
    LEFT join [PBBPDW01].Transient.SrvItemX                        siL5   on s.ServiceId           = siL5.ServiceId                      
                                                                          and siL5.ParentItemId    is not null     
																          and siL5.PwbParentItemId = siL4.ItemId 
																          and siL5.ItemStatus      = 'A'
	                                                                      and siL5.ItemId          = FCI5.ItemId   
																	      and SiL5.[Version]       = FCI5.ItemVersion 
																		  
	
    left join [PBBPDW01].Transient.SrvitemPrice                    siL3p  on siL3p.ItemId     = siL3.ItemId
                                                                          and @AsOfDate between siL3p.BeginDate and coalesce(siL3p.EndDate,'20551231')
    left join [PBBPDW01].Transient.SrvitemPrice                    siL4p  on siL4p.ItemId     = siL4.ItemId
                                                                          and @AsOfDate between siL4p.BeginDate and coalesce(siL4p.EndDate,'20551231')
    left join [PBBPDW01].Transient.SrvitemPrice                    siL5p on siL5p.ItemId     = siL5.ItemId
                                                                          and @AsOfDate between siL5p.BeginDate and coalesce(siL5p.EndDate,'20551231')

    left join [PBBPDW01].Transient.PrdComponentClass       pcc3   on pcc3.ComponentClassId   = siL3.ComponentClassId  
    left join [PBBPDW01].Transient.PrdComponentClass       pcc4   on pcc4.ComponentClassId   = siL4.ComponentClassId
    LEFT JOIN [PBBPDW01].Transient.PrdProductComponent     pc4    on pc4.ProductComponentId  = siL4.ProductComponentId
    left join [PBBPDW01].Transient.PrdComponentClass       pcc5   on pcc5.ComponentClassId   = siL5.ComponentClassId

 

    left join [PBBPDW01].Transient.PriPrice                pp     on pp.PriceId       = siL4p.PriceId 
    left join [PBBPDW01].Transient.PriPriceList            ppp    on ppp.PriceListId  = pp.PriceListId
    LEFT JOIN [PBBPDW01].Transient.priPricePlan            ppl    ON pp.PricePlanID   = ppl.PricePlanID

    LEFT JOIN [PBBPDW01].Transient.PWB_PackageWeights      pw5    on pw5.ProductOffering    = siL1.Displayname
                                                                          and pw5.PriceList          = ppp.PriceList
																		  and coalesce(pw5.PricePlan,'') =  coalesce(ppl.PricePlan ,'')
																		  and pw5.Component          = siL5.DisplayName
																		  and pw5.PackageComponent   = SiL4.DisplayName
																		 
--	join dbo.DimService 
--  where da.AccountCode = '400354794'
 
)


GO
