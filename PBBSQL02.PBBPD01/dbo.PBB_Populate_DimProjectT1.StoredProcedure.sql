USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimProjectT1]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- carrie turner is a SME

-- =============================================
-- Author:		Todd Boyer
-- Create date: 2023-10-11
-- Description:	Load DimProjectT1
-- Version:     1.0	Initial Version
--
-- =============================================
 
CREATE PROCEDURE [dbo].[PBB_Populate_DimProjectT1]
AS


BEGIN

DECLARE @MaxKey smallint=0;
DECLARE @RunDatetime datetime = getdate();


SELECT @MaxKey = coalesce(max(DimProjectKey),0) FROM [PBBPDW01].dbo.DimProjectT1  ;
 

-- NOTE:  need external market projects!!!
-- truncate table [PBBPDW01].dbo.DimProject

-- OMNIA PROJECTS
DROP TABLE if exists #TempSourceProjects ;

WITH 
SourceProjects 

	AS (
	SELECT a.*
	 , CASE WHEN dp.DimProjectKey is null then 'N' else 'Y' end ProjectExists
	 , Row_Number() over (partition by CASE WHEN dp.DimProjectKey is null then 'N' else 'Y' end  order by a.ProjectCode) Row_Num
	  FROM (
			SELECT coalesce(wob.chr_WO_number  ,wob.chr_name) COLLATE DATABASE_DEFAULT ProjectCode
			 , max(wob.chr_name) chr_name
			 , max(coalesce(upper(replace(wob.chr_name,'PC-','')) ,'Unknown') )            ProjectName
			 , max(coalesce(case when isnull(cus_serviceabledate,'1/1/2021') < '1/1/2021' or chr_name not like '%PROJECT%' then 'LEGACY' else upper(replace(chr_name,'PC-','')) end ,'Unknown')) CalcProjectName
			 , max(coalesce(case when isnull(cus_serviceabledate,'1/1/2021') < '1/1/2021' or chr_name not like '%PROJECT%' then 'LEGACY' else 'PROJECT' end ,'Unknown')) AddressType
			 , max(smb.Value) CompetitiveStatus
			 , max(left(pbb_LocationIsServiceable,1)) IsServiceable
			 , min(case when pbb_LocationServiceableDate='1900-01-01' then '99991231' 
						when pbb_LocationServiceableDate=''           then '99991231' 
						else cast(coalesce(pbb_LocationServiceableDate,'99991231') as date) end ) LocationServiceableDate
			 , min(cast(coalesce(cus_serviceabledate,'99991231') as date)) ProjectServiceableDate
			 , max(CASE WHEN pbb_Fiber = 'Active-E' THEN 'Y' ELSE 'N' END) HasFiberActiveE
			 , max(CASE WHEN pbb_Fiber = 'GPON'     THEN 'Y' ELSE 'N' END) HasFiberGPON

		   FROM  pbbsql01.pbb_p_mscrm.dbo.chr_workorder               wob 
		   LEFT JOIN [OMNIA_EPBB_P_PBB_DW].dbo.DimServiceLocation_pbb dsl  on replace(dsl.pbb_LocationProjectCode,'PC-','') COLLATE DATABASE_DEFAULT  = upper(replace(wob.chr_name,'PC-',''))  COLLATE DATABASE_DEFAULT 
																			and coalesce(pbb_LocationProjectCode,'') <> ''
																			and pbb_LocationProjectCode <> 'Unknown'
																			and pbb_LocationProjectCode <> 'PC-Duplicate - Do Not Use'

   
		   LEFT JOIN [PBBPDW01].dbo.PBB_STringMapBaseJoin('chr_workorder','cus_competitivetype')         smb  on smb.JoinOnValue = wob.cus_CompetitiveType 
 

		  WHERE 1=1
			--and dp.DimProjectId is  NOT  null

		  GROUP by coalesce(wob.chr_WO_Number  ,wob.chr_name) COLLATE DATABASE_DEFAULT
		  ) a
	LEFT JOIN [PBBPDW01].dbo.DimProjectT1                        dp   on dp.Projectcode  = trim(a.chr_name) COLLATE DATABASE_DEFAULT


)
SELECT * into #TempSourceProjects FROM SourceProjects 
 order by 1;

 /*
 select * from #TempSourceProjects order by chr_name 
 select * from #TempSourceProjects where ProjectServiceableDate ='99991231' order by chr_name
 select * from #TempSourceProjects where ProjectCode ='WO-00101'
 select * from dbo.DimProject order by DimProjectNaturalKey;
 select * from dbo.DimProject order by LocationServiceableDAte desc
 select * from dbo.DimProject order by ProjectServiceableDAte desc
*/


