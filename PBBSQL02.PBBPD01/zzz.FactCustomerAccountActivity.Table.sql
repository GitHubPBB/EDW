USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerAccountActivity]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerAccountActivity](
	[FactCustomerAccountActivityId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](36) NOT NULL,
	[DimDateId] [date] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[AccountAddQuantity] [int] NOT NULL,
	[AccountRemoveQuantity] [int] NOT NULL,
	[AccountNetQuantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerAccountActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
