USE [PBBPDW01]
GO
/****** Object:  View [rpt].[TroubleTicketWorkflow_PBBView]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [rpt].[TroubleTicketWorkflow_PBBView]
as  
WITH IncidentQueue
AS (
	SELECT i.TicketNumber
		,i.IncidentId
		,qi.QueueItemId
		,qi.CreatedOn
		,qi.CreatedByName
		,q.QueueID
		,q.Name AS QueueName
	FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].Incident i
	JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QueueItem qi ON qi.ObjectId = i.IncidentId
	LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QUEUE q ON q.QueueId = qi.QueueID
	)
	,QueueItemAudit
AS (
	SELECT i.TicketNumber
		,a.ObjectId AS QueueItemID
		,a.CreatedOn
		,a.UserIdName
		,a.AttributeMask
		,a.ChangeData
		,AuditOrder = ROW_NUMBER() OVER (
			PARTITION BY a.ObjectId ORDER BY a.createdon DESC
			)
		,RowOrder = ROW_NUMBER() OVER (
			PARTITION BY a.ObjectId ORDER BY a.createdon ASC
			)
		,q.QueueID
		,QUEUE.Name AS QueueName
		,q.QueueDate
	FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].Incident i
	JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QueueItem qi ON qi.ObjectId = i.IncidentId
	JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].Audit a ON a.ObjectId = qi.QueueItemId
	CROSS APPLY (
		SELECT REPLACE(CASE 
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 1
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
								WHERE id = 1
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 2
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
								WHERE id = 2
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 3
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
								WHERE id = 3
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 4
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
								WHERE id = 4
								)
					WHEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
							WHERE id = 5
							) = 2
						THEN (
								SELECT Data
								FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
								WHERE id = 5
								)
					END, 'queue,', '') AS QueueID
			,CASE 
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 1
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
							WHERE id = 1
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 2
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
							WHERE id = 2
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 3
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
							WHERE id = 3
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 4
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
							WHERE id = 4
							)
				WHEN (
						SELECT Data
						FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](STUFF(a.AttributeMask, 1, 1, ''), ',')
						WHERE id = 5
						) = 6
					THEN (
							SELECT Data
							FROM [OMNIA_EPBB_P_PBB_DW].[dbo].[F_Split](a.ChangeData, '~')
							WHERE id = 5
							)
				END AS QueueDate
		) q
	LEFT JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].QUEUE ON QUEUE.QueueId = q.QueueID
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
--WHERE IncidentQueue.TicketNumber = @TicketNumber

UNION ALL

SELECT IncidentQueue.TicketNumber
	,[Queue Changed By] = IncidentQueue.CreatedByName
	,[Queue Changed Date] = CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, QueueItemAudit.QueueDate), DATENAME(TzOffset, SYSDATETIMEOFFSET())))
	,[Previous Queue] = ''
	,[New Queue] = QueueItemAudit.QueueName
	,[Order] = 0
FROM IncidentQueue
LEFT JOIN QueueItemAudit ON QueueItemAudit.QueueItemID = IncidentQueue.QueueItemId
--WHERE IncidentQueue.TicketNumber = @TicketNumber
WHERE QueueItemAudit.RowOrder = 1
GO
