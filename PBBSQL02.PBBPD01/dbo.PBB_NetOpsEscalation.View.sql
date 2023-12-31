USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_NetOpsEscalation]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[PBB_NetOpsEscalation] as
With EscNetOps as
(select cast(Text as xml).value('(/pi/ps/p/@type)[1]','int') as type1
		,cast(Text as xml).value('(/pi/ps/p/@otc)[1]','int') as otc1
		,cast(Text as xml).value('(/pi/ps/p/@id)[1]','uniqueidentifier') as IncidentID
		,cast(Text as xml).value('(/pi/ps/p)[1]','varchar(max)') as value1
		,cast(Text as xml).value('(/pi/ps/p/@type)[2]','int') as type2
		,cast(Text as xml).value('(/pi/ps/p/@otc)[2]','int') as otc2
		,cast(Text as xml).value('(/pi/ps/p/@id)[2]','uniqueidentifier') as QueueID
		,cast(Text as xml).value('(/pi/ps/p)[2]','varchar(max)') as value2
		,cast(Text as xml).value('(/pi/ps/p/@type)[3]','int') as type3
		,cast(Text as xml).value('(/pi/ps/p/@otc)[3]','int') as otc3
		,cast(Text as xml).value('(/pi/ps/p/@id)[3]','uniqueidentifier') as id3
		,cast(Text as xml).value('(/pi/ps/p)[3]','varchar(max)') as EscalatedBy
		,CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, post.ModifiedOn), DATENAME(TzOffset, SYSDATETIMEOFFSET())))  EnteredQueueOn
		from PBBSQL01.[PBB_P_MSCRM].dbo.Post
			LEFT join PBBSQL01.[PBB_P_MSCRM].[dbo].[Queue] q on q.QueueId = cast(post.Text as xml).value('(/pi/ps/p/@id)[2]','uniqueidentifier')
		where text like '%AddToQueue.Post%'
		and cast(Text as xml).value('(/pi/ps/p/@id)[2]','uniqueidentifier') in ('EA4E9BA9-2275-EB11-80E7-00155D106046','FB92B6C8-D7BA-EA11-80D5-00155D2570DA')),

