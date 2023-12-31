USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerProduct]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerProduct](
	[FactCustomerProductId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](65) NOT NULL,
	[ServiceID] [int] NOT NULL,
	[DimCustomerActivityId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimAgentId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[Activity_DimDateId] [date] NOT NULL,
	[Connect_DimDateId] [date] NOT NULL,
	[Disconnect_DimDateId] [date] NOT NULL,
	[NonpayDisconnect_DimDateId] [date] NOT NULL,
	[EffectiveStartDate] [datetime] NOT NULL,
	[EffectiveEndDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCustomerProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
