USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimAppointmentView_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimAppointmentView_pbb](
	[ActivityId] [nvarchar](400) NOT NULL,
	[pbb_OrderActivityType] [varchar](7) NOT NULL,
	[OrderClosed_DimDateId] [date] NULL,
	[pbb_SalesOrderReviewDate] [datetime] NULL,
	[ScheduledEnd_DimDateId] [date] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
