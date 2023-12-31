USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_FMFiberCarrierModel]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[PBB_FMFiberCarrierModel] as
with Circuit as
(
select f.Circuit_Id, f.DimFMCircuitId, f.DimServiceLocationId, d.CircuitType, d.CircuitStatus, ad.ServiceLocationFullAddress
from FactFMCircuit f
join DimFMCircuit d on f.DimFMCircuitId = d.DimFMCircuitId
join DimAddressDetails_pbb ad on f.dimservicelocationid = ad.DimServiceLocationId
where CircuitGrade = 'CARRIER - FIBER'
),
NetworkID as
(
select f.FACILITY_Id, f.DimFMFacilityId, f.DimFMCircuitId, d.FacilityName, d.facilitystatus, d.FacilityType 
from FactFMFacility f
join DimFMFacility d on f.DimFMFacilityId = d.DimFMFacilityId
where facilitytype = 'NetworkCircuitId'
),
ONT as
(
select f.EQUIPMENT_Id, f.DimFMEquipmentId, f.DimFMCircuitId, DimFMAddressId, DimAccountId, DimAccountCategoryId, DimServiceLocationId, d.EquipmentLCE, d.EquipmentType, d.EquipmentStatus, d.EquipmentMfgId, d.EquipmentEquipmentType
from FactFMEquipment f
join DimFMEquipment d on f.DimFMEquipmentId = d.DimFMEquipmentId
where EQUIPMENTTYPE IN ('ONT')
),
HasSetTopOrCableCard as
(
select distinct DimAccountID, DimServiceLocationId
--, EquipmentType, EquipmentStatus  
from FactFMEquipment f
join DimFMEquipment d on f.DimFMEquipmentId = d.DimFMEquipmentId
where EQUIPMENTTYPE IN ('set top box','cable card')
and EquipmentStatus = 'Active'
)

select circuit.Circuit_Id, 'FIBER CARRIER' CircuitType, Circuit.CircuitStatus, circuit.ServiceLocationFullAddress, ONT.EquipmentMfgId ONT, ONT.EquipmentEquipmentType ONTType, NetworkID.FacilityName NetworkID
from Circuit
left join ONT on circuit.DimFMCircuitId = ONT.DimFMCircuitId
left join NetworkID on Circuit.DimFMCircuitId = Networkid.DimFMCircuitId



--from ProductAnalysis PA
--join Equipment E on PA.DimAccountId = E.DimAccountId and PA.DimServiceLocationID = E.DimServiceLocationId
--where (AccountGroupCode like 'BRI%' or AccountGroupCode like 'CPC%')
--and CableCategory in ('VB','VE')



GO
