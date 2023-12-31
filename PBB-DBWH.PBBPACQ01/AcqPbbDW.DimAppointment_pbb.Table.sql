USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimAppointment_pbb]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimAppointment_pbb](
	[pbb_DimAppointmentId] [int] NOT NULL,
	[ActivityId] [nvarchar](400) NOT NULL,
	[pbb_SFLAppointmentID] [nvarchar](100) NOT NULL,
	[pbb_SFLAppointmentStatus] [nvarchar](100) NOT NULL,
	[pbb_SFLAppointmentURL] [nvarchar](4000) NOT NULL,
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
ALTER TABLE [AcqPbbDW].[DimAppointment_pbb] ADD  DEFAULT ('') FOR [pbb_SFLAppointmentID]
GO
ALTER TABLE [AcqPbbDW].[DimAppointment_pbb] ADD  DEFAULT ('') FOR [pbb_SFLAppointmentStatus]
GO
ALTER TABLE [AcqPbbDW].[DimAppointment_pbb] ADD  DEFAULT ('') FOR [pbb_SFLAppointmentURL]
GO
