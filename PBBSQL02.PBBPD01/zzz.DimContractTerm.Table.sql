USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimContractTerm]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimContractTerm](
	[DimContractTermId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[ContractTermName] [nvarchar](100) NOT NULL,
	[ContractTermType] [nvarchar](50) NOT NULL,
	[ContractTermStatus] [nvarchar](50) NOT NULL,
	[ContractTermAutoRenew] [nvarchar](50) NOT NULL,
	[ContractName] [nvarchar](100) NOT NULL,
	[ContractOwner] [nvarchar](200) NOT NULL,
	[ContractDescription] [nvarchar](4000) NOT NULL,
	[ContractStatus] [nvarchar](50) NOT NULL,
	[ContractVersion] [nvarchar](100) NOT NULL,
	[ContractModifiedBy] [nvarchar](200) NOT NULL,
	[ContractModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimContractTermId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
