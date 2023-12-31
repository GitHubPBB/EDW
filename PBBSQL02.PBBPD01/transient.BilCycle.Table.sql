USE [PBBPDW01]
GO
/****** Object:  Table [transient].[BilCycle]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[BilCycle](
	[CycleID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[Cycle] [varchar](40) NOT NULL,
	[PreBillYYYY] [char](4) NOT NULL,
	[PreBillMM] [char](2) NOT NULL,
	[CycleDay] [char](2) NULL,
	[CycleIndex] [int] NOT NULL,
	[CycleScheduleID] [int] NOT NULL,
	[IsBillingInit] [int] NOT NULL
) ON [PRIMARY]
GO
