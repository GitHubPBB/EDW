USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_SubscriberCountReport]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_SubscriberCountReport] as
select sortvalue, BeginDate, EndDate, AccountType, AccountGroup, BundleType, PBB_BundleTypeStart, PBB_BundleTypeEnd, sum(begincount) BeginCount, sum(install) Install, sum(disconnect) Disconnect, Sum(upgrade) Upgrade, sum(downgrade) Downgrade, sum(sidegrade) Sidegrade, sum(endcount) EndCount
from 
(
--Beginning Bundle
select b.sortvalue, BeginDate, EndDate,t.accounttype, t.accountgroup, b.BundleType, t.PBB_BundleTypeStart, t.PBB_BundleTypeEnd, sum(begincount) begincount, 0 endcount,
sum(install)*-1 Install, sum(disconnect)*-1 Disconnect, Sum(upgrade)*-1 Upgrade, sum(downgrade)*-1 Downgrade, sum(sidegrade)*-1 Sidegrade
from [dbo].[PBB_BundleSort] B
join [PBB_Snapshot_FactBundleTypeActivity] t on b.BundleType = t.PBB_BundleTypeStart
group by b.sortvalue, BeginDate, EndDate,t.accounttype, t.accountgroup,b.BundleType, t.PBB_BundleTypeStart, t.PBB_BundleTypeEnd
union
--Ending Bundle
select b.sortvalue, BeginDate, EndDate,t.accounttype, t.accountgroup, b.BundleType, t.PBB_BundleTypeStart, t.PBB_BundleTypeEnd, 0 begincount, sum(endcount) endcount,
sum(Install) Install, sum(disconnect) Disconnect, Sum(upgrade) Upgrade, sum(downgrade) Downgrade, sum(sidegrade) Sidegrade
from [dbo].[PBB_BundleSort] B
join [PBB_Snapshot_FactBundleTypeActivity] t on b.BundleType = t.PBB_BundleTypeEnd
group by b.sortvalue, BeginDate, EndDate,t.accounttype, t.accountgroup,b.BundleType, t.PBB_BundleTypeStart, t.PBB_BundleTypeEnd
) dat
where BeginDate > '12/31/2020'
group by sortvalue, BeginDate, EndDate,accounttype, accountgroup, bundletype, PBB_BundleTypeStart, PBB_BundleTypeEnd
GO
