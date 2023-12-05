USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[FactAppointment]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[FactAppointment](
	[FactAppointmentId] [int] NOT NULL,
	[ActivityId] [nvarchar](400) NOT NULL,
	[DimCaseId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[ActualStart_DimDateId] [date] NOT NULL,
	[ActualEnd_DimDateId] [date] NOT NULL,
	[ScheduledStart_DimDateId] [date] NOT NULL,
	[ScheduledEnd_DimDateId] [date] NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ((0)) FOR [DimCaseId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ((0)) FOR [DimSalesOrderId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ((0)) FOR [DimAccountId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ((0)) FOR [DimAccountCategoryId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ('1900-01-01') FOR [ActualStart_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ('1900-01-01') FOR [ActualEnd_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ('1900-01-01') FOR [ScheduledStart_DimDateId]
GO
ALTER TABLE [AcqPbbDW].[FactAppointment] ADD  DEFAULT ('1900-01-01') FOR [ScheduledEnd_DimDateId]
GO
