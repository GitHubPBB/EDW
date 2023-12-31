USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PWB_AccountServiceHier_AsOf]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[PWB_AccountServiceHier_AsOf] as
select distinct a.AccountCode, siL1.LocationId , s.ServiceId, s.ProductClassId, s.ProductId, siL1.itemId, siL1.DisplayName L1_DisplayName
     , siL2.ItemId L2_ItemId, siL2.DisplayName L2_DisplayName, siL2.ServiceReference
     , siL3.ItemId L3_ItemId, siL3.DisplayName L3_DisplayName
     , siL4.ItemId L4_ItemId, siL4.DisplayName L4_DisplayName, siL4.ComponentClassId L4_ComponentClassId, pcc.ComponentClass L4_ComponentClass
	 , siL4.PricePlanId L4_PricePlanId, ppp.PriceList
	 , NULL L5_ItemId, NULL L5_DisplayName, NULL L5_ComponentClassId, NULL L5_ComponentClass
    -- , siL5.ItemId L5_ItemId, siL5.DisplayName L5_DisplayName, siL5.ComponentClassId L5_ComponentClassId
	 , cast(coalesce(siL3p.Amount,0.00) as decimal(12,2)) L3_Amount, cast(coalesce(siL4p.Amount,0.00) as decimal(12,2)) L4_Amount , cast(0.00 as decimal(12,2)) L5_Amount, ppl.PricePlan 
	 , pc4.DisperseCharges , pc4.DisperseWeight, pc4.IsValid, pc4.OfferEndDate
	 , 0.00 DisperseAmount, 0 DisperseWeightAlloc, 0 DisperseChargesAlloc, NULL ComponentId
  from PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.CusAccount           a    
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.srvservice           s      on  a.AccountId     = s.AccountId
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem              siL1   on  s.ServiceId     = siL1.Serviceid                 
                                                                      and siL1.ItemId     = siL1.RootItemId    
																	  and siL1.itemStatus = 'A'
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem              siL2   on  s.ServiceId     = siL2.ServiceId
                                                                      and siL2.PWBParentItemId = siL1.ItemId           
																	  and siL2.ParentItemID is null         
																	  and siL2.itemStatus = 'A'
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem              siL3   on  s.ServiceId     = siL3.ServiceId                 
                                                                      and sil3.ParentItemId is not null     
																	  and siL3.PwbParentItemId = siL2.ItemId 
																	  and siL3.ItemStatus = 'A'
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvitemPrice    siL3p  on siL3p.ItemId     = siL3.ItemId
                                                                      and siL3p.EndDate is null
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem              siL4   on  s.ServiceId     = siL4.ServiceId                 
                                                                      and sil4.ParentItemId is not null     
																	  and siL4.PwbParentItemId = siL3.ItemId 
																	  and siL4.ItemStatus = 'A'
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PrdComponentClass pcc  on pcc.ComponentClassId = siL4.ComponentClassId
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvitemPrice    siL4p  on siL4p.ItemId     = siL4.ItemId
                                                                      and siL4p.EndDate is null
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PriPrice        pp     on pp.PriceId       = siL4p.PriceId 
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PriPriceList    ppp    on ppp.PriceListId  = pp.PriceListId
  LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.priPricePlan    ppl    ON pp.PricePlanID   = ppl.PricePlanID
  LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PrdProductComponent pc4    on pc4.ProductComponentId = siL4.ProductComponentId
 
-- where s.accountid = @Acct 

 UNION

  select distinct a.AccountCode, siL1.LocationId, s.ServiceId , s.ProductClassId, s.ProductId, siL1.itemId, siL1.DisplayName L1_DisplayName
     , siL2.ItemId L2_ItemId, siL2.DisplayName L2_DisplayName, siL2.ServiceReference
     , siL3.ItemId L3_ItemId, siL3.DisplayName L3_DisplayName
     , siL4.ItemId L4_ItemId, siL4.DisplayName L4_DisplayName, siL4.ComponentClassId L4_ComponentClassId, NULL L4_ComponentClass
	 , siL4.PricePlanId L4_PricePlanId, ppp.PriceList
     , siL5.ItemId L5_ItemId, siL5.DisplayName L5_DisplayName, siL5.ComponentClassId L5_ComponentClassId, pcc.ComponentClass L5_ComponentClass
	 , cast(0.00 as decimal(12,2)) L3_Amount, 0.00 L4_Amount, cast(coalesce(siL5p.Amount,0.00) as decimal(12,2)) L5_Amount, ppl.PricePlan 
	 , pc4.DisperseCharges , pc4.DisperseWeight, pc4.IsValid, pc4.OfferEndDate
	 , pw5.DisperseAmount, pw5.DisperseWeight DisperseWeightAlloc, pw5.DisperseCharges DisperseChargesAlloc, siL5.ComponentId
  from PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.srvservice        s
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.CusAccount        a      on  a.AccountId     = s.AccountId
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem           siL1   on  s.ServiceId     = siL1.Serviceid                 
                                                                   and siL1.ItemId     = siL1.RootItemId    
																   and siL1.itemStatus = 'A'
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem           siL2   on  s.ServiceId     = siL2.ServiceId
                                                                   and siL2.PWBParentItemId = siL1.ItemId           
																   and siL2.ParentItemID is null         
																   and siL2.itemStatus = 'A'
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem           siL3   on  s.ServiceId     = siL3.ServiceId                 
                                                                   and sil3.ParentItemId is not null     
																   and siL3.PwbParentItemId = siL2.ItemId 
																   and siL3.ItemStatus = 'A'
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvitemPrice siL3p  on  siL3p.ItemId    = siL3.ItemId
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem           siL4   on  s.ServiceId     = siL4.ServiceId                 
                                                                   and sil4.ParentItemId is not null     
																   and siL4.PwbParentItemId = siL3.ItemId 
																   and siL4.ItemStatus = 'A'
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvitemPrice siL4p  on  siL4p.ItemId    = siL4.ItemId
  join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvItem           siL5   on  s.ServiceId     = siL5.ServiceId                      
                                                                   and sil5.ParentItemId is not null     
																   and siL5.PwbParentItemId = siL4.ItemId 
																   and siL5.ItemStatus = 'A'
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.SrvitemPrice siL5p  on siL5p.ItemId     = siL5.ItemId
                                                                   and siL5p.EndDate is null
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PrdComponentClass pcc on pcc.ComponentClassId = siL5.ComponentClassId
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PriPrice     pp     on pp.PriceId       = siL4p.PriceId 
  left join PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PriPriceList ppp    on ppp.PriceListId  = pp.PriceListId
  LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.priPricePlan ppl    ON pp.PricePlanID   = ppl.PricePlanID
  LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PrdProductComponent pc4    on  pc4.ProductComponentId = siL4.ProductComponentId
  LEFT JOIN PBBSQL01.[OMNIA_EPBB_P_PBB_CM].dbo.PWB_PackageWeights  pw5    on  pw5.ProductOffering    = siL1.Displayname
                                                                          and pw5.PriceList          = ppp.PriceList
																		  and coalesce(pw5.PricePlan,'') =  coalesce(ppl.PricePlan ,'')
																		  and pw5.Component          = siL5.DisplayName
																		  and pw5.PackageComponent   = SiL4.DisplayName
 
GO
