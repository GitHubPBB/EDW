USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_FactAppointment]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_FactAppointment]
AS
SELECT FactAppointment.ActivityId,
	FactAppointment.DimCaseId,
	FactAppointment.DimSalesOrderId,
	FactAppointment.DimAccountId,
	FactAppointment.DimAccountCategoryId,
	FactAppointment.ActualStart_DimDateId,
	FactAppointment.ActualEnd_DimDateId,
	FactAppointment.ScheduledStart_DimDateId,
	FactAppointment.ScheduledEnd_DimDateId,
	'Appointment' AS ActivityType
FROM FactAppointment

UNION ALL

SELECT CONVERT(NVARCHAR(400),FactServiceActivity.ActivityId) as ActivityId,
	FactServiceActivity.DimCaseId,
	FactServiceActivity.DimSalesOrderId,
	FactServiceActivity.DimAccountId,
	FactServiceActivity.DimAccountCategoryId,
	CONVERT(DATE,ISNULL(DimServiceActivity.ServiceActivityActualStart, '1900-01-01')),
	CONVERT(DATE,ISNULL(DimServiceActivity.ServiceActivityActualEnd, '2050-12-31')),
	CONVERT(DATE,ISNULL(DimServiceActivity.ServiceActivityScheduledStart, '1900-01-01')),
	CONVERT(DATE,ISNULL(DimServiceActivity.ServiceActivityScheduledEnd, '2050-12-31')),
	'ServiceActivity' AS ActivityType
FROM FactServiceActivity
JOIN DimServiceActivity ON FactServiceActivity.DimServiceActivityId = DimServiceActivity.DimServiceActivityId
GO
