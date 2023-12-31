USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Snapshot_FactBundleTypeActivityForMonth]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '5/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '6/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '7/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '8/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '9/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '10/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '11/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '12/1/2020'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '1/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '2/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '3/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '4/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '5/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '6/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '7/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '8/1/2021'
exec dbo.PBB_Snapshot_FactBundleTypeActivityForMonth '9/1/2021'
*/

CREATE PROCEDURE [dbo].[PBB_Snapshot_FactBundleTypeActivityForMonth](
			 @beginDate date
											    )
AS
    begin

	   declare @endDate date = dateadd(month,1,@beginDate)

	   delete from dbo.PBB_Snapshot_FactBundleTypeActivity
	   where BeginDate = @beginDate
		    and EndDate = @endDate

	   insert INTO dbo.PBB_Snapshot_FactBundleTypeActivity
			select *
			from dbo.PBB_FactBundleTypeActivity(@beginDate,@endDate)

	  -- insert INTO dbo.PBB_Snapshot_FactBundleTypeActivity
			--select [BeginDate]
			--	 ,[EndDate]
			--	 ,-1 as [DimServiceLocationId]
			--	 ,-1 as [DimAccountId]
			--	 ,-1 as [AccountLocation]
			--	 ,[PBB_BundleTypeStart]
			--	 ,[Begin_Other]
			--	 ,[PBB_BundleTypeEnd]
			--	 ,[End_Other]
			--	 ,sum([BeginCount]) as [BeginCount]
			--	 ,sum([EndCount]) as [EndCount]
			--	 ,sum([Install]) as [Install]
			--	 ,sum([Disconnect]) as [Disconnect]
			--	 ,sum([Upgrade]) as [Upgrade]
			--	 ,sum([Downgrade]) as [DownGrade]
			--	 ,sum([Sidegrade]) as [SideGrade]
			--from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_Snapshot_FactBundleTypeActivity]
			--where BeginDate = @beginDate
			--	 and EndDate = @endDate
			--group by [BeginDate]
			--	   ,[EndDate]
			--	   ,[PBB_BundleTypeStart]
			--	   ,[Begin_Other]
			--	   ,[PBB_BundleTypeEnd]
			--	   ,[End_Other]
    end
GO
