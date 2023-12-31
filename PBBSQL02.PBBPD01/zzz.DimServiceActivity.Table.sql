USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimServiceActivity]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimServiceActivity](
	[DimServiceActivityId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityId] [uniqueidentifier] NOT NULL,
	[ServiceActivityActualStart] [datetime] NULL,
	[ServiceActivityActualEnd] [datetime] NULL,
	[ServiceActivityActualDurationMinutes] [int] NOT NULL,
	[ServiceActivityDescription] [nvarchar](max) NOT NULL,
	[ServiceActivityName] [nvarchar](160) NOT NULL,
	[ServiceActivitySubject] [nvarchar](200) NOT NULL,
	[ServiceActivityStatus] [nvarchar](9) NOT NULL,
	[ServiceActivityScheduledStart] [datetime] NULL,
	[ServiceActivityScheduledEnd] [datetime] NULL,
	[ServiceActivityScheduledDurationMinutes] [int] NOT NULL,
	[ServiceActivityCreatedOn] [datetime] NULL,
	[ServiceActivityCreatedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityModifiedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityRegardingObjectName] [nvarchar](4000) NOT NULL,
	[ServiceActivityRegardingObjectType] [varchar](19) NOT NULL,
	[ServiceActivityOwner] [nvarchar](200) NOT NULL,
	[ServiceActivitySiteName] [nvarchar](160) NOT NULL,
	[ServiceActivityResourceNames] [nvarchar](4000) NOT NULL,
	[ServiceActivityDispatchedBy] [nvarchar](200) NOT NULL,
	[ServiceActivityDispatchedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimServiceActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
