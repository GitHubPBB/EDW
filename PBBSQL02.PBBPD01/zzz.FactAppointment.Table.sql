USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactAppointment]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactAppointment](
	[FactAppointmentId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityId] [nvarchar](400) NOT NULL,
	[DimCaseId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[ActualStart_DimDateId] [date] NOT NULL,
	[ActualEnd_DimDateId] [date] NOT NULL,
	[ScheduledStart_DimDateId] [date] NOT NULL,
	[ScheduledEnd_DimDateId] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactAppointmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
