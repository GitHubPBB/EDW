USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FMNetworkModelAnalysis_Old]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[PBB_FMNetworkModelAnalysis_Old]
AS
WITH Address_details
AS (
SELECT f.Circuit_Id AS CircuitID
		,f.DimFMCircuitId AS DimCircuitId	
		,f.DimaccountID AS DimAccountID
		,[FM AddressID] AS FMAddressID
		,f.DimServiceLocationId
		,cast ([Omnia SrvItemLocationID] as Int) as Omnia_SrvItemLocationID
		,d.CircuitStatus
		,d.CircuitType
		,d.CircuitGrade
		,ad.ServiceLocationFullAddress
		,ad.AccountName
		,ad.AccountCode
		,act.AccountStatus
		,ad.[House Number]
		,ad.Street
		,ad.City
		,ad.STATE
		,ad.[Postal Code] AS Zip
		,ad.Latitude
		,ad.Longitude
		,ad.cabinet
	FROM FactFMCircuit f
	JOIN DimFMCircuit d ON f.DimFMCircuitId = d.DimFMCircuitId
	JOIN DimAddressDetails_pbb ad ON f.dimservicelocationid = ad.DimServiceLocationId
	JOIN Dimaccount act ON f.dimaccountid = act.DimAccountId
	WHERE d.CircuitGrade  IN ( 'CARRIER - FIBER' ,'FTTH CARRIER CIRCUIT','HFC CARRIER')
	)
,PlumPod as(
SELECT 
cast(Locationid as INT) as Locationid
,CASE WHEN sum(IsSmartHome + IsSmartHomePod) >= 1 THEN 'Y' ELSE 'N' END AS [PlumePod] 
FROM  [PBB_ServiceLocationItem]
WHERE ItemStatus in ('A','N')
GROUP BY Locationid,IsSmartHome
)

,SpeedTier AS
(SELECT distinct  
cast(Locationid as INT) as Locationid
,CASE 
WHEN (DownloadMB >'0'  or UploadMB>'0') then concat(DownloadMB,'MB',' / ',UploadMB,'MB') 
else Null end as SpeedTier
FROM  [PBB_ServiceLocationItem]
where ItemStatus in ('A','N')
and Component like '%Extreme Internet%'
)
,Facility_details
AS (
	SELECT f.FACILITY_Id AS FacilitID
		,f.DimFMCircuitId
		,f.DimFMFacilityId
		,d.FacilityName
		,SUBSTRING(REVERSE(d.FacilityName), 1, 1) Port
		,d.facilitystatus
		,d.FacilityType
 FROM FactFMFacility f
 JOIN DimFMFacility d ON f.DimFMFacilityId = d.DimFMFacilityId
 WHERE facilitytype = 'NetworkCircuitId'
 )
,Equipment_details
AS (
	SELECT f.EQUIPMENT_Id
		,f.DimFMEquipmentId
		,f.DimFMCircuitId
		,DimFMAddressId
		,DimAccountId
		,DimAccountCategoryId
		,DimServiceLocationId
		,d.EquipmentLCE
		,d.EquipmentType
		,d.EquipmentStatus
		,replace(d.EquipmentMfgId, '"', '') AS SerialNumber
		,d.EquipmentEquipmentType
		,et.model
	FROM FactFMEquipment f
	JOIN DimFMEquipment d ON f.DimFMEquipmentId = d.DimFMEquipmentId
	join pbbsql01.omnia_epbb_p_pbb_cm.dbo.equipmenttype et on d.EquipmentEquipmentType = et.name
where et.class = 'ONT'	
	)
,PlumDevices AS (
		SELECT *
		FROM (
			SELECT f.DimFMCircuitId
				,CASE 
					WHEN et.class = 'Data Modem'
						AND manufacturer = 'Plume'
						THEN 'Plume Router'
					ELSE et.class
					END AS class
				,STRING_AGG(EquipmentMfgId, ' | ') EqpMfgID
			FROM FactFMEquipment f
			JOIN DimFMEquipment d ON f.DimFMEquipmentId = d.DimFMEquipmentId
			JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.equipmenttype et ON d.EquipmentEquipmentType = et.name
			WHERE et.class <> 'ONT'
				AND equipmentstatus = 'ACTIVE'
				AND DimFMCircuitId <> 0
			GROUP BY f.DimFMCircuitId
				,CASE 
					WHEN et.class = 'Data Modem'
						AND manufacturer = 'Plume'
						THEN 'Plume Router'
					ELSE et.class
					END
			) EQP
		PIVOT(MIN(EqpMfgID) FOR class IN (
					[ATA]
					,[Data Modem]
					,[Plume Router]
					,[Residential Gateway]
					,[Set Top Box]
					)) AS pvt
					)
SELECT distinct 
     ad.CircuitID 
	,ad.DimCircuitId
	,ad.DimAccountID 
	,ad.FMAddressID 
	,ad.CircuitStatus 
    ,ad.CircuitType
    ,ad.CircuitGrade 
	,ad.DimServiceLocationId 
    ,ad.Omnia_SrvItemLocationID 
	,ad.AccountName
	,ad.AccountCode
	,ad.Accountstatus as AccountStatus
	,ad.ServiceLocationFullAddress 
	,ad.[House Number] as HouseNumber
	,ad.Street
	,ad.City 
	,ad.STATE 
	,ad.Zip 
	,ad.Latitude 
	,ad.Longitude 
	,trim(isnull(nullif(ad.Cabinet, ''), 'Unknown')) AS  Cabinet 
	,fd.FacilitID as NetworkCircuitID
    ,fd.FacilityName
    ,fd.facilitystatus
    ,fd.FacilityType
	,ed.EQUIPMENT_Id
	,ed.EquipmentLCE
	,ed.EquipmentType
	,ed.EquipmentStatus
    ,ed.EquipmentEquipmentType
	,ed.SerialNumber AS Serial
	,NULL AS TOR
	,NULL AS Switch
	,fd.Port
	,NULL AS [IP Address]
	,pp.PlumePod
	,st.SpeedTier
	,pd.[Plume Router]
	,pd.[Data Modem]
	,pd.[Set Top Box]
	,pd.[Residential Gateway]
	,pd.[ATA]

from Address_details ad
JOIN Facility_details fd ON  ad.DimCircuitId = fd.DimFMCircuitId
JOIN Equipment_details ed  ON ad.DimCircuitId = ed.DimFMCircuitId
LEFT JOIN PlumPod  pp ON ad.Omnia_SrvItemLocationID = pp.Locationid
LEFT JOIN SpeedTier st ON ad.Omnia_SrvItemLocationID =st.Locationid
LEFT JOIN PlumDevices pd  ON ad.DimCircuitId = pd.DimFMCircuitId

GO
