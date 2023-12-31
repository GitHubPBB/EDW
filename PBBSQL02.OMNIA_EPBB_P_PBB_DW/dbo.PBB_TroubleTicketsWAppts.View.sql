USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_TroubleTicketsWAppts]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[PBB_TroubleTicketsWAppts] as

with caseaddr as
(select dimcaseid, StreetAddress1, StreetAddress2, City, [State Abbreviation], [Postal Code], [Project Name], Cabinet, NetworkAddress
from factcase c
join DimAddressDetails_pbb a on c.DimServiceLocationId = a.DimServiceLocationId 
)
select distinct 
c.TicketNumber, c.TicketTitle, c.TicketStatus, c.TroubleTicketType, c.TroubleType, c.CasePriorityStatus, c.ReportedTrouble, CaseCreatedOn, 
c.CaseCauseCode, c.CaseClearTroubleComment, c.CaseFoundCodeName, c.CaseCloseCodeComment, c.CaseCloseCode, c.CaseClearCode,
f.ScheduledStart_DimDateId, f.ScheduledEnd_DimDateId, 
appt.pbb_SFLAppointmentStatus, appt.pbb_SFLAppointmentURL,
ac.AccountGroup, ac.AccountTypeCode, AccountCode, AccountName, 
ca.*
from PBB_FactAppointment f
join DimAppointment_pbb appt on f.ActivityId = appt.ActivityId 
join dimcase c on f.dimcaseid = c.DimCaseId
join caseaddr ca on f.DimCaseId = ca.DimCaseId
join dimaccount a on f.DimAccountId = a.DimAccountId
join DimAccountCategory ac on f.DimAccountCategoryId = ac.DimAccountCategoryId
where f.DimCaseId <> 0
GO
