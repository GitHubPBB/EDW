USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCustomerItem]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCustomerItem](
	[DimCustomerItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemActivationDate] [date] NULL,
	[ItemDeactivationDate] [date] NULL,
	[ItemStatus] [varchar](1) NOT NULL,
	[ItemServiceIdentifier] [varchar](85) NOT NULL,
	[ItemProviderCode] [char](7) NOT NULL,
	[ItemProvider] [varchar](40) NOT NULL,
	[ItemPrintProvider] [varchar](60) NOT NULL,
	[ItemPrintProviderAbbreviation] [char](6) NOT NULL,
	[ItemProviderClass] [varchar](40) NOT NULL,
	[ItemNumberOfPeriodsBilled] [decimal](15, 7) NOT NULL,
	[ItemInitialBillingId] [int] NOT NULL,
	[ItemFinalBillingId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCustomerItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
