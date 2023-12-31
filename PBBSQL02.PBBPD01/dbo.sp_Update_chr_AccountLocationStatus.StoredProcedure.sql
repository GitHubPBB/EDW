USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[sp_Update_chr_AccountLocationStatus]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================
-- Author:		Imtiaz Bhatia
-- Create date: 1/5/2023
-- Description:	Populates Table chr_AccountLocationStatus with all Account-Location combinations and their current status
-- =======================================================================================================================
CREATE PROCEDURE [dbo].[sp_Update_chr_AccountLocationStatus]
as
/*
select ca.AccountCode as AccountNumber, AccountStatusCode, sl.LocationID, sl.FullLocation, si.ItemID, si.ItemStatus, 
			si.ActivationDate, si.DeactivationDate, si.ItemNonpayDiscDate
from cusaccount ca
	join srvservice ss on ss.AccountID=ca.AccountID
	join srvitem si on si.ServiceID=ss.ServiceID
	join SrvLocationSearch sl on sl.LocationID=si.LocationID
	left join SrvItemPrice sip on sip.ItemID=si.ItemID
	left join PriPrice p on p.PriceID=sip.PriceID
Where IsNull(p.BillingFrequency,'') <> 'O' and si.ComponentClassID <> 510
order by ca.AccountCode, sl.LocationID, si.ItemID
*/

/*
Create Table chr_AccountLocationStatus
(
	AccountNumber char(12) Null,
	LocationID int Null,
	FullLocation varchar(500) Null,
	LocationStatus varchar(1) Null,
	ActivationDate smalldatetime Null,
	DeactivationDate smalldatetime Null
)
*/
Truncate Table chr_AccountLocationStatus

;With AccountLocations as
	(Select Distinct ca.AccountCode as AccountNumber, ca.AccountID, AccountStatusCode, sl.LocationID, sl.FullLocation
	 From pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.cusaccount ca
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvservice ss on ss.AccountID=ca.AccountID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvitem si on si.ServiceID=ss.ServiceID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvLocationSearch sl on sl.LocationID=si.LocationID
	),
ActiveItems as
	(Select ca.AccountID, sl.LocationID, count(*) as ItemCount, 
		min(si.ActivationDate) as ActivationDate, Null as DeactivationDate
	 From pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.cusaccount ca
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvservice ss on ss.AccountID=ca.AccountID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvitem si on si.ServiceID=ss.ServiceID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvLocationSearch sl on sl.LocationID=si.LocationID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvItemPrice sip on sip.ItemID=si.ItemID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.PriPrice p on p.PriceID=sip.PriceID
	 Where IsNull(p.BillingFrequency,'') <> 'O' and si.ComponentClassID <> 510 and si.ItemStatus='A'
	 group by ca.AccountID, sl.LocationID
	),
InactiveItems as
	(Select ca.AccountID, sl.LocationID, count(*) as ItemCount,  
		min(si.ActivationDate) as ActivationDate, max(IsNull(si.DeactivationDate, si.ActivationDate)) as DeactivationDate
	 From pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.cusaccount ca
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvservice ss on ss.AccountID=ca.AccountID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvitem si on si.ServiceID=ss.ServiceID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvLocationSearch sl on sl.LocationID=si.LocationID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvItemPrice sip on sip.ItemID=si.ItemID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.PriPrice p on p.PriceID=sip.PriceID
	 Where IsNull(p.BillingFrequency,'') <> 'O' and si.ComponentClassID <> 510 and si.ItemStatus='I'
	 group by ca.AccountID, sl.LocationID
	),
NonPayItems as
	(Select ca.AccountID, sl.LocationID, count(*) as ItemCount, 
		min(si.ActivationDate) as ActivationDate, Null as DeactivationDate
	 From pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.cusaccount ca
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvservice ss on ss.AccountID=ca.AccountID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.srvitem si on si.ServiceID=ss.ServiceID
		join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvLocationSearch sl on sl.LocationID=si.LocationID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvItemPrice sip on sip.ItemID=si.ItemID
		left join pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.PriPrice p on p.PriceID=sip.PriceID
	 Where IsNull(p.BillingFrequency,'') <> 'O' and si.ComponentClassID <> 510 and si.ItemStatus='N'
	 group by ca.AccountID, sl.LocationID
	)
Insert Into chr_AccountLocationStatus
Select al.AccountNumber, al.LocationID, al.FullLocation, 
	Case When IsNull(ai.ItemCount,0) > 0 Then 'A' When IsNull(ni.ItemCount,0) > 0 Then 'N' Else 'I' End as LocationStatus,
	Case When IsNull(ai.ActivationDate,'20790101') <= IsNull(ii.ActivationDate,'20790101') and IsNull(ai.ActivationDate,'20790101') <= IsNull(ni.ActivationDate,'20790101') Then ai.ActivationDate
		 When IsNull(ii.ActivationDate,'20790101') <= IsNull(ni.ActivationDate,'20790101') Then ii.ActivationDate Else ni.ActivationDate End as ActivationDate,
	Case When ai.itemcount > 0 or ni.ItemCount > 0 Then Null Else ii.DeactivationDate End as DeactivationDate
--		, IsNull(ai.itemcount,0) as ActiveItems, IsNull(ni.ItemCount,0) as NonPayItems, IsNull(ii.ItemCount,0) as InactiveItems
from AccountLocations al
	Left Join ActiveItems ai ON ai.AccountID=al.AccountID and ai.LocationID=al.LocationID
	Left Join InactiveItems ii ON ii.AccountID=al.AccountID and ii.LocationID=al.LocationID
	Left Join NonPayItems ni ON ni.AccountID=al.AccountID and ni.LocationID=al.LocationID
--Order by al.AccountNumber, al.FullLocation

--select * from chr_AccountLocationStatus

GO
