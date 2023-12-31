USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_ServiceOrderWorkflow]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  View [rpt].[PBB_ServiceOrderWorkflow]
as  

with OrderDetails  as 
(
SELECT DISTINCT
SOB.CustomerId
,SOB.SalesOrderId
,SOB.OrderNumber
,SOB.Name AS OrderName
,SOB.CreatedOn AS [Bill Review Entry Date]
,SOB.ModifiedOn AS [Bill Review Complete Date]
,SOB.chr_OrderCaptureID AS OrderCaptureID
,SOB.chr_ProvisioningDate AS ProvisioningDate
,SOB.Description AS Description
,SOB.CreatedOn ServiceOrderCreatedDate
,SOB.ModifiedOn AS SOTransferredDate
,OB.Name AS OpportunityName
,SUB.FullName AS OrderCreatedBy
,OFSB.chr_name AS OrderFulfillmentStatus
,APB.Subject AS ActivityName
,OBS.Name AS ActivityOwner
,OT.CreatedOn AS [Task Entry Date]
,OT.scheduledstart AS [Task Begin Date]
,OT.scheduledend AS [Due Date (?)]
,OT.ModifiedON AS [Completed Date]
,OT.Description AS [ActivityDescription]
--,ActivityStatus.value AS [Activity Status]
from [PBBSQL01].[PBB_P_MSCRM].[DBO].[SalesOrderBase] SOB
LEFT OUTER  JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[ActivityPointerBase] APB  ON SOB.SalesOrderId = APB.RegardingObjectId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OwnerBase] OBS ON  APB.OwnerId= OBS.OwnerId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_OrderTask] OT ON APB.ActivityId = OT.ActivityId
--INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_StringMapBaseJoin] ('chr_OrderTask', 'StateCode')  ActivityStatus  on  OT.StateCode = ActivityStatus.joinonvalue
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OpportunityBase] OB ON SOB.OpportunityId = OB.OpportunityId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_OrderFulfillmentStatusBase] OFSB ON SOB.chr_FulfillmentStatus = OFSB.chr_OrderFulfillmentStatusId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase] SUB ON SOB.CreatedBy = SUB.SystemUserId
WHERE APB.Subject IS NOT NULL
AND SOB.OrderNumber IS NOT NULL

UNION 

SELECT DISTINCT 
SOB.CustomerId
,SOB.SalesOrderId
,SOB.OrderNumber
,SOB.Name AS OrderName
,SOB.CreatedOn AS [Bill Review Entry Date]
,SOB.ModifiedOn AS [Bill Review Complete Date]
,SOB.chr_OrderCaptureID AS OrderCaptureID
,SOB.chr_ProvisioningDate AS ProvisioningDate
,SOB.Description AS Description
,SOB.CreatedOn ServiceOrderCreatedDate
,SOB.ModifiedOn AS SOTransferredDate
,OB.Name AS OpportunityName
,SUB.FullName AS OrderCreatedBy
,OFSB.chr_name AS OrderFulfillmentStatus
,WAB.chr_name AS ActivityName
,OBS.Name AS ActivityOwner
,WAB.CreatedOn AS [Task Entry Date]
,WAB.chr_StartedDateTime AS [Task Begin Date]
,WAB.chr_CompletedDateTime AS [Due Date (?)]
,WAB.ModifiedON AS [Completed Date]
,NULL AS [ActivityDescription]
--,ActivityStatus.value AS [Activity Status]
from [PBBSQL01].[PBB_P_MSCRM].[DBO].[SalesOrderBase] SOB
LEFT OUTER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_WorkflowAutomatedActivityBase] WAB ON SOB.SalesOrderId = WAB.chr_SalesOrderID
--Inner JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_StringMapBaseJoin] ('chr_WorkflowAutomatedActivity', 'chr_ActivityStatus') ActivityStatus on WAB.chr_ActivityStatus= ActivityStatus.joinonvalue
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OwnerBase] OBS ON  WAB.CreatedBy= OBS.OwnerId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OpportunityBase] OB ON SOB.OpportunityId = OB.OpportunityId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_OrderFulfillmentStatusBase] OFSB ON SOB.chr_FulfillmentStatus = OFSB.chr_OrderFulfillmentStatusId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase] SUB ON SOB.CreatedBy = SUB.SystemUserId
WHERE WAB.chr_name IS NOT NULL
AND SOB.OrderNumber IS NOT NULL

