USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ProjectServiceLocation]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_ProjectServiceLocation] as
WITH 
  ProjectLocations AS

 (	SELECT distinct dp.DimProjectId, dp.DimProjectNaturalKey, upper(csl.cus_ProjectCode) cus_ProjectCode, dm.ReportingMarketName, dm.AccountMarketName
            , csl.chr_MasterLocationId LocationId, csl.Cus_CabinetNameName, csl.cus_CabinetName --, csl.cus_Marketable, csl.cus_PremiseType
			, case when dsl.ServiceLocationRegion_WireCenter like '%Urban%' then 'Urban' else 'Rural' end AddressType
			, case when csl.cus_Serviceable = '972050000'  then 'Y' else 'N' end ServiceableAddress
			, trim(concat(dsl.ServiceLocationFullAddress,' ', dsl.ServiceLocationRoom)) ServiceLocationFullAddress
			, dslp.pbb_Marketable
			, dslp.pbb_PremiseType
			, csl.chr_RegionIdName
			, left(csl.chr_RegionIdName,3) RegionAbbr

		FROM Transient.chr_servicelocation                   csl  
		JOIN [PBBPDW01].dbo.DimProject                       dp   on dp.ProjectCode = csl.cus_ProjectCode   COLLATE DATABASE_DEFAULT
		JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation    dsl  on dsl.locationid = csl.chr_masterlocationid
		LEFT JOIN [PBBPDW01].dbo.DimMarket                   dm   on dm.DimMarketId = dp.DimMarketId
		LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocationV2_pbb dslp on dslp.LocationId = dsl.LocationId
		WHERE chr_ServiceLocationId is not null
			AND cus_ProjectCode <> 'PC-Duplicate - Do Not Use' 
			AND cus_ProjectCode <> 'PC-TEST/INTERNAL ONLY-EXCLUDED FROM SERVICEABLE PASSINGS' 
			AND cus_ProjectCode <> 'UNKNOWN'
			AND cus_ProjectCode <> 'PC-UNIVERSAL'
			AND cus_ProjectCode <> 'PC-234'
			AND cus_ProjectCode <> 'PC-LEGACY'
	 )       
 SELECT *   FROM ProjectLocations;
GO
