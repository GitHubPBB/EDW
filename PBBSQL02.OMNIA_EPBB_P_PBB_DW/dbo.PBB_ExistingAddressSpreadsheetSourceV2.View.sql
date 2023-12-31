USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ExistingAddressSpreadsheetSourceV2]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
select * from dbo.[PBB_ExistingAddressSpreadsheetSourceV2] where LocationComment like '%DRILL%'
*/

CREATE VIEW [dbo].[PBB_ExistingAddressSpreadsheetSourceV2] 
as
	select [pbb_SrvLocation].[LocationID] as [UseLocationID]
		 ,convert(date,[chr_ServiceLocationBase].[CreatedOn]) as CreatedOn
		 ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(COALESCE(aj.HouseNum,''))) + ' ' + RTRIM(LTRIM(COALESCE(aj.HouseNumSuffix,''))) + ' ' + RTRIM(LTRIM(COALESCE(LTRIM(RTRIM(aj.Direction)),''))) + ' ' + COALESCE(aj.StreetName,'') + ' ' + RTRIM(LTRIM(COALESCE(LTRIM(RTRIM(aj.StreetSuffix)),''))) + ' ' + RTRIM(LTRIM(COALESCE(LTRIM(RTRIM(aj.PostDirectional)),''))) + ' ' + case
																																																																												  when aj.ApartmentNum is not null
																																																																													  and LEN(aj.ApartmentNum) > 0
																																																																												  then COALESCE('APT ' + aj.ApartmentNum,'') else ''
																																																																											   end + ' ' + COALESCE(aj.Room,''),'  ',' '),'  ',' '),'  ',' '))) AS FullStreetAddress
		 ,chr_housenumber as HouseNumber
		 ,chr_housesuffix as HouseSuffix
		 ,chr_predirectional as PreDirectional
		 ,chr_street as Street
		 ,aj.StreetSuffix as StreetSuffix
		 ,chr_postdirectional as PostDirectional
		 ,chr_apartment as Apartment
		 ,chr_room as Room
		 ,chr_floor as [Floor]
		 ,chr_city as City
		 ,chr_stateorprovince as [State]
		 ,chr_postalcode as PostalCode
		 ,chr_postalcodeplus4 as PostalCodePlus4
		 ,isnull(w.[chr_name],'') as [LocationComment]
		 ,isnull([chr_ServiceLocationBase].[cus_ProjectCode],'') as [ProjectCodeOld]
		 --,isnull([chr_ServiceLocationBase].[cus_Project], '') as [ProjectCodeOld]
		 ,c.cus_name as [Cabinet]
		 ,cus_cabinet as [CabinetOld]
		 ,TaxAreaCode
		 ,sz.[Zone]
		 ,r.chr_Name as [Region]
		 ,chr_latitude as Latitude
		 ,chr_longitude as Longitude
		 ,chr_censusstatecode as CensusStateCode
		 ,chr_censuscountycode as CensusCountyCode
		 ,chr_censustract as CensusTract
		 ,chr_censusblock as CensusBlock
		 ,isnull([Serviceable].[value],'') as [Serviceable]
		 ,isnull([Data].value,'') [Data]
		 ,isnull([CATV].[value],'') as [CATV]
		 ,isnull([CATVDigital].[value],'') as [CATVDigital]
		 ,isnull([Phone].[value],'') as [Phone]
		 ,isnull([FixedWireless].[value],'') as [FixedWireless]
		 ,isnull([Fiber].[value],'') [Fiber]
		 ,isnull([DefaultNetworkDelivery].[value],'') as [DefaultNetworkDelivery]
		 ,isnull([FundType].[value],'') as [FundType]
		 ,isnull([chr_ServiceLocationBase].[cus_FundTypeID],'') as [FundTypeID]
		 ,cus_ExternalID as ExternalID
		 ,isnull([chr_ServiceLocationBase].[cus_VetroCircuitID],'') as [VetroCircuitID]
		 ,[chr_ServiceLocationBase].[cus_LoadDate] as [LoadDate]
	from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[SrvLocation] AS [pbb_SrvLocation]
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[TaxTaxArea] ta on ta.TaxAreaID = pbb_SrvLocation.TaxAreaID
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].ADDRESSJoin aj on aj.SrvLocation_LocationID = pbb_SrvLocation.LocationID
		left join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].SrvLocationZone sz on sz.LocationZoneID = pbb_SrvLocation.LocationZoneID
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].[chr_servicelocationBase] AS [chr_ServiceLocationBase] ON [pbb_SrvLocation].[LocationID] = [chr_ServiceLocationBase].[chr_masterlocationId]
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].[cus_cabinetBase] c on c.cus_cabinetId = [chr_ServiceLocationBase].cus_CabinetName
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].[chr_CommonRegion] r on r.chr_CommonRegionId = [chr_ServiceLocationBase].chr_RegionId
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].[chr_workorderBase] w on w.chr_workorderId = [chr_ServiceLocationBase].[cus_Project] 
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_Serviceable') AS [Serviceable] ON Serviceable.JoinOnValue = [chr_ServiceLocationBase].[cus_Serviceable]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_NonServiceableReason') AS [NonServiceableReason] ON [NonServiceableReason].[JoinOnValue] = [chr_ServiceLocationBase].[cus_NonServiceableReason]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_CATV') AS [CATV] on [CATV].[JoinOnValue] = [chr_ServiceLocationBase].[cus_CATV]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_CATVDigital') AS [CATVDigital] on [CATVDigital].[JoinOnValue] = [chr_ServiceLocationBase].[cus_CATVDigital]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_Data') AS [Data] on [Data].[JoinOnValue] = [chr_ServiceLocationBase].[cus_Data]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_Phone') AS [Phone] on [Phone].[JoinOnValue] = [chr_ServiceLocationBase].[cus_Phone]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_Fiber') AS [Fiber] on [Fiber].[JoinOnValue] = [chr_ServiceLocationBase].[cus_Fiber]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_FixedWireless') AS [FixedWireless] on [FixedWireless].[JoinOnValue] = [chr_ServiceLocationBase].[cus_FIxedWireless]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_DefaultNetworkDelivery') AS [DefaultNetworkDelivery] on [DefaultNetworkDelivery].[JoinOnValue] = [chr_ServiceLocationBase].[cus_DefaultNetworkDelivery]
		left join [dbo].[PBB_StringMapBaseJoin]('chr_servicelocation','cus_FundType') AS [FundType] on [FundType].[JoinOnValue] = [chr_ServiceLocationBase].[cus_FundType]
		left join [PBBSQL01].[PBB_P_MSCRM].[dbo].[AuditBase] AS [AuditBase] ON [chr_ServiceLocationBase].[chr_servicelocationId] = [AuditBase].[ObjectId]
																 AND [AuditBase].[AuditId] IN(select [AuditBase].[AuditId]
																						from [PBBSQL01].[PBB_P_MSCRM].[dbo].[AuditBase] AS AuditBase
																							left join
																							(
																							    select [AuditBase_MaxRow].[ObjectId]
																									,MAX([AuditBase_MaxRow].[CreatedOn]) CreatedOnMax
																							    from [PBBSQL01].[PBB_P_MSCRM].[dbo].[AuditBase] AS AuditBase_MaxRow
																								    left join
																								    (
																									   select [AuditBase_Serviceable].[AuditId]
																										    ,[AuditBase_Serviceable].[ObjectId]
																										    ,[AuditBase_Serviceable].[CreatedOn]
																										    ,CAST(N'<x>' + REPLACE(REPLACE([AuditBase_Serviceable].[ChangeData],'&','&amp;'),N'~',N'</x><x>') + N'</x>' AS XML).value('/x[sql:column("ServiceableOrdinal.Ordinal")][1]','nvarchar(max)') AS ServiceableData
																									   from [PBBSQL01].[PBB_P_MSCRM].[dbo].[AuditBase] AS AuditBase_Serviceable
																										   join
																										   (
																											  select [AuditBase_ServiceableOrdinal].[AuditId]
																												   ,LEN(SUBSTRING([AuditBase_ServiceableOrdinal].[AttributeMask],1,CHARINDEX(',66,',[AuditBase_ServiceableOrdinal].[AttributeMask]))) - LEN(REPLACE(SUBSTRING([AuditBase_ServiceableOrdinal].[AttributeMask],1,CHARINDEX(',66,',[AuditBase_ServiceableOrdinal].[AttributeMask])),',','')) AS Ordinal
																											  from [PBBSQL01].[PBB_P_MSCRM].[dbo].[AuditBase] AS AuditBase_ServiceableOrdinal
																										   ) as ServiceableOrdinal ON [AuditBase_Serviceable].[AuditId] = [ServiceableOrdinal].[AuditId]
																									   where [AuditBase_Serviceable].[ObjectTypeCode] = 10042
																										    and [AuditBase_Serviceable].[AttributeMask] like '%,66,%'
																								    ) as AuditBase_ServiceableData ON [AuditBase_MaxRow].[AuditId] = [AuditBase_ServiceableData].[AuditId]
																							    where [AuditBase_MaxRow].[ObjectTypeCode] = 10042
																									and [AuditBase_MaxRow].[AttributeMask] LIKE '%,66,%'
																							    group by [AuditBase_MaxRow].[ObjectId]
																							) AS AuditBase_Max on [AuditBase].[ObjectId] = [AuditBase_Max].[ObjectId]
																											  and [AuditBase].[CreatedOn] = [AuditBase_Max].[CreatedOnMax]
																							left join
																							(
																							    select [chr_servicelocationBase].[chr_servicelocationId]
																							    from [PBBSQL01].[PBB_P_MSCRM].[dbo].[chr_servicelocationBase] AS chr_servicelocationBase
																							) as ServiceLocationBase_Serviceable ON [AuditBase].[ObjectId] = [ServiceLocationBase_Serviceable].[chr_servicelocationId]
																						where [AuditBase].[ObjectTypeCode] = 10042
																							 and [AuditBase].[AttributeMask] LIKE '%,66,%'
																							 and [AuditBase_Max].[CreatedOnMax] IS NOT NULL
																							 and [ServiceLocationBase_Serviceable].[chr_servicelocationId] IS NOT NULL
																							 and [AuditBase].[ChangeData] IS NOT NULL)
		LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[dbo].[SystemUserBase] AS [SystemUserBase] ON [AuditBase].[UserId] = [SystemUserBase].[SystemUserId]
GO
