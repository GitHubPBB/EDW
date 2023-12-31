USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PWB_PackageWeightsBalancedComponent_tb]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[PWB_PackageWeightsBalancedComponent_tb] AS 
SELECT pw.ProductOffering
     , pw.PackageComponent
	 , pw.PackageComponentCode
	 , pw.OfferEndDate
	 , pw.PriceList
	 , pw.PricePlan
	 , pw.StandardRate
	 , pw.DisperseCharges
	 , pw.ComponentCode
	 , pw.Component
	 , case when allocateable ='Y' AND DispersedAllFlag='N' and DisperseWeight=1 then pw.DisperseAmount + pwb.DisperseBalance   
	        when allocateable ='Y' AND DispersedAllFlag='N' and DisperseWeight=0 and ComponentCount=1 then pw.DisperseAmount + pwb.DisperseBalance   
	        else pw.DisperseAmount end DisperseAmount
	 , pw.DisperseWeight
     , pcc.ComponentClass
     , row_number() over (partition by pw.ProductOffering, pw.PackageComponent, pw.PackageComponentCode, pw.PriceList, coalesce(pw.PricePlan,'') order by DisperseAmount desc) row_num
	 , Allocateable
  FROM dbo.PWB_PackageWeights                         pw  
  JOIN dbo.PWB_PackageWeightsBalanced_tb pwb               on  pw.ProductOffering        = pwb.ProductOffering
                                                           and pw.PackageComponent       = pwb.PackageComponent
											               and pw.PackageComponentCode   = pwb.PackageComponentCode
											               and pw.PriceList              = pwb.PriceList
											               and coalesce(pw.PricePlan,'') = coalesce(pwb.PricePlan,'')
											               and pw.StandardRate           = pwb.StandardRate
  JOIN [PBBPDW01].transient.PrdComponent        pc  WITH (NOLOCK) on pc.ComponentCode       = pw.ComponentCode
  JOIN [PBBPDW01].transient.PrdComponentClass   pcc WITH (NOLOCK) on pcc.ComponentClassId   = pc.ComponentClassId
 -- JOIN PBBSQL01.OMNIA_EPBB_P_PBB_CM.dbo.PrdComponent        pc  WITH (NOLOCK) on pc.ComponentCode       = pw.ComponentCode
 -- JOIN PBBSQL01.OMNIA_EPBB_P_PBB_CM.dbo.PrdComponentClass   pcc WITH (NOLOCK) on pcc.ComponentClassId   = pc.ComponentClassId
 --WHERE pw.DisperseAmount <> 0.00
GO