CurrentQueue as
(select CONVERT(datetime, SWITCHOFFSET(CONVERT(datetimeoffset, EnteredOn), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS EnteredOn, 
		ib.IncidentId, ib.ticketnumber, q.Name QueueName
		from PBBSQL01.[PBB_P_MSCRM].[dbo].Incident ib
			inner join PBBSQL01.[PBB_P_MSCRM].[dbo].[QueueItemBase] qb on qb.ObjectId = ib.IncidentId
			inner join PBBSQL01.[PBB_P_MSCRM].[dbo].[Queue] q on q.QueueId = qb.QueueId)

Select cast(QT.EnteredQueueOn as date) EnteredQueueOn,
DATEADD( DAY , 1 - DATEPART(WEEKDAY, cast(QT.EnteredQueueOn as date)), cast(QT.EnteredQueueOn as date)) [Week_Start_Date]
,DATEADD( DAY , 7 - DATEPART(WEEKDAY, cast(QT.EnteredQueueOn as date)), cast(QT.EnteredQueueOn as date)) [Week_End_Date]
,DATEPART(WEEKDAY, cast(QT.EnteredQueueOn as date)) DayOfWeek,
QT.EscalatedBy,
CQ.QueueName CurrentQueue,
Incident.TicketNumber
,Incident.Title
	 ,CASE chr_TroubleTicketTypes
		 WHEN 126770003
		 THEN 'Account Trouble Ticket'
		 WHEN 126770004
		 THEN 'Circuit Trouble Ticket'
		 WHEN 126770000
		 THEN 'Network Trouble Ticket'
		 WHEN 126770002
		 THEN 'Non-Service Trouble Ticket'
		 WHEN 100000000
		 THEN 'Product Trouble Ticket'
		 WHEN 126770001
		 THEN 'Service Trouble Ticket'
		 WHEN 100008642
		 THEN 'Product Case'
		 ELSE 'Unknown'
	  END AS TroubleTicketType
	 ,StringMap2.value AS TroubleTicketStatus
	 ,Incident.chr_TroubleTypeIdName AS TroubleType
	 	 ,Incident.chr_ReportedTroubleIdName AS ReportedTrouble
	 ,StringMap.value AS PriorityStatus
	 ,Incident.CreatedOn AS CreatedDate
	 ,Incident.createdbyname AS CreatedBy
	 ,Incident.chr_duedate AS DueDate
	 ,Incident.chr_clearusername AS ClearUser
	 ,Incident.chr_causecodeidname AS CauseCode
	 ,Incident.chr_FoundCodeidName AS FoundCode
	 ,Incident.chr_clearcodeidname AS ClearCode
	 ,Incident.chr_startcleardatetime AS ClearStartDate
	 ,Incident.chr_ClearDatetime AS ClearEndDate
	 ,Incident.chr_ClearTroubleComment AS ClearComments
	 ,Incident.chr_closecodeidname AS CloseCode
	 ,Incident.chr_closeusername AS CloseUser
	 ,Incident.chr_closedatetime AS CloseDate
	 ,Incident.chr_closecodecomment AS CloseComments
	 ,rtrim(Incident.Description) AS Description
	 ,Incident.OwnerIdName as Owner
	,Account.AccountNumber AS AccountCode
	 ,Account.chr_AccountGroupIdName AS AccountGroup
	 ,left(Account.chr_AccountGroupIdName, 3) Market
	 ,Account.chr_AccountTypeIdName AS AccountType
	 ,Account.chr_AccountClassIdName AS AccountClass
	 ,Account.Name AS AccountName
	 ,Account.EMailAddress1 AS Email
	 ,Account.Telephone1 AS PhoneNumber
	 ,Account.Telephone2 AS AlternatePhone
	 ,cast(Account.chr_AccountActivationDate as date) AS AccountActivationDate
	 ,cast(Account.chr_AccountDeactivationDate as date) AS AccountDeactivationDate
	 ,Account.chr_AccountStatusIdName AS AccountStatus
	 ,chr_servicelocation.chr_masterlocationid AS SrvlocationID
	 ,Incident.chr_ServiceLocationName AS ServiceLocation
	-- ,Incident.IncidentId
from PBBSQL01.[PBB_P_MSCRM].dbo.Incident
	LEFT JOIN PBBSQL01.[PBB_P_MSCRM].dbo.Account ON Incident.AccountId = Account.AccountId
	LEFT JOIN PBBSQL01.[PBB_P_MSCRM].dbo.chr_servicelocation ON Incident.chr_ServiceLocation = chr_servicelocation.chr_servicelocationId
	LEFT JOIN PBBSQL01.[PBB_P_MSCRM].dbo.StringMap ON(Incident.PriorityCode = StringMap.AttributeValue
					   and StringMap.ObjectTypeCode = '112'
					   and StringMap.AttributeName = 'prioritycode')
	LEFT JOIN PBBSQL01.[PBB_P_MSCRM].dbo.Stringmap AS StringMap2 ON(Incident.statuscode = StringMap2.AttributeValue
								  and StringMap2.ObjectTypeCode = '112'
								  and StringMap2.AttributeName = 'statuscode')
	JOIN EscNetOps QT on QT.IncidentId = Incident.IncidentId
	LEFT JOIN CurrentQueue CQ on Incident.IncidentId = CQ.IncidentId
Where cast(isnull(Incident.CreatedOn,'1/1/2021') as date) Between '1/1/2021' and getdate()
--and incident.ticketnumber = 'CAS-1040089-J1Z9Z9'
--order by incident.TicketNumber, Incident.CreatedOn

--select * from PBB_NetOpsEscalation


GO
