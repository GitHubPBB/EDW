USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_AddressNetworkCircuitID]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_AddressNetworkCircuitID] as
select srvlocation_locationid, address_id, circuit_id, c.status, f.Name, nf.*
from pbbsql01.omnia_epbb_p_pbb_cm.dbo.facility f 
join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.PBB_FACILITY_NetworkAddress_ComponentBreakdown nf on f.id = nf.facilityid
join pbbsql01.omnia_epbb_p_pbb_cm.dbo.circuit c on f.circuit_id = c.id
join pbbsql01.omnia_epbb_p_pbb_cm.dbo.address a on c.address_id = a.id
where srvlocation_locationid is not null
GO
