USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimAppointmentView_pbb]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimAppointmentView_pbb](
	[ActivityId] [nvarchar](400) NOT NULL,
	[pbb_OrderActivityType] [varchar](7) NOT NULL,
	[OrderClosed_DimDateId] [date] NULL,
	[pbb_SalesOrderReviewDate] [datetime] NULL,
	[ScheduledEnd_DimDateId] [date] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationId] [int] NULL
) ON [PRIMARY]
GO
