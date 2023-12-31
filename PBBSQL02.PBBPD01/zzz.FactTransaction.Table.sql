USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactTransaction]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactTransaction](
	[FactTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [int] NOT NULL,
	[TransactionAmount] [money] NOT NULL,
	[ProposedWriteOffAmount] [money] NOT NULL,
	[OriginalWriteOffAmount] [money] NOT NULL,
	[CurrentWriteOffAmount] [money] NOT NULL,
	[AdjustmentID] [int] NOT NULL,
	[DimTransactionId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimWriteOffId] [int] NOT NULL,
	[TransactionDate_DimDateId] [date] NOT NULL,
	[PostDate_DimDateId] [date] NOT NULL,
	[WriteOff_DimDateId] [date] NOT NULL
) ON [PRIMARY]
GO
