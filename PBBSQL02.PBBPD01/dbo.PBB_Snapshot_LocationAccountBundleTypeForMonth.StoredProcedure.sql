USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Snapshot_LocationAccountBundleTypeForMonth]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '5/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '6/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '7/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '8/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '9/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '10/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '11/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '12/1/2020'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '1/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '2/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '3/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '4/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '5/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '6/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '7/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '8/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '9/1/2021'
exec dbo.PBB_Snapshot_LocationAccountBundleTypeForMonth '10/1/2021'
*/

CREATE procedure [dbo].[PBB_Snapshot_LocationAccountBundleTypeForMonth](
			 @SnapshotDate as date
														)
as
    begin

	   delete from PBB_Snapshot_LocationAccountBundleType
	   where SnapshotDate = @SnapshotDate

	   insert into PBB_Snapshot_LocationAccountBundleType
			select cast(@SnapshotDate as date) as [SnapshotDate]
				 ,cast(dateadd(day,-1,@SnapshotDate) as date) as [PeriodEndDate]
				 ,abt.*
			from [dbo].[PBB_GetLocationAccountBundleType](@SnapshotDate) abt
    end
GO
