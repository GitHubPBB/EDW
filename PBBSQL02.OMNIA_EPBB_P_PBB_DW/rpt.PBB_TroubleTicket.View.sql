USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_TroubleTicket]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [rpt].[PBB_TroubleTicket]
AS
--select count(*) from [rpt].[TroubleTicket] 
--select *  from [rpt].[TroubleTicket] 
with IncidentDetails
as (
select Distinct [AccountBase].AccountNumber AS AccountCode
,[chr_AccountGroupBase].chr_name as AccountGroup
,[chr_AccountTypeBase].chr_name AS AccountType
,[chr_AccountClassBase].chr_name AS AccountClass
,[AccountBase].Name AS AccountName
,[AccountBase].EMailAddress1 AS Email
,[AccountBase].Telephone1 AS PhoneNumber
,[AccountBase].Telephone2 AS AlternatePhone
,[AccountBase].chr_AccountActivationDate AS AccountActivationDate
,[AccountBase].chr_AccountDeactivationDate AS AccountDeactivationDate
,[AccountBase].statusCode  AS AccountStatus
,chr_servicelocationbase.chr_servicelocationId AS CRMLocationID
,chr_servicelocationbase.chr_masterlocationid AS SrvlocationID
,fmADDRESS.LocationID AS FMAddressID
,fmADDRESS.Address AS FMAddress
,chr_servicelocationBase.chr_name as ServiceLocation
,IncidentBase.title as Title 
,IncidentBase.TicketNumber
,StringMap4.value AS TroubleTicketType
,StringMap2.value AS TroubleTicketStatus
,chr_troubletypeBase.chr_name as TroubleType
,Incidentbase.PriorityCode AS Priority
,StringMap.value AS PriorityStatus
,[chr_reportedtroubleBase]. chr_name as ReportedTrouble
,Incidentbase.CreatedOn AS CreatedDate
,IncidentBase.chr_duedate AS DueDate
,[SystemUserBase].YomiFullName AS ClearUser
,[chr_causecodeBase].chr_name AS CauseCode
,[chr_foundcodeBase].chr_name AS  FoundCode
,[chr_clearcodeBase].chr_name AS  ClearCode
,IncidentBase.chr_startcleardatetime as ClearStartDate
,IncidentBase.chr_ClearDatetime AS ClearEndDate 
,IncidentBase.chr_ClearTroubleComment as ClearComments
,[chr_closecodeBase].chr_name AS  CloseCode
,IncidentBase.chr_closedatetime AS CloseDate
,IncidentBase.chr_closecodecomment AS CloseComments
,IncidentBase.Description
,[ContactBase].FullName AS ResponsibleContactIdName
,IncidentBase.CaseOriginCode as CaseOrigin
,OwnerBase.YomiName AS Owner
,IncidentBase.IncidentID 
,Appointment.Subject AS AppointmentSubject
,dense_rank() over (PARTITION BY  Incidentbase.TicketNumber order by Appointment.ScheduledStart desc ) as LatestAppointment
,Appointment.ScheduledStart AS ScheduledStart
,Appointment.ScheduledEnd ScheduledEnd
,StringMap3.value AppointmentStatus
,cus_SFLAppointmentStatus
FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].[IncidentBase]
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_servicelocationBase]  on [IncidentBase].[chr_ServiceLocation] = chr_servicelocationBase.[chr_servicelocationId]
LEFT JOIN [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[DBO].fmADDRESS ON chr_servicelocationbase.chr_masterlocationid = fmADDRESS.LocationID
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_reportedtroubleBase]  on ([IncidentBase].[chr_ReportedTroubleId] = [chr_reportedtroubleBase].[chr_reportedtroubleId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_troubletypeBase]  on [IncidentBase].[chr_TroubleTypeId] = chr_troubletypeBase.[chr_troubletypeId]
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[AccountBase]  on Case when [IncidentBase].[CustomerIdType] = 1  then [IncidentBase].[CustomerId] end   = [AccountBase].[AccountId]
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_AccountGroupBase]  on ([AccountBase].[chr_AccountGroupId] = [chr_AccountGroupBase].[chr_AccountGroupId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_AccountTypeBase]  on ([AccountBase].[chr_AccountTypeId] = [chr_AccountTypeBase].[chr_AccountTypeId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_AccountClassBase]  on ([AccountBase].[chr_AccountClassId] = [chr_AccountClassBase].[chr_AccountClassId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase]  with(nolock) on ([IncidentBase].[chr_CancelUser] = [SystemUserBase].[SystemUserId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_causecodeBase]  on ([IncidentBase].[chr_CauseCodeid] = [chr_causecodeBase].[chr_causecodeId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_foundcodeBase]  on ([IncidentBase].[chr_FoundCodeid] = [chr_foundcodeBase].[chr_foundcodeId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_clearcodeBase]  on ([IncidentBase].[chr_ClearCodeid] = [chr_clearcodeBase].[chr_clearcodeId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_closecodeBase]  on ([IncidentBase].[chr_CloseCodeid] = [chr_closecodeBase].[chr_closecodeId])
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[ContactBase]  on ([IncidentBase].[ResponsibleContactId] = [ContactBase].[ContactId])
left join  [PBBSQL01].[PBB_P_MSCRM].[DBO].OwnerBase  with(nolock) on ([IncidentBase].OwnerId = OwnerBase.OwnerId)
LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[Appointment] ON IncidentBase.IncidentId = [Appointment].RegardingObjectId
LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap3 ON (
			[Appointment].statuscode = StringMap3.AttributeValue
			AND StringMap3.ObjectTypeCode = '4200'
			AND StringMap3.AttributeName = 'statuscode')
LEFT JOIN   [PBBSQL01].[PBB_P_MSCRM].[DBO].StringMap ON (
			IncidentBase.PriorityCode = StringMap.AttributeValue
			AND StringMap.ObjectTypeCode = '112'
			AND StringMap.AttributeName = 'prioritycode'
			)
LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap2 ON (
			Incidentbase.statuscode = StringMap2.AttributeValue
			AND StringMap2.ObjectTypeCode = '112'
			AND StringMap2.AttributeName = 'statuscode'
			)
LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap4 ON (
			Incidentbase.chr_TroubleTicketTypes = StringMap4.AttributeValue
			AND StringMap4.ObjectTypeCode = '112'
			AND StringMap4.AttributeName = 'chr_troubletickettypes'
			)	
),
 IncidentComment as(
select ObjectId
,[SystemUserBase].FullName +' :- '+ string_agg([AnnotationBase].NoteText, '|| ' ) WITHIN GROUP (ORDER BY [AnnotationBase].CreatedOn desc) as TroubleComment
from [PBBSQL01].[PBB_P_MSCRM].[DBO].[Annotationbase]
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase]  with(nolock) on ([AnnotationBase].[CreatedBy] = [SystemUserBase].[SystemUserId]) 
where  ObjectId in ( select IncidentID from [PBBSQL01].[PBB_P_MSCRM].[DBO].[IncidentBase])
Group by ObjectId, [SystemUserBase].FullName
) 

select * from IncidentDetails 
JOIN IncidentComment ON IncidentDetails.IncidentID =  IncidentComment.ObjectId
where  LatestAppointment= 1
 --AND  ObjectID = 'FCA805D0-12AA-EB11-80F6-00155D1060E7'


















--with TroubleTicket  as (Select 
--Account.AccountNumber AS AccountCode,
--Account.chr_AccountGroupIdName AS AccountGroup,
--Account.chr_AccountTypeIdName AS AccountType,
--Account.chr_AccountClassIdName AS AccountClass,
--Account.Name AS AccountName,
--Account.EMailAddress1 AS Email,
--Account.Telephone1 AS PhoneNumber,
--Account.Telephone2 AS AlternatePhone,
--Account.chr_AccountActivationDate AS AccountActivationDate,
--Account.chr_AccountDeactivationDate AS AccountDeactivationDate,
--Account.chr_AccountStatusIdName AS AccountStatus,
--chr_servicelocation.chr_servicelocationId AS CRMLocationID,
--chr_servicelocation.chr_masterlocationid AS SrvlocationID,
--Incident.chr_ServiceLocationName AS ServiceLocation,
--fmADDRESS.LocationID AS FMAddressID,
--fmADDRESS.Address AS FMAddress,
--Incident.Title,
--Incident.TicketNumber,
--StringMap4.value AS TroubleTicketType,
--StringMap2.value AS TroubleTicketStatus,
--Incident.chr_TroubleTypeIdName AS TroubleType,
--Incident.PriorityCode AS Priority,
--StringMap.value AS PriorityStatus,
--Incident.chr_ReportedTroubleIdName AS ReportedTrouble,
--Incident.CreatedOn AS CreatedDate,
--Incident.createdbyname AS CreatedBy, 
-- Incident.chr_duedate AS DueDate,
--Incident.chr_clearusername AS ClearUser,
--Incident.chr_causecodeidname AS CauseCode,
--Incident.chr_FoundCodeidName AS FoundCode,
--Incident.chr_clearcodeidname AS ClearCode,
--Incident.chr_startcleardatetime AS ClearStartDate,
--Incident.chr_ClearDatetime AS ClearEndDate,
--Incident.chr_ClearTroubleComment AS ClearComments,
--Incident.chr_closecodeidname AS CloseCode,
--Incident.chr_closeusername AS CloseUser, 
--Incident.chr_closedatetime AS CloseDate,
--Incident.chr_closecodecomment AS CloseComments
--,CASE 
--			WHEN Annotation.Subject LIKE '%Note created By%'
--				THEN isnull(nullif(substring(Annotation.Subject, PATINDEX('%%' + ' ' + 'by' + '%%', Annotation.Subject) + 4, PATINDEX('%%' + ' ' + 'on' + '%%', Annotation.Subject) - 4 - PATINDEX('%%' + ' ' + 'by' + '%%', Annotation.Subject)), ''), 'Unknown')
--			WHEN Annotation.Subject LIKE '%Note created on%'
--				THEN isnull(nullif(substring(Annotation.Subject, PATINDEX('%%' + ' ' + 'by' + '%%', Annotation.Subject) + 4, 20), ''), 'Unknown')
--			ELSE 'Unknown'
--			END as TroubleCommentCreatedBy

--,CASE 
--			WHEN Annotation.Subject LIKE '%Note created By%'
--				THEN isnull(nullif(substring(Annotation.Subject, PATINDEX('%%' + ' ' + 'on' + '%%', Annotation.Subject) + 4, 20), ''), 'NULL')
--			WHEN Annotation.Subject LIKE '%Note created on%'
--				THEN isnull(nullif(substring(Annotation.Subject, PATINDEX('%%' + ' ' + 'on' + '%%', Annotation.Subject) + 4, 18), ''), 'NULL')
--			ELSE 'NULL'
--			END AS TroubleCommentCreatedOn
--,Annotation.NoteText AS TroubleComment			
--,Incident.SubjectIdName AS Subject,
--Incident.Description,
--Incident.ResponsibleContactIdName,
--Incident.CaseOriginCode as CaseOrigin,
--Incident.OwnerIdName as Owner
--,Appointment.Subject AS AppointmentSubject
--,Appointment.ScheduledStart AS ScheduledStart
--,dense_rank() over (PARTITION BY  Incident.TicketNumber order by Appointment.ScheduledStart desc ) as LatestAppointment
--,Appointment.ScheduledEnd ScheduledEnd
--,StringMap3.value AppointmentStatus
--,cus_SFLAppointmentStatus  as FSLAppointmentStatus
--,Incident.IncidentId
--from [PBBSQL01].[PBB_P_MSCRM].[DBO].Incident
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Account ON Incident.AccountId = Account.AccountId
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].chr_servicelocation ON Incident.chr_ServiceLocation = chr_servicelocation.chr_servicelocationId
--LEFT JOIN [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[DBO].fmADDRESS ON chr_servicelocation.chr_masterlocationid = fmADDRESS.LocationID
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].StringMap ON (Incident.PriorityCode = StringMap.AttributeValue and StringMap.ObjectTypeCode = '112' and StringMap.AttributeName = 'prioritycode')
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap2 ON (Incident.statuscode = StringMap2.AttributeValue and StringMap2.ObjectTypeCode = '112' and StringMap2.AttributeName = 'statuscode')
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Appointment ON Incident.IncidentId = Appointment.RegardingObjectId
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap3 ON (Appointment.statuscode = StringMap3.AttributeValue and StringMap3.ObjectTypeCode = '4200' and StringMap3.AttributeName = 'statuscode')
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Annotation ON Incident.IncidentId = Annotation.ObjectId
--LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Stringmap AS StringMap4 ON (
--			Incident.chr_TroubleTicketTypes = StringMap4.AttributeValue
--			AND StringMap4.ObjectTypeCode = '112'
--			AND StringMap4.AttributeName = 'chr_troubletickettypes'
--			)	
--)

--select  
--AccountCode
--	,AccountGroup
--	,AccountType
--	,AccountClass
--	,AccountName
--	,Email
--	,PhoneNumber
--	,AlternatePhone
--	,AccountActivationDate
--	,AccountDeactivationDate
--	,AccountStatus
--	,CRMLocationID
--	,SrvlocationID
--	,FMAddressID
--	,FMAddress
--	,ServiceLocation
--	,Title
--	,TicketNumber
--	,TroubleTicketType
--	,TroubleTicketStatus
--	,TroubleType
--	,Priority
--	,PriorityStatus
--	,ReportedTrouble
--	,CreatedDate
--	,CreatedBy
--	,DueDate
--	,ClearUser
--	,CauseCode
--	,FoundCode
--	,ClearCode
--	,ClearStartDate
--	,ClearEndDate
--	,ClearComments
--	,CloseCode
--	,CloseUser
--	,CloseDate
--	,CloseComments
--	,Subject
--	,Description
--	,ResponsibleContactIdName
--	,CaseOrigin
--	,OWNER
--	,AppointmentSubject
--	,ScheduledStart
--	,ScheduledEnd
--	,AppointmentStatus
--	,FSLAppointmentStatus
--	,IncidentId
--	,TroubleCommentCreatedBy
--	,TroubleCommentCreatedOn
--	----,'Created By  ' + TroubleCommentCreatedBy + ' :- ' + string_agg (TroubleComment,'||')  AS TroubleComment
--	,'Created By  ' + TroubleCommentCreatedBy + ' :- ' + TroubleComment  AS TroubleComment
--	from TroubleTicket 
--	where LatestAppointment = 1
----and TicketNumber = 'CAS-1014314-H7B4T8'
----group by AccountCode
----	,AccountGroup
----	,AccountType
----	,AccountClass
----	,AccountName
----	,Email
----	,PhoneNumber
----	,AlternatePhone
----	,AccountActivationDate
----	,AccountDeactivationDate
----	,AccountStatus
----	,CRMLocationID
----	,SrvlocationID
----	,FMAddressID
----	,FMAddress
----	,ServiceLocation
----	,Title
----	,TicketNumber
----	,TroubleTicketType
----	,TroubleTicketStatus
----	,TroubleType
----	,Priority
----	,PriorityStatus
----	,ReportedTrouble
----	,CreatedDate
----	,CreatedBy
----	,DueDate
----	,ClearUser
----	,CauseCode
----	,FoundCode
----	,ClearCode
----	,ClearStartDate
----	,ClearEndDate
----	,ClearComments
----	,CloseCode
----	,CloseUser
----	,CloseDate
----	,CloseComments
----	,Subject
----	,Description
----	,ResponsibleContactIdName
----	,CaseOrigin
----	,OWNER
----	,AppointmentSubject
----	,ScheduledStart
----	,ScheduledEnd
----	,AppointmentStatus
----	,FSLAppointmentStatus
----	,IncidentId
----	,TroubleCommentCreatedBy
----	,TroubleCommentCreatedOn

GO
