USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_NonPayCountLast6Months]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_NonPayCountLast6Months]
as
select Accountcode, count(distinct d.disconnectrun) NonPayCount 
from pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[CV_NoticeDisconnect_V100] nd
join pbbsql01.omnia_epbb_p_pbb_ar.[dbo].[ArDisconnectRun] d on nd.DisconnectRun = d.DisconnectRun
where d.DisconnectRunDate between (dateadd(month,-6,getdate())) and getdate()
group by accountcode
GO