UNION
SELECT DISTINCT
SOB.CustomerId
,SOB.SalesOrderId
,SOB.OrderNumber
,SOB.Name AS OrderName
,SOB.CreatedOn AS [Bill Review Entry Date]
,SOB.ModifiedOn AS [Bill Review Complete Date]
,SOB.chr_OrderCaptureID AS OrderCaptureID
,SOB.chr_ProvisioningDate AS ProvisioningDate
,SOB.Description AS Description
,SOB.CreatedOn ServiceOrderCreatedDate
,SOB.ModifiedOn AS SOTransferredDate
,OB.Name AS OpportunityName
,SUB.FullName AS OrderCreatedBy
,OFSB.chr_name AS OrderFulfillmentStatus
,PRS.chr_name AS ActivityName
,OBS.Name AS ActivityOwner
,PRS.CreatedOn AS [Task Entry Date]
,PRS.CreatedOn AS [Task Begin Date]
,PRS.chr_ScheduledDateTime AS [Due Date (?)]
,PRS.ModifiedON AS [Completed Date]
,NULL AS [ActivityDescription]
--,ActivityStatus.value AS [Activity Status]
from [PBBSQL01].[PBB_P_MSCRM].[DBO].[SalesOrderBase] SOB
LEFT OUTER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_ProvisioningRequestBase] PRS ON SOB.SalesOrderId = PRS.chr_OrderId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OwnerBase] OBS ON  PRS.CreatedBy= OBS.OwnerId
--Inner JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_StringMapBaseJoin]('chr_ProvisioningRequest', 'chr_ProvisioningStatus') ActivityStatus on PRS.chr_ProvisioningStatus = ActivityStatus.JoinOnValue
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[OpportunityBase] OB ON SOB.OpportunityId = OB.OpportunityId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_OrderFulfillmentStatusBase] OFSB ON SOB.chr_FulfillmentStatus = OFSB.chr_OrderFulfillmentStatusId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[SystemUserBase] SUB ON SOB.CreatedBy = SUB.SystemUserId
WHERE PRS.chr_name IS NOT NULL
AND SOB.OrderNumber IS NOT NULL

)
,
 AccountDetails as (
SELECT DISTINCT
AB.AccountId 
,AB.AccountNumber AS AccountCode
,AB.chr_IntegrationAccountId AS AccountIntegrationAccountID
,AB.Name AS AccountName
,AB.EMailAddress1 AS Email
,AB.Telephone1 AS ContactPhone
,AB.chr_AccountActivationDate AS AccountActivationDate
,AB.chr_AccountDeactivationDate AS AccountDeactivationDate
,BCB.chr_Name AS AccountBillCycle
,AGB.chr_Name AS AccountGroup
FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_BillingCycleBase] BCB
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[AccountBase] AB ON BCB.chr_BillingCycleId = AB.chr_CycleId
INNER JOIN [PBBSQL01].[PBB_P_MSCRM].[DBO].[chr_AccountGroupBase] AGB ON AB.chr_AccountGroupId = AGB.chr_AccountGroupId
),

Appointment as (

SELECT DISTINCT 
     APMT.RegardingObjectId
	,dense_rank() over (PARTITION BY APMT.RegardingObjectId order by APMT.ScheduledStart desc ) as LatestAppointment
	,APMT.ScheduledStart AS Appointment_ScheduledStart
	,APMT.ScheduledEnd Appointment_Scheduledend
	--,AppointmentStatus.value AppointmentStatus
	,APMT.cus_SFLAppointmentStatus
FROM [PBBSQL01].[PBB_P_MSCRM].[DBO].[Appointment] APMT
--INNER JOIN [OMNIA_EPBB_P_PBB_DW].[dbo].PBB_StringMapBaseJoin('Appointment', 'StateCode') AppointmentStatus ON APMT.StateCode = AppointmentStatus.joinonvalue
group by 
     APMT.RegardingObjectId
	,APMT.ScheduledStart 
	,APMT.ScheduledEnd
	--,AppointmentStatus.value
	,APMT.cus_SFLAppointmentStatus
	)

SELECT 
AccountDetails.AccountId 
,AccountDetails.AccountCode
,AccountDetails.AccountIntegrationAccountID
,AccountDetails.AccountName
,AccountDetails.Email
,AccountDetails.ContactPhone
,AccountDetails.AccountActivationDate
,AccountDetails.AccountDeactivationDate
,AccountDetails.AccountBillCycle
,AccountDetails.AccountGroup
,OrderDetails.CustomerId
,OrderDetails.SalesOrderId
,OrderDetails.OrderNumber
,OrderDetails.OrderName
,OrderDetails.[Bill Review Entry Date]
,OrderDetails.[Bill Review Complete Date]
,OrderDetails.OrderCaptureID
,OrderDetails.ProvisioningDate
,OrderDetails.Description
,OrderDetails.ServiceOrderCreatedDate
,OrderDetails.SOTransferredDate
,OrderDetails.OpportunityName
,OrderDetails.OrderCreatedBy
,OrderDetails.OrderFulfillmentStatus
,OrderDetails.ActivityName
,OrderDetails.ActivityOwner
,OrderDetails.[Task Entry Date]
,OrderDetails.[Task Begin Date]
,OrderDetails.[Due Date (?)]
,OrderDetails.[Completed Date]
,OrderDetails.[ActivityDescription]
--,Appointment.RegardingObjectId
,Appointment.LatestAppointment
,Appointment.Appointment_ScheduledStart
,Appointment.Appointment_Scheduledend
--,AppointmentStatus
,Appointment.cus_SFLAppointmentStatus
from OrderDetails
JOIN AccountDetails ON OrderDetails.CustomerId = AccountDetails.AccountId
LEFT JOIN Appointment ON OrderDetails.SalesOrderId = Appointment.RegardingObjectId and LatestAppointment = 1

GO
