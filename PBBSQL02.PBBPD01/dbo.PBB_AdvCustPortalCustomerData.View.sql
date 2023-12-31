USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_AdvCustPortalCustomerData]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[PBB_AdvCustPortalCustomerData] as
select distinct A.AccountGroupCode, a.AccountCode, a.AccountStatusCode, a.AccountName, 
case when cw.UserName is not null then 'Y' else 'N' end as PortalUserExists, Email ACPEmail
from pbbsql01.omnia_epbb_p_pbb_cm.dbo.PWB_CV_Account a 
join pbbsql01.CHRWEB.dbo.CHRWebUser_BillingAccount CB on cb.BillingAccountID = a.accountcode
Left join pbbsql01.CHRWEB.dbo.chrwebuser cw on cb.chrwebuserid = cw.CHRWebUserID
where a.AccountStatusCode not in ('I') 
GO
