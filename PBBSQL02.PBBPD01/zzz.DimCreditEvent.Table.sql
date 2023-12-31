USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCreditEvent]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCreditEvent](
	[DimCreditEventId] [int] IDENTITY(1,1) NOT NULL,
	[AccountCreditEventID] [int] NOT NULL,
	[CreditEventDate] [smalldatetime] NULL,
	[CreditEventWeight] [int] NOT NULL,
	[CreditEventMemo] [varchar](255) NOT NULL,
	[CreditEventResultingScore] [int] NOT NULL,
	[CreditEvent] [varchar](40) NOT NULL,
	[CreditEventCreatedBy] [varchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCreditEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[AccountCreditEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
