USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_FMNetworkModelAnalysis_BV]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [rpt].[PBB_FMNetworkModelAnalysis_BV]
AS
SELECT [CircuitID] 'Cir-ID'
      ,[CircuitStatus] 'Cir-Status'
      ,[CircuitType] 'Cir-Type'
      ,[CircuitGrade] 'Cir-Grade'
      ,[Omnia_SrvItemLocationID] 'Addr-LocationID'
      ,[AccountName] 'Acct-Name'
      ,[AccountCode] 'Acct-Code'
      ,[AccountStatus] 'Acct-Status'
      ,[AccountGroupCode] 'Acct-GroupCode'
      ,[ServiceLocationFullAddress] 'Addr-FullAddress'
      ,[HouseNumber] 'Addr-HouseNumber'
      ,[Street] 'Addr-Street'
      ,[City] 'Addr-City'
      ,[STATE] 'Addr-State'
      ,[Zip] 'Addr-Zip'
      ,[Latitude] 'Addr-Latitude'
      ,[Longitude] 'Addr-Longitude'
      ,[Cabinet] 'Addr-Cabinet'
	  --Need Project
      ,[NetworkCircuitID] 'NC-ID'
      ,[FacilityName] 'NC-Name'
      ,[facilitystatus] 'NC-Status'
      ,[FacilityType] 'NC-Type'
      ,[EQUIPMENT_Id] 'ONT-ID'
      ,[EquipmentLCE] 'ONT-LCE'
      ,[EquipmentType] 'ONT-Type'
      ,[EquipmentStatus] 'ONT-Status'
      ,[EquipmentEquipmentType] 'ONT-EqpType'
      ,[Serial] 'ONT-SerialNumber'
      ,[TOR] 
      ,[Switch] 
      ,[Port]
      ,[IP Address]
	  ,[SpeedTier]
      ,[PlumePod] 'Eqp-HasSmartHome'
      ,[Plume Router] 'Eqp-PlumeRouter'
      ,[Data Modem] 'Eqp-DataModem'
      ,[Set Top Box] 'Eqp-SetTopBox'
      ,[Residential Gateway] 'Eqp-ResidentialGateway'
      ,[ATA] 'Eqp-ATA'
  FROM [dbo].[PBB_FMNetworkModelAnalysis]
GO
