USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_TroubleTicketWorkflow]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [rpt].[PBB_TroubleTicketWorkflow]
as  
WITH IncidentQueue
AS (
	SELECT i.TicketNumber
		,i.IncidentId
		,qi.QueueItemId --
		,qi.CreatedOn --
		,qi.FullName AS CreatedByName
		,qi.QueueName
		,qi.QueueID
FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].[Incidentbase] i
	JOIN (
		SELECT QUI.ObjectId
		,QUI.QueueID
			,QUI.QueueItemId
			,QUI.CreatedOn
			,[SystemUserBase].FullName
			,q.Name AS QueueName
		FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].QueueItembase QUI
		LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase] WITH (NOLOCK) ON (QUI.[CreatedBy] = [SystemUserBase].[SystemUserId])
		LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QUEUEBASE q ON q.QueueId = QUI.QueueID
		) qi ON qi.ObjectId = i.IncidentId	
)
	,QueueItemAudit
AS (
	SELECT i.TicketNumber
		,a.ObjectId AS QueueItemID
		,a.CreatedOn
		,[SystemUserBase].FullName as UserIdName
		,a.AttributeMask
		,a.ChangeData
		
		,AuditOrder = ROW_NUMBER() OVER (
			PARTITION BY a.ObjectId ORDER BY a.createdon DESC
			)
		,RowOrder = ROW_NUMBER() OVER (
			PARTITION BY a.ObjectId ORDER BY a.createdon ASC
			)
			
		,q.QueueID
		,QUEUEBASE.Name AS QueueName
		
		,q.QueueDate
	
FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].Incidentbase i
JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QueueItembase qi ON qi.ObjectId = i.IncidentId
JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Auditbase a ON a.ObjectId = qi.QueueItemId
left join [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase]  with(nolock) on (a.[UserId] = [SystemUserBase].[SystemUserId])
CROSS APPLY (
		SELECT REPLACE(CASE 
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 1
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
								WHERE id = 1
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 2
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
								WHERE id = 2
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 3
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
								WHERE id = 3
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 4
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
								WHERE id = 4
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 5
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
								WHERE id = 5
								)
					END, 'queue,', '') AS QueueID
			,CASE 
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 1
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
							WHERE id = 1
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 2
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
							WHERE id = 2
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 3
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
							WHERE id = 3
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 4
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
							WHERE id = 4
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 5
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[rpt].[PBB_F_Split](a.ChangeData, '~')
							WHERE id = 5
							)
				END AS QueueDate
		) q
	LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QUEUEBASE ON QUEUEBASE.QueueId = q.QueueID
	WHERE len(a.ChangeData) > 0
		AND a.Action = 52 -- ADD TO QUEUE
	)
SELECT IncidentQueue.TicketNumber
	,[Queue Changed By] = QueueItemAudit.UserIdName
	,[Queue Changed Date] = CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, CASE 
					WHEN QueueItemAudit.AuditOrder = 1
						THEN QueueItemAudit.CreatedOn
					ELSE QueueItemAudit.QueueDate
					END), DATENAME(TzOffset, SYSDATETIMEOFFSET())))
	,[Previous Queue] = QueueItemAudit.QueueName
	,[New Queue] = CASE 
		WHEN QueueItemAudit.AuditOrder = 1
			THEN IncidentQueue.QueueName
		ELSE A2.QueueName
		END
	,[Order] = QueueItemAudit.RowOrder
FROM IncidentQueue
LEFT JOIN QueueItemAudit ON QueueItemAudit.QueueItemID = IncidentQueue.QueueItemId
LEFT JOIN QueueItemAudit A2 ON A2.TicketNumber = QueueItemAudit.TicketNumber
	AND A2.AuditOrder = QueueItemAudit.AuditOrder - 1

UNION ALL

SELECT IncidentQueue.TicketNumber
	,[Queue Changed By] = IncidentQueue.CreatedByName
	,[Queue Changed Date] = CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, QueueItemAudit.QueueDate), DATENAME(TzOffset, SYSDATETIMEOFFSET())))
	,[Previous Queue] = ''
	,[New Queue] = QueueItemAudit.QueueName
	,[Order] = 0
FROM IncidentQueue
LEFT JOIN QueueItemAudit ON QueueItemAudit.QueueItemID = IncidentQueue.QueueItemId
where  QueueItemAudit.RowOrder = 1
GO
