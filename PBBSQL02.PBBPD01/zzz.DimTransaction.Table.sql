USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimTransaction]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimTransaction](
	[DimTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](256) NOT NULL,
	[TransactionClass] [varchar](40) NOT NULL,
	[AdjustmentCode] [char](7) NOT NULL,
	[AdjustmentName] [varchar](40) NOT NULL,
	[AdjustmentClass] [varchar](40) NOT NULL,
	[TransactionReversalReason] [varchar](30) NOT NULL,
	[ReversalAdjustmentCode] [char](7) NOT NULL,
	[ReversalAdjustmentName] [varchar](40) NOT NULL,
	[ReversalAdjustmentClass] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