-- select * from SourceMarkets order by Row_num
-- declare @MaxKey int = 100, @Rundatetime date= getdate(); SELECT @MaxKey = coalesce(max(DimProjectKey),0) FROM [PBBPDW01].dbo.DimProjectT1  ;
INSERT INTO [PBBPDW01].dbo.DimProjectT1
-- declare @MaxKey int = 100, @Rundatetime date= getdate(); SELECT @MaxKey = coalesce(max(DimProjectKey),0) FROM [PBBPDW01].dbo.DimProjectT1  ;
SELECT @MaxKey+Row_Num   DimProjectId
     , ProjectCode       DimProjectNaturalKey
	 , 'coalesce(chr_WO_Number  ,chr_name)' DimProjectNaturalKeyFields
     , chr_name ProjectCode      
     , ProjectName
	 , CalcProjectName
	 , AddressType
	 , LocationServiceableDate
	 , ProjectServiceableDate
	 , HasFiberActiveE
	 , HasFiberGPON
	 , CompetitiveStatus
	 , 0 DimMarketId
	 , '' DimMarketNaturalKey 
	 , 'Omnia DW' MetaSourceSystemCode
	 , @RunDatetime MetaInsertDatetime
	 , @RunDatetime MetaUpdateDatetime
	 , 'I' MetaOperationCode
	 , 0 MetaDataQualityStatusId
  FROM #TempSourceProjects
 WHERE Chr_name NOT in (SELECT ProjectCode COLLATE DATABASE_DEFAULT FROM dbo.DimProjectT1)
   AND ProjectCode NOT in (SELECT DimProjectNaturalKey FROM dbo.DimProjectT1)
   AND ProjectExists = 'N' COLLATE DATABASE_DEFAULT
   order by ProjectName
;
 
 -- CHANGE
  
  -- Declare @RunDatetime date = getdate();
  UPDATE [PBBPDW01].dbo.DimProjectT1
     SET MetaUpdateDatetime = @RunDatetime
	   , MetaOperationCode = 'U'
	   , LocationServiceableDate = sm.LocationServiceableDate
	   , ProjectServiceableDate  = case when sm.ProjectServiceableDate='99991231' then dm.ProjectServiceableDate else sm.ProjectServiceableDate end
	   , HasFiberActiveE         = sm.HasFiberActiveE
	   , HasFiberGPON            = sm.HasFiberGPON
	   , AddressType             = sm.AddressType
	   , CompetitiveType         = sm.CompetitiveStatus
	   , ProjectName             = sm.ProjectName
	   , CalcProjectName         = sm.CalcProjectName
	   , ProjectCode             = sm.chr_name

	-- select DimProjectId, dm.DimProjectNaturalKey, sm.ProjectCode, dm.LocationServiceableDate, sm.LocationServiceableDate, dm.ProjectServiceableDate, sm.ProjectServiceableDate, dm.HasFiberActiveE, sm.HasFiberActiveE, dm.HasFiberGPON, sm.HasFiberGPON, dm.AddressType, sm.AddressType, dm.ProjectName,sm.ProjectName, dm.ProjectCode, sm.Chr_name
    FROM [PBBPDW01].dbo.DimProjectT1 dm
    JOIN #TempSourceProjects       sm on dm.DimProjectNaturalKey  COLLATE DATABASE_DEFAULT = sm.ProjectCode COLLATE DATABASE_DEFAULT 
   WHERE 
         dm.LocationServiceableDate <> sm.LocationServiceableDate
      OR (coalesce(dm.ProjectServiceableDate,'99991231')  <> coalesce(sm.ProjectServiceableDate,'99991231') and sm.ProjectServiceableDate <> '99991231')
	  OR dm.HasFiberActiveE     COLLATE DATABASE_DEFAULT     <> sm.HasFiberActiveE    COLLATE DATABASE_DEFAULT
	  OR dm.HasFiberGPON        COLLATE DATABASE_DEFAULT     <> sm.HasFiberGPON       COLLATE DATABASE_DEFAULT
	  OR dm.AddressType         COLLATE DATABASE_DEFAULT     <> sm.AddressType        COLLATE DATABASE_DEFAULT
	  OR dm.ProjectName         COLLATE DATABASE_DEFAULT     <> sm.ProjectName        COLLATE DATABASE_DEFAULT
	  OR dm.CompetitiveType     COLLATE DATABASE_DEFAULT     <> sm.CompetitiveStatus  COLLATE DATABASE_DEFAULT
	  OR dm.ProjectCode         COLLATE DATABASE_DEFAULT     <> sm.Chr_Name           COLLATE DATABASE_DEFAULT

;
 
 
END
GO
