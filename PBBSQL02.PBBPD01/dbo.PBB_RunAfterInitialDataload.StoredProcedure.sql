USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_RunAfterInitialDataload]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[PBB_RunAfterInitialDataload]
as
    BEGIN
	   --Update historic records
	   update sl
		set 
		    pbb_locationserviceabledate = cast(a.modifydate as date)
		   ,pbb_LocationMadeServiceableBy = a.username
	   --select distinct a.SrvLocation_LocationID as LocationID
	   --       ,a.Username
	   --       ,a.ModifyDate, sl.*
	   from pbbsql01.omnia_epbb_p_pbb_cm.dbo.ADDRESS_History a
		   join DimServiceLocation_pbb sl on a.srvlocation_locationid = sl.LocationId
		   inner join
		   (
			  -- find min ModifyDate by LocationID
			  select SrvLocation_LocationID as LocationID
				   ,min(ModifyDate) as ModifyDate
			  from pbbsql01.omnia_epbb_p_pbb_cm.dbo.Address_History
			  where Serviceable = 1
			  group by SrvLocation_LocationID
		   ) h on h.ModifyDate = a.ModifyDate
				and h.LocationID = a.SrvLocation_LocationID
	   where a.Serviceable = 1 --and SrvLocation_LocationID = 3950552
		    and pbb_LocationProjectCode <> 'Duplicate - Do not use'
		    and pbb_LocationIsServiceable = 'Yes'
		    and pbb_LocationServiceableDate = '';

	   --update Hagerstown serviceable date
	   update DimServiceLocation_pbb
		set 
		    pbb_LocationServiceableDate = 'Apr 21 2021 8:00AM'
	   where pbb_LocationProjectCode like 'HAG CO PROJECT%';

	--   select * from DimServiceLocation_pbb where pbb_LocationProjectCode in('HAG HTF02a-C02 PROJECT')

	   update DimServiceLocation_pbb
		set 
		    pbb_LocationServiceableDate = 'May 12 2021 8:00AM'
	   where pbb_LocationProjectCode like 'HAG EXT01 PROJECT%'
		    and pbb_LocationServiceableDate = '';

	   update DimServiceLocation_pbb
		set 
		    pbb_LocationServiceableDate = 'Jun 8 2021 8:00AM'
	   where pbb_LocationServiceableDate = ''
		    and pbb_LocationProjectCode in('HAG EXT02 PROJECT','HAG HTF01a-C02 PROJECT','HAG HTF01a-C01 PROJECT','HAG HTF02a-C02 PROJECT');
    END
GO
