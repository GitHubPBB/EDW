USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ProductAnalysisWFM]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [dbo].[PBB_ProductAnalysisWFM] as
select P.*, 
[CircuitID]
      ,[DimCircuitId]
      ,[FMAddressID]
      ,[CircuitStatus]
      ,[CircuitType]
      ,[CircuitGrade]
      ,[Latitude]
      ,[Longitude]
      ,[NetworkCircuitID]
      ,[FacilityName]
      ,[facilitystatus]
      ,[FacilityType]
      ,[EQUIPMENT_Id]
      ,[EquipmentLCE]
      ,[EquipmentType]
      ,[EquipmentStatus]
      ,[EquipmentEquipmentType]
      ,[Serial]
      ,[TOR]
      ,[Switch]
      ,[Port]
      ,[IP Address]
      ,[PlumePod]
      ,[SpeedTier]
      ,[Plume Router]
      ,[Data Modem]
      ,[Set Top Box]
      ,[Residential Gateway]
      ,[ATA],
case when E.CircuitID is null then 'N' else 'Y' end as CircuitExists
from PBB_ProductAnalysisDetails P
left join PBB_FMNetworkModelAnalysis E on P.AccountCode = E.AccountCode and P.LocationId = E.Omnia_SrvItemLocationID 
	and (E.EQUIPMENT_Id is not null or [Plume Router] is not null or [Data Modem] is not null or [Residential Gateway] is not null or ata is not null)
GO
