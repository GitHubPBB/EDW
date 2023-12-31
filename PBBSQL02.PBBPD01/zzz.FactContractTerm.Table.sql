USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactContractTerm]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactContractTerm](
	[FactContractTermId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](400) NOT NULL,
	[ContractTermLength] [int] NOT NULL,
	[DimContractTermId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimOpportunityId] [int] NOT NULL,
	[DimSalesOrderId] [int] NOT NULL,
	[ContractTermStart_DimDateId] [date] NOT NULL,
	[ContractTermEnd_DimDateId] [date] NOT NULL,
	[ContractSignature_DimDateId] [date] NOT NULL,
	[ContractInitialStart_DimDateId] [date] NOT NULL,
	[ContractTermination_DimDateId] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactContractTermId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
