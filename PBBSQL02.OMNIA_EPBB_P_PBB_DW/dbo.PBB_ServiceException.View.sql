USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_ServiceException]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[PBB_ServiceException] as 
with other as
(select A.dimaccountid, A.AccountCode, A.AccountName, fci.dimservicelocationid, sl.ServiceLocationFullAddress, 
sum(isdata) IsData, sum(isdatasvc) IsDataSvc, 
sum(isphone) IsPhone, sum(islocalphn) IsLocalPhn, sum(iscomplexphn) IsComplexPhn, 
sum(iscable) IsCable, sum(iscablesvc) IsCableSvc
from dbo.FactCustomerItem fci
join dbo.DimCatalogItem ci on ci.DimCatalogItemId = fci.DimCatalogItemId
join dbo.DimServiceLocation sl on fci.DimServiceLocationId = sl.DimServiceLocationId
join dbo.prdcomponentmap cm on cm.Componentcode = ci.ComponentCode
join dbo.Dimaccount A on fci.DimAccountId = A.DimAccountId
WHERE Activation_DimDateId <= GETDATE()
               AND Deactivation_DimDateId > GETDATE()
               AND EffectiveStartDate <= GETDATE()
               AND EffectiveEndDate > GETDATE()
               AND A.DimAccountId <> 0
                        AND componentclassid not in (60000,10000,40200,510,81000,12000,100,50000,14000,66000,11020,500)
	
                       -- and cm.ComponentID not in (201630,103951,202276,103758,201075,100376,104171,103079)
group by A.DimAccountId, A.AccountCode, A.accountName, fci.dimservicelocationid, sl.ServiceLocationFullAddress)
select AccountCode, AccountName, ServiceLocationFullAddress, Parent, Child from
(select *,
case when
((isdata > 0 and IsDataSvc = 0) 
or (isphone > 0 and IsLocalPhn = 0 and IsComplexPhn = 0)
or (iscable > 0 and IsCableSvc = 0))
or (isdata = 0 and IsDataSvc = 0 and IsPhone = 0 and IsLocalPhn = 0 and IsComplexPhn = 0 and IsCable = 0 and IsCableSvc = 0) 
then 'Other' end as Other,
case when IsDataSvc > 0 then 'Data' end as dat,
case when IsLocalPhn > 0 or IsComplexPhn > 0 then 'Phone' end as phn,
case when IsCableSvc > 0 then 'Video' end as cbl
from Other) o
left join [dbo].[PBB_AccountLocation_ALLActiveServices_Aggregation](getdate(),', ') sa on o.dimaccountid = sa.DimAccountId and o.DimServiceLocationId = sa.DimServiceLocationId
where Other is not null and dat is null and phn is null and cbl is null
and isnull(child,'') not like '%AMI Reading Point%'
and isnull(child,'') not like '%Email%'
and isnull(child,'') not like '%E-mail%'
and isnull(child,'') not like '%DID%'
and isnull(child,'') not like '%Annual Fiber Maintenance Fees%'
and isnull(child,'') not like '%HPBX BG FORWARD LINE%'
and isnull(child,'') not like '%Static IP%'
and isnull(child,'') not like '%Conference Bridge 80%'
and isnull(child,'') not like '%Dark Fiber%'
and isnull(child,'') not like '%MADN%'
and isnull(child,'') not like '%Hosted Exchange%'
and isnull(child,'') not like '%Personal Ring Number%'
and isnull(child,'') not like '%Priority Ringing%'
and isnull(child,'') not like '%Virtual Ring Number%'
and (child is not null or parent is not null)
GO
