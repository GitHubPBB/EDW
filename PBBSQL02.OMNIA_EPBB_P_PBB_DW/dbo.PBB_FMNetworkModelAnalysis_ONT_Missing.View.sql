USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FMNetworkModelAnalysis_ONT_Missing]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  VIEW [dbo].[PBB_FMNetworkModelAnalysis_ONT_Missing]
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
		,ad.AccountGroupCode
	FROM FactFMCircuit f
	JOIN DimFMCircuit d ON f.DimFMCircuitId = d.DimFMCircuitId
	JOIN DimAddressDetails_pbb ad ON f.dimservicelocationid = ad.DimServiceLocationId
	JOIN Dimaccount act ON f.dimaccountid = act.DimAccountId
	WHERE CircuitGrade  IN ( 'CARRIER - FIBER' ,'FTTH CARRIER CIRCUIT','HFC CARRIER')
	AND d.CircuitStatus = 'ACTIVE'
	AND act.AccountStatus IN (
		'Active'
		,'Non-Pay'
		))

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
 WHERE facilitytype = 'NetworkCircuitId')

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

SELECT distinct 
     Address_details.CircuitID
     ,Address_details.CircuitStatus
    ,Address_details.CircuitType
	,Address_details.AccountName
	,Address_details.AccountCode
	,Address_details.Accountstatus
	,Address_details.AccountGroupCode
	,Address_details.ServiceLocationFullAddress
	,Facility_details.FacilitID
    ,Facility_details.FacilityName
    ,Facility_details.facilitystatus
    ,Facility_details.FacilityType
	,Equipment_details.EQUIPMENT_Id
	,SerialNumber 
	,Equipment_details.EquipmentLCE
	,Equipment_details.EquipmentType
	,Equipment_details.EquipmentStatus
    ,Equipment_details.EquipmentEquipmentType
from Address_details
LEFT JOIN Facility_details ON  Address_details.DimCircuitId = Facility_details.DimFMCircuitId
LEFT JOIN Equipment_details ON Address_details.DimCircuitId = Equipment_details.DimFMCircuitId
AND SerialNumber IS NULL
--and EQUIPMENT_Id = 264709
	
GO
