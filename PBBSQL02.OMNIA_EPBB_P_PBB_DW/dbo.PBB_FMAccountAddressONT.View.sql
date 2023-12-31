USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FMAccountAddressONT]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[PBB_FMAccountAddressONT] as
SELECT DISTINCT 
       c.id CircuitID, 
       c.type CircuitType, 
       c.STATUS CircuitStatus, 
       c.ADDRESS_Id FMAddressID, 
       --c.ACCOUNT_Id, 
	   a.accountcode,
       e.MfgID SerialNumber,
	   e.Type EquipmentType,
       et.Model, et.Manufacturer, et.class
FROM pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.equipment AS e
     LEFT JOIN pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.equipmenttype AS et ON et.id = e.EQUIPMENTTYPE_Id
     JOIN
(
    SELECT *
    FROM pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.fmgraphnode gn
    WHERE gn.[tablename] LIKE '%equipment%'
          AND gn.type LIKE 'cpe'
) gn ON e.id = gn.RecordId
     JOIN pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.Circuit c ON gn.fmGRAPH_Id = c.fmGRAPH_Id
	 JOIN pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.[Omnia360_CV_Account] A on ISNULL(c.ACCOUNT_Id,'') = a.IntegrationAccountId
WHERE(ISNULL(e.type, '') = 'ONT'
      OR ISNULL(et.class, '') = 'ONT')

GO
